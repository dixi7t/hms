-- Delete existing database if it exists
DROP DATABASE IF EXISTS hotel_management;

-- Create new database
CREATE DATABASE hotel_management;
USE hotel_management;

-- Create guests table to store guest info
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    id_proof VARCHAR(50),
    nationality VARCHAR(50)
);

-- Create rooms table to store room details
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10),
    room_type VARCHAR(50),
    price_per_night DECIMAL(10,2),
    status ENUM('available', 'booked', 'maintenance') DEFAULT 'available'
);

-- Create bookings table to store guest reservations
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Create payments table to store payment info
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status ENUM('paid', 'pending') DEFAULT 'pending',
    payment_date DATE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Create a procedure to insert 100 sample guest records
DELIMITER $$

CREATE PROCEDURE generate_sample_guests()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO guests (full_name, phone, email, id_proof, nationality)
        VALUES (
            CONCAT('Guest_', i),
            CONCAT('9', FLOOR(100000000 + RAND() * 900000000)),
            CONCAT('guest', i, '@example.com'),
            UUID(),
            CONCAT('Country_', FLOOR(1 + RAND() * 50))
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Run the procedure to insert sample guest data
CALL generate_sample_guests();

-- Drop the procedure after running (cleanup)
DROP PROCEDURE IF EXISTS generate_sample_guests;

-- Insert sample room records
INSERT INTO rooms (room_number, room_type, price_per_night, status) VALUES
('101', 'Single', 60.00, 'available'),
('102', 'Double', 85.00, 'available'),
('103', 'Suite', 150.00, 'booked'),
('104', 'Deluxe', 120.00, 'maintenance');

-- Insert one booking to test relationships
INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 3, '2025-04-01', '2025-04-05');

-- Insert a payment record linked to the booking
INSERT INTO payments (booking_id, amount, payment_method, payment_status, payment_date) VALUES
(1, 600.00, 'Credit Card', 'paid', '2025-03-28');
