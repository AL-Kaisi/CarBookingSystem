# Development Guide

This guide provides information for developers working on the Car Booking System.

## Setting Up Your Development Environment

### Prerequisites

1. **Oracle Database**
   - Oracle 11g or higher
   - Local instance or access to development server
   - SQL Developer or similar tool

2. **Git**
   - Git client installed
   - GitHub account for contributions

3. **Text Editor**
   - Any SQL-capable editor
   - Recommended: VS Code with Oracle Developer Tools

### Initial Setup

1. **Clone the repository:**
```bash
git clone https://github.com/AL-Kaisi/CarBookingSystem.git
cd CarBookingSystem
```

2. **Create development database user:**
```sql
CREATE USER dev_carbooking IDENTIFIED BY password;
GRANT CONNECT, RESOURCE, CREATE VIEW TO dev_carbooking;
GRANT CREATE SYNONYM, CREATE DATABASE LINK TO dev_carbooking;
```

3. **Install the system:**
```sql
CONNECT dev_carbooking/password
@scripts/install.sql
```

4. **Load sample data:**
```sql
@sql/data/sample_data.sql
```

5. **Verify installation:**
```sql
@tests/test_installation.sql
```

## Development Workflow

### 1. Creating a New Feature

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes
# Test thoroughly
# Commit changes
git add .
git commit -m "Add your feature description"

# Push to GitHub
git push origin feature/your-feature-name
```

### 2. Code Standards

#### SQL Formatting
- Use uppercase for SQL keywords
- Use lowercase for identifiers
- Indent with 2 spaces
- Comment complex logic

```sql
-- Good example
CREATE OR REPLACE PROCEDURE update_customer_status(
  p_customer_id IN NUMBER,
  p_status IN VARCHAR2
) AS
BEGIN
  UPDATE customer
  SET status = p_status,
      last_updated = SYSDATE
  WHERE customer_id = p_customer_id;
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END update_customer_status;
```

#### Naming Conventions
- Tables: Singular, lowercase (e.g., `customer`, `booking`)
- Columns: Lowercase with underscores (e.g., `customer_id`, `booking_date`)
- Packages: Uppercase with underscores (e.g., `BOOKING_CARS`)
- Procedures/Functions: Lowercase with underscores (e.g., `create_booking`)

### 3. Testing

#### Unit Testing
Create test scripts in `tests/unit/`:

```sql
-- tests/unit/test_customer_creation.sql
DECLARE
  v_customer_id NUMBER;
  v_result BOOLEAN;
BEGIN
  -- Test customer creation
  BOOKING_CARS.create_customer(
    v_customer_id => NULL,
    v_forname => 'Test',
    v_surname => 'User',
    -- ... other parameters
  );
  
  -- Verify creation
  v_result := BOOKING_CARS.Customer_check('Test', 'User', 'test@example.com');
  
  IF v_result THEN
    DBMS_OUTPUT.PUT_LINE('TEST PASSED: Customer created successfully');
  ELSE
    RAISE_APPLICATION_ERROR(-20001, 'TEST FAILED: Customer not created');
  END IF;
END;
/
```

#### Integration Testing
Test complete workflows:

```sql
-- tests/integration/test_booking_workflow.sql
DECLARE
  v_booking_success BOOLEAN;
BEGIN
  -- Complete booking workflow test
  BOOKING_CARS.Make_Booking(
    -- ... parameters
  );
  
  -- Verify booking exists
  -- Check status
  -- Verify calculations
END;
/
```

### 4. Debugging

Enable debug output:
```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;
ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:ALL';
```

Add debug statements:
```sql
DBMS_OUTPUT.PUT_LINE('Debug: Processing customer ' || v_customer_id);
DBMS_OUTPUT.PUT_LINE('Debug: Date range ' || v_date_from || ' to ' || v_date_to);
```

Use exception handling:
```sql
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: Customer not found');
    RAISE;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
