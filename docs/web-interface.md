# Car Booking System Web Interface

The Car Booking System includes a modern web interface built with Node.js and Express, providing an easy-to-use dashboard for managing customers, vehicles, and bookings.

## Features

### Dashboard
- Overview of system statistics
- Recent bookings display
- Quick action buttons for common tasks

### Customer Management
- List all customers
- Search customers by name or email
- View customer details and booking history
- Add new customers

### Vehicle Management
- List all vehicles
- Add or update vehicle information
- Check vehicle availability
- View vehicle details

### Booking System
- Create new bookings
- Check availability in real-time
- Update booking status
- View all bookings

### Reporting
- Monthly revenue reports
- Visual charts for data analysis
- Export data to CSV

## Technology Stack

- **Backend**: Node.js with Express
- **Database**: PostgreSQL
- **View Engine**: EJS
- **Styling**: Custom CSS
- **JavaScript**: Vanilla JS for frontend interactions

## Quick Start

### Using Docker (Recommended)

1. Clone the repository:
```bash
git clone https://github.com/AL-Kaisi/CarBookingSystem.git
cd CarBookingSystem
```

2. Start the entire system:
```bash
docker-compose up -d
```

3. Access the web interface:
```
http://localhost:3000
```

### Manual Installation

1. Install dependencies:
```bash
cd web
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your database credentials
```

3. Start the server:
```bash
npm start
```

## Interface Guide

### Navigation
The main navigation menu provides access to all sections:
- Dashboard
- Customers
- Vehicles
- Bookings
- Reports

### Creating a Booking
1. Click "New Booking" from the dashboard or bookings page
2. Fill in customer information (or select existing customer)
3. Select vehicle category and dates
4. Click "Check Availability" to see available vehicles
5. Submit the booking form

### Managing Customers
1. Navigate to the Customers section
2. Use the search bar to find specific customers
3. Click on a customer to view their details and booking history
4. Add new customers using the "Add Customer" button

### Vehicle Operations
1. Go to the Vehicles section
2. View all vehicles in the fleet
3. Add new vehicles or update existing ones
4. Check availability for specific dates

### Status Updates
Booking statuses can be updated directly from the bookings list:
- Open
- Confirmed
- Cancelled
- Completed
- No Show

## Security Considerations

- All inputs are validated
- SQL injection protection through parameterised queries
- Session management for user state
- Environment variables for sensitive data

## Customisation

### Styling
Modify `/web/public/css/style.css` to change the appearance.

### Adding Features
1. Add new routes in `/web/routes/`
2. Create controllers in `/web/controllers/`
3. Add views in `/web/views/`

### Database Functions
All database operations use the PostgreSQL functions defined in the main system.

## Troubleshooting

### Connection Issues
- Verify PostgreSQL is running
- Check database credentials in `.env`
- Ensure correct host/port configuration

### Display Problems
- Clear browser cache
- Check console for JavaScript errors
- Verify all assets are loading

### Data Issues
- Check database functions are installed
- Verify user permissions
- Review server logs for errors

## Performance Tips

1. Use database indexes for frequently queried fields
2. Implement pagination for large data sets
3. Cache static assets
4. Use connection pooling (already implemented)

## Future Enhancements

Planned features for future releases:
- User authentication and authorisation
- Email notifications
- Payment processing integration
- Mobile-responsive design improvements
- Advanced reporting and analytics
- API for third-party integrations

## Support

For issues or questions:
- Check the main documentation
- Review the troubleshooting guide
- Open an issue on GitHub
- Contact the maintainers

The web interface provides a complete solution for managing the car booking system through an intuitive browser-based interface.