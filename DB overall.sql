-- Create tables
-- REFRENCE TABLE

CREATE TABLE Airlines(
    Airline_ID VARCHAR2(3) Primary Key,
    Airline_Name VARCHAR2(50),
    Headquarters VARCHAR2(40)
);
CREATE TABLE Airports(
    Airport_ID VARCHAR2(4) PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL UNIQUE,
    Country VARCHAR2(50) NOT NULL,
    City VARCHAR2(50) NOT NULL,
    IATA_Code VARCHAR2(3) NOT NULL UNIQUE
);

CREATE TABLE Aircrafts(
    Aircraft_ID VARCHAR2(10) PRIMARY KEY,
    Model VARCHAR2(20) NOT NULL,
    Capacity NUMBER,
    CONSTRAINT chk_capacity CHECK (Capacity >= 0),
    Manufacturer VARCHAR2(50) NOT NULL
);

CREATE TABLE MANAGERS(
    MANAGER_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NAME VARCHAR2(50) NOT NULL
);

CREATE TABLE DEPARTMENTS(
    Department_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    MANAGER_ID NUMBER UNIQUE,
    FOREIGN KEY (MANAGER_ID) REFERENCES MANAGERS(MANAGER_ID)
);

--MAIN TABLE
CREATE TABLE PASSENGERS(
    Passenger_id NUMBER GENERATED ALWAYS AS IDENTITY primary key,
    First_Name VARCHAR2(30) not null,
    Last_Name VARCHAR2(30) not null,
    DOB DATE Not Null,
    Gender VARCHAR2(6),
    Contact Number Unique not null,
    Email VARCHAR2(50) not null unique,
    Passport_No Varchar2(15) not null unique,
    Nationality Varchar2(20) not null
);

Create table Flights(
    Flight_Id VARCHAR2(8) primary key,
    Airline_Id VARCHAR2(3),
    Departure_Airport VARCHAR2(50) NOT NULL,
    Arrival_Airport VARCHAR2(50) NOT NULL,
    Departure_date DATE NOT NULL,
    Arrival_date DATE NOT NULL,
    Aircraft_ID VARCHAR2(10),
    Flight_Status VARCHAR2(40) DEFAULT 'Scheduled' check(Flight_status in ('Scheduled', 'Departed', 'Arrived', 'Cancelled', 'Delayed')),
    Foreign Key (Airline_Id) REFERENCES Airlines(Airline_Id),
    Foreign Key (Aircraft_ID) REFERENCES Aircrafts(Aircraft_ID)
)
PARTITION BY RANGE (Departure_Date) (
    PARTITION f2024 VALUES LESS THAN (TO_DATE('01-JAN-2024','DD-MON-YYYY')),
    PARTITION f2025 VALUES LESS THAN (TO_DATE('01-JAN-2025','DD-MON-YYYY')),
    PARTITION fmax VALUES LESS THAN (MAXVALUE)
);

create table Bookings(
    Booking_id NUMBER GENERATED ALWAYS AS IDENTITY primary key,
    Passenger_id Number,
    Flight_id VARCHAR2(8),
    Booking_Date date not null,
    Seat_No VARCHAR2(4) not null unique,
    Class VARCHAR2(15) DEFAULT 'Economy' check(Class in ('Economy', 'First Class', 'Business')),
    Price Number(8,2) not null,
    CONSTRAINT chk_price CHECK (Price > 0),
    Status VARCHAR2(15) not null check(Status in ('Confirmed', 'Pending', 'Cancelled')),
    Foreign Key (Passenger_id) REFERENCES PASSENGERS(Passenger_id),
    Foreign Key (Flight_Id) REFERENCES Flights(Flight_Id)
);

create table Staff(
    Staff_Id NUMBER GENERATED ALWAYS AS IDENTITY primary key,
    Name Varchar2(30) not null,
    Role Varchar2(15) not null,
    Department_Id number,
    Contact number unique not null,
    Hire_Date Date not null,
    Salary Number(7,2) not NULL,
    CONSTRAINT chk_salary CHECK (salary > 0),
    Foreign Key (Department_Id) REFERENCES Departments(Department_Id)
);
 
