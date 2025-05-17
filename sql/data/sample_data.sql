-- Car Booking System Sample Data for PostgreSQL
-- Version: 2.0.0
-- Author: Mohamed Alkaisi

\echo 'Loading Sample Data'
\echo '=================='

-- Insert sample models
INSERT INTO model VALUES ('COROLLA', 'TOYOTA', 'Corolla', 45.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('CAMRY', 'TOYOTA', 'Camry', 65.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('RAV4', 'TOYOTA', 'RAV4', 80.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('FOCUS', 'FORD', 'Focus', 40.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('FUSION', 'FORD', 'Fusion', 60.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('EXPLORER', 'FORD', 'Explorer', 90.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('F150', 'FORD', 'F-150', 95.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('CIVIC', 'HONDA', 'Civic', 45.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('ACCORD', 'HONDA', 'Accord', 65.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('CRV', 'HONDA', 'CR-V', 75.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('ALTIMA', 'NISSAN', 'Altima', 55.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('ROGUE', 'NISSAN', 'Rogue', 70.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('320I', 'BMW', '320i', 85.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('X5', 'BMW', 'X5', 120.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('C300', 'MERCEDES', 'C300', 90.00) ON CONFLICT DO NOTHING;
INSERT INTO model VALUES ('GLE350', 'MERCEDES', 'GLE350', 130.00) ON CONFLICT DO NOTHING;

-- Insert sample vehicles
INSERT INTO vehicle VALUES ('ABC123', 'TOYOTA', 'COROLLA', 'COMPACT', 15000, 45.00, '2025-12-01') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('DEF456', 'TOYOTA', 'CAMRY', 'SALOON', 12000, 65.00, '2025-11-15') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('GHI789', 'TOYOTA', 'RAV4', 'SUV', 8000, 80.00, '2025-10-20') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('JKL012', 'FORD', 'FOCUS', 'COMPACT', 20000, 40.00, '2025-09-30') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('MNO345', 'FORD', 'EXPLORER', 'SUV', 5000, 90.00, '2025-08-15') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('PQR678', 'HONDA', 'CIVIC', 'COMPACT', 18000, 45.00, '2025-07-01') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('STU901', 'HONDA', 'CRV', 'SUV', 10000, 75.00, '2025-12-31') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('VWX234', 'BMW', '320I', 'LUXURY', 3000, 85.00, '2025-11-01') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('YZA567', 'MERCEDES', 'C300', 'LUXURY', 4000, 90.00, '2025-10-15') ON CONFLICT DO NOTHING;
INSERT INTO vehicle VALUES ('BCD890', 'FORD', 'F150', 'TRUCK', 25000, 95.00, '2025-09-01') ON CONFLICT DO NOTHING;

-- Insert sample customers
DO $$
DECLARE
    v_customer_id INTEGER;
BEGIN
    -- Customer 1
    v_customer_id := nextval('cust_id_seq');
    INSERT INTO customer VALUES (
        v_customer_id, 'John', 'Smith', 'M', 'john.smith@example.co.uk',
        '020-7946-0123', '123 High Street', 'Flat 4B', NULL,
        'London', 'SW1A 1AA', 'UK', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Customer 2
    v_customer_id := nextval('cust_id_seq');
    INSERT INTO customer VALUES (
        v_customer_id, 'Jane', 'Doe', 'F', 'jane.doe@example.co.uk',
        '0161-496-0234', '456 Oxford Road', NULL, NULL,
        'Manchester', 'M1 7DL', 'UK', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Customer 3
    v_customer_id := nextval('cust_id_seq');
    INSERT INTO customer VALUES (
        v_customer_id, 'Robert', 'Johnson', 'M', 'robert.johnson@example.co.uk',
        '0131-225-5678', '789 Royal Mile', 'Suite 100', NULL,
        'Edinburgh', 'EH1 2NG', 'UK', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Customer 4
    v_customer_id := nextval('cust_id_seq');
    INSERT INTO customer VALUES (
        v_customer_id, 'Emma', 'Thompson', 'F', 'emma.thompson@example.co.uk',
        '0121-414-9000', '321 Broad Street', NULL, NULL,
        'Birmingham', 'B15 2TT', 'UK', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Customer 5
    v_customer_id := nextval('cust_id_seq');
    INSERT INTO customer VALUES (
        v_customer_id, 'David', 'Williams', 'M', 'david.williams@example.co.uk',
        '029-2087-4000', '654 Cardiff Road', 'Unit 5', NULL,
        'Cardiff', 'CF10 3AT', 'UK', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
END $$;

-- Insert sample bookings
DO $$
DECLARE
    v_booking_id INTEGER;
    v_customer_id INTEGER;
BEGIN
    -- Get customer IDs
    SELECT customer_id INTO v_customer_id FROM customer WHERE email_address = 'john.smith@example.co.uk';
    
    -- Booking 1 - Past completed booking
    v_booking_id := nextval('book_id_seq');
    INSERT INTO booking VALUES (
        v_booking_id, 'completed', v_customer_id, 'ABC123',
        '2025-01-01', '2025-01-05', 225.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Booking 2 - Current confirmed booking
    v_booking_id := nextval('book_id_seq');
    INSERT INTO booking VALUES (
        v_booking_id, 'confirmed', v_customer_id, 'DEF456',
        '2025-06-01', '2025-06-07', 390.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Get another customer
    SELECT customer_id INTO v_customer_id FROM customer WHERE email_address = 'jane.doe@example.co.uk';
    
    -- Booking 3 - Future booking
    v_booking_id := nextval('book_id_seq');
    INSERT INTO booking VALUES (
        v_booking_id, 'open', v_customer_id, 'GHI789',
        '2025-07-15', '2025-07-20', 400.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Booking 4 - Cancelled booking
    v_booking_id := nextval('book_id_seq');
    INSERT INTO booking VALUES (
        v_booking_id, 'cancelled', v_customer_id, 'JKL012',
        '2025-08-01', '2025-08-03', 120.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
    
    -- Get another customer
    SELECT customer_id INTO v_customer_id FROM customer WHERE email_address = 'robert.johnson@example.co.uk';
    
    -- Booking 5 - Upcoming booking
    v_booking_id := nextval('book_id_seq');
    INSERT INTO booking VALUES (
        v_booking_id, 'confirmed', v_customer_id, 'VWX234',
        '2025-09-10', '2025-09-15', 425.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) ON CONFLICT DO NOTHING;
END $$;

\echo 'Sample data loaded successfully!'
\echo ''
\echo 'Sample Customers:'
SELECT customer_id, cust_forename || ' ' || cust_surname as full_name, email_address
FROM customer
ORDER BY customer_id;

\echo ''
\echo 'Available Vehicles:'
SELECT v.reg_number, m.manufacturer_name, mo.model_name, v.vehicle_category_code, v.daily_hire_rate
FROM vehicle v
JOIN manufacturer m ON v.manufacturer_code = m.manufacturer_code
JOIN model mo ON v.model_code = mo.model_code
ORDER BY v.reg_number;

\echo ''
\echo 'Current Bookings:'
SELECT b.booking_id, c.cust_forename || ' ' || c.cust_surname as customer, 
       b.reg_number, b.date_from, b.date_to, b.booking_status_code
FROM booking b
JOIN customer c ON b.customer_id = c.customer_id
ORDER BY b.date_from;