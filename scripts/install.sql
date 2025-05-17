-- Car Booking System Installation Script for PostgreSQL
-- Version: 2.0.0
-- Author: Mohamed Alkaisi
-- Date: May 2025

\echo 'Car Booking System Installation Script'
\echo '====================================='
\echo ''
\echo 'This script will install all required database objects'
\echo 'for the Car Booking System on PostgreSQL.'
\echo ''

-- Create sequences
\echo 'Creating sequences...'

CREATE SEQUENCE IF NOT EXISTS cust_id_seq
    START WITH 1000
    INCREMENT BY 1
    NO CYCLE;

CREATE SEQUENCE IF NOT EXISTS book_id_seq
    START WITH 5000
    INCREMENT BY 1
    NO CYCLE;

CREATE SEQUENCE IF NOT EXISTS vehicle_id_seq
    START WITH 100
    INCREMENT BY 1
    NO CYCLE;

-- Create tables
\echo 'Creating tables...'

-- Customer table
CREATE TABLE IF NOT EXISTS customer (
    customer_id INTEGER PRIMARY KEY DEFAULT nextval('cust_id_seq'),
    cust_forename VARCHAR(50) NOT NULL,
    cust_surname VARCHAR(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    email_address VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    address_line3 VARCHAR(100),
    town VARCHAR(50),
    post_code VARCHAR(20),
    country VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicle category table
CREATE TABLE IF NOT EXISTS vehicle_category (
    vehicle_category_code VARCHAR(20) PRIMARY KEY,
    vehicle_category_description VARCHAR(100) NOT NULL
);

-- Manufacturer table
CREATE TABLE IF NOT EXISTS manufacturer (
    manufacturer_code VARCHAR(20) PRIMARY KEY,
    manufacturer_name VARCHAR(50) NOT NULL
);

-- Model table
CREATE TABLE IF NOT EXISTS model (
    model_code VARCHAR(20) PRIMARY KEY,
    manufacturer_code VARCHAR(20) REFERENCES manufacturer(manufacturer_code),
    model_name VARCHAR(50) NOT NULL,
    daily_hire_rate DECIMAL(10,2) NOT NULL
);

-- Vehicle table
CREATE TABLE IF NOT EXISTS vehicle (
    reg_number VARCHAR(20) PRIMARY KEY,
    manufacturer_code VARCHAR(20) REFERENCES manufacturer(manufacturer_code),
    model_code VARCHAR(20) REFERENCES model(model_code),
    vehicle_category_code VARCHAR(20) REFERENCES vehicle_category(vehicle_category_code),
    current_mileage INTEGER,
    daily_hire_rate DECIMAL(10,2),
    date_mot_due DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Booking status table
CREATE TABLE IF NOT EXISTS booking_status (
    booking_status_code VARCHAR(20) PRIMARY KEY,
    booking_status_description VARCHAR(100) NOT NULL
);

-- Booking table
CREATE TABLE IF NOT EXISTS booking (
    booking_id INTEGER PRIMARY KEY DEFAULT nextval('book_id_seq'),
    booking_status_code VARCHAR(20) REFERENCES booking_status(booking_status_code),
    customer_id INTEGER REFERENCES customer(customer_id),
    reg_number VARCHAR(20) REFERENCES vehicle(reg_number),
    date_from DATE NOT NULL,
    date_to DATE NOT NULL,
    total_cost DECIMAL(10,2),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT date_check CHECK (date_to >= date_from)
);

-- Create indexes
\echo 'Creating indexes...'

CREATE INDEX IF NOT EXISTS idx_customer_email ON customer(email_address);
CREATE INDEX IF NOT EXISTS idx_customer_name ON customer(cust_surname, cust_forename);
CREATE INDEX IF NOT EXISTS idx_booking_dates ON booking(date_from, date_to);
CREATE INDEX IF NOT EXISTS idx_booking_customer ON booking(customer_id);
CREATE INDEX IF NOT EXISTS idx_booking_vehicle ON booking(reg_number);
CREATE INDEX IF NOT EXISTS idx_vehicle_category ON vehicle(vehicle_category_code);

-- Create views
\echo 'Creating views...'

CREATE OR REPLACE VIEW customer_booking AS
SELECT 
    b.booking_id,
    b.customer_id,
    b.booking_status_code,
    b.reg_number,
    b.date_from,
    b.date_to,
    c.cust_forename,
    c.cust_surname,
    c.email_address,
    v.manufacturer_code,
    v.model_code,
    v.vehicle_category_code,
    v.daily_hire_rate
FROM booking b
JOIN customer c ON b.customer_id = c.customer_id
JOIN vehicle v ON b.reg_number = v.reg_number;

-- Insert reference data
\echo 'Inserting reference data...'

-- Vehicle categories
INSERT INTO vehicle_category VALUES ('COMPACT', 'Compact Car') ON CONFLICT DO NOTHING;
INSERT INTO vehicle_category VALUES ('SALOON', 'Saloon') ON CONFLICT DO NOTHING;
INSERT INTO vehicle_category VALUES ('SUV', 'Sport Utility Vehicle') ON CONFLICT DO NOTHING;
INSERT INTO vehicle_category VALUES ('LUXURY', 'Luxury Vehicle') ON CONFLICT DO NOTHING;
INSERT INTO vehicle_category VALUES ('VAN', 'Van') ON CONFLICT DO NOTHING;
INSERT INTO vehicle_category VALUES ('TRUCK', 'Pickup Truck') ON CONFLICT DO NOTHING;

-- Booking statuses
INSERT INTO booking_status VALUES ('open', 'Open - Unconfirmed') ON CONFLICT DO NOTHING;
INSERT INTO booking_status VALUES ('confirmed', 'Confirmed') ON CONFLICT DO NOTHING;
INSERT INTO booking_status VALUES ('cancelled', 'Cancelled') ON CONFLICT DO NOTHING;
INSERT INTO booking_status VALUES ('completed', 'Completed') ON CONFLICT DO NOTHING;
INSERT INTO booking_status VALUES ('no_show', 'No Show') ON CONFLICT DO NOTHING;

-- Manufacturers
INSERT INTO manufacturer VALUES ('TOYOTA', 'Toyota') ON CONFLICT DO NOTHING;
INSERT INTO manufacturer VALUES ('FORD', 'Ford') ON CONFLICT DO NOTHING;
INSERT INTO manufacturer VALUES ('BMW', 'BMW') ON CONFLICT DO NOTHING;
INSERT INTO manufacturer VALUES ('MERCEDES', 'Mercedes-Benz') ON CONFLICT DO NOTHING;
INSERT INTO manufacturer VALUES ('HONDA', 'Honda') ON CONFLICT DO NOTHING;
INSERT INTO manufacturer VALUES ('NISSAN', 'Nissan') ON CONFLICT DO NOTHING;

-- Verify installation
\echo ''
\echo 'Verifying installation...'
\echo ''

SELECT 'Tables' as object_type, COUNT(*) as count 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
UNION ALL
SELECT 'Views', COUNT(*) 
FROM information_schema.views 
WHERE table_schema = 'public';

\echo ''
\echo 'Installation completed successfully!'
\echo ''
\echo 'Note: Functions and triggers must be installed separately'
\echo ''