const Booking = require('../models/Booking');
const Branch = require('../models/Branch');
const Space = require('../models/Space');
const { AppError } = require('../utils/AppError');
const { asyncHandler } = require('../utils/asyncHandler');
const { writeAudit } = require('../utils/audit');

async function assertBranchExists(branchId) {
  const branch = await Branch.findById(branchId);
  if (!branch || !branch.isActive) {
    throw new AppError(404, 'Branch not found');
  }
  return branch;
}

function canManageBranch(user, branchId) {
  return user.role === 'central_admin' || String(user.branch || '') === String(branchId);
}

const createSpace = asyncHandler(async (req, res) => {
  await assertBranchExists(req.params.branchId);
  if (!canManageBranch(req.user, req.params.branchId)) {
    throw new AppError(403, 'You can only manage your assigned branch');
  }

  const space = await Space.create({ ...req.body, branch: req.params.branchId });
  await writeAudit({
    user: req.user,
    action: 'space.created',
    entityType: 'Space',
    entityId: space._id,
    branch: space.branch,
    metadata: { name: space.name, type: space.type }
  });

  res.status(201).json({ space });
});

const listSpaces = asyncHandler(async (req, res) => {
  await assertBranchExists(req.params.branchId);
  const filter = { branch: req.params.branchId, isActive: true };
  if (req.query.type) {
    filter.type = req.query.type;
  }

  const spaces = await Space.find(filter).sort({ type: 1, name: 1 });
  const startTime = req.query.startTime ? new Date(req.query.startTime) : null;
  const endTime = req.query.endTime ? new Date(req.query.endTime) : null;

  if (!startTime || !endTime) {
    return res.json({ spaces });
  }

  const bookings = await Booking.find({
    branch: req.params.branchId,
    status: 'confirmed',
    startTime: { $lt: endTime },
    endTime: { $gt: startTime }
  }).select('space');

  const bookedSpaceIds = new Set(bookings.map((booking) => String(booking.space)));
  const spacesWithAvailability = spaces.map((space) => ({
    ...space.toObject(),
    available: !bookedSpaceIds.has(String(space._id))
  }));

  return res.json({ spaces: spacesWithAvailability });
});

const updateSpace = asyncHandler(async (req, res) => {
  const space = await Space.findById(req.params.id);
  if (!space || !space.isActive) {
    throw new AppError(404, 'Space not found');
  }

  if (!canManageBranch(req.user, space.branch)) {
    throw new AppError(403, 'You can only manage your assigned branch');
  }

  Object.assign(space, req.body);
  await space.save();
  await writeAudit({
    user: req.user,
    action: 'space.updated',
    entityType: 'Space',
    entityId: space._id,
    branch: space.branch,
    metadata: req.body
  });

  res.json({ space });
});

const deactivateSpace = asyncHandler(async (req, res) => {
  const space = await Space.findById(req.params.id);
  if (!space || !space.isActive) {
    throw new AppError(404, 'Space not found');
  }

  if (!canManageBranch(req.user, space.branch)) {
    throw new AppError(403, 'You can only manage your assigned branch');
  }

  space.isActive = false;
  await space.save();
  await writeAudit({
    user: req.user,
    action: 'space.deactivated',
    entityType: 'Space',
    entityId: space._id,
    branch: space.branch
  });

  res.status(204).send();
});

const addCapacityRule = asyncHandler(async (req, res) => {
  const space = await Space.findById(req.params.id);
  if (!space || !space.isActive) {
    throw new AppError(404, 'Space not found');
  }

  if (!canManageBranch(req.user, space.branch)) {
    throw new AppError(403, 'You can only manage your assigned branch');
  }

  space.capacityRules.push(req.body);
  await space.save();
  await writeAudit({
    user: req.user,
    action: 'space.capacity_rule.created',
    entityType: 'Space',
    entityId: space._id,
    branch: space.branch,
    metadata: req.body
  });

  res.status(201).json({ space });
});

module.exports = {
  createSpace,
  listSpaces,
  updateSpace,
  deactivateSpace,
  addCapacityRule
};
