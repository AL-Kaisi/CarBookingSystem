-- Car Booking System Complete Installation Script
-- Version: 2.0.0
-- Author: Mohamed Alkaisi
-- Date: May 2025

\echo 'Car Booking System Complete Installation'
\echo '========================================'
\echo ''

-- Install base schema
\i /docker-entrypoint-initdb.d/install.sql

-- Install functions
\echo ''
\echo 'Installing functions...'
\echo ''

-- Include function definitions inline since file paths are problematic in Docker
-- Customer check function (overloaded)
CREATE OR REPLACE FUNCTION customer_check(
    v_forname VARCHAR,
    v_surname VARCHAR,
    v_email VARCHAR
) RETURNS BOOLEAN AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM customer 
    WHERE cust_forename = v_forname 
    AND cust_surname = v_surname 
    AND email_address = v_email;
    
    RETURN v_count = 1;
EXCEPTION 
    WHEN OTHERS THEN 
        RAISE NOTICE 'Error in customer_check: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- Customer check by ID
CREATE OR REPLACE FUNCTION customer_check(
    v_customer_id INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM customer 
    WHERE customer_id = v_customer_id;
    
    RETURN v_count = 1;
EXCEPTION 
    WHEN OTHERS THEN 
        RAISE NOTICE 'Error in customer_check: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- Create customer procedure
CREATE OR REPLACE FUNCTION create_customer(
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
) RETURNS VOID AS $$
BEGIN
    INSERT INTO customer (
        customer_id, cust_forename, cust_surname,
        gender, email_address, phone_number,
        address_line1, address_line2, address_line3,
        town, post_code, country
    ) VALUES (
        COALESCE(v_customer_id, nextval('cust_id_seq')),
        v_forname, v_surname, v_gender, v_email,
        v_phone_number, v_address_line1, v_address_line2,
        v_address_line3, v_town, v_postcode, v_country
    );
    
    RAISE NOTICE 'Customer created: % %', v_forname, v_surname;
EXCEPTION 
    WHEN OTHERS THEN 
        RAISE EXCEPTION 'Error creating customer: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Date check function
CREATE OR REPLACE FUNCTION date_check(
    v_date_from DATE,
    v_date_to DATE
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN v_date_from > CURRENT_DATE 
       AND v_date_to > CURRENT_DATE 
       AND v_date_from <= v_date_to;
EXCEPTION 
    WHEN OTHERS THEN 
        RAISE NOTICE 'Error in date_check: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- Create booking function
CREATE OR REPLACE FUNCTION create_booking(
    a_date_to DATE,
    a_date_from DATE,
    a_email VARCHAR,
    a_registration_number VARCHAR
) RETURNS BOOLEAN AS $$
DECLARE
    v_customer_id INTEGER;
    v_count INTEGER;
    v_booking_id INTEGER;
BEGIN
    -- Check if vehicle is already booked
    SELECT COUNT(*) INTO v_count
    FROM booking
    WHERE reg_number = a_registration_number
    AND date_from <= a_date_to
    AND date_to >= a_date_from;
    
    -- Get customer ID
    SELECT customer_id INTO v_customer_id
    FROM customer
    WHERE email_address = a_email;
    
    IF v_count > 0 THEN
        RETURN FALSE;
    ELSIF date_check(a_date_from, a_date_to) THEN
        INSERT INTO booking (
            booking_status_code, customer_id, reg_number,
            date_from, date_to
        ) VALUES (
            'open', v_customer_id, a_registration_number,
            a_date_from, a_date_to
        );
        
        v_booking_id := currval('book_id_seq');
        
        RAISE NOTICE 'Booking ID % created for customer ID %', v_booking_id, v_customer_id;
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'Invalid date range';
    END IF;
    
    RETURN FALSE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Please enter your email to book';
        RETURN FALSE;
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in create_booking: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- Check cars availability
CREATE OR REPLACE FUNCTION check_cars(
    v_type VARCHAR,
    v_date_from DATE,
    v_date_to DATE,
    v_email VARCHAR
) RETURNS BOOLEAN AS $$
DECLARE
    v_reg_num VARCHAR;
    v_check BOOLEAN := FALSE;
    cur_check CURSOR FOR 
        SELECT reg_number 
        FROM vehicle 
        WHERE vehicle_category_code = v_type;
BEGIN
    FOR v_reg_num IN cur_check LOOP
        v_check := create_booking(v_date_to, v_date_from, v_email, v_reg_num);
        EXIT WHEN v_check = TRUE;
    END LOOP;
    
    IF NOT v_check THEN 
        RAISE NOTICE 'Sorry, there are no cars available';
    END IF;
    
    RETURN v_check;
EXCEPTION 
    WHEN OTHERS THEN 
        RAISE NOTICE 'Error in check_cars: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- Make booking (main procedure)
CREATE OR REPLACE FUNCTION make_booking(
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
) RETURNS BOOLEAN AS $$
DECLARE
    c_check_customer BOOLEAN;
    c_car_check BOOLEAN;
    c_email VARCHAR;
BEGIN
    -- Check or create customer
    IF v_customer_id IS NULL THEN
        c_check_customer := customer_check(v_forname, v_surname, v_email);
        
        IF NOT c_check_customer THEN
            PERFORM create_customer(
                NULL, v_forname, v_surname, v_gender, v_email,
                v_phone_number, v_address_line1, v_address_line2,
                v_address_line3, v_town, v_postcode, v_country
            );
        END IF;
        c_email := v_email;
    ELSE
        c_check_customer := customer_check(v_customer_id);
        
        IF c_check_customer THEN
            SELECT email_address INTO c_email
            FROM customer
            WHERE customer_id = v_customer_id;
        ELSE
            PERFORM create_customer(
                NULL, v_forname, v_surname, v_gender, v_email,
                v_phone_number, v_address_line1, v_address_line2,
                v_address_line3, v_town, v_postcode, v_country
            );
            c_email := v_email;
        END IF;
    END IF;
    
    -- Check and create booking
    IF v_vehicletype IS NOT NULL THEN
        c_car_check := check_cars(v_vehicletype, v_date_from, v_date_to, c_email);
        RETURN c_car_check;
    END IF;
    
    RETURN FALSE;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in make_booking: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- Update booking status
CREATE OR REPLACE FUNCTION update_booking(
    v_bookingid INTEGER,
    v_booking_status_code VARCHAR
) RETURNS VOID AS $$
DECLARE
    c_status VARCHAR;
BEGIN
    SELECT booking_status_code INTO c_status
    FROM booking
    WHERE booking_id = v_bookingid;
    
    IF c_status = 'cancelled' THEN
        RAISE EXCEPTION 'Booking cannot be changed after cancellation';
    END IF;
    
    UPDATE booking
    SET booking_status_code = v_booking_status_code,
        last_updated = CURRENT_TIMESTAMP
    WHERE booking_id = v_bookingid;
    
    RAISE NOTICE 'Booking % updated to status %', v_bookingid, v_booking_status_code;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating booking: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Available vehicles function
CREATE OR REPLACE FUNCTION available_vehicles(
    v_category VARCHAR,
    v_date_from DATE,
    v_date_to DATE
) RETURNS TABLE (
    reg_number VARCHAR,
    model_name VARCHAR,
    daily_hire_rate DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT v.reg_number, m.model_name, v.daily_hire_rate
    FROM vehicle v
    JOIN model m ON v.model_code = m.model_code
    WHERE v.vehicle_category_code = v_category
    AND NOT EXISTS (
        SELECT 1 FROM booking b
        WHERE b.reg_number = v.reg_number
        AND b.date_from <= v_date_to
        AND b.date_to >= v_date_from
        AND b.booking_status_code NOT IN ('cancelled')
    )
    ORDER BY v.daily_hire_rate;
END;
$$ LANGUAGE plpgsql;

-- Revenue report function
CREATE OR REPLACE FUNCTION revenue_report(
    start_date DATE DEFAULT NULL,
    end_date DATE DEFAULT NULL
) RETURNS TABLE (
    month TEXT,
    total_bookings BIGINT,
    total_revenue DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        TO_CHAR(b.date_from, 'YYYY-MM') as month,
        COUNT(*) as total_bookings,
        SUM(v.daily_hire_rate * (b.date_to - b.date_from + 1)) as total_revenue
    FROM booking b
    JOIN vehicle v ON b.reg_number = v.reg_number
    WHERE b.booking_status_code IN ('completed', 'confirmed')
    AND (start_date IS NULL OR b.date_from >= start_date)
    AND (end_date IS NULL OR b.date_from <= end_date)
    GROUP BY TO_CHAR(b.date_from, 'YYYY-MM')
    ORDER BY month;
END;
$$ LANGUAGE plpgsql;

-- Install triggers
\echo ''
\echo 'Installing triggers...'
\echo ''

-- Function to prevent updating cancelled bookings
CREATE OR REPLACE FUNCTION check_booking_status_update()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.booking_status_code = 'cancelled' THEN
        RAISE EXCEPTION 'Sorry, booking cannot be changed after cancelling';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS updating_booking_status ON booking;
CREATE TRIGGER updating_booking_status
    BEFORE UPDATE ON booking
    FOR EACH ROW
    EXECUTE FUNCTION check_booking_status_update();

-- Function to update last_updated timestamp
CREATE OR REPLACE FUNCTION update_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updating timestamps
DROP TRIGGER IF EXISTS update_customer_timestamp ON customer;
CREATE TRIGGER update_customer_timestamp
    BEFORE UPDATE ON customer
    FOR EACH ROW
    EXECUTE FUNCTION update_last_updated();

DROP TRIGGER IF EXISTS update_vehicle_timestamp ON vehicle;
CREATE TRIGGER update_vehicle_timestamp
    BEFORE UPDATE ON vehicle
    FOR EACH ROW
    EXECUTE FUNCTION update_last_updated();

DROP TRIGGER IF EXISTS update_booking_timestamp ON booking;
CREATE TRIGGER update_booking_timestamp
    BEFORE UPDATE ON booking
    FOR EACH ROW
    EXECUTE FUNCTION update_last_updated();

\echo ''
\echo 'Complete installation finished successfully!'
\echo ''