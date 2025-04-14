-- Delete and recreate the database
DROP DATABASE IF EXISTS hotel_management;
CREATE DATABASE hotel_management;
USE hotel_management;

-- Addresses Table
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    city VARCHAR(45) NOT NULL,
    state VARCHAR(45),
    country VARCHAR(45) NOT NULL,
    zipcode VARCHAR(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Chain
CREATE TABLE hotel_chain (
    hotel_chain_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_chain_name VARCHAR(45) NOT NULL,
    hotel_chain_contact_number VARCHAR(12),
    hotel_chain_email_address VARCHAR(45) UNIQUE,
    hotel_chain_website VARCHAR(45),
    hotel_chain_head_office_address_id INT,
    FOREIGN KEY (hotel_chain_head_office_address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Star Ratings
CREATE TABLE star_ratings (
    star_rating INT PRIMARY KEY,
    star_rating_image VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel
CREATE TABLE hotel (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_name VARCHAR(45) NOT NULL,
    hotel_contact_number VARCHAR(12),
    hotel_email_address VARCHAR(45) UNIQUE,
    hotel_website VARCHAR(45),
    hotel_description VARCHAR(100),
    hotel_floor_count INT,
    room_capacity INT,
    hotel_chain_id INT,
    addresses_address_id INT,
    star_ratings_star_rating INT,
    check_in_time TIME,
    check_out_time TIME,
    FOREIGN KEY (hotel_chain_id) REFERENCES hotel_chain(hotel_chain_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (addresses_address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (star_ratings_star_rating) REFERENCES star_ratings(star_rating)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel-Chain Relationship
CREATE TABLE hotel_chain_has_hotel (
    hotel_chains_hotel_chain_id INT,
    hotels_hotel_id INT,
    PRIMARY KEY (hotel_chains_hotel_chain_id, hotels_hotel_id),
    FOREIGN KEY (hotel_chains_hotel_chain_id) REFERENCES hotel_chain(hotel_chain_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hotels_hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Type
CREATE TABLE room_type (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type_name VARCHAR(45),
    room_cost DECIMAL(10,2),
    room_type_description VARCHAR(100),
    smoke_friendly TINYINT,
    pet_friendly TINYINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Rooms
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number INT,
    rooms_type_room_type_id INT,
    hotel_hotel_id INT,
    FOREIGN KEY (rooms_type_room_type_id) REFERENCES room_type(room_type_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (hotel_hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Guests
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_first_name VARCHAR(45),
    guest_last_name VARCHAR(45),
    guest_contact_number VARCHAR(12),
    guest_email_address VARCHAR(45) UNIQUE,
    guest_credit_card VARCHAR(45),
    guest_id_proof VARCHAR(45),
    addresses_address_id INT,
    FOREIGN KEY (addresses_address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Department
CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(45),
    department_description VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Employees
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_first_name VARCHAR(45),
    emp_last_name VARCHAR(45),
    emp_designation VARCHAR(45),
    emp_address_id INT,
    emp_contact_number VARCHAR(12),
    emp_email_address VARCHAR(45) UNIQUE,
    department_department_id INT,
    addresses_address_id INT,
    hotel_hotel_id INT,
    FOREIGN KEY (addresses_address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (department_department_id) REFERENCES department(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (hotel_hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bookings
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_date DATETIME,
    duration_of_stay VARCHAR(10),
    check_in_date DATETIME,
    check_out_date DATETIME,
    booking_payment_type VARCHAR(45),
    total_rooms_booked INT,
    hotel_hotel_id INT,
    guests_guest_id INT,
    employees_emp_id INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (hotel_hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (guests_guest_id) REFERENCES guests(guest_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (employees_emp_id) REFERENCES employees(emp_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Rooms Booked
CREATE TABLE rooms_booked (
    rooms_booked_id INT AUTO_INCREMENT PRIMARY KEY,
    bookings_booking_id INT,
    rooms_room_id INT,
    FOREIGN KEY (bookings_booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (rooms_room_id) REFERENCES rooms(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Rate Discount
CREATE TABLE room_rate_discount (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    discount_rate DECIMAL(10,2),
    start_month TINYINT,
    end_month TINYINT,
    room_type_room_type_id INT,
    FOREIGN KEY (room_type_room_type_id) REFERENCES room_type(room_type_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Services
CREATE TABLE hotel_services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(45),
    service_description VARCHAR(100),
    service_cost DECIMAL(10,2),
    hotel_hotel_id INT,
    FOREIGN KEY (hotel_hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Services Used
CREATE TABLE hotel_services_used_by_guests (
    service_used_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_services_service_id INT,
    bookings_booking_id INT,
    FOREIGN KEY (hotel_services_service_id) REFERENCES hotel_services(service_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (bookings_booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Invoice
CREATE TABLE invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    payment_date DATETIME,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Feedback
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT,
    booking_id INT,
    feedback_text VARCHAR(255),
    rating INT,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Discounts
CREATE TABLE discounts (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    discount_percent DECIMAL(5,2),
    description VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Maintenance
CREATE TABLE maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    staff_id INT,
    issue_description VARCHAR(255),
    status VARCHAR(45),
    request_date DATETIME,
    resolved_date DATETIME,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES employees(emp_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Employee Salary
CREATE TABLE employee_salary (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    month TINYINT,
    year YEAR,
    base_salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    deductions DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reservation Status
CREATE TABLE reservation_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    status VARCHAR(45),
    updated_at DATETIME,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
