const express = require('express');
const authRoutes = require('./authRoutes');
const branchRoutes = require('./branchRoutes');
const spaceRoutes = require('./spaceRoutes');
const bookingRoutes = require('./bookingRoutes');
const auditRoutes = require('./auditRoutes');
const analyticsRoutes = require('./analyticsRoutes');
const { health } = require('../controllers/healthController');

const router = express.Router();

router.get('/health', health);
router.use('/auth', authRoutes);
router.use('/branches', branchRoutes);
router.use('/spaces', spaceRoutes);
router.use('/bookings', bookingRoutes);
router.use('/audit-logs', auditRoutes);
router.use('/analytics', analyticsRoutes);

module.exports = router;
