--Procedures & Functions
--1> Procedure to assign a seat and confirm booking.
CREATE OR REPLACE PROCEDURE SEAT_AND_CONFIRM_BOOKING(
    p_passenger_id IN bookings.passenger_id%type,
    p_flight_id IN flights.flight_id%type,
    p_seat_no IN bookings.seat_no%type,
    p_class IN bookings.class%type,
    p_price IN bookings.price%type
)
IS
    Existing_Count NUMBER;
    p_seat_taken NUMBER;
    p_booking_id Bookings.BOOKING_ID%TYPE;
    p_departure_date Flights.Departure_Date%TYPE;
BEGIN
    SELECT COUNT(*) INTO Existing_Count
    FROM Flights
    WHERE Flight_ID = p_flight_id;

    IF Existing_Count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Flight ID Not Found');
    END IF;

    IF p_price <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid price amount. ');
    END IF;

    SELECT Departure_Date INTO p_departure_date
    FROM Flights
    WHERE Flight_ID = p_flight_id;

    IF p_departure_date < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20003, 'Cannot book seat: Flight has already departed.');
    END IF;

    SELECT COUNT(*) INTO p_seat_taken
    FROM Bookings
    WHERE Flight_ID = p_flight_id
      AND Seat_no = p_seat_no;

    IF p_seat_taken > 0 THEN
        SELECT Booking_ID INTO p_booking_id
        FROM Bookings
        WHERE Flight_ID = p_flight_id
          AND Seat_no = p_seat_no;

        UPDATE Bookings
        SET Status = 'Pending'
        WHERE Booking_ID = p_booking_id;

        DBMS_OUTPUT.PUT_LINE('Seat already assigned. Booking status updated to Pending.');
    ELSE
        INSERT INTO Bookings(
            Passenger_id,
            Flight_Id,
            Booking_Date,
            Seat_no,
            Class,
            Price,
            Status
        ) VALUES (
            p_passenger_id,
            p_flight_id,
            SYSDATE,
            p_seat_no,
            p_class,
            p_price,
            'Confirmed'
        );

        DBMS_OUTPUT.PUT_LINE('Seat assigned and booking confirmed.');
    END IF;

    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE;
END;
/

BEGIN
    Seat_And_Confirm_Booking(
        p_passenger_id => 2,
        p_flight_id => 'DL2002',
        p_seat_no => '12R', 
        p_class => 'Economy',
        p_price => 450
        );
END;

UPDATE Flights
SET 
    Departure_date = date '2025-12-19',
    Arrival_date = date '2025-12-19'
WHERE Flight_Id = 'DL2002'; 


SELECT * FROM BOOKINGS WHERE FLIGHT_ID = 'DL2002';
SELECT * FROM FLIGHTS ;

-- 2> Function to calculate final fare with class modifiers and tax.

CREATE OR REPLACE FUNCTION Final_Fare (
    base_price IN bookings.price%type,
    travel_class IN bookings.class%type
) RETURN NUMBER IS
    modifier NUMBER := 1.0;
    tax_rate CONSTANT NUMBER := 0.13;
    final_price_after_tax bookings.price%type;
BEGIN
    -- Determine class modifier
    CASE travel_class
        WHEN 'Economy' THEN modifier := 1.0;
        WHEN 'Business' THEN modifier := 1.25;
        WHEN 'First Class' THEN modifier := 1.5;
        ELSE modifier := 1.0; 
    END CASE;

    -- Apply modifier and tax
    final_price_after_tax := (base_price * modifier) * (1 + tax_rate);

    RETURN final_price_after_tax;
END Final_Fare;
/

DECLARE
 base_price bookings.price%type := &base_price;
 Class bookings.class%type := '&Class';
 Output Number;
BEGIN
    Output := Final_Fare(base_price, Class);
    dbms_output.put_line('Price after modifier and tax is: ' || Output);
END;


--3> Procedure to process check-in and baggage assignment.
CREATE OR REPLACE PROCEDURE PROCESS_CHECK_IN_AND_BAGGAGE(
    p_passenger_id   IN Passengers.Passenger_ID%TYPE,
    p_flight_id      IN Flights.Flight_id%type,
    p_baggage_weight IN Check_In.Baggage_Weight%TYPE

)
IS
    e_passenger_exists  NUMBER;
    e_flight_exists     NUMBER;
    e_already_checked_in NUMBER;
