--1> List all confirmed bookings for a given passenger.
SELECT 
    B.Booking_ID,
    B.Flight_ID,
    F.Departure_Airport,
    F.Arrival_Airport,
    F.Departure_Date,
    B.Seat_No,
    B.Class,
    B.Price
FROM 
    Bookings B
JOIN 
    Flights F ON B.Flight_ID = F.Flight_ID
WHERE 
    B.Passenger_ID = :passenger_id
    AND B.Status = 'Confirmed';
    
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
WHERE Status = 'Confirmed' AND Passenger_ID = 9;




--2> Show flight schedules with available seats per route.
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



--3> Identify flights that have been cancelled or delayed.
-- updating date to not to trigger the update_flight)status _tigger

UPDATE Flights
SET 
    Departure_Date = TRUNC(SYSDATE) + 1,
    Arrival_Date = TRUNC(SYSDATE) + 1
WHERE 
    Flight_ID IN ('DL2002', 'F97007', 'WN4004', 'SY1010');

select * from flights;


-- upadate status to add answer in query
UPDATE Flights
SET Flight_Status = 'Cancelled'
WHERE Flight_ID IN ('DL2002', 'F97007');  
UPDATE Flights
SET Flight_Status = 'Delayed'
WHERE Flight_ID IN ('WN4004', 'SY1010'); 

--actual query
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




--4> Retrieve staff hired in the past year sorted by department.
--Modifying data to show 
UPDATE Staff
SET Hire_Date = TRUNC(SYSDATE) - 30  
WHERE Staff_Id = 1;

UPDATE Staff
SET Hire_Date = TRUNC(SYSDATE) - 60 
WHERE Staff_Id = 5;

UPDATE Staff
SET Hire_Date = TRUNC(SYSDATE) - 90  
WHERE Staff_Id = 10;


--Actual Query
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



--5> Show passengers who haven't checked in for upcoming flights.
INSERT INTO Passengers (
    First_Name, Last_Name, DOB, Gender, Contact, Email, Passport_No, Nationality
) VALUES
    ('Ethan', 'Moore', DATE '1991-04-17', 'Male', '5556060606', 'ethan.moore@email.com', 'US606060601', 'American'),
    ('Sophia', 'Green', DATE '1988-12-09', 'Female', '5557070707', 'sophia.green@email.com', 'US707070702', 'American'),
    ('Liam', 'Scott', DATE '1993-06-22', 'Male', '5558080808', 'liam.scott@email.com', 'US808080803', 'Canadian');

select * from bookings;
INSERT INTO Bookings (
    Passenger_ID, Flight_ID, Booking_Date, Seat_No, Class, Price, Status
) VALUES
    (21, 'AA1001', TRUNC(SYSDATE), '23A', 'Economy', 475.00, 'Confirmed'),
    (22, 'DL2002', TRUNC(SYSDATE), '19C', 'Business', 980.00, 'Confirmed'),
    (23, 'SY1010', TRUNC(SYSDATE), '7B', 'Economy', 500.00, 'Confirmed');

-- Actual query 
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




--6> Find top 5 busiest airports based on departure frequency.
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



--7> Display payment summary for a given month (total revenue, mode distribution).
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



-- List aircrafts used most frequently across all flights.
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


--9> Retrieve bookings where the payment is still pending.
--insert for pending status
INSERT INTO Payments (
    Booking_ID, Amount_Paid, Payment_Date, Payment_Mode, Status
) VALUES
    (2, 475.00, TRUNC(SYSDATE), 'Online', 'Pending'),
    (3, 980.00, TRUNC(SYSDATE), 'Cash', 'Pending'),
    (4, 500.00, TRUNC(SYSDATE), 'Online', 'Pending');
-- Actual Query
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


-- Identify flights with overbooked status (passengers exceed capacity).
--Change capacity of aircaft to check the query for overbooked
UPDATE Aircrafts
SET Capacity = 0
WHERE AIRCRAFT_ID = 'B737-800';

--Actual query
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
