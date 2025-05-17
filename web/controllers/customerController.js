const db = require('../config/database');

const customerController = {
  // List all customers
  listCustomers: async (req, res) => {
    try {
      const result = await db.query('SELECT * FROM customer ORDER BY cust_surname, cust_forename');
      res.render('customers/list', { customers: result.rows });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error loading customers');
      res.redirect('/');
    }
  },

  // Show customer details
  showCustomer: async (req, res) => {
    const customerId = req.params.id;
    
    try {
      const customerResult = await db.query('SELECT * FROM customer WHERE customer_id = $1', [customerId]);
      const bookingsResult = await db.query(`
        SELECT b.*, v.model_code, v.vehicle_category_code, bs.booking_status_description
        FROM booking b
        JOIN vehicle v ON b.reg_number = v.reg_number
        JOIN booking_status bs ON b.booking_status_code = bs.booking_status_code
        WHERE b.customer_id = $1
        ORDER BY b.date_from DESC
      `, [customerId]);
      
      if (customerResult.rows.length === 0) {
        req.flash('error_msg', 'Customer not found');
        return res.redirect('/customers');
      }
      
      res.render('customers/show', { 
        customer: customerResult.rows[0],
        bookings: bookingsResult.rows
      });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error loading customer details');
      res.redirect('/customers');
    }
  },

  // Create new customer form
  newCustomer: (req, res) => {
    res.render('customers/new');
  },

  // Create customer
  createCustomer: async (req, res) => {
    const { forname, surname, gender, email, phone, address1, address2, address3, town, postcode, country } = req.body;
    
    try {
      await db.query(
        `SELECT create_customer(NULL, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
        [forname, surname, gender, email, phone, address1, address2, address3, town, postcode, country]
      );
      
      req.flash('success_msg', 'Customer created successfully');
      res.redirect('/customers');
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error creating customer: ' + err.message);
      res.redirect('/customers/new');
    }
  },

  // Search customer
  searchCustomer: async (req, res) => {
    const { query } = req.query;
    
    try {
      const result = await db.query(`
        SELECT * FROM customer 
        WHERE LOWER(cust_forename) LIKE LOWER($1) 
           OR LOWER(cust_surname) LIKE LOWER($1)
           OR LOWER(email_address) LIKE LOWER($1)
        ORDER BY cust_surname, cust_forename
      `, [`%${query}%`]);
      
      res.render('customers/list', { customers: result.rows, searchQuery: query });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error searching customers');
      res.redirect('/customers');
    }
  }
};

module.exports = customerController;