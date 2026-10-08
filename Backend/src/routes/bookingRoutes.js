const express = require('express');
const {
  createBooking,
  getBooking,
  listBookings,
  updateBookingStatus
} = require('../controllers/bookingController');
const { requireAuth } = require('../middleware/auth');
const { validate } = require('../middleware/validate');
const { bookingSchemas } = require('../utils/validationSchemas');

const router = express.Router();

router.post('/', requireAuth, validate(bookingSchemas.create), createBooking);
router.get('/', requireAuth, listBookings);
router.get('/:id', requireAuth, validate(bookingSchemas.idParam), getBooking);
router.patch('/:id/status', requireAuth, validate(bookingSchemas.status), updateBookingStatus);

module.exports = router;
