const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');

// Customer routes
router.get('/', customerController.listCustomers);
router.get('/new', customerController.newCustomer);
router.post('/create', customerController.createCustomer);
router.get('/search', customerController.searchCustomer);
router.get('/:id', customerController.showCustomer);

module.exports = router;