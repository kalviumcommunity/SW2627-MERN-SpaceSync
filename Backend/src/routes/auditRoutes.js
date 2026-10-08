const express = require('express');
const { auditSummary, listAuditLogs } = require('../controllers/auditController');
const { requireAuth, requireRole } = require('../middleware/auth');

const router = express.Router();

router.get('/', requireAuth, requireRole('branch_manager', 'central_admin'), listAuditLogs);
router.get('/summary', requireAuth, requireRole('branch_manager', 'central_admin'), auditSummary);

module.exports = router;