create table Payments(
    Payment_Id NUMBER GENERATED ALWAYS AS IDENTITY primary key,
    Booking_id NUMBER,
    Amount_Paid number(8,2) not null,
    CONSTRAINT chk_amt_paid CHECK (Amount_Paid > 0),
    Payment_Date Date not null,
    Payment_Mode VARCHAR2(10) not null check(Payment_Mode in ('Cash', 'Online')),
    Status VARCHAR2(15) not null check(Status in ('Confirmed', 'Pending', 'Refunded', 'Failed')),
    foreign key (Booking_id) references Bookings(Booking_id)
)
PARTITION BY RANGE (Payment_Date) (
    PARTITION p2024 VALUES LESS THAN (TO_DATE('01-JAN-2024','DD-MON-YYYY')),
    PARTITION p2025 VALUES LESS THAN (TO_DATE('01-JAN-2025','DD-MON-YYYY')),
    PARTITION pmax VALUES LESS THAN (MAXVALUE)
);

create table Check_In(
    CheckIn_id NUMBER GENERATED ALWAYS AS IDENTITY primary key,
    Passenger_Id NUMBER,
    Flight_Id VARCHAR2(8),
    CheckIn_Time Timestamp,
    Baggage_Weight number(5,2) not null,
    CONSTRAINT Baggage_Weight CHECK (Baggage_Weight > 0),
    foreign key (Passenger_Id) references PASSENGERS(Passenger_id),
    foreign key (Flight_Id) references Flights(Flight_Id)
);

-- Data Entry
--INSERTION FOR ALL TABLE
INSERT INTO Airlines (
    Airline_ID
    ,Airline_Name
    ,Headquarters
) 
VALUES 
    ('AA', 'American Airlines', 'Fort Worth, Texas'),
    ('DL', 'Delta Air Lines', 'Atlanta, Georgia'),
    ('UA', 'United Airlines', 'Chicago, Illinois'),
    ('WN', 'Southwest Airlines', 'Dallas, Texas'),
    ('B6', 'JetBlue Airways', 'Long Island City, New York'),
    ('AS', 'Alaska Airlines', 'Seattle, Washington'),
    ('F9', 'Frontier Airlines', 'Denver, Colorado'),
    ('NK', 'Spirit Airlines', 'Miramar, Florida'),
    ('G4', 'Allegiant Air', 'Las Vegas, Nevada'),
    ('SY', 'Sun Country Airlines', 'Minneapolis, Minnesota'),
    ('HA', 'Hawaiian Airlines', 'Honolulu, Hawaii'),
    ('VX', 'Virgin America', 'Burlingame, California'),
    ('9E', 'Endeavor Air', 'Minneapolis, Minnesota'),
    ('YX', 'Republic Airways', 'Indianapolis, Indiana'),
    ('QX', 'Horizon Air', 'Seattle, Washington');


INSERT INTO Airports (
    Airport_ID
    ,Name
    ,Country
    ,City
    ,IATA_Code
) 
VALUES
    ('JFK1', 'John F. Kennedy International Airport', 'United States', 'New York', 'JFK'),
    ('LAX1', 'Los Angeles International Airport', 'United States', 'Los Angeles', 'LAX'),
    ('ORD1', 'Chicago O''Hare International Airport', 'United States', 'Chicago', 'ORD'),
    ('DFW1', 'Dallas/Fort Worth International Airport', 'United States', 'Dallas', 'DFW'),
    ('DEN1', 'Denver International Airport', 'United States', 'Denver', 'DEN'),
    ('SFO1', 'San Francisco International Airport', 'United States', 'San Francisco', 'SFO'),
    ('SEA1', 'Seattle-Tacoma International Airport', 'United States', 'Seattle', 'SEA'),
    ('LAS1', 'McCarran International Airport', 'United States', 'Las Vegas', 'LAS'),
    ('PHX1', 'Phoenix Sky Harbor International Airport', 'United States', 'Phoenix', 'PHX'),
    ('IAH1', 'George Bush Intercontinental Airport', 'United States', 'Houston', 'IAH'),
    ('MIA1', 'Miami International Airport', 'United States', 'Miami', 'MIA'),
    ('MCO1', 'Orlando International Airport', 'United States', 'Orlando', 'MCO'),
    ('BOS1', 'Logan International Airport', 'United States', 'Boston', 'BOS'),
    ('MSP1', 'Minneapolis-St. Paul International Airport', 'United States', 'Minneapolis', 'MSP'),
    ('DTW1', 'Detroit Metropolitan Wayne County Airport', 'United States', 'Detroit', 'DTW');


