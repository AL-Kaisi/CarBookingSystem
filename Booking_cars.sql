--------------------------------------------------------
--  File created - Sunday-December-15-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package BOOKING_CARS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "MA5482D"."BOOKING_CARS" 
AS 
  FUNCTION Customer_check ( 
    v_forname customer.cust_forename%TYPE, 
    v_surname customer.cust_surname%TYPE, 
    v_email   customer.email_address%TYPE) 
  RETURN BOOLEAN; 
  FUNCTION Customer_check ( 
    v_customer_id customer.customer_id%TYPE) 
  RETURN BOOLEAN; 
  FUNCTION Check_cars ( 
    v_type      vehicle.vehicle_category_code%TYPE, 
    v_date_from booking.date_from%TYPE, 
    v_date_to   booking.date_to%TYPE, 
    v_email     customer.email_address%TYPE ) 
  RETURN BOOLEAN; 
  PROCEDURE create_customer ( 
    v_customer_id   customer.customer_id%TYPE, 
    v_forname       customer.cust_forename%TYPE, 
    v_surname       customer.cust_surname%TYPE, 
    v_gender        customer.gender%TYPE, 
    v_email         customer.email_address%TYPE, 
    v_phone_number  customer.phone_number%TYPE, 
    v_address_line1 customer.address_line1%TYPE, 
    v_address_line2 customer.address_line2%TYPE, 
    v_address_line3 customer.address_line3%TYPE, 
    v_town          customer.town%TYPE, 
    v_postcode      customer.post_code%TYPE, 
    v_country       customer.country%TYPE); 
  FUNCTION Date_check ( 
    v_date_from booking.date_from%TYPE, 
    v_date_to   booking.date_to%TYPE) 
  RETURN BOOLEAN; 
  FUNCTION Create_Booking ( 
    a_date_to              booking.date_to%TYPE, 
    a_date_from            booking.date_from%TYPE, 
    a_email                customer.email_address%TYPE, 
    a_registeration_number vehicle.reg_number%TYPE) 
  RETURN BOOLEAN; 
  PROCEDURE Make_Booking ( 
    v_customer_id    customer.customer_id%TYPE, 
    v_forname        customer.cust_forename%TYPE, 
    v_surname        customer.cust_surname%TYPE, 
    v_gender         customer.gender%TYPE, 
    v_email          customer.email_address%TYPE, 
    v_phone_number   customer.phone_number%TYPE, 
    v_address_line1  customer.address_line1%TYPE, 
    v_address_line2  customer.address_line2%TYPE, 
    v_address_line3  customer.address_line3%TYPE, 
    v_town           customer.town%TYPE, 
    v_postcode       customer.post_code%TYPE, 
    v_country        customer.country%TYPE, 
    v_vehicletype    vehicle.vehicle_category_code%TYPE, 
    v_date_from      booking.date_from%TYPE, 
    v_date_to        booking.date_to%TYPE, 
    v_booking_status booking.booking_status_code%TYPE); 
  PROCEDURE update_booking ( 
    v_bookingid           booking.booking_id%TYPE, 
    v_booking_status_code booking.booking_status_code%TYPE); 
END booking_cars;

/
--------------------------------------------------------
--  DDL for Package Body BOOKING_CARS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "MA5482D"."BOOKING_CARS" 
IS 
/* The function below runs a check on wether customers their forename,surename and email exit. If true then return a boolean result */
-------------------------------------------------------------------------------------------------------------------------------  
 FUNCTION customer_check (v_forname customer.cust_forename%TYPE, v_surname customer.cust_surname%TYPE, v_email customer.email_address%TYPE)RETURN BOOLEAN AS
v_count NUMBER;
v_code NUMBER;
v_error varchar2(64);
BEGIN

SELECT COUNT(*) INTO v_count FROM CUSTOMER WHERE CUST_FORENAME= v_forname AND CUST_SURNAME=v_surname AND EMAIL_ADDRESS=v_email;

IF v_count = 1
THEN
RETURN TRUE;
ELSE RETURN FALSE;
END IF;
RETURN NULL;

