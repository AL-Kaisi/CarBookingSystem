-- Business Rules Triggers for PostgreSQL
-- Version: 2.0.0
-- Author: Mohamed Alkaisi

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

-- Function to validate booking dates
CREATE OR REPLACE FUNCTION validate_booking_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_from < CURRENT_DATE THEN
        RAISE EXCEPTION 'Booking start date cannot be in the past';
    END IF;
    
    IF NEW.date_to < NEW.date_from THEN
        RAISE EXCEPTION 'Booking end date must be after start date';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for date validation
DROP TRIGGER IF EXISTS validate_booking_dates_trigger ON booking;
CREATE TRIGGER validate_booking_dates_trigger
    BEFORE INSERT OR UPDATE ON booking
    FOR EACH ROW
    EXECUTE FUNCTION validate_booking_dates();

-- Function to prevent double booking
CREATE OR REPLACE FUNCTION prevent_double_booking()
RETURNS TRIGGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM booking
    WHERE reg_number = NEW.reg_number
    AND booking_id != NEW.booking_id
    AND date_from <= NEW.date_to
    AND date_to >= NEW.date_from
    AND booking_status_code NOT IN ('cancelled');
    
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Vehicle is already booked for these dates';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for double booking prevention
DROP TRIGGER IF EXISTS prevent_double_booking_trigger ON booking;
CREATE TRIGGER prevent_double_booking_trigger
    BEFORE INSERT OR UPDATE ON booking
    FOR EACH ROW
    EXECUTE FUNCTION prevent_double_booking();