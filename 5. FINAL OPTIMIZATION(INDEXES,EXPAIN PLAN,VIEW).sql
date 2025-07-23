-- Performance Optimization

--1> Indexes on Passenger_ID, Flight_ID, Booking_Date.
create INDEX index_passenger_id on passengers (passenger_id);
create INDEX index_passenger_id on Bookings (passenger_id);
create INDEX index_flight_id on Flights(flight_id);
create INDEX index_flight_id on Bookings(flight_id);
create INDEX index_flight_id on Flights(flight_id);
create INDEX index_booking_date on Bookings (booking_date);




--2>Use EXPLAIN PLAN to analyze and improve slow queries.
--1> List all confirmed bookings for a given passenger.
Explain PLAN FOR
  SELECT 
  Booking_ID,
  Passenger_ID,
  Flight_ID,
  Seat_No,
  Class,
  Price,
  Status,
  Booking_Date
FROM Bookings
WHERE Status = 'Confirmed' AND Passenger_ID = 5;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
--2> Show flight schedules with available seats per route.

EXPLAIN PLAN FOR
SELECT 
    F.Flight_ID,
    A.Airline_Name,
    F.Departure_Airport,
    F.Arrival_Airport,
    F.Departure_Date,
    F.Arrival_Date,
    AC.Model AS Aircraft_Model,
    AC.Capacity,
    COUNT(B.Booking_ID) AS Booked_Seats,
    (AC.Capacity - COUNT(B.Booking_ID)) AS Available_Seats,
    CASE 
        WHEN (AC.Capacity - COUNT(B.Booking_ID)) < 0 THEN 'Overbooked'
        WHEN (AC.Capacity - COUNT(B.Booking_ID)) = 0 THEN 'Full'
        ELSE 'Available'
    END AS Seat_Status
FROM 
    Flights F
JOIN 
    Airlines A ON F.Airline_Id = A.Airline_Id
JOIN 
    Aircrafts AC ON F.Aircraft_ID = AC.Aircraft_ID
LEFT JOIN 
    Bookings B ON F.Flight_ID = B.Flight_ID AND B.Status = 'Confirmed'
GROUP BY 
    F.Flight_ID, A.Airline_Name, F.Departure_Airport, F.Arrival_Airport,
    F.Departure_Date, F.Arrival_Date, AC.Model, AC.Capacity
ORDER BY 
    F.Departure_Date;

select * from TABLE(DBMS_XPLAN.DISPLAY);

--OPTIMIZE USING CTE
EXPLAIN PLAN FOR
WITH ConfirmedSeatCounts AS (
    SELECT Flight_ID, COUNT(*) AS Booked_Seats
    FROM Bookings
    WHERE Status = 'Confirmed'
    GROUP BY Flight_ID
)
SELECT 
    F.Flight_ID,
    A.Airline_Name,
    F.Departure_Airport,
    F.Arrival_Airport,
    F.Departure_Date,
    F.Arrival_Date,
    AC.Model AS Aircraft_Model,
    AC.Capacity,
    NVL(CSC.Booked_Seats, 0) AS Booked_Seats,
    (AC.Capacity - NVL(CSC.Booked_Seats, 0)) AS Available_Seats,
    CASE 
        WHEN (AC.Capacity - NVL(CSC.Booked_Seats, 0)) < 0 THEN 'Overbooked'
        WHEN (AC.Capacity - NVL(CSC.Booked_Seats, 0)) = 0 THEN 'Full'
        ELSE 'Available'
    END AS Seat_Status
FROM Flights F
JOIN Airlines A ON F.Airline_ID = A.Airline_ID
JOIN Aircrafts AC ON F.Aircraft_ID = AC.Aircraft_ID
LEFT JOIN ConfirmedSeatCounts CSC ON F.Flight_ID = CSC.Flight_ID
ORDER BY F.Departure_Date;


select * from TABLE(DBMS_XPLAN.DISPLAY);
-- “By isolating confirmed seat counts into a CTE and joining it with aggregated capacity data, we reduced query complexity and minimized redundant full table scans. The optimizer now produces an adaptive plan with lower CPU cost. Further improvement is achievable with a composite index on Bookings(Flight_ID, Status), which would enable an index-driven aggregation.”

--3> Identify flights that have been cancelled or delayed.
EXPLAIN PLAN FOR
SELECT 
    Flight_ID,
    Airline_Id,
    Departure_Airport,
    Arrival_Airport,
    Departure_Date,
    Arrival_Date,
    Flight_Status
