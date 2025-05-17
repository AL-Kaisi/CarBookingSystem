# Quick Start Guide

Get up and running with the Car Booking System in 5 minutes!

## Prerequisites

- Docker and Docker Compose (recommended)
- OR PostgreSQL 13+ and Node.js 16+

## Quick Start with Docker (Recommended)

### 1. Clone the Repository

```bash
git clone https://github.com/AL-Kaisi/CarBookingSystem.git
cd CarBookingSystem
```

### 2. Start Everything

```bash
docker-compose up -d
```

### 3. Install Database

```bash
docker exec -it carbooking_db psql -U carbooking -d carbooking -f /docker-entrypoint-initdb.d/install.sql
```

### 4. Access Web Interface

Open your browser to:
```
http://localhost:3000
```

That's it! The system is now running with both database and web interface.

## Manual Installation

### 1. Database Setup

```bash
createdb carbooking
psql -d carbooking -f scripts/install.sql
psql -d carbooking -f sql/data/sample_data.sql
```

### 2. Web Interface Setup

```bash
cd web
npm install
cp .env.example .env
# Edit .env with your database credentials
npm start
```

### 3. Access

Open: http://localhost:3000

## Using the Web Interface

### 1. Dashboard
The home page shows system statistics and recent bookings.

### 2. Create a Booking
1. Click "New Booking" on the dashboard
2. Fill in customer details
3. Select vehicle type and dates
4. Click "Check Availability"
5. Submit the booking

### 3. Manage Customers
- View all customers
- Search by name or email
- Add new customers
- View booking history

### 4. Vehicle Management
- View fleet inventory
- Add or update vehicles
- Check availability

## Using SQL Commands

### Connect to Database

```bash
docker exec -it carbooking_db psql -U carbooking -d carbooking
```

### Check Vehicle Availability

```sql
SELECT * FROM available_vehicles('SUV', CURRENT_DATE + 7, CURRENT_DATE + 10);
```

### Create a Booking

```sql
SELECT make_booking(
    NULL,  -- customer_id (NULL for new customer)
    'John', 'Smith', 'M',
    'john.smith@example.co.uk',
    '020-7946-0123',
    '123 High Street',
    NULL, NULL,
    'London', 'SW1A 1AA', 'UK',
    'SUV',
    CURRENT_DATE + 7,
    CURRENT_DATE + 10,
    'confirmed'
);
```

## Common Operations

### Check if Customer Exists

```sql
SELECT customer_check('John', 'Smith', 'john.smith@example.co.uk');
```

### Update Booking Status

```sql
SELECT update_booking(5001, 'cancelled');
```

### Add New Vehicle

```sql
SELECT add_update_cars(
    'BA23 XYZ',
    'TOYOTA',
    'CAMRY',
    'SALOON',
    '0',
    '65.00',
    '2026-01-01',
    'Camry',
    'Toyota'
);
```

## Useful Queries

### Available Vehicles by Category

```sql
SELECT * FROM available_vehicles('SUV', CURRENT_DATE + 7, CURRENT_DATE + 10);
```

### Customer Booking History

```sql
SELECT b.booking_id, b.date_from, b.date_to, v.reg_number, b.booking_status_code
FROM booking b
JOIN customer c ON b.customer_id = c.customer_id
JOIN vehicle v ON b.reg_number = v.reg_number
WHERE c.email_address = 'john.smith@example.co.uk'
ORDER BY b.date_from DESC;
```

### Revenue Report

```sql
SELECT * FROM revenue_report();
```

## Troubleshooting

### Connection Failed
- Check PostgreSQL is running: `pg_ctl status`
- Verify database exists: `psql -l | grep carbooking`

### Installation Failed
- Check user privileges: `\du` in psql
- Ensure scripts directory is accessible

### Function Not Found
- Verify installation completed: `\df` in psql
- Check for error messages in installation output

## Next Steps

1. Read the full [API Documentation](docs/api/README.md)
2. Review the [Development Guide](docs/guides/development.md)
3. Check out [Troubleshooting Guide](docs/guides/troubleshooting.md)
4. Contribute to the project!

## Need Help?

- [Full Documentation](docs/)
- [Report Issues](https://github.com/AL-Kaisi/CarBookingSystem/issues)
- [Discussions](https://github.com/AL-Kaisi/CarBookingSystem/discussions)

Happy motoring!