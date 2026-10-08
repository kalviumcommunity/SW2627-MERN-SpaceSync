const mongoose = require('mongoose');
const Booking = require('../models/Booking');
const Space = require('../models/Space');
const { AppError } = require('../utils/AppError');
const { asyncHandler } = require('../utils/asyncHandler');
const { writeAudit } = require('../utils/audit');

function canSeeBooking(user, booking) {
  if (user.role === 'central_admin') return true;
  if (user.role === 'branch_manager') return String(user.branch || '') === String(booking.branch);
  return String(booking.member) === String(user._id);
}

const createBooking = asyncHandler(async (req, res) => {
  let createdBooking;

  async function allocateBooking(session) {
    const space = await Space.findOneAndUpdate(
      { _id: req.body.space, isActive: true },
      { $inc: { bookingLockVersion: 1 } },
      { new: true, session: session || undefined }
    );
    if (!space || !space.isActive) {
      throw new AppError(404, 'Space not found');
    }

    const startTime = new Date(req.body.startTime);
    const endTime = new Date(req.body.endTime);
    if (endTime <= startTime) {
      throw new AppError(400, 'endTime must be after startTime');
    }

    const conflictingBooking = await Booking.findOne({
      space: space._id,
      status: 'confirmed',
      startTime: { $lt: endTime },
      endTime: { $gt: startTime }
    }).session(session || null);

    if (conflictingBooking) {
      throw new AppError(409, 'Space is already booked for the requested time slot');
    }

    const bookings = await Booking.create(
      [
        {
          member: req.user._id,
          branch: space.branch,
          space: space._id,
          startTime,
          endTime,
          notes: req.body.notes
        }
      ],
      { session: session || undefined }
    );

    createdBooking = bookings[0];
    await writeAudit({
      user: req.user,
      action: 'booking.created',
      entityType: 'Booking',
      entityId: createdBooking._id,
      branch: space.branch,
      metadata: {
        space: space._id,
        startTime,
        endTime
      },
      session
    });
  }

  const session = await mongoose.startSession();
  try {
    try {
      await session.withTransaction(async () => {
        await allocateBooking(session);
      });
    } catch (error) {
      const transactionUnsupported =
        error.message &&
        error.message.includes('Transaction numbers are only allowed');
      if (!transactionUnsupported) {
        throw error;
      }

      await allocateBooking();
    }
  } finally {
    await session.endSession();
  }

  res.status(201).json({ booking: createdBooking });
});

const listBookings = asyncHandler(async (req, res) => {
  const filter = {};
  if (req.user.role === 'member') {
    filter.member = req.user._id;
  } else if (req.user.role === 'branch_manager') {
    filter.branch = req.user.branch;
  }

  const bookings = await Booking.find(filter)
    .populate('branch', 'name city')
    .populate('space', 'name type')
    .populate('member', 'name email')
    .sort({ startTime: -1 });

  res.json({ bookings });
});

const getBooking = asyncHandler(async (req, res) => {
  const booking = await Booking.findById(req.params.id)
    .populate('branch', 'name city')
    .populate('space', 'name type')
    .populate('member', 'name email');

  if (!booking) {
    throw new AppError(404, 'Booking not found');
  }

  if (!canSeeBooking(req.user, booking)) {
    throw new AppError(403, 'You cannot view this booking');
  }

  res.json({ booking });
});

const updateBookingStatus = asyncHandler(async (req, res) => {
  const booking = await Booking.findById(req.params.id);
  if (!booking) {
    throw new AppError(404, 'Booking not found');
  }

  if (!canSeeBooking(req.user, booking)) {
    throw new AppError(403, 'You cannot update this booking');
  }

  if (req.user.role === 'member' && req.body.status !== 'cancelled') {
    throw new AppError(403, 'Members can only cancel bookings');
  }

  booking.status = req.body.status;
  await booking.save();
  await writeAudit({
    user: req.user,
    action: `booking.${req.body.status}`,
    entityType: 'Booking',
    entityId: booking._id,
    branch: booking.branch,
    metadata: { status: req.body.status }
  });

  res.json({ booking });
});

module.exports = { createBooking, listBookings, getBooking, updateBookingStatus };
