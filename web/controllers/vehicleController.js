const db = require('../config/database');

const vehicleController = {
  // List all vehicles
  listVehicles: async (req, res) => {
    try {
      const result = await db.query(`
        SELECT v.*, m.model_name, man.manufacturer_name, vc.vehicle_category_description
        FROM vehicle v
        JOIN model m ON v.model_code = m.model_code
        JOIN manufacturer man ON v.manufacturer_code = man.manufacturer_code
        JOIN vehicle_category vc ON v.vehicle_category_code = vc.vehicle_category_code
        ORDER BY v.vehicle_category_code, v.reg_number
      `);
      
      res.render('vehicles/list', { vehicles: result.rows });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error loading vehicles');
      res.redirect('/');
    }
  },

  // Show vehicle form
  newVehicle: async (req, res) => {
    try {
      const categoriesResult = await db.query('SELECT * FROM vehicle_category ORDER BY vehicle_category_code');
      const manufacturersResult = await db.query('SELECT * FROM manufacturer ORDER BY manufacturer_name');
      const modelsResult = await db.query('SELECT * FROM model ORDER BY model_name');
      
      res.render('vehicles/new', {
        categories: categoriesResult.rows,
        manufacturers: manufacturersResult.rows,
        models: modelsResult.rows
      });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error loading vehicle form');
      res.redirect('/vehicles');
    }
  },

  // Create or update vehicle
  createOrUpdateVehicle: async (req, res) => {
    const {
      reg_number, manufacturer_code, model_code, vehicle_category_code,
      current_mileage, daily_hire_rate, date_mot_due, model_name, manufacturer_name
    } = req.body;

    try {
      await db.query(
        'SELECT add_update_cars($1, $2, $3, $4, $5, $6, $7, $8, $9)',
        [reg_number, manufacturer_code, model_code, vehicle_category_code,
         current_mileage, daily_hire_rate, date_mot_due, model_name, manufacturer_name]
      );
      
      req.flash('success_msg', 'Vehicle saved successfully');
      res.redirect('/vehicles');
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error saving vehicle: ' + err.message);
      res.redirect('/vehicles/new');
    }
  },

  // Check availability
  checkAvailability: async (req, res) => {
    const { category, date_from, date_to } = req.query;
    
    try {
      const result = await db.query(
        'SELECT * FROM available_vehicles($1, $2::date, $3::date)',
        [category, date_from, date_to]
      );
      
      res.render('vehicles/availability', {
        vehicles: result.rows,
        searchParams: { category, date_from, date_to }
      });
    } catch (err) {
      console.error(err);
      req.flash('error_msg', 'Error checking availability');
      res.redirect('/vehicles');
    }
  }
};

module.exports = vehicleController;