EXCEPTION 
WHEN OTHERS THEN 
v_code := SQLCODE;
v_error := SUBSTR(SQLERRM, 1,64);
DBMS_OUTPUT.PUT_LINE('ERROR CODE =' || v_code|| ' : ' ||v_error);

END customer_check;

/* The function below with above called an overloading. The below function has only one paramter that checks if customer id exist
This assumes that if the customer remmber id and do not want write the whole forename, surename and email*/
--------------------------------------------------------------------------------------------------------------------------------

FUNCTION customer_check (v_Customer_Id customer.customer_id%TYPE)RETURN BOOLEAN AS

v_count NUMBER;
v_code NUMBER;
v_error varchar2(64);
BEGIN

SELECT COUNT(*) INTO v_count FROM CUSTOMER WHERE  customer_id = v_customer_id;

IF v_count = 1
THEN
RETURN TRUE;
ELSE RETURN FALSE;
END IF;
RETURN NULL;

EXCEPTION 
WHEN OTHERS THEN 
v_code := SQLCODE;
v_error := SUBSTR(SQLERRM, 1,64);
DBMS_OUTPUT.PUT_LINE('ERROR CODE =' || v_code|| ' : ' ||v_error);

END customer_check;

/* The procedure below create new customer if the customer does not exist in the database*/
  ------------------------------------------------------------------------------------------------------------------------------  
  PROCEDURE Create_customer (v_customer_id   customer.customer_id%TYPE, v_forname customer.cust_forename%TYPE, 
                             v_surname       customer.cust_surname%TYPE, v_gender customer.gender%TYPE,
                             v_email customer.email_address%TYPE, v_phone_number  customer.phone_number%TYPE, 
                             v_address_line1 customer.address_line1%TYPE, v_address_line2 customer.address_line2%TYPE, 
                             v_address_line3 customer.address_line3%TYPE,  v_town  customer.town%TYPE, 
                             v_postcode      customer.post_code%TYPE, v_country    customer.country%TYPE)  AS 
    v_code  NUMBER; 
    v_error VARCHAR(64); 
  BEGIN 
      INSERT INTO customer 
                  (customer_id, cust_forename, cust_surname, 
                   gender, 
                   email_address, 
                   phone_number, 
                   address_line1, 
                   address_line2, 
                   address_line3, 
                   town, 
                   post_code, 
                   country) 
      VALUES      (v_customer_id, 
                   v_forname, 
                   v_surname, 
                   v_gender, 
                   v_email, 
                   v_phone_number, 
                   v_address_line1, 
                   v_address_line2, 
                   v_address_line3, 
                   v_town, 
                   v_postcode, 
                   v_country); 
                   dbms_output.put_line('Customer created : ' ||v_forname ||' ' ||  v_surname );
  END create_customer; 
  -----------------------------------------------------------------------------------------------------------------------------  
  /* The function below checks for registeration number that exit and not booked within the date entered. 
  Once registeration number and not booked within selected date then booking generated for that reg number
 */ 
  FUNCTION Check_cars (v_type      vehicle.vehicle_category_code%TYPE, 
                       v_date_from booking.date_from%TYPE, 
                       v_date_to   booking.date_to%TYPE, 
                       v_email     customer.email_address%TYPE) 
  RETURN BOOLEAN 
  AS 
    v_reg_num vehicle.reg_number%TYPE; 
    v_check   BOOLEAN; 
    v_count   NUMBER; 
    v_code    NUMBER; 
    v_error   VARCHAR(64); 
    CURSOR c_chck IS 
      SELECT reg_number 
      FROM   vehicle 
      WHERE  vehicle_category_code = v_type; 
  BEGIN 
      OPEN c_chck; 

      LOOP 
          FETCH c_chck INTO v_reg_num; 

          IF c_chck%FOUND THEN 
            v_check := Create_Booking(v_date_to, v_date_from, v_email, v_reg_num); 
          END IF; 

          EXIT WHEN c_chck%NOTFOUND 
                     OR v_check = TRUE; 
      END LOOP; 

      CLOSE c_chck; 

      IF v_check = FALSE THEN 
        dbms_output.Put_line('SORRY THERE IS NO CAR AVILABLE'); 
      END IF; 
      RETURN NULL;
  EXCEPTION 
    WHEN OTHERS THEN 
               v_code := SQLCODE; 

               v_error := Substr(SQLERRM, 1, 64); 

               dbms_output.Put_line('ERROR CODE =' 
                                    || v_code 
                                    || ' : ' 
                                    ||v_error); 
  END check_cars; 
