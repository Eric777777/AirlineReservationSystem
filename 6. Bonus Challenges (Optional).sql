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



