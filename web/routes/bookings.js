const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');

// Booking routes
router.get('/', bookingController.listBookings);
router.get('/new', bookingController.showBookingForm);
router.post('/check-availability', bookingController.checkAvailability);
router.post('/create', bookingController.createBooking);
router.post('/update-status', bookingController.updateStatus);

module.exports = router;