--------------------------------------------------------------------------------------------------------------------------------
  /* This function set to check the booking date against the system date to esnure booking   
    
  */ 
  FUNCTION Date_check (v_date_from booking.date_from%TYPE, 
                       v_date_to   booking.date_to%TYPE) 
  RETURN BOOLEAN 
  AS 
    v_date  DATE; 
    v_code  NUMBER; 
    v_error VARCHAR(64); 
  BEGIN 
      v_date := To_date(SYSDATE, 'DD-MON-YY'); 

      IF To_date(v_date_from, 'DD-MON-YY') > v_date 
         AND To_date(v_date_to, 'DD-MON-YY') > v_date 
         AND To_date(v_date_from, 'DD-MON-YY') <= 
             To_date(v_date_to, 'DD,MON-YY') 
      THEN 
        RETURN TRUE; 
      ELSE 
        RETURN FALSE; 
      END IF; 

      COMMIT; 
  EXCEPTION 
    WHEN OTHERS THEN 
               v_code := SQLCODE; 

               v_error := Substr(SQLERRM, 1, 64); 

               dbms_output.Put_line('ERROR CODE =' 
                                    || v_code 
                                    || ' : ' 
                                    ||v_error); 
  END date_check; 
  ------------------------------------------------------------------------------------------------------------------------------  
 
   /* This function below takes information from the check cars such as date_to,date_from,email and registeration number. 
   Afterwardws will check that if booking already exist for that reg number or not with dates entred. Afterwards run the dates 
   into another function to check that the booking dates note for the same dates requesting. If booking for that reg number 
   doesn't exist and dates from are not in the same day then create the booking and output a result.
  */ 
  FUNCTION Create_Booking(a_date_to              booking.date_to%TYPE, 
                       a_date_from            booking.date_from%TYPE, 
                       a_email                customer.email_address%TYPE, 
                       a_registeration_number vehicle.reg_number%TYPE) 
  RETURN BOOLEAN 
  AS 
    v_date                    DATE; 
    v_customer_id             customer.customer_id%TYPE; 
    v_count                   NUMBER; 
    v_booking_id              booking.booking_id%TYPE; 
    v_date_from               DATE; 
    v_date_to                 DATE; 
    v_code                    NUMBER; 
    v_error                   VARCHAR(64); 
    v_manufacture_code        vehicle.manufacturer_code%TYPE; 
    v_model_code              vehicle.model_code%TYPE; 
    v_vehicle_cat_code        vehicle.vehicle_category_code%TYPE; 
    v_current_mileage         vehicle.current_mileage%TYPE; 
    v_vehicle_daily_hire_rate vehicle.daily_hire_rate%TYPE; 
    v_datecheck               BOOLEAN; 
    invalid_date EXCEPTION; 
  BEGIN 
      SELECT Count(reg_number) 
      INTO   v_count 
      FROM   booking 
      WHERE  reg_number = a_registeration_number 
             AND date_from <= a_date_to 
             AND date_to = a_date_from; 

      SELECT customer_id 
      INTO   v_customer_id 
      FROM   customer 
      WHERE  email_address = a_email; 

      IF ( v_count > 0 ) THEN 
        RETURN FALSE; 
      ELSIF Date_check(a_date_from, a_date_to) THEN 
        INSERT INTO booking 
                    (booking_id, 
                     booking_status_code, 
                     customer_id, 
                     reg_number, 
                     date_from, 
                     date_to) 
        VALUES      (book_id_seq.NEXTVAL, 
                     'open', 
                     v_customer_id, 
                     a_registeration_number, 
                     a_date_from, 
                     a_date_to); 

        SELECT book_id_seq.CURRVAL 
        INTO   v_booking_id 
        FROM   dual; 

        SELECT manufacturer_code, 
               model_code, 
               vehicle_category_code, 
               current_mileage, 
               daily_hire_rate 
        INTO   v_manufacture_code, v_model_code, v_vehicle_cat_code, 
               v_current_mileage 
        , 
               v_vehicle_daily_hire_rate 
        FROM   vehicle 
        WHERE  reg_number = a_registeration_number; 

        dbms_output.Put_line('BOOKING_ID ' 
                             || v_booking_id 
                             || ' : ' 
                             ||'This booking id created for this customer id' 
                             || v_customer_id 
                             ||'Here is the car details that been booked = ' 
                             || Chr(10) 
                             ||'Reg No : ' 
                             ||a_registeration_number 
                             || Chr(10) 
                             ||'manufatuer code :' 
                             || v_manufacture_code 
                             || Chr(10) 
                             || 'model_code :' 
                             || v_model_code 
                             || Chr(10) 
                             ||'Vehicle ctagory code' 
                             || v_vehicle_cat_code 
                             ||Chr(10) 
                             ||'current mileage' 
                             || v_current_mileage 
                             || 'Daily_hire_rate' 
                             || v_vehicle_daily_hire_rate); 

        RETURN TRUE; 
      ELSE 
        RAISE invalid_date; 
      END IF; 

      COMMIT; 

      RETURN NULL; 
  EXCEPTION 
    WHEN no_data_found THEN 
               dbms_output.Put_line('Please enter your email to book'); WHEN 
  invalid_date THEN 
               dbms_output.Put_line('ENTER A VALID DATE'); WHEN OTHERS THEN 
               v_code := SQLCODE; 

               v_error := Substr(SQLERRM, 1, 64); 

               dbms_output.Put_line('ERROR CODE =' 
                                    || v_code 
                                    || ' : ' 
                                    ||v_error); 
  END Create_Booking; 
  ------------------------------------------------------------------------------------------------------------------------------  
    /* This is the main proccudure that the customer need to use to make a car booking as it uses all the fnctions and 
    proccudure created to check for customer or register and making customer booking.
  */ 
  PROCEDURE Make_Booking (v_customer_id    customer.customer_id%TYPE, 
                         v_forname        customer.cust_forename%TYPE, 
                         v_surname        customer.cust_surname%TYPE, 
                         v_gender         customer.gender%TYPE, 
                         v_email          customer.email_address%TYPE, 
                         v_phone_number   customer.phone_number%TYPE, 
                         v_address_line1  customer.address_line1%TYPE, 
                         v_address_line2  customer.address_line2%TYPE, 
                         v_address_line3  customer.address_line3%TYPE, 
                         v_town           customer.town%TYPE, 
                         v_postcode       customer.post_code%TYPE, 
                         v_country        customer.country%TYPE, 
                         v_vehicletype    vehicle.vehicle_category_code%TYPE, 
                         v_date_from      booking.date_from%TYPE, 
                         v_date_to        booking.date_to%TYPE, 
                         v_booking_status booking.booking_status_code%TYPE) 
  AS 
    c_check_date        BOOLEAN; 
    c_check_customer    BOOLEAN; 
    c_insert_booking    BOOLEAN; 
    c_car_check         BOOLEAN; 
    c_fn                VARCHAR2(50); 
    c_un                VARCHAR2(50); 
    c_email                customer.email_address%TYPE; 
    c_code              NUMBER; 
    c_error             VARCHAR(64); 
    c_registeration_num vehicle.reg_number%TYPE; 
    c_null_values EXCEPTION; 
    PRAGMA EXCEPTION_INIT (c_null_values, -01400); 
    c_customer_id       customer.customer_id%TYPE; 
  BEGIN 
      IF v_customer_id IS NULL THEN 
        c_check_customer := Customer_check(v_forname, v_surname, v_email); 

        IF c_check_customer = TRUE THEN 
          dbms_output.Put_line(v_forname 
                               ||' ' 
                               ||v_surname 
                               ||' ' 
                               || 'exist'); 
        ELSE 
          Create_customer(cust_id_seq.NEXTVAL, v_forname, v_surname, v_gender, 
          v_email 
          , 
          v_phone_number, v_address_line1, v_address_line2, v_address_line3, 
          v_town, 
          v_postcode, v_country); 
        END IF; 
      ELSIF v_customer_id IS NOT NULL THEN 
        c_check_customer := Customer_check(v_customer_id); 

        IF c_check_customer = TRUE THEN 
          SELECT cust_forename, 
                 cust_surname,
                 email_address
                
          INTO   c_fn, c_un,c_email   
          FROM   customer 
          WHERE  customer_id = v_customer_id; 

          dbms_output.Put_line(c_fn 
                               ||' ' 
                               ||c_un 
                               ||' ' 
                               || 'exist'); 
        ELSE 
          Create_customer(cust_id_seq.NEXTVAL, v_forname, v_surname, v_gender, 
          v_email 
          , 
          v_phone_number, v_address_line1, v_address_line2, v_address_line3, 
          v_town, 
          v_postcode, v_country); 
        END IF; 
      ELSE 
        Create_customer(cust_id_seq.NEXTVAL, v_forname, v_surname, v_gender, 
        v_email, 
        v_phone_number, v_address_line1, v_address_line2, v_address_line3, 
        v_town, 
        v_postcode, v_country); 
      END IF; 

      IF v_vehicletype IS NOT NULL AND v_email IS NULL THEN 
        c_car_check := Check_cars(v_vehicletype, v_date_from, v_date_to, c_email );
        if c_car_check = TRUE THEN 
        dbms_output.put_line('REG NUMBER FOUND AVILABLE WITHIN THE DATE');
        
        ELSE 
          dbms_output.put_line('REG NUMBER NOT FOUND');
        END IF;
      ELSif  c_email IS  NULL THEN  
      c_car_check := Check_cars(v_vehicletype, v_date_from, v_date_to, v_email );
      END IF; 

      COMMIT; 
      
  EXCEPTION 
    WHEN no_data_found THEN 