BEGIN
    SELECT COUNT(*) INTO e_flight_exists
    FROM Flights
    WHERE Flight_ID = p_flight_id;

    IF e_flight_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Flight ID not found.');
    END IF;

    SELECT COUNT(*) INTO e_passenger_exists
    FROM Passengers
    WHERE Passenger_ID = p_passenger_id;

    IF e_passenger_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Passenger ID not found.');
    END IF;

    SELECT COUNT(*) INTO e_already_checked_in
    FROM Check_In
    WHERE Passenger_ID = p_passenger_id
      AND Flight_ID = p_flight_id;

    IF e_already_checked_in > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Passenger already checked in for this flight.');
    END IF;

    INSERT INTO Check_In (
        Passenger_ID,
        Flight_ID,
        CheckIn_Time,
        Baggage_Weight
    ) VALUES (
        p_passenger_id,
        p_flight_id,
        SYSTIMESTAMP,
        p_baggage_weight
    );

    DBMS_OUTPUT.PUT_LINE('Check-in completed for Passenger ' || p_passenger_id || 
                         '. Baggage is assigned for weight: ' || p_baggage_weight || ' kg.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE;
END;
/


BEGIN
    PROCESS_CHECK_IN_AND_BAGGAGE(
        p_passenger_id   => 22,          
        p_flight_id      => 'WN4004',      
        p_baggage_weight => 36         
    );
END;
/
-- =========================================================================================

-- TRIGGERS

-- 1>Trigger to prevent double-booking of a seat.
CREATE OR REPLACE TRIGGER Prevent_Seat_Double_Booking
BEFORE INSERT ON Bookings
FOR EACH ROW
DECLARE
    seat_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO seat_count
    FROM Bookings
    WHERE Seat_No = :NEW.Seat_No AND Flight_ID = :NEW.Flight_ID;

    IF seat_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Seat already booked.');
    END IF;
END;
--output
-- Trigger PREVENT_SEAT_DOUBLE_BOOKING compiled

-- Elapsed: 00:00:00.022


INSERT INTO Bookings (Passenger_id, Flight_id, Booking_Date, Seat_No, Class, Price, Status)
VALUES (1, 'AA1001', SYSDATE, '15A', 'Economy', 400, 'Confirmed');
-- output
-- 1 row inserted.

-- Elapsed: 00:00:00.018
INSERT INTO Bookings (Passenger_id, Flight_id, Booking_Date, Seat_No, Class, Price, Status)
VALUES (2, 'AA1001', SYSDATE, '12A', 'Economy', 450, 'Confirmed');
-- output
-- ORA-20009: Seat already booked.
-- ORA-06512: at "SQL_OTSY0WRYNPGJSEFJTM9F5B2DUB.PREVENT_SEAT_DOUBLE_BOOKING", line 9
-- ORA-04088: error during execution of trigger 'SQL_OTSY0WRYNPGJSEFJTM9F5B2DUB.PREVENT_SEAT_DOUBLE_BOOKING'

-- https://docs.oracle.com/error-help/db/ora-21000/
-- Error at Line: 4 Column: 0
---------------------------------------------------------------------------------------------------------------


-- 2>Trigger to update flight status based on time or cancellations.
    CREATE OR REPLACE TRIGGER Update_Flight_Status
BEFORE UPDATE ON Flights
FOR EACH ROW
BEGIN
    IF :OLD.Flight_Status = 'Cancelled' THEN
        :NEW.Flight_Status := 'Cancelled';
    ELSIF :NEW.Departure_Date < SYSDATE AND :NEW.Arrival_Date < SYSDATE THEN
        :NEW.Flight_Status := 'Completed';
    ELSIF :NEW.Departure_Date < SYSDATE THEN
        :NEW.Flight_Status := 'Departed';
    END IF;
END;
-- Output
-- Trigger UPDATE_FLIGHT_STATUS compiled

-- Elapsed: 00:00:00.023


-- Test the trigger

UPDATE Flights
SET Departure_Date = SYSDATE - 1
WHERE Flight_ID = 'AA1001';
SELECT Flight_Status FROM Flights WHERE Flight_ID = 'AA1001';
-- "FLIGHT_STATUS"
-- "Departed"

--3>Trigger to log payment failures with reasons.
CREATE TABLE Payment_Error_Codes (
    Error_Code VARCHAR2(10) PRIMARY KEY,
    Description VARCHAR2(100) NOT NULL
);

-- Sample error codes
INSERT INTO Payment_Error_Codes VALUES ('DECLINE', 'Card Declined');
INSERT INTO Payment_Error_Codes VALUES ('NET_ERR', 'Network Error');
INSERT INTO Payment_Error_Codes VALUES ('INS_FUN', 'Insufficient Funds');
INSERT INTO Payment_Error_Codes VALUES ('EXP_CARD', 'Expired Card');
INSERT INTO Payment_Error_Codes VALUES ('GEN_ERR', 'General Payment Error');

ALTER TABLE Payments
ADD Failure_Code VARCHAR2(10);

-- table for logs
CREATE TABLE Payment_Fail_Log (
    Log_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Booking_ID NUMBER,
    Reason VARCHAR2(100),
    Log_Date TIMESTAMP
);

CREATE OR REPLACE TRIGGER Log_Payment_Failure
AFTER INSERT OR UPDATE ON Payments
FOR EACH ROW
WHEN (NEW.Status = 'Failed')
DECLARE
    error_msg VARCHAR2(100);
BEGIN
    -- Look up the failure description
    SELECT Description INTO error_msg
    FROM Payment_Error_Codes
    WHERE Error_Code = :NEW.Failure_Code;

    -- Insert into failure log
    INSERT INTO Payment_Fail_Log (Booking_ID, Reason, Log_Date)
    VALUES (:NEW.Booking_ID, error_msg, SYSTIMESTAMP);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO Payment_Fail_Log (Booking_ID, Reason, Log_Date)
        VALUES (:NEW.Booking_ID, 'Unknown failure reason', SYSTIMESTAMP);
END;

-- Alter constraints to add failure to status in payment
SELECT uc.constraint_name,
       uc.constraint_type,
       ucc.column_name,
       uc.search_condition
FROM user_constraints uc
JOIN user_cons_columns ucc
  ON uc.constraint_name = ucc.constraint_name
WHERE uc.table_name = 'PAYMENTS';
-- SYS_C002643101
ALTER TABLE Payments
DROP CONSTRAINT SYS_C002643101;

ALTER TABLE Payments
ADD CONSTRAINT CK_PAYMENTS_STATUS
CHECK (Status IN ('Confirmed', 'Pending', 'Failed'));
-- check the trigger Log_Payment_Failure
UPDATE Payments
SET Status = 'Failed', Failure_Code = 'INS_FUN'
WHERE Booking_ID = 3;

SELECT * FROM Payment_Fail_Log ;
--output
-- "LOG_ID","BOOKING_ID","REASON","LOG_DATE"
-- 1,3,"Insufficient Funds","2025-07-11T07:22:06.923798Z"