```

## Common Development Tasks

### Adding a New Table

1. Create table definition:
```sql
-- sql/schema/tables/your_table.sql
CREATE TABLE your_table (
  id NUMBER PRIMARY KEY,
  name VARCHAR2(100) NOT NULL,
  created_date DATE DEFAULT SYSDATE
);
```

2. Add to installation script:
```sql
-- scripts/install.sql
@@../sql/schema/tables/your_table.sql
```

3. Create indexes if needed:
```sql
CREATE INDEX idx_your_table_name ON your_table(name);
```

### Adding a New Procedure

1. Add to package specification:
```sql
PROCEDURE your_new_procedure(
  p_param1 IN VARCHAR2,
  p_param2 OUT NUMBER
);
```

2. Implement in package body:
```sql
PROCEDURE your_new_procedure(
  p_param1 IN VARCHAR2,
  p_param2 OUT NUMBER
) AS
BEGIN
  -- Implementation
  NULL;
END your_new_procedure;
```

3. Add tests:
```sql
-- tests/unit/test_your_procedure.sql
BEGIN
  BOOKING_CARS.your_new_procedure('test', v_output);
  -- Assertions
END;
/
```

### Modifying Existing Objects

1. Create upgrade script:
```sql
-- scripts/upgrade/v1.1.0_add_column.sql
ALTER TABLE customer ADD loyalty_points NUMBER DEFAULT 0;
```

2. Update installation script
3. Test upgrade path
4. Document changes

## Performance Optimization

### Query Optimization

1. Use EXPLAIN PLAN:
```sql
EXPLAIN PLAN FOR
SELECT * FROM booking WHERE customer_id = 123;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

2. Add appropriate indexes:
```sql
CREATE INDEX idx_booking_customer ON booking(customer_id);
```

3. Gather statistics:
```sql
EXEC DBMS_STATS.gather_table_stats(USER, 'BOOKING');
```

### PL/SQL Optimization

1. Use bulk operations:
```sql
DECLARE
  TYPE t_ids IS TABLE OF NUMBER;
  v_customer_ids t_ids;
BEGIN
  SELECT customer_id BULK COLLECT INTO v_customer_ids
  FROM customer WHERE status = 'ACTIVE';
  
  FORALL i IN v_customer_ids.FIRST..v_customer_ids.LAST
    UPDATE booking SET processed = 'Y'
    WHERE customer_id = v_customer_ids(i);
END;
```

2. Use appropriate data types
3. Minimize context switches
4. Cache frequently used data

## Version Control

### Commit Messages

Use conventional commits:
```
feat: Add email notification for bookings
fix: Correct date validation in booking process
docs: Update API documentation
test: Add unit tests for customer validation
refactor: Simplify booking status logic
```

### Branching Strategy

- `master`: Production-ready code
- `develop`: Integration branch
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `hotfix/*`: Emergency fixes

## Security Considerations

1. **Never hardcode credentials**
2. **Validate all inputs**
3. **Use bind variables**
4. **Implement proper access control**
5. **Audit sensitive operations**

Example secure coding:
```sql
-- Good: Using bind variables
EXECUTE IMMEDIATE 'SELECT * FROM customer WHERE email = :1'
  INTO v_customer
  USING p_email;

-- Bad: String concatenation
EXECUTE IMMEDIATE 'SELECT * FROM customer WHERE email = ''' || p_email || '''';
```

## Documentation

### Code Documentation

Add meaningful comments:
```sql
/**
 * Creates a new booking for a customer
 * 
 * @param p_customer_id Customer identifier
 * @param p_vehicle_id Vehicle to book
 * @param p_date_from Start date
 * @param p_date_to End date
 * @return Booking ID if successful, -1 if failed
 */
FUNCTION create_booking(
  p_customer_id NUMBER,
  p_vehicle_id NUMBER,
  p_date_from DATE,
  p_date_to DATE
) RETURN NUMBER;
```

### API Documentation

Update `docs/api/README.md` when adding new functionality.

## Troubleshooting Development Issues

### Common Problems

1. **Package won't compile**
   - Check for syntax errors
   - Verify all referenced objects exist
   - Review error messages with `SHOW ERRORS`

2. **Tests failing**
   - Ensure test data is loaded
   - Check for uncommitted changes
   - Verify sequences are reset

3. **Performance issues**
   - Check execution plans
   - Verify statistics are current
   - Look for missing indexes

## Resources

- [Oracle PL/SQL Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/)
- [SQL Style Guide](https://www.sqlstyle.guide/)
- [Oracle Best Practices](https://www.oracle.com/technical-resources/articles/database-performance/plsql-best-practices.html)

## Getting Help

1. Check existing issues on GitHub
2. Ask in discussions
3. Contact maintainers
4. Review documentation

Remember: Always test your changes thoroughly before submitting a pull request!