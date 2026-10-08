const AuditLog = require('../models/AuditLog');

async function writeAudit({ user, action, entityType, entityId, branch, metadata = {}, session }) {
  await AuditLog.create(
    [
      {
        actor: user?._id,
        actorRole: user?.role,
        action,
        entityType,
        entityId,
        branch,
        metadata
      }
    ],
    { session }
  );
}

module.exports = { writeAudit };
