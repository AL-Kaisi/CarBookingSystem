const express = require('express');
const router = express.Router();
const db = require('../config/database');

// Home page with dashboard
router.get('/', async (req, res) => {
  try {
    // Get statistics
    const stats = {};
    
    const customerCount = await db.query('SELECT COUNT(*) FROM customer');
    stats.customers = customerCount.rows[0].count;
    
    const vehicleCount = await db.query('SELECT COUNT(*) FROM vehicle');
    stats.vehicles = vehicleCount.rows[0].count;
    
    const activeBookings = await db.query('SELECT COUNT(*) FROM booking WHERE booking_status_code IN (\'confirmed\', \'open\')');
    stats.activeBookings = activeBookings.rows[0].count;
    
    const todayBookings = await db.query('SELECT COUNT(*) FROM booking WHERE date_from = CURRENT_DATE');
    stats.todayBookings = todayBookings.rows[0].count;
    
    // Get recent bookings
    const recentBookings = await db.query(`
      SELECT b.*, c.cust_forename, c.cust_surname, v.reg_number, v.model_code
      FROM booking b
      JOIN customer c ON b.customer_id = c.customer_id
      JOIN vehicle v ON b.reg_number = v.reg_number
      ORDER BY b.created_date DESC
      LIMIT 5
    `);
    
    res.render('index', { 
      stats, 
      recentBookings: recentBookings.rows 
    });
  } catch (err) {
    console.error(err);
    res.render('index', { 
      stats: { customers: 0, vehicles: 0, activeBookings: 0, todayBookings: 0 },
      recentBookings: []
    });
  }
});

// Reports page
router.get('/reports', async (req, res) => {
  try {
    const revenueReport = await db.query('SELECT * FROM revenue_report() ORDER BY month DESC LIMIT 12');
    
    res.render('reports', {
      revenueReport: revenueReport.rows
    });
  } catch (err) {
    console.error(err);
    req.flash('error_msg', 'Error loading reports');
    res.redirect('/');
  }
});

module.exports = router;