const express = require('express');
const { createBranch, listBranches } = require('../controllers/branchController');
const { createSpace, listSpaces } = require('../controllers/spaceController');
const { recordWalkIn } = require('../controllers/occupancyController');
const { requireAuth, requireRole } = require('../middleware/auth');
const { validate } = require('../middleware/validate');
const { branchSchemas, occupancySchemas, spaceSchemas } = require('../utils/validationSchemas');

const router = express.Router();

router.get('/', requireAuth, listBranches);
router.post('/', requireAuth, requireRole('central_admin'), validate(branchSchemas.create), createBranch);
router.get('/:branchId/spaces', requireAuth, validate(spaceSchemas.list), listSpaces);
router.post(
  '/:branchId/spaces',
  requireAuth,
  requireRole('branch_manager', 'central_admin'),
  validate(spaceSchemas.create),
  createSpace
);
router.post(
  '/:branchId/walk-ins',
  requireAuth,
  requireRole('branch_manager', 'central_admin'),
  validate(occupancySchemas.createWalkIn),
  recordWalkIn
);

module.exports = router;
