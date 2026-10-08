const express = require('express');
const { branchUtilization, utilization } = require('../controllers/analyticsController');
const { requireAuth, requireRole } = require('../middleware/auth');
const { validate } = require('../middleware/validate');
const { analyticsSchemas } = require('../utils/validationSchemas');

const router = express.Router();

router.get(
  '/utilization',
  requireAuth,
  requireRole('branch_manager', 'central_admin'),
  validate(analyticsSchemas.range),
  utilization
);
router.get(
  '/utilization/:branchId',
  requireAuth,
  requireRole('branch_manager', 'central_admin'),
  validate(analyticsSchemas.branchParam),
  branchUtilization
);

module.exports = router;
