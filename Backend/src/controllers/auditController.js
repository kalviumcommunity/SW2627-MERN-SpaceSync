const AuditLog = require('../models/AuditLog');
const { asyncHandler } = require('../utils/asyncHandler');

const listAuditLogs = asyncHandler(async (req, res) => {
  const filter = {};
  if (req.user.role === 'branch_manager') {
    filter.branch = req.user.branch;
  }

  const logs = await AuditLog.find(filter)
    .populate('actor', 'name email role')
    .populate('branch', 'name city')
    .sort({ createdAt: -1 })
    .limit(200);

  res.json({ logs });
});

const auditSummary = asyncHandler(async (req, res) => {
  const match = req.user.role === 'branch_manager' ? { branch: req.user.branch } : {};
  const summary = await AuditLog.aggregate([
    { $match: match },
    {
      $group: {
        _id: { action: '$action', entityType: '$entityType' },
        count: { $sum: 1 },
        lastActivityAt: { $max: '$createdAt' }
      }
    },
    { $sort: { count: -1, lastActivityAt: -1 } }
  ]);

  res.json({ summary });
});

module.exports = { listAuditLogs, auditSummary };
