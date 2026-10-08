const mongoose = require('mongoose');
const Booking = require('../models/Booking');
const Branch = require('../models/Branch');
const Space = require('../models/Space');
const WalkIn = require('../models/WalkIn');
const { AppError } = require('../utils/AppError');
const { asyncHandler } = require('../utils/asyncHandler');

function dateRangeFromQuery(query) {
  const from = query.from ? new Date(query.from) : new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
  const to = query.to ? new Date(query.to) : new Date();
  return { from, to };
}

async function buildUtilization(branchId, from, to) {
  const match = {
    status: { $in: ['confirmed', 'completed'] },
    startTime: { $gte: from, $lte: to }
  };
  if (branchId) {
    match.branch = new mongoose.Types.ObjectId(branchId);
  }

  const bookingRows = await Booking.aggregate([
    { $match: match },
    {
      $group: {
        _id: '$branch',
        bookingCount: { $sum: 1 },
        bookedMinutes: {
          $sum: {
            $dateDiff: {
              startDate: '$startTime',
              endDate: '$endTime',
              unit: 'minute'
            }
          }
        }
      }
    }
  ]);

  const walkInMatch = { observedAt: { $gte: from, $lte: to } };
  if (branchId) {
    walkInMatch.branch = new mongoose.Types.ObjectId(branchId);
  }

  const walkInRows = await WalkIn.aggregate([
    { $match: walkInMatch },
    {
      $group: {
        _id: '$branch',
        walkInCount: { $sum: '$count' }
      }
    }
  ]);

  const branchFilter = branchId ? { _id: branchId } : { isActive: true };
  const branches = await Branch.find(branchFilter).lean();
  const spaceCounts = await Space.aggregate([
    { $match: branchId ? { branch: new mongoose.Types.ObjectId(branchId), isActive: true } : { isActive: true } },
    { $group: { _id: '$branch', activeSpaces: { $sum: 1 }, totalCapacity: { $sum: '$capacity' } } }
  ]);

  const bookingByBranch = new Map(bookingRows.map((row) => [String(row._id), row]));
  const walkInsByBranch = new Map(walkInRows.map((row) => [String(row._id), row]));
  const spacesByBranch = new Map(spaceCounts.map((row) => [String(row._id), row]));

  return branches.map((branch) => {
    const key = String(branch._id);
    const bookings = bookingByBranch.get(key) || {};
    const walkIns = walkInsByBranch.get(key) || {};
    const spaces = spacesByBranch.get(key) || {};
    const activeSpaces = spaces.activeSpaces || 0;
    const availableMinutes = activeSpaces * 12 * 60 * Math.max(1, Math.ceil((to - from) / 86400000));

    return {
      branch,
      bookingCount: bookings.bookingCount || 0,
      bookedMinutes: bookings.bookedMinutes || 0,
      walkInCount: walkIns.walkInCount || 0,
      activeSpaces,
      totalCapacity: spaces.totalCapacity || 0,
      utilizationRate: availableMinutes ? Number(((bookings.bookedMinutes || 0) / availableMinutes).toFixed(4)) : 0
    };
  });
}

const utilization = asyncHandler(async (req, res) => {
  const { from, to } = dateRangeFromQuery(req.query);
  const report = await buildUtilization(null, from, to);
  res.json({ from, to, report });
});

const branchUtilization = asyncHandler(async (req, res) => {
  const branch = await Branch.findById(req.params.branchId);
  if (!branch) {
    throw new AppError(404, 'Branch not found');
  }

  if (req.user.role === 'branch_manager' && String(req.user.branch || '') !== String(branch._id)) {
    throw new AppError(403, 'You can only view your assigned branch');
  }

  const { from, to } = dateRangeFromQuery(req.query);
  const report = await buildUtilization(req.params.branchId, from, to);
  res.json({ from, to, report: report[0] || null });
});

module.exports = { utilization, branchUtilization };
