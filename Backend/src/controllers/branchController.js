const Branch = require('../models/Branch');
const { asyncHandler } = require('../utils/asyncHandler');
const { writeAudit } = require('../utils/audit');

const createBranch = asyncHandler(async (req, res) => {
  const branch = await Branch.create(req.body);
  await writeAudit({
    user: req.user,
    action: 'branch.created',
    entityType: 'Branch',
    entityId: branch._id,
    branch: branch._id,
    metadata: { name: branch.name }
  });

  res.status(201).json({ branch });
});

const listBranches = asyncHandler(async (req, res) => {
  const branches = await Branch.find({ isActive: true }).sort({ city: 1, name: 1 });
  res.json({ branches });
});

module.exports = { createBranch, listBranches };
