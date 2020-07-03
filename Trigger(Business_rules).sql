--------------------------------------------------------
--  File created - Sunday-December-15-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger UPDATING_BOOKING_STATUS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "MA5482D"."UPDATING_BOOKING_STATUS" 
BEFORE UPDATE ON BOOKING 
FOR EACH ROW

BEGIN 
if :OLD.BOOKING_STATUS_CODE = 'cancelled' THEN
RAISE_APPLICATION_ERROR (-20503,'sorry booking cannot be changed after canceling');

end if;

end;
/
ALTER TRIGGER "MA5482D"."UPDATING_BOOKING_STATUS" ENABLE;
