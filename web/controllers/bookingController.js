const db = require('../config/database');

const bookingController = {
  // Show booking form
  showBookingForm: async (req, res) => {
    try {
      const categoriesResult = await db.query('SELECT * FROM vehicle_category ORDER BY vehicle_category_code');
      res.render('bookings/new', { categories: categoriesResult.rows });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error loading booking form');
      res.redirect('/');
    }
  },

  // Check availability
  checkAvailability: async (req, res) => {
    const { category, date_from, date_to } = req.body;
    
    try {
      const result = await db.query(
        'SELECT * FROM available_vehicles($1, $2::date, $3::date)',
        [category, date_from, date_to]
      );
      
      res.json({ available: result.rows.length > 0, vehicles: result.rows });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error checking availability' });
    }
  },

  // Create booking
  createBooking: async (req, res) => {
    const {
      customer_id, forname, surname, gender, email, phone, 
      address1, town, postcode, country, vehicle_type, 
      date_from, date_to
    } = req.body;

    try {
      const result = await db.query(
        `SELECT make_booking($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14::date, $15::date, $16)`,
        [customer_id, forname, surname, gender, email, phone, address1, null, null, town, postcode, country, vehicle_type, date_from, date_to, 'confirmed']
      );

      req.flash('success_msg', 'Booking created successfully!');
      res.redirect('/bookings');
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error creating booking: ' + err.message);
      res.redirect('/bookings/new');
    }
  },

  // List bookings
  listBookings: async (req, res) => {
    try {
      const result = await db.query(`
        SELECT b.*, c.cust_forename, c.cust_surname, c.email_address,
               v.model_code, v.vehicle_category_code, bs.booking_status_description
        FROM booking b
        JOIN customer c ON b.customer_id = c.customer_id
        JOIN vehicle v ON b.reg_number = v.reg_number
        JOIN booking_status bs ON b.booking_status_code = bs.booking_status_code
        ORDER BY b.date_from DESC
      `);
      
      res.render('bookings/list', { bookings: result.rows });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error loading bookings');
      res.redirect('/');
    }
  },

  // Update booking status
  updateStatus: async (req, res) => {
    const { booking_id, status } = req.body;
    
    try {
      await db.query('SELECT update_booking($1, $2)', [booking_id, status]);
      req.flash('success_msg', 'Booking status updated');
      res.redirect('/bookings');
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error updating booking: ' + err.message);
      res.redirect('/bookings');
    }
  }
};

module.exports = bookingController;