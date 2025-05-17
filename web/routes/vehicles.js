const express = require('express');
const router = express.Router();
const vehicleController = require('../controllers/vehicleController');

// Vehicle routes
router.get('/', vehicleController.listVehicles);
router.get('/new', vehicleController.newVehicle);
router.post('/create', vehicleController.createOrUpdateVehicle);
router.get('/availability', vehicleController.checkAvailability);

module.exports = router;