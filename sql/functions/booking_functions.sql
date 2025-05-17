-- Car Booking System Functions for PostgreSQL
-- Replacement for BOOKING_CARS package
-- Version: 2.0.0
-- Author: Mohamed Alkaisi

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