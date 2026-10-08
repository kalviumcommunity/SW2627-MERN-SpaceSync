const express = require('express');
const { addCapacityRule, deactivateSpace, updateSpace } = require('../controllers/spaceController');
const { requireAuth, requireRole } = require('../middleware/auth');
const { validate } = require('../middleware/validate');
const { spaceSchemas } = require('../utils/validationSchemas');

const router = express.Router();

router.put(
  '/:id',
  requireAuth,
  requireRole('branch_manager', 'central_admin'),
  validate(spaceSchemas.update),
  updateSpace
);
router.delete(
  '/:id',
  requireAuth,
  requireRole('branch_manager', 'central_admin'),
  validate(spaceSchemas.idParam),
  deactivateSpace
);
router.post(
  '/:id/capacity-rules',
  requireAuth,
  requireRole('branch_manager', 'central_admin'),
  validate(spaceSchemas.capacityRule),
  addCapacityRule
);

module.exports = router;
