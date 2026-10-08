const Branch = require('../models/Branch');
const WalkIn = require('../models/WalkIn');
const { AppError } = require('../utils/AppError');
const { asyncHandler } = require('../utils/asyncHandler');
const { writeAudit } = require('../utils/audit');

function canManageBranch(user, branchId) {
  return user.role === 'central_admin' || String(user.branch || '') === String(branchId);
}

const recordWalkIn = asyncHandler(async (req, res) => {
  const branch = await Branch.findById(req.params.branchId);
  if (!branch || !branch.isActive) {
    throw new AppError(404, 'Branch not found');
  }

  if (!canManageBranch(req.user, req.params.branchId)) {
    throw new AppError(403, 'You can only record walk-ins for your assigned branch');
  }

  const walkIn = await WalkIn.create({
    branch: req.params.branchId,
    recordedBy: req.user._id,
    count: req.body.count,
    observedAt: req.body.observedAt || new Date(),
    notes: req.body.notes
  });

  await writeAudit({
    user: req.user,
    action: 'walk_in.recorded',
    entityType: 'WalkIn',
    entityId: walkIn._id,
    branch: walkIn.branch,
    metadata: { count: walkIn.count, observedAt: walkIn.observedAt }
  });

  res.status(201).json({ walkIn });
});

module.exports = { recordWalkIn };