FROM 
    Flights
WHERE 
    Flight_Status IN ('Cancelled', 'Delayed')
ORDER BY 
    Departure_Date;
select * from TABLE(DBMS_XPLAN.DISPLAY);


--4 Retrieve staff hired in the past year sorted by department.
EXPLAIN PLAN FOR
SELECT 
    S.Staff_Id,
    S.Name,
    S.Role,
    S.Hire_Date,
    D.Name AS Department
FROM 
    Staff S
JOIN 
    Departments D ON S.Department_Id = D.Department_Id
WHERE 
    S.Hire_Date >= ADD_MONTHS(TRUNC(SYSDATE), -12)
ORDER BY 
    D.Name;
select * from TABLE(DBMS_XPLAN.DISPLAY);



--5 Show passengers who haven't checked in for upcoming flights.
EXPLAIN PLAN FOR
SELECT 
    P.Passenger_Id,
    P.First_Name,
    P.Last_Name,
    B.Flight_ID,
    F.Departure_Date,
    F.Arrival_Date
FROM 
    Passengers P
JOIN 
    Bookings B ON P.Passenger_Id = B.Passenger_Id
JOIN 
    Flights F ON B.Flight_ID = F.Flight_ID
LEFT JOIN 
    Check_In C ON P.Passenger_Id = C.Passenger_Id AND B.Flight_ID = C.Flight_ID
WHERE 
    C.CheckIn_id IS NULL
    AND B.Status = 'Confirmed'
ORDER BY 
    F.Departure_Date;

select * from TABLE(DBMS_XPLAN.DISPLAY);

--OPTIMIZE USING CTE
EXPLAIN PLAN FOR
WITH ConfirmedBookings AS (
    SELECT 
        B.Passenger_Id,
        B.Flight_ID
    FROM Bookings B
    WHERE B.Status = 'Confirmed'
),
UncheckedPassengers AS (
    SELECT 
        CB.Passenger_Id,
        CB.Flight_ID
    FROM ConfirmedBookings CB
    LEFT JOIN Check_In C
        ON CB.Passenger_Id = C.Passenger_Id 
       AND CB.Flight_ID = C.Flight_ID
    WHERE C.CheckIn_ID IS NULL
)
SELECT 
    P.Passenger_Id,
    P.First_Name,
    P.Last_Name,
    UP.Flight_ID,
    F.Departure_Date,
    F.Arrival_Date
FROM UncheckedPassengers UP
JOIN Passengers P ON P.Passenger_Id = UP.Passenger_Id
JOIN Flights F ON F.Flight_ID = UP.Flight_ID
ORDER BY F.Departure_Date;

select * from TABLE(DBMS_XPLAN.DISPLAY);


--6 Find top 5 busiest airports based on departure frequency.
EXPLAIN PLAN FOR
SELECT 
    Departure_Airport,
    COUNT(*) AS Departure_Count
FROM 
    Flights
GROUP BY 
    Departure_Airport
ORDER BY 
    Departure_Count DESC
FETCH FIRST 5 ROWS ONLY; 


--OPTIMIZE USING MATERALIZED VIEW
CREATE MATERIALIZED VIEW TopDepartureAirports 
BUILD IMMEDIATE
REFRESH COMPLETE ON COMMIT
AS
SELECT Departure_Airport, COUNT(*) AS Departure_Count
FROM Flights
GROUP BY Departure_Airport;

EXPLAIN PLAN FOR
SELECT * FROM TopDepartureAirports
ORDER BY Departure_Count DESC
FETCH FIRST 5 ROWS ONLY;

select * from TABLE(DBMS_XPLAN.DISPLAY);


--7 Display payment summary for a given month (total revenue, mode distribution).
EXPLAIN PLAN FOR
SELECT 
    TO_CHAR(Payment_Date, 'YYYY-MM') AS Month,
    SUM(Amount_Paid) AS Total_Revenue,
    SUM(CASE WHEN Payment_Mode = 'Cash' THEN Amount_Paid ELSE 0 END) AS Cash_Revenue,
    SUM(CASE WHEN Payment_Mode = 'Online' THEN Amount_Paid ELSE 0 END) AS Online_Revenue,
    COUNT(*) AS Total_Transactions
FROM 
    Payments
