-- Update Information Functions for PostgreSQL
-- Replacement for UPDATE_INFORMATION package
-- Version: 2.0.0
-- Author: Mohamed Alkaisi

-- Get booking details for a specific date
CREATE OR REPLACE FUNCTION booking_details(v_date DATE)
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
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.booking_id,
        b.customer_id,
        b.booking_status_code,
        b.reg_number,
        b.date_from,
        b.date_to,
        c.cust_forename,
        c.cust_surname,
        c.email_address
    FROM customer_booking cb
    JOIN booking b ON cb.booking_id = b.booking_id
    JOIN customer c ON b.customer_id = c.customer_id
    WHERE b.date_from = v_date;
END;
$$ LANGUAGE plpgsql;

-- Display booking report
CREATE OR REPLACE FUNCTION display_booking_report(v_date DATE)
RETURNS TABLE (
    booking_info TEXT
) AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT * FROM booking_details(v_date) LOOP
        booking_info := rec.booking_id || ' ' ||
                       rec.customer_id || ' ' ||
                       rec.booking_status_code || ' ' ||
                       rec.reg_number || ' ' ||
                       rec.date_from || ' ' ||
                       rec.date_to || ' ' ||
                       rec.cust_forename || ' ' ||
                       rec.cust_surname || ' ' ||
                       rec.email_address;
        RETURN NEXT;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Check registration number
CREATE OR REPLACE FUNCTION check_registration_num(v_reg_num VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM vehicle
    WHERE reg_number = v_reg_num;
    
    RETURN v_count = 0;
END;
$$ LANGUAGE plpgsql;

-- Add or update vehicle
CREATE OR REPLACE FUNCTION add_update_cars(
    v_reg_number VARCHAR,
    v_manufacturer_code VARCHAR,
    v_model_code VARCHAR,
    v_vehicle_category_code VARCHAR,
    v_current_mileage VARCHAR,
    v_daily_hire_rate VARCHAR,
    v_daily_mot_due VARCHAR,
    v_model_name VARCHAR,
    v_manufacture_name VARCHAR
) RETURNS VOID AS $$
BEGIN
    IF check_registration_num(v_reg_number) THEN
        -- Add new vehicle
        INSERT INTO model (model_code, daily_hire_rate, model_name)
        VALUES (v_model_code, v_daily_hire_rate::DECIMAL, v_model_name)
        ON CONFLICT (model_code) DO NOTHING;
        
        INSERT INTO manufacturer (manufacturer_code, manufacturer_name)
        VALUES (v_manufacturer_code, v_manufacture_name)
        ON CONFLICT (manufacturer_code) DO NOTHING;
        
        INSERT INTO vehicle (
            reg_number, manufacturer_code, model_code,
            vehicle_category_code, current_mileage,
            daily_hire_rate, date_mot_due
        ) VALUES (
            v_reg_number, v_manufacturer_code, v_model_code,
            v_vehicle_category_code, v_current_mileage::INTEGER,
            v_daily_hire_rate::DECIMAL, v_daily_mot_due::DATE
        );
        
        RAISE NOTICE 'Vehicle Number % has been registered', v_reg_number;
    ELSE
        -- Update existing vehicle
        UPDATE vehicle
        SET vehicle_category_code = v_vehicle_category_code,
            current_mileage = v_current_mileage::INTEGER,
            daily_hire_rate = v_daily_hire_rate::DECIMAL,
            date_mot_due = v_daily_mot_due::DATE,
            last_updated = CURRENT_TIMESTAMP
        WHERE reg_number = v_reg_number;
        
        RAISE NOTICE 'Vehicle Number % has been updated', v_reg_number;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in add_update_cars: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Additional reporting functions

-- Get revenue report
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

-- Get available vehicles
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