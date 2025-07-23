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