WHERE 
    TO_CHAR(Payment_Date, 'YYYY-MM') = '2024-12'  
    AND Status = 'Confirmed'
GROUP BY 
    TO_CHAR(Payment_Date, 'YYYY-MM');

    
select * from TABLE(DBMS_XPLAN.DISPLAY);

--8 List aircrafts used most frequently across all flights.
EXPLAIN PLAN
SELECT 
    F.Aircraft_ID,
    A.Model,
    A.Manufacturer,
    COUNT(*) AS Usage_Count
FROM 
    Flights F
JOIN 
    Aircrafts A ON F.Aircraft_ID = A.Aircraft_ID
GROUP BY 
    F.Aircraft_ID, A.Model, A.Manufacturer
ORDER BY 
    Usage_Count DESC;

select * from TABLE(DBMS_XPLAN.DISPLAY);


--9 Retrieve bookings where the payment is still pending.
EXPLAIN PLAN FOR
SELECT 
    B.Booking_ID,
    B.Passenger_ID,
    P.First_Name,
    P.Last_Name,
    B.Flight_ID,
    B.Seat_No,
    B.Price,
    B.Booking_Date,
    Pay.Status AS Payment_Status
FROM
    Bookings B
JOIN 
    Payments Pay ON B.Booking_ID = Pay.Booking_ID
JOIN 
    Passengers P ON B.Passenger_ID = P.Passenger_ID
WHERE 
    Pay.Status = 'Pending'
ORDER BY 
    B.Booking_Date;

Select * from TABLE(DBMS_XPLAN.DISPLAY);

--10Identify flights with overbooked status (passengers exceed capacity).
EXPLAIN PLAN FOR
SELECT 
    F.Flight_ID,
    F.Departure_Airport,
    F.Arrival_Airport,
    AC.Model AS Aircraft_Model,
    AC.Capacity,
    COUNT(B.Booking_ID) AS Confirmed_Passengers,
    (COUNT(B.Booking_ID) - AC.Capacity) AS Excess_Passengers
FROM 
    Flights F
JOIN 
    Aircrafts AC ON F.Aircraft_ID = AC.Aircraft_ID
JOIN 
    Bookings B ON F.Flight_ID = B.Flight_ID
WHERE 
    B.Status = 'Confirmed'
GROUP BY 
    F.Flight_ID, F.Departure_Airport, F.Arrival_Airport,
    AC.Model, AC.Capacity
HAVING 
    COUNT(B.Booking_ID) > AC.Capacity
ORDER BY 
    Excess_Passengers DESC;

Select * from TABLE(DBMS_XPLAN.DISPLAY);
--OPTIMIZE QUERY USING CTE
EXPLAIN PLAN FOR
WITH ConfirmedBookings AS (
  SELECT Flight_ID, COUNT(*) AS Confirmed_Passengers
  FROM Bookings
  WHERE Status = 'Confirmed'
  GROUP BY Flight_ID
)
SELECT 
  F.Flight_ID,
  F.Departure_Airport,
  F.Arrival_Airport,
  AC.Model AS Aircraft_Model,
  AC.Capacity,
  CB.Confirmed_Passengers,
  (CB.Confirmed_Passengers - AC.Capacity) AS Excess_Passengers
FROM Flights F
JOIN Aircrafts AC ON F.Aircraft_ID = AC.Aircraft_ID
JOIN ConfirmedBookings CB ON F.Flight_ID = CB.Flight_ID
WHERE CB.Confirmed_Passengers > AC.Capacity
ORDER BY Excess_Passengers DESC;


Select * from TABLE(DBMS_XPLAN.DISPLAY);





--3> Partition tables such as Flights and Payments by year or route.
-- Done in creation of table



--4> Create materialized views for monthly flight summaries.
CREATE MATERIALIZED VIEW Monthly_Flight_Summary
BUILD IMMEDIATE
REFRESH COMPLETE ON COMMIT
AS
SELECT 
    f.Flight_Id,
    TO_CHAR(f.Departure_date, 'YYYY-MM') AS Month,
    COUNT(b.Booking_Id) AS Total_Bookings,
    SUM(b.Price) AS Total_Revenue
FROM 
    Flights f
    JOIN Bookings b ON f.Flight_Id = b.Flight_Id
GROUP BY 
    f.Flight_Id, TO_CHAR(f.Departure_date, 'YYYY-MM');

select * from Monthly_Flight_Summary;

select * from flights;
