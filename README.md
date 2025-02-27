# Booking Cars Database Package

## Overview
The `BOOKING_CARS` package is an Oracle PL/SQL package designed to manage customer bookings for car rentals. It provides functions and procedures to validate customers, check vehicle availability, create bookings, and update booking statuses.

## Features
- **Customer Validation:** Check if a customer exists using forename, surname, and email.
- **Vehicle Availability Check:** Verify available vehicles based on type and booking dates.
- **Booking Management:** Create, update, and cancel bookings.
- **Customer Management:** Add new customers if they do not exist in the database.
- **Booking Status Updates:** Manage booking confirmations and cancellations with triggers ensuring business rules are followed.
- **Vehicle Data Management:** Add and update vehicle information.

---

## Package Specification

### `BOOKING_CARS` Package

#### Functions
- `Customer_check(v_forname, v_surname, v_email) RETURN BOOLEAN`
- `Customer_check(v_customer_id) RETURN BOOLEAN`
- `Check_cars(v_type, v_date_from, v_date_to, v_email) RETURN BOOLEAN`
- `Date_check(v_date_from, v_date_to) RETURN BOOLEAN`
- `Create_Booking(a_date_to, a_date_from, a_email, a_registration_number) RETURN BOOLEAN`

#### Procedures
- `create_customer(v_customer_id, v_forname, v_surname, v_gender, v_email, v_phone_number, v_address_line1, v_address_line2, v_address_line3, v_town, v_postcode, v_country)`
- `Make_Booking(v_customer_id, v_forname, v_surname, v_gender, v_email, v_phone_number, v_address_line1, v_address_line2, v_address_line3, v_town, v_postcode, v_country, v_vehicletype, v_date_from, v_date_to, v_booking_status)`
- `update_booking(v_bookingid, v_booking_status_code)`

---

## Package Body

### Customer Management
- **`customer_check`**: Verifies if a customer exists in the database using either full name and email or customer ID.
- **`create_customer`**: Adds a new customer if they are not found in the system.

### Booking Management
- **`Check_cars`**: Validates vehicle availability for the requested dates and type.
- **`Create_Booking`**: Creates a booking if the vehicle is available and the customer is registered.
- **`Make_Booking`**: Handles complete booking workflow, including customer verification, vehicle check, and booking creation.
- **`update_booking`**: Updates the status of an existing booking.

---

## Triggers

### `UPDATING_BOOKING_STATUS`
- Ensures that once a booking is canceled, it cannot be modified.

---

## `UPDATE_INFORMATION` Package

### Procedures
- `booking_details(v_date, p_cur OUT SYS_REFCURSOR)`: Retrieves booking details for a given date.
- `Display_Booking_Report(v_date)`: Displays booking details in a structured format.
- `add_update_cars(v_reg_number, v_manufacturer_code, v_model_code, v_vehicle_category_code, v_current_mileage, v_daily_hire_rate, v_daily_mot_due, v_model_name, v_manufacture_name)`: Adds or updates vehicle records.

### Functions
- `Check_registration_num(v_reg_num) RETURN BOOLEAN`: Checks if a vehicle registration number exists.

---

## Installation & Usage

1. **Connect to Oracle Database**:
   ```sql
   sqlplus username/password@database
   ```
2. **Run the DDL Script**:
   ```sql
   @path/to/booking_cars_package.sql
   ```
3. **Verify the Package Installation**:
   ```sql
   SELECT object_name, object_type FROM user_objects WHERE object_name = 'BOOKING_CARS';
   ```
4. **Test Functions & Procedures**:
   ```sql
   DECLARE
       v_result BOOLEAN;
   BEGIN
       v_result := BOOKING_CARS.Customer_check('John', 'Doe', 'john.doe@example.com');
       IF v_result THEN
           DBMS_OUTPUT.PUT_LINE('Customer exists');
       ELSE
           DBMS_OUTPUT.PUT_LINE('Customer does not exist');
       END IF;
   END;
   /
   ```

---

## Error Handling
- All functions and procedures include exception handling to catch errors and provide meaningful messages using `DBMS_OUTPUT.PUT_LINE`.
- Triggers enforce business rules such as preventing modifications to canceled bookings.

---

## Future Enhancements
- Implement logging for all database actions.
- Enhance error handling with a dedicated error logging table.
- Add automated unit tests for package procedures and functions.

---

## License
This project is licensed under the MIT License.

---