INSERT INTO Aircrafts (
    Aircraft_ID
    ,Model
    ,Capacity
    ,Manufacturer
) 
VALUES
    ('B737-800', '737-800', 189, 'Boeing'),
    ('A320-200', 'A320-200', 180, 'Airbus'),
    ('B777-300', '777-300', 396, 'Boeing'),
    ('A330-300', 'A330-300', 295, 'Airbus'),
    ('B787-900', '787-900', 290, 'Boeing'),
    ('A321-200', 'A321-200', 220, 'Airbus'),
    ('B767-300', '767-300', 269, 'Boeing'),
    ('A319-100', 'A319-100', 156, 'Airbus'),
    ('B747-400', '747-400', 416, 'Boeing'),
    ('A380-800', 'A380-800', 525, 'Airbus'),
    ('E190-100', 'E190-100', 114, 'Embraer'),
    ('CRJ-700', 'CRJ-700', 78, 'Bombardier'),
    ('ATR-72', '72-600', 78, 'ATR'),
    ('Q400-DH', '8-Q400', 86, 'Bombardier'),
    ('MD80-88', 'MD-80', 172, 'McDonnell Douglas');


INSERT INTO Managers (Name) 
VALUES 
    ('John Smith'),
    ('Sarah Johnson'),
    ('Michael Brown'),
    ('Emily Davis'),
    ('David Wilson'),
    ('Lisa Anderson'),
    ('Robert Taylor'),
    ('Jennifer Martinez'),
    ('Christopher Lee'),
    ('Amanda White'),
    ('Matthew Garcia'),
    ('Jessica Rodriguez'),
    ('Daniel Thompson'),
    ('Ashley Moore'),
    ('Kevin Jackson');


INSERT INTO Departments (
    Name
    ,Manager_ID
) 
VALUES
    ('Operations', 1),
    ('Customer Service', 2),
    ('Maintenance', 3),
    ('Security', 4),
    ('Ground Services', 5),
    ('Flight Operations', 6),
    ('Human Resources', 7),
    ('Finance', 8),
    ('Information Technology', 9),
    ('Marketing', 10),
    ('Baggage Handling', 11),
    ('Catering', 12),
    ('Reservations', 13),
    ('Quality Assurance', 14),
    ('Training', 15);


INSERT INTO Passengers (
    First_Name
    ,Last_Name
    ,DOB
    ,Gender
    ,Contact
    ,Email
    ,Passport_No
    ,Nationality
) 
VALUES
    ('James', 'Wilson', DATE '1985-03-15', 'Male', 5551234567, 'james.wilson@email.com', 'US123456789', 'American'),
    ('Maria', 'Garcia', DATE '1990-07-22', 'Female', 5552345678, 'maria.garcia@email.com', 'US234567890', 'American'),
    ('Robert', 'Johnson', DATE '1978-11-08', 'Male', 5553456789, 'robert.johnson@email.com', 'US345678901', 'American'),
    ('Linda', 'Davis', DATE '1992-05-14', 'Female', 5554567890, 'linda.davis@email.com', 'CA456789012', 'Canadian'),
    ('William', 'Miller', DATE '1987-09-30', 'Male', 5555678901, 'william.miller@email.com', 'US567890123', 'American'),
    ('Patricia', 'Brown', DATE '1995-01-12', 'Female', 5556789012, 'patricia.brown@email.com', 'UK678901234', 'British'),
    ('Christopher', 'Jones', DATE '1983-12-25', 'Male', 5557890123, 'chris.jones@email.com', 'US789012345', 'American'),
    ('Barbara', 'Martinez', DATE '1988-06-18', 'Female', 5558901234, 'barbara.martinez@email.com', 'MX890123456', 'Mexican'),
    ('David', 'Anderson', DATE '1991-04-03', 'Male', 5559012345, 'david.anderson@email.com', 'US901234567', 'American'),
    ('Susan', 'Taylor', DATE '1986-10-27', 'Female', 5550123456, 'susan.taylor@email.com', 'AU012345678', 'Australian'),
    ('Michael', 'Thomas', DATE '1989-08-11', 'Male', 5551357924, 'michael.thomas@email.com', 'US123456780', 'American'),
    ('Jennifer', 'Jackson', DATE '1993-02-28', 'Female', 5552468135, 'jennifer.jackson@email.com', 'CA234567891', 'Canadian'),
    ('Charles', 'White', DATE '1984-12-05', 'Male', 5553579246, 'charles.white@email.com', 'US345678902', 'American'),
    ('Nancy', 'Harris', DATE '1990-03-19', 'Female', 5554680357, 'nancy.harris@email.com', 'UK456789013', 'British'),
    ('Thomas', 'Clark', DATE '1987-07-16', 'Male', 5555791468, 'thomas.clark@email.com', 'US567890124', 'American');


INSERT INTO Flights (
    Flight_Id
    ,Airline_Id
    ,Departure_Airport
    ,Arrival_Airport
    ,Departure_date
    ,Arrival_date
    ,Aircraft_ID
    ,Flight_Status
) 
VALUES
    ('AA1001', 'AA', 'John F. Kennedy International Airport', 'Los Angeles International Airport', DATE '2024-12-15', DATE '2024-12-15', 'B737-800', 'Scheduled'),
    ('DL2002', 'DL', 'Chicago O''Hare International Airport', 'Miami International Airport', DATE '2024-12-16', DATE '2024-12-16', 'A320-200', 'Delayed'),
    ('UA3003', 'UA', 'Denver International Airport', 'Seattle-Tacoma International Airport', DATE '2024-12-17', DATE '2024-12-17', 'B777-300', 'Departed'),
    ('WN4004', 'WN', 'Dallas/Fort Worth International Airport', 'Phoenix Sky Harbor International Airport', DATE '2024-12-18', DATE '2024-12-18', 'A330-300', 'Arrived'),
    ('B65005', 'B6', 'San Francisco International Airport', 'McCarran International Airport', DATE '2024-12-19', DATE '2024-12-19', 'B787-900', 'Cancelled'),
    ('AS6006', 'AS', 'George Bush Intercontinental Airport', 'Orlando International Airport', DATE '2024-12-20', DATE '2024-12-20', 'A321-200', 'Cancelled'),
    ('F97007', 'F9', 'Logan International Airport', 'Minneapolis-St. Paul International Airport', DATE '2024-12-21', DATE '2024-12-21', 'B767-300', 'Arrived'),
    ('NK8008', 'NK', 'Detroit Metropolitan Wayne County Airport', 'John F. Kennedy International Airport', DATE '2024-12-22', DATE '2024-12-22', 'A319-100', 'Departed'),
    ('G49009', 'G4', 'Los Angeles International Airport', 'Chicago O''Hare International Airport', DATE '2024-12-23', DATE '2024-12-23', 'B747-400', 'Delayed'),
    ('SY1010', 'SY', 'Miami International Airport', 'Denver International Airport', DATE '2024-12-24', DATE '2024-12-24', 'A380-800', 'Scheduled'),
    ('HA1111', 'HA', 'Seattle-Tacoma International Airport', 'Dallas/Fort Worth International Airport', DATE '2024-12-25', DATE '2024-12-25', 'E190-100', 'Scheduled'),
    ('VX1212', 'VX', 'Phoenix Sky Harbor International Airport', 'San Francisco International Airport', DATE '2024-12-26', DATE '2024-12-26', 'CRJ-700', 'Scheduled'),
    ('9E1313', '9E', 'McCarran International Airport', 'George Bush Intercontinental Airport', DATE '2024-12-27', DATE '2024-12-27', 'ATR-72', 'Scheduled'),
    ('YX1414', 'YX', 'Orlando International Airport', 'Logan International Airport', DATE '2024-12-28', DATE '2024-12-28', 'Q400-DH', 'Scheduled'),
    ('QX1515', 'QX', 'Minneapolis-St. Paul International Airport', 'Detroit Metropolitan Wayne County Airport', DATE '2024-12-29', DATE '2024-12-29', 'MD80-88', 'Scheduled');


INSERT INTO Bookings (
    Passenger_ID
    ,Flight_ID
    ,Booking_Date
    ,Seat_No
    ,Class
    ,Price
    ,Status
) 
VALUES
    (1, 'AA1001', DATE '2024-12-01', '12A', 'Economy', 450.00, 'Confirmed'),
    (2, 'DL2002', DATE '2024-12-02', '5B', 'Business', 950.00, 'Pending'),
    (3, 'UA3003', DATE '2024-12-03', '1A', 'First Class', 1200.00, 'Cancelled'),
    (4, 'WN4004', DATE '2024-12-04', '18C', 'Economy', 320.00, 'Cancelled'),
    (5, 'B65005', DATE '2024-12-05', '8D', 'Business', 750.00, 'Pending'),
    (6, 'AS6006', DATE '2024-12-06', '14E', 'Economy', 380.00, 'Pending'),
    (7, 'F97007', DATE '2024-12-07', '6F', 'Business', 850.00, 'Confirmed'),
    (8, 'NK8008', DATE '2024-12-08', '22A', 'Economy', 280.00, 'Confirmed'),
    (9, 'G49009', DATE '2024-12-09', '3B', 'First Class', 1450.00, 'Confirmed'),
    (10, 'SY1010', DATE '2024-12-10', '11C', 'Economy', 520.00, 'Confirmed'),
    (11, 'HA1111', DATE '2024-12-11', '7D', 'Business', 680.00, 'Confirmed'),
    (12, 'VX1212', DATE '2024-12-12', '15E', 'Economy', 410.00, 'Confirmed'),
    (13, 'YX1414', DATE '2024-12-13', '4F', 'Business', 720.00, 'Confirmed'),
    (14, 'QX1515', DATE '2024-12-14', '19A', 'Economy', 350.00, 'Confirmed'),
    (15, '9E1313', DATE '2024-12-15', '2B', 'First Class', 1100.00, 'Confirmed');


INSERT INTO Staff (
    Name,
    Role,
    Department_Id,
    Contact,
    Hire_Date,
    Salary
) 
VALUES
    ('Alice Cooper', 'Pilot', 6, 5551111111, DATE '2020-01-15', 85000.00),
    ('Bob Williams', 'Flight Attendnt', 1, 5552222222, DATE '2019-03-20', 45000.00),
    ('Carol Smith', 'Mechanic', 3, 5553333333, DATE '2018-07-10', 65000.00),
    ('David Johnson', 'Security Offcr', 4, 5554444444, DATE '2021-05-12', 42000.00),
    ('Eva Martinez', 'Ground Crew', 5, 5555555555, DATE '2020-09-08', 38000.00),
    ('Frank Davis', 'Cust. Service', 2, 5556666666, DATE '2019-11-25', 35000.00),
    ('Grace Wilson', 'HR Specialist', 7, 5557777777, DATE '2018-04-18', 52000.00),
    ('Henry Brown', 'Accountant', 8, 5558888888, DATE '2020-12-03', 58000.00),
    ('Iris Taylor', 'IT Support', 9, 5559999999, DATE '2019-08-14', 48000.00),
    ('Jack Anderson', 'Marketing', 10, 5550000000, DATE '2021-02-28', 55000.00),
    ('Karen Miller', 'Bag Handler', 11, 5551010101, DATE '2020-06-15', 32000.00),
    ('Leo Garcia', 'Catering Staff', 12, 5552020202, DATE '2019-12-01', 28000.00),
    ('Mia Thompson', 'Reservations', 13, 5553030303, DATE '2021-01-20', 36000.00),
    ('Nick Rodriguez', 'Quality Ctrl', 14, 5554040404, DATE '2018-10-05', 47000.00),
    ('Olivia Lee', 'Trainer', 15, 5555050505, DATE '2020-03-12', 51000.00);


INSERT INTO Payments (
    Booking_ID
    , Amount_Paid
    , Payment_Date
    , Payment_Mode
    , Status
) 
VALUES
    (1, 450.00, DATE '2024-12-01', 'Online', 'Confirmed'),
    (2, 950.00, DATE '2024-12-02', 'Online', 'Pending'),
    (3, 1200.00, DATE '2024-12-03', 'Cash', 'Refunded'),
    (4, 320.00, DATE '2024-12-04', 'Online', 'Failed'),
    (5, 750.00, DATE '2024-12-05', 'Online', 'Failed'),
    (6, 380.00, DATE '2024-12-06', 'Cash', 'Refunded'),
    (7, 850.00, DATE '2024-12-07', 'Online', 'Pending'),
    (8, 280.00, DATE '2024-12-08', 'Online', 'Confirmed'),
    (9, 1450.00, DATE '2024-12-09', 'Cash', 'Confirmed'),
    (10, 520.00, DATE '2024-12-10', 'Online', 'Confirmed'),
    (11, 680.00, DATE '2024-12-11', 'Online', 'Confirmed'),
    (12, 410.00, DATE '2024-12-12', 'Cash', 'Confirmed'),
    (13, 720.00, DATE '2024-12-13', 'Online', 'Confirmed'),
    (14, 350.00, DATE '2024-12-14', 'Online', 'Confirmed'),
    (15, 1100.00, DATE '2024-12-15', 'Cash', 'Confirmed');


INSERT INTO Check_In (
    Passenger_ID
    , Flight_ID
    , CheckIn_Time
    , Baggage_Weight
) 
VALUES
    (1, 'AA1001', TIMESTAMP '2024-12-15 08:00:00', 15.50),
    (2, 'DL2002', TIMESTAMP '2024-12-16 09:30:00', 22.75),
    (3, 'UA3003', TIMESTAMP '2024-12-17 07:45:00', 18.25),
    (4, 'WN4004', TIMESTAMP '2024-12-18 10:15:00', 12.80),
    (5, 'B65005', TIMESTAMP '2024-12-19 11:20:00', 20.45),
    (6, 'AS6006', TIMESTAMP '2024-12-20 06:30:00', 16.90),
    (7, 'F97007', TIMESTAMP '2024-12-21 08:45:00', 25.30),
    (8, 'NK8008', TIMESTAMP '2024-12-22 09:10:00', 14.75),
    (9, 'G49009', TIMESTAMP '2024-12-23 07:20:00', 21.60),
    (10, 'SY1010', TIMESTAMP '2024-12-24 10:00:00', 19.85),
    (11, 'HA1111', TIMESTAMP '2024-12-25 08:30:00', 17.40),
    (12, 'VX1212', TIMESTAMP '2024-12-26 09:45:00', 13.95),
    (13, 'YX1414', TIMESTAMP '2024-12-27 11:00:00', 24.15),
    (14, 'QX1515', TIMESTAMP '2024-12-28 07:15:00', 16.55),
    (15, '9E1313', TIMESTAMP '2024-12-29 08:50:00', 23.70);


-- Main Queries
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


-- Main PL/SQL, functions, Triggers, Exception Handling
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


-- Main Performance Optimization

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


-- Bonus Challenges
-- Create a view that displays detailed booking info 
-- including flight route, airline name, passenger contact, and seat details.

CREATE VIEW Booking_info AS 
SELECT 
    f.arrival_airport,
    f.departure_airport,
    a.airline_name, 
    p.contact as passenger_contact,
    b.seat_no
FROM 
    flights f
JOIN 
    airlines a
ON
    f.airline_id = a.airline_id 
JOIN 
    bookings b
ON 
    b.flight_id = f.flight_id
JOIN 
    passengers p
ON
    p.passenger_id = b.passenger_id
 
SELECT * from Booking_info;


-- Implement a dynamic SQL query to fetch flight details based on 
-- user-defined origin, destination, and date range.

SELECT 
    flight_id,
    departure_airport,
    arrival_airport,
    departure_date,
    arrival_date,
    airline_id,
    flight_status 
FROM flights 
WHERE  
    departure_airport = :departure_airport
    AND arrival_airport = :arrival_airport
    AND departure_date = TO_DATE(:departure_date, 'YYYY-MM-DD')
    AND arrival_date = TO_DATE(:arrival_date, 'YYYY-MM-DD'); 




