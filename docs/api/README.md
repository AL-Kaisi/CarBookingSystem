# Car Booking System API Documentation

This document provides detailed information about the PostgreSQL functions available in the Car Booking System.

## Table of Contents

1. [Customer Functions](#customer-functions)
2. [Booking Functions](#booking-functions)
3. [Vehicle Functions](#vehicle-functions)
4. [Reporting Functions](#reporting-functions)
5. [Usage Examples](#usage-examples)
6. [Error Handling](#error-handling)

## Customer Functions

### customer_check (Overloaded)

**Version 1: Check by customer details**
```sql
customer_check(
    v_forname VARCHAR,
    v_surname VARCHAR,
    v_email VARCHAR
) RETURNS BOOLEAN
```

**Version 2: Check by customer ID**
```sql
customer_check(
    v_customer_id INTEGER
) RETURNS BOOLEAN
```

**Description**: Verifies if a customer exists in the database.

**Parameters**:
- `v_forname`: Customer's first name
- `v_surname`: Customer's last name
- `v_email`: Customer's email address
- `v_customer_id`: Customer's unique ID

**Returns**: TRUE if customer exists, FALSE otherwise

---

### create_customer

```sql
create_customer(
    v_customer_id INTEGER,
    v_forname VARCHAR,
    v_surname VARCHAR,
    v_gender CHAR,
    v_email VARCHAR,
    v_phone_number VARCHAR,
    v_address_line1 VARCHAR,
    v_address_line2 VARCHAR,
    v_address_line3 VARCHAR,
    v_town VARCHAR,
    v_postcode VARCHAR,
    v_country VARCHAR
) RETURNS VOID
```

**Description**: Creates a new customer record.

**Parameters**:
- `v_customer_id`: Customer ID (use NULL for auto-generation)
- `v_forname`: Customer's first name
- `v_surname`: Customer's last name
- `v_gender`: Customer's gender ('M' or 'F')
- `v_email`: Customer's email address
- `v_phone_number`: Customer's phone number
- `v_address_line1`: Primary address line
- `v_address_line2`: Secondary address line (optional)
- `v_address_line3`: Tertiary address line (optional)
- `v_town`: Town/City
- `v_postcode`: Postal code
- `v_country`: Country

## Booking Functions

### check_cars

```sql
check_cars(
    v_type VARCHAR,
    v_date_from DATE,
    v_date_to DATE,
    v_email VARCHAR
) RETURNS BOOLEAN
```

**Description**: Checks vehicle availability for a specific category and date range.

**Parameters**:
- `v_type`: Vehicle category code (e.g., 'SUV', 'SALOON')
- `v_date_from`: Start date of booking
- `v_date_to`: End date of booking
- `v_email`: Customer's email address

**Returns**: TRUE if vehicles are available, FALSE otherwise

---

### date_check

```sql
date_check(
    v_date_from DATE,
    v_date_to DATE
) RETURNS BOOLEAN
```

**Description**: Validates booking dates.

**Parameters**:
- `v_date_from`: Start date of booking
- `v_date_to`: End date of booking

**Returns**: TRUE if dates are valid, FALSE otherwise

---

### create_booking

```sql
create_booking(
    a_date_to DATE,
    a_date_from DATE,
    a_email VARCHAR,
    a_registration_number VARCHAR
) RETURNS BOOLEAN
```

**Description**: Creates a new booking for a specific vehicle.

**Parameters**:
- `a_date_to`: End date of booking
- `a_date_from`: Start date of booking
- `a_email`: Customer's email address
- `a_registration_number`: Vehicle registration number

**Returns**: TRUE if booking created successfully, FALSE otherwise

---

### make_booking

```sql
make_booking(
    v_customer_id INTEGER,
    v_forname VARCHAR,
    v_surname VARCHAR,
    v_gender CHAR,
    v_email VARCHAR,
    v_phone_number VARCHAR,
    v_address_line1 VARCHAR,
    v_address_line2 VARCHAR,
    v_address_line3 VARCHAR,
    v_town VARCHAR,
    v_postcode VARCHAR,
    v_country VARCHAR,
    v_vehicletype VARCHAR,
    v_date_from DATE,
    v_date_to DATE,
    v_booking_status VARCHAR
) RETURNS BOOLEAN
```

**Description**: Complete booking workflow that handles customer creation/verification and booking creation.

**Returns**: TRUE if booking created successfully, FALSE otherwise

---

### update_booking

```sql
update_booking(
    v_bookingid INTEGER,
    v_booking_status_code VARCHAR
) RETURNS VOID
```

**Description**: Updates the status of an existing booking.

**Parameters**:
- `v_bookingid`: Booking ID to update
- `v_booking_status_code`: New status code ('confirmed', 'cancelled', etc.)

## Vehicle Functions

### check_registration_num

```sql
check_registration_num(
    v_reg_num VARCHAR
) RETURNS BOOLEAN
```

**Description**: Checks if a vehicle registration number exists.

**Parameters**:
- `v_reg_num`: Vehicle registration number

**Returns**: TRUE if registration doesn't exist, FALSE if it exists

---

### add_update_cars

```sql
add_update_cars(
    v_reg_number VARCHAR,
    v_manufacturer_code VARCHAR,
    v_model_code VARCHAR,
    v_vehicle_category_code VARCHAR,
    v_current_mileage VARCHAR,
    v_daily_hire_rate VARCHAR,
    v_daily_mot_due VARCHAR,
    v_model_name VARCHAR,
    v_manufacture_name VARCHAR
) RETURNS VOID
```

**Description**: Adds a new vehicle or updates existing vehicle information.

---

### available_vehicles

```sql
available_vehicles(
    v_category VARCHAR,
    v_date_from DATE,
    v_date_to DATE
) RETURNS TABLE (
    reg_number VARCHAR,
    model_name VARCHAR,
    daily_hire_rate DECIMAL
)
```

**Description**: Returns available vehicles for a category and date range.

**Parameters**:
- `v_category`: Vehicle category code
- `v_date_from`: Start date
- `v_date_to`: End date

**Returns**: Table of available vehicles with registration, model, and rate

## Reporting Functions

### booking_details

```sql
booking_details(v_date DATE)
RETURNS TABLE (
    booking_id INTEGER,
    customer_id INTEGER,
    booking_status_code VARCHAR,
    reg_number VARCHAR,
    date_from DATE,
    date_to DATE,
    cust_forename VARCHAR,
    cust_surname VARCHAR,
    email_address VARCHAR
)
```

**Description**: Returns booking details for a specific date.

**Parameters**:
- `v_date`: Date to query bookings

**Returns**: Table with booking information

---

### display_booking_report

```sql
display_booking_report(v_date DATE)
RETURNS TABLE (
    booking_info TEXT
)
```

**Description**: Displays a formatted booking report for a specific date.

**Parameters**:
- `v_date`: Date to generate report for

**Returns**: Formatted booking information

---

### revenue_report

```sql
revenue_report(
    start_date DATE DEFAULT NULL,
    end_date DATE DEFAULT NULL
) RETURNS TABLE (
    month TEXT,
    total_bookings BIGINT,
    total_revenue DECIMAL
)
```

**Description**: Generates revenue report for specified period.

**Parameters**:
- `start_date`: Report start date (optional)
- `end_date`: Report end date (optional)

**Returns**: Monthly revenue summary

## Usage Examples

### Creating a new customer and booking

```sql
SELECT make_booking(
    NULL,  -- customer_id
    'John',
    'Doe',
    'M',
    'john.doe@example.co.uk',
    '020-7123-4567',
    '123 High Street',
    NULL,
    NULL,
    'London',
    'SW1A 1AA',
    'UK',
    'SUV',
    '2025-07-01'::DATE,
    '2025-07-07'::DATE,
    'confirmed'
);
```

### Checking vehicle availability

```sql
SELECT * FROM available_vehicles('COMPACT', '2025-08-01', '2025-08-05');
```

### Generating a booking report

```sql
SELECT * FROM display_booking_report('2025-07-01'::DATE);
```

### Getting revenue report

```sql
SELECT * FROM revenue_report('2025-01-01'::DATE, '2025-12-31'::DATE);
```

## Error Handling

The system uses PostgreSQL exception handling:

- `RAISE NOTICE`: For informational messages
- `RAISE EXCEPTION`: For errors that stop execution
- `EXCEPTION` blocks: Handle specific error conditions

All functions include exception handlers that provide meaningful error messages.

## Best Practices

1. Always validate dates before creating bookings
2. Check customer existence before processing bookings
3. Use appropriate exception handling in your applications
4. Ensure all required fields are provided when creating customers
5. Verify vehicle availability before confirming bookings
6. Use transactions when making multiple related changes