dbms_output.Put_line('PLEASE PROVIDE  REGISTERED EMAIL IN ORDER TO PROCCESSED WITH YOUR BOOKING');
WHEN c_null_values THEN
dbms_output.Put_line('PLEASE PROVIDE AT LEAST YOUR FULL NAME AND EMAIL'); WHEN 
  OTHERS THEN 
           c_code := SQLCODE; 

           c_error := Substr(SQLERRM, 1, 64); 

           dbms_output.Put_line('ERROR CODE = ' 
                                ||c_code 
                                || ' ; ' 
                                || c_error); 
  END Make_Booking ; 
  ------------------------------------------------------------------------------------------------------------------------------  
   /* This procudure below enable users to cancel their own booking. It asks users for two inputs such as 
   booking ID and the status want change their booking too such as cancelled.  
 */ 
  
  PROCEDURE Update_booking (v_bookingid booking.booking_id%TYPE, 
                            v_booking_status_code booking.booking_status_code%TYPE) 
  AS 
    c_customer_id customer.customer_id%TYPE; 
    c_status      booking.booking_status_code%TYPE; 
    c_booking_id  booking.booking_id%TYPE; 
    c_ex EXCEPTION; 
    c_null EXCEPTION; 
  BEGIN 
      SELECT booking.booking_status_code 
      INTO   c_status 
      FROM   booking 
      WHERE  booking_id = v_bookingid; 

      IF( v_booking_status_code = 'open' ) THEN 
        RAISE c_ex; 
      END IF; 

      IF( v_booking_status_code = 'confirmed' ) THEN 
        UPDATE booking 
        SET    booking.booking_status_code = v_booking_status_code 
        WHERE  booking.booking_id = v_bookingid; 
         dbms_output.Put_line('BOOKING changed to confirmed'); 
      ELSIF( v_booking_status_code = 'cancelled' )THEN 
        UPDATE booking 
        SET    booking.booking_status_code = v_booking_status_code 
        WHERE  booking.booking_id = v_bookingid; 
          dbms_output.Put_line('BOOKING got cancelled'); 
      END IF; 
  EXCEPTION 
    WHEN c_ex THEN 
               dbms_output.Put_line('BOOKING CANNOT BE CHANGED'); 
  END update_booking; 
--------------------------------------------------------------------------------------------------------------------------------  
END booking_cars;

/
