# Troubleshooting Guide

This guide helps resolve common issues with the Car Booking System.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Runtime Errors](#runtime-errors)
3. [Performance Problems](#performance-problems)
4. [Data Issues](#data-issues)
5. [Package Compilation Errors](#package-compilation-errors)

## Installation Issues

### Issue: Installation script fails

**Symptoms:**
- Scripts fail with permission errors
- Objects not created successfully
- Invalid object errors

**Solutions:**

1. Check user privileges:
```sql
SELECT * FROM user_sys_privs;
SELECT * FROM user_tab_privs;
```

2. Ensure proper grants:
```sql
GRANT CREATE TABLE TO your_user;
GRANT CREATE PROCEDURE TO your_user;
GRANT CREATE SEQUENCE TO your_user;
GRANT CREATE VIEW TO your_user;
GRANT CREATE TRIGGER TO your_user;
```

3. Run with appropriate user:
```sql
CONNECT sys/password AS SYSDBA;
GRANT DBA TO your_user;
```

### Issue: Objects already exist

**Symptoms:**
- ORA-00955: name is already used by an existing object

**Solutions:**

1. Run uninstall script first:
```sql
@scripts/uninstall.sql
```

2. Manually drop objects:
```sql
DROP TABLE booking CASCADE CONSTRAINTS;
DROP PACKAGE booking_cars;
-- etc.
```

## Runtime Errors

### Issue: Customer not found

**Error:**
```
ORA-01403: no data found
```

**Context:** When calling booking procedures

**Solutions:**

1. Verify customer exists:
```sql
SELECT * FROM customer WHERE email_address = 'user@example.com';
```

2. Create customer first:
```sql
BEGIN
  BOOKING_CARS.create_customer(
    v_customer_id => NULL,
    v_forname => 'John',
    v_surname => 'Doe',
    -- ... other parameters
  );
END;
/
```

### Issue: Invalid date range

**Error:**
```
ORA-20001: ENTER A VALID DATE
```

**Solutions:**

1. Check date format:
```sql
SELECT TO_DATE('2025-06-01', 'YYYY-MM-DD') FROM dual;
```

2. Ensure dates are in the future:
```sql
DECLARE
  v_valid BOOLEAN;
BEGIN
  v_valid := BOOKING_CARS.Date_check(
    v_date_from => SYSDATE + 1,
    v_date_to => SYSDATE + 5
  );
END;
/
```

### Issue: Vehicle not available

**Error:**
```
SORRY THERE IS NO CAR AVAILABLE
```

**Solutions:**

1. Check vehicle inventory:
```sql
SELECT * FROM vehicle WHERE vehicle_category_code = 'SUV';
```

2. Check existing bookings:
```sql
SELECT * FROM booking 
WHERE reg_number IN (
  SELECT reg_number FROM vehicle 
  WHERE vehicle_category_code = 'SUV'
)
AND date_from <= TO_DATE('2025-06-05', 'YYYY-MM-DD')
AND date_to >= TO_DATE('2025-06-01', 'YYYY-MM-DD');
```

## Performance Problems

### Issue: Slow booking searches

**Symptoms:**
- Queries taking too long
- Timeouts when checking availability

**Solutions:**

1. Check indexes exist:
```sql
SELECT index_name, column_name 
FROM user_ind_columns 
WHERE table_name = 'BOOKING';
```

2. Gather statistics:
```sql
EXEC DBMS_STATS.gather_schema_stats(USER);
```

3. Analyze execution plan:
```sql
EXPLAIN PLAN FOR
SELECT * FROM booking WHERE date_from = TO_DATE('2025-06-01', 'YYYY-MM-DD');

SELECT * FROM TABLE(DBMS_XPLAN.display);
```

### Issue: Package compilation slow

**Solutions:**

1. Check for invalid dependencies:
```sql
SELECT * FROM user_objects WHERE status = 'INVALID';
```

2. Recompile schema:
```sql
EXEC DBMS_UTILITY.compile_schema(USER);
```

## Data Issues

### Issue: Duplicate customer records

**Symptoms:**
- ORA-00001: unique constraint violated

**Solutions:**

1. Check for duplicates:
```sql
SELECT email_address, COUNT(*) 
FROM customer 
GROUP BY email_address 
HAVING COUNT(*) > 1;
```

2. Clean duplicate data:
```sql
DELETE FROM customer 
WHERE customer_id NOT IN (
  SELECT MIN(customer_id) 
  FROM customer 
  GROUP BY email_address
);
```

### Issue: Orphaned bookings

**Solutions:**

1. Find orphaned records:
```sql
SELECT * FROM booking b
WHERE NOT EXISTS (
  SELECT 1 FROM customer c WHERE c.customer_id = b.customer_id
);
```

2. Clean orphaned data:
```sql
DELETE FROM booking 
WHERE customer_id NOT IN (SELECT customer_id FROM customer);
```

## Package Compilation Errors

### Issue: BOOKING_CARS won't compile

**Common errors and fixes:**

1. **Missing table/column:**
```sql
-- Check if all tables exist
SELECT table_name FROM user_tables;
```

2. **Invalid column reference:**
```sql
-- Verify column names
SELECT column_name FROM user_tab_columns 
WHERE table_name = 'CUSTOMER';
```

3. **Sequence not found:**
```sql
-- Create missing sequences
CREATE SEQUENCE cust_id_seq START WITH 1000;
```

### Issue: Trigger compilation fails

**Solutions:**

1. Check trigger syntax:
```sql
SHOW ERRORS TRIGGER updating_booking_status;
```

2. Verify table structure:
```sql
DESC booking;
```

## Common Error Codes

| Error Code | Description | Common Cause | Solution |
|------------|-------------|--------------|----------|
| ORA-00001 | Unique constraint violated | Duplicate data | Check for existing records |
| ORA-00904 | Invalid identifier | Typo in column name | Verify column names |
| ORA-00942 | Table or view does not exist | Missing object | Run installation script |
| ORA-01403 | No data found | Missing record | Verify data exists |
| ORA-01422 | Exact fetch returns more than requested | Multiple records | Add unique constraints |
| ORA-01722 | Invalid number | Type mismatch | Check data types |
| ORA-02291 | Integrity constraint violated | Invalid foreign key | Verify parent record exists |

## Debug Mode

Enable debug output:
```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;
EXEC DBMS_OUTPUT.enable(1000000);
```

Add debug statements to packages:
```sql
DBMS_OUTPUT.PUT_LINE('Debug: Customer ID = ' || v_customer_id);
```

## Getting Help

1. Check error messages:
```sql
SHOW ERRORS;
```

2. Review alert log:
```sql
SELECT value FROM v$parameter WHERE name = 'background_dump_dest';
```

3. Enable SQL tracing:
```sql
ALTER SESSION SET SQL_TRACE = TRUE;
```

## Preventive Measures

1. Regular maintenance:
```sql
-- Weekly
EXEC DBMS_STATS.gather_schema_stats(USER);

-- Monthly  
EXEC DBMS_UTILITY.compile_schema(USER);
```

2. Monitor space:
```sql
SELECT segment_name, bytes/1024/1024 MB
FROM user_segments
WHERE segment_type = 'TABLE'
ORDER BY bytes DESC;
```

3. Backup regularly:
```bash
expdp username/password directory=backup_dir dumpfile=carbooking.dmp
```

Remember to always test changes in a development environment before applying to production!