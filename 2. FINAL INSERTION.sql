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


-- Inesertion for queries
