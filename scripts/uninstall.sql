-- Car Booking System Uninstall Script for PostgreSQL
-- Version: 2.0.0
-- Author: Mohamed Alkaisi

\echo 'Car Booking System Uninstall Script'
\echo '=================================='
\echo ''
\echo 'WARNING: This will remove all Car Booking System objects!'
\echo 'All data will be permanently deleted!'
\echo ''
\echo 'Press Ctrl+C to cancel or Enter to continue...'
\prompt

-- Drop functions
\echo 'Dropping functions...'
DROP FUNCTION IF EXISTS customer_check(VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS customer_check(INTEGER);
DROP FUNCTION IF EXISTS create_customer(INTEGER, VARCHAR, VARCHAR, CHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS date_check(DATE, DATE);
DROP FUNCTION IF EXISTS check_cars(VARCHAR, DATE, DATE, VARCHAR);
DROP FUNCTION IF EXISTS create_booking(DATE, DATE, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS make_booking(INTEGER, VARCHAR, VARCHAR, CHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, DATE, DATE, VARCHAR);
DROP FUNCTION IF EXISTS update_booking(INTEGER, VARCHAR);
DROP FUNCTION IF EXISTS booking_details(DATE);
DROP FUNCTION IF EXISTS display_booking_report(DATE);
DROP FUNCTION IF EXISTS check_registration_num(VARCHAR);
DROP FUNCTION IF EXISTS add_update_cars(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS revenue_report(DATE, DATE);
DROP FUNCTION IF EXISTS available_vehicles(VARCHAR, DATE, DATE);

-- Drop trigger functions
DROP FUNCTION IF EXISTS check_booking_status_update();
DROP FUNCTION IF EXISTS update_last_updated();
DROP FUNCTION IF EXISTS validate_booking_dates();
DROP FUNCTION IF EXISTS prevent_double_booking();

-- Drop views
\echo 'Dropping views...'
DROP VIEW IF EXISTS customer_booking;

-- Drop tables (in reverse order of dependencies)
\echo 'Dropping tables...'
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS booking_status CASCADE;
DROP TABLE IF EXISTS vehicle CASCADE;
DROP TABLE IF EXISTS model CASCADE;
DROP TABLE IF EXISTS manufacturer CASCADE;
DROP TABLE IF EXISTS vehicle_category CASCADE;
DROP TABLE IF EXISTS customer CASCADE;

-- Drop sequences
\echo 'Dropping sequences...'
DROP SEQUENCE IF EXISTS book_id_seq;
DROP SEQUENCE IF EXISTS cust_id_seq;
DROP SEQUENCE IF EXISTS vehicle_id_seq;

\echo ''
\echo 'Uninstall completed successfully!'
\echo ''