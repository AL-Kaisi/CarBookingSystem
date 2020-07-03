--------------------------------------------------------
--  File created - Sunday-December-15-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package UPDATE_INFORMATION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "MA5482D"."UPDATE_INFORMATION" 
AS 

  PROCEDURE booking_details ( 
v_date date, p_cur out SYS_REFCURSOR 
   ); 
PROCEDURE Display_Booking_Report  (v_date date);
  FUNCTION Check_registeration_num ( 
    v_reg_num vehicle.reg_number%TYPE) 
  RETURN BOOLEAN; 
  PROCEDURE add_update_cars( 
 v_reg_number           varchar2, 
                            v_manufacturer_code     varchar2, 
                            v_model_code           varchar2, 
                            v_vehicle_category_code varchar2, 
                            v_current_mileage       varchar2, 
                            v_daily_hire_rate       varchar2, 
                            v_daily_mot_due        varchar2, 
                            v_model_name           varchar2, 
                            v_manufacture_name      varchar2 ); 
END update_information;

/
--------------------------------------------------------
--  DDL for Package Body UPDATE_INFORMATION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "MA5482D"."UPDATE_INFORMATION" 
IS 
 /* The proccudure below receive an input from Display_booking_report to start ref cursor then send the cursor back to it. 
 Note this procedure collect information requested from the view created*/
-------------------------------------------------------------------------------------------------------------------------------  
  PROCEDURE Booking_details (v_date DATE, 
                             p_cur  OUT SYS_REFCURSOR) 
  AS 
  BEGIN 
      OPEN p_cur FOR 
        SELECT * 
        FROM   customer_booking 
        WHERE  date_from = v_date; 
  END booking_details; 

/* The proccudure below receive the cursor back from booking details with an information requested then output the details 
 need for the report*/
-------------------------------------------------------------------------------------------------------------------------------  
  PROCEDURE Display_booking_report (v_date DATE) 
  AS 
    p_emp_cur             SYS_REFCURSOR; 
    v_booking_id          booking.booking_id%TYPE; 
    v_customer_id         customer.customer_id%TYPE; 
    v_booking_status_code booking.booking_status_code%TYPE; 
    v_reg_number          booking.reg_number%TYPE; 
    v_date_from           booking.date_from%TYPE; 
    v_date_to             booking.date_to%TYPE; 
    v_cust_forename       customer.cust_forename%TYPE; 
    v_cust_surname        customer.cust_surname%TYPE; 
    v_email_address       customer.email_address%TYPE; 
  BEGIN 
      Booking_details(v_date, p_emp_cur); 

      LOOP 
          FETCH p_emp_cur INTO v_booking_id, v_customer_id, 
          v_booking_status_code, 
          v_reg_number, v_date_from, v_date_to, v_cust_forename, v_cust_surname, 
          v_email_address; 

          exit WHEN p_emp_cur%NOTFOUND; 

          dbms_output.Put_line(v_booking_id 
                               ||' ' 
                               ||v_customer_id 
                               ||' ' 
                               ||v_booking_status_code 
                               ||' ' 
                               ||v_reg_number 
                               ||' ' 
                               ||v_date_from 
                               ||' ' 
                               ||v_date_to 
                               ||' ' 
                               ||v_cust_forename 
                               ||' ' 
                               || v_cust_surname 
                               ||' ' 
                               ||v_email_address); 
      END LOOP; 

      CLOSE p_emp_cur; 
  END display_booking_report; 

/* This function below refreneced from add update proccudure then it checks if the registeration inserted for the new vehicle 
already exist then send a blean value back*/
-------------------------------------------------------------------------------------------------------------------------------  
  FUNCTION Check_registeration_num (v_reg_num vehicle.reg_number%TYPE) 
  RETURN BOOLEAN 
  AS 
    v_count NUMBER; 
  BEGIN 
      SELECT Count(*) 
      INTO   v_count 
      FROM   vehicle 
      WHERE  reg_number = v_reg_num; 

      IF v_count = 0 THEN 
        RETURN TRUE; 
      ELSE 
        RETURN FALSE; 
      END IF; 

      RETURN NULL; 
  END check_registeration_num; 

/* This is the proccdure that checks at first if the new car information entred by the clerk already avilable.
if the information found avilable then the car should be updated and if the car not found then it must be registered. */
-------------------------------------------------------------------------------------------------------------------------------  
  PROCEDURE Add_update_cars(v_reg_number            VARCHAR2, 
                            v_manufacturer_code     VARCHAR2, 
                            v_model_code            VARCHAR2, 
                            v_vehicle_category_code VARCHAR2, 
                            v_current_mileage       VARCHAR2, 
                            v_daily_hire_rate       VARCHAR2, 
                            v_daily_mot_due         VARCHAR2, 
                            v_model_name            VARCHAR2, 
                            v_manufacture_name      VARCHAR2) 
  AS 
    v_check BOOLEAN; 
    v_code  NUMBER; 
    v_error VARCHAR2(64); 
    e_null_values EXCEPTION; 
    PRAGMA EXCEPTION_INIT (e_null_values, -01400); 
  BEGIN 
      IF Check_registeration_num(v_reg_number) THEN 
        INSERT INTO model 
                    (model_code, 
                     daily_hire_rate, 
                     model_name) 
        VALUES     (v_model_code, 
                    v_daily_hire_rate, 
                    v_model_name); 

        INSERT INTO manufacturer 
                    (manufacturer_code, 
                     manufacturer_name) 
        VALUES     (v_manufacture_name, 
                    v_manufacture_name); 

        INSERT INTO vehicle 
        VALUES      (v_reg_number, 
                     v_manufacture_name, 
                     v_model_code, 
                     v_vehicle_category_code, 
                     v_current_mileage, 
                     v_daily_hire_rate, 
                     v_daily_mot_due); 

        dbms_output.Put_line('vehicle Number' 
                             || v_reg_number 
                             ||'has been registered'); 
      ELSE 
        UPDATE vehicle 
        SET    vehicle_category_code = v_vehicle_category_code, 
               current_mileage = v_current_mileage, 
               daily_hire_rate = v_daily_hire_rate, 
               date_mot_due = To_date(v_daily_mot_due, 'DD-MON-YY') 
        WHERE  reg_number = v_reg_number; 

        dbms_output.Put_line('vehicle Number' 
                             || v_reg_number 
                             ||'has been registered'); 
      END IF; 
  EXCEPTION 
    WHEN e_null_values THEN 
               dbms_output.Put_line('Please do not leave empty values'); WHEN 
  OTHERS THEN 
               v_code := SQLCODE; 

               v_error := Substr(SQLERRM, 1, 64); 

               dbms_output.Put_line('Error code =' 
                                    ||v_code 
                                    || ' ' 
                                    ||v_error); 
  END add_update_cars; 
END update_information;

/
