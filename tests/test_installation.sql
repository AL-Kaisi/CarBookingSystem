-- Car Booking System Installation Test Script for PostgreSQL
-- Version: 2.0.0
-- Author: Mohamed Alkaisi

\echo 'Car Booking System Installation Test'
\echo '===================================='
\echo ''

DO $$
DECLARE
    v_errors INTEGER := 0;
    v_warnings INTEGER := 0;
    v_count INTEGER;
    v_test_name VARCHAR(100);
    
    -- Test results record
    rec RECORD;
BEGIN
    -- Test sequences
    RAISE NOTICE 'Testing Sequences...';
    
    FOR rec IN 
        SELECT sequence_name 
        FROM information_schema.sequences 
        WHERE sequence_catalog = current_database() 
        AND sequence_schema = 'public'
        AND sequence_name IN ('cust_id_seq', 'book_id_seq', 'vehicle_id_seq')
    LOOP
        RAISE NOTICE 'Sequence: % ... PASSED', rec.sequence_name;
    END LOOP;
    
    -- Count sequences
    SELECT COUNT(*) INTO v_count
    FROM information_schema.sequences 
    WHERE sequence_catalog = current_database() 
    AND sequence_schema = 'public'
    AND sequence_name IN ('cust_id_seq', 'book_id_seq', 'vehicle_id_seq');
    
    IF v_count < 3 THEN
        RAISE NOTICE 'Missing sequences ... FAILED';
        v_errors := v_errors + 1;
    END IF;
    
    RAISE NOTICE '';
    
    -- Test tables
    RAISE NOTICE 'Testing Tables...';
    
    FOR rec IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
        AND table_name IN ('customer', 'vehicle_category', 'manufacturer', 'model', 'vehicle', 'booking_status', 'booking')
        ORDER BY table_name
    LOOP
        RAISE NOTICE 'Table: % ... PASSED', rec.table_name;
    END LOOP;
    
    -- Count tables
    SELECT COUNT(*) INTO v_count
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
    AND table_name IN ('customer', 'vehicle_category', 'manufacturer', 'model', 'vehicle', 'booking_status', 'booking');
    
    IF v_count < 7 THEN
        RAISE NOTICE 'Missing tables ... FAILED';
        v_errors := v_errors + 1;
    END IF;
    
    RAISE NOTICE '';
    
    -- Test views
    RAISE NOTICE 'Testing Views...';
    
    FOR rec IN 
        SELECT table_name 
        FROM information_schema.views 
        WHERE table_schema = 'public'
        AND table_name = 'customer_booking'
    LOOP
        RAISE NOTICE 'View: % ... PASSED', rec.table_name;
    END LOOP;
    
    RAISE NOTICE '';
    
    -- Test functions
    RAISE NOTICE 'Testing Functions...';
    
    FOR rec IN 
        SELECT routine_name 
        FROM information_schema.routines 
        WHERE routine_schema = 'public'
        AND routine_type = 'FUNCTION'
        AND routine_name IN ('customer_check', 'create_customer', 'make_booking', 'update_booking')
        GROUP BY routine_name
        ORDER BY routine_name
    LOOP
        RAISE NOTICE 'Function: % ... PASSED', rec.routine_name;
    END LOOP;
    
    RAISE NOTICE '';
    
    -- Test reference data
    RAISE NOTICE 'Testing Reference Data...';
    
    -- Test vehicle categories
    SELECT COUNT(*) INTO v_count FROM vehicle_category;
    IF v_count >= 5 THEN
        RAISE NOTICE 'Vehicle Categories: % rows ... PASSED', v_count;
    ELSE
        RAISE NOTICE 'Vehicle Categories: % rows ... WARNING', v_count;
        v_warnings := v_warnings + 1;
    END IF;
    
    -- Test booking statuses
    SELECT COUNT(*) INTO v_count FROM booking_status;
    IF v_count >= 4 THEN
        RAISE NOTICE 'Booking Statuses: % rows ... PASSED', v_count;
    ELSE
        RAISE NOTICE 'Booking Statuses: % rows ... WARNING', v_count;
        v_warnings := v_warnings + 1;
    END IF;
    
    -- Test manufacturers
    SELECT COUNT(*) INTO v_count FROM manufacturer;
    IF v_count >= 5 THEN
        RAISE NOTICE 'Manufacturers: % rows ... PASSED', v_count;
    ELSE
        RAISE NOTICE 'Manufacturers: % rows ... WARNING', v_count;
        v_warnings := v_warnings + 1;
    END IF;
    
    RAISE NOTICE '';
    
    -- Test basic functionality
    RAISE NOTICE 'Testing Basic Functionality...';
    
    BEGIN
        PERFORM customer_check('Test', 'User', 'test@example.com');
        RAISE NOTICE 'Customer Check Function ... PASSED';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Customer Check Function ... WARNING: %', SQLERRM;
            v_warnings := v_warnings + 1;
    END;
    
    -- Summary
    RAISE NOTICE '';
    RAISE NOTICE 'Test Summary';
    RAISE NOTICE '===========';
    RAISE NOTICE 'Errors:   %', v_errors;
    RAISE NOTICE 'Warnings: %', v_warnings;
    RAISE NOTICE '';
    
    IF v_errors = 0 THEN
        IF v_warnings = 0 THEN
            RAISE NOTICE 'Status: ALL TESTS PASSED';
        ELSE
            RAISE NOTICE 'Status: PASSED WITH WARNINGS';
        END IF;
    ELSE
        RAISE NOTICE 'Status: FAILED';
    END IF;
    
    RAISE NOTICE '';
END $$;