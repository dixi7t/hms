-- Delete and recreate the database
DROP DATABASE IF EXISTS hotel_management;
CREATE DATABASE hotel_management;
USE hotel_management;

-- Address Table (changed from addresses)
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    city VARCHAR(45) NOT NULL,
    state VARCHAR(45),
    country VARCHAR(45) NOT NULL,
    zipcode VARCHAR(6),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_address_city (city),
    INDEX idx_address_country (country)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Chain Table
CREATE TABLE hotel_chain (
    chain_id INT AUTO_INCREMENT PRIMARY KEY,
    chain_name VARCHAR(45) NOT NULL,
    contact_number VARCHAR(12),
    email_address VARCHAR(45) UNIQUE,
    website VARCHAR(45),
    head_office_address_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (head_office_address_id) REFERENCES address(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_email CHECK (email_address LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Star Ratings Table
CREATE TABLE star_rating (
    rating_id INT PRIMARY KEY,
    rating_image VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Table
CREATE TABLE hotel (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_name VARCHAR(45) NOT NULL,
    contact_number VARCHAR(12),
    email_address VARCHAR(45) UNIQUE,
    website VARCHAR(45),
    description VARCHAR(100),
    floor_count INT,
    room_capacity INT,
    chain_id INT,
    address_id INT,
    rating_id INT,
    check_in_time TIME,
    check_out_time TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (chain_id) REFERENCES hotel_chain(chain_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (rating_id) REFERENCES star_rating(rating_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_hotel_name (hotel_name),
    INDEX idx_hotel_chain (chain_id),
    CONSTRAINT chk_hotel_email CHECK (email_address LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Type Table
CREATE TABLE room_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(45),
    base_cost DECIMAL(10,2),
    description VARCHAR(100),
    smoke_friendly TINYINT,
    pet_friendly TINYINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Table (changed from rooms)
CREATE TABLE room (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number INT,
    type_id INT,
    hotel_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES room_type(type_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_room_hotel (hotel_id),
    UNIQUE INDEX idx_room_unique (hotel_id, room_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Amenity Table (new table)
CREATE TABLE amenity (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,
    amenity_name VARCHAR(45) NOT NULL,
    description VARCHAR(100),
    standard_charge DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Amenity Table (new table)
CREATE TABLE room_amenity (
    room_id INT,
    amenity_id INT,
    additional_charge DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY (room_id, amenity_id),
    FOREIGN KEY (room_id) REFERENCES room(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenity(amenity_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Guest Table (changed from guests)
CREATE TABLE guest (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    contact_number VARCHAR(12),
    email_address VARCHAR(45) UNIQUE,
    credit_card VARCHAR(45),
    id_proof VARCHAR(45),
    address_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_guest_name (last_name, first_name),
    CONSTRAINT chk_guest_email CHECK (email_address LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Department Table
CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(45),
    description VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Employee Table (changed from employees)
CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    designation VARCHAR(45),
    contact_number VARCHAR(12),
    email_address VARCHAR(45) UNIQUE,
    department_id INT,
    address_id INT,
    hotel_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_employee_name (last_name, first_name),
    CONSTRAINT chk_employee_email CHECK (email_address LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Booking Table (changed from bookings)
CREATE TABLE booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_date DATETIME,
    duration_of_stay VARCHAR(10),
    check_in_date DATETIME,
    check_out_date DATETIME,
    payment_type VARCHAR(45),
    total_rooms_booked INT,
    hotel_id INT,
    guest_id INT,
    employee_id INT,
    total_amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_booking_dates (check_in_date, check_out_date),
    INDEX idx_booking_guest (guest_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Booked Table (changed from rooms_booked)
CREATE TABLE booked_room (
    booked_room_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    room_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES room(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_booked_room (room_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seasonal Pricing Table (new table)
CREATE TABLE seasonal_pricing (
    seasonal_pricing_id INT AUTO_INCREMENT PRIMARY KEY,
    type_id INT,
    start_date DATE,
    end_date DATE,
    multiplier DECIMAL(3,2) DEFAULT 1.00,
    description VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES room_type(type_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_seasonal_dates (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Rate Discount Table (changed from room_rate_discount)
CREATE TABLE room_discount (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    discount_rate DECIMAL(10,2),
    start_month TINYINT,
    end_month TINYINT,
    type_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES room_type(type_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_months CHECK (start_month BETWEEN 1 AND 12 AND end_month BETWEEN 1 AND 12)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Service Table (changed from hotel_services)
CREATE TABLE hotel_service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(45),
    description VARCHAR(100),
    cost DECIMAL(10,2),
    hotel_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_service_hotel (hotel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Service Used Table (changed from hotel_services_used_by_guests)
CREATE TABLE service_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    service_id INT,
    booking_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES hotel_service(service_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_service_usage (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Invoice Table
CREATE TABLE invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    payment_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_invoice_booking (booking_id),
    INDEX idx_invoice_status (payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Feedback Table
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT,
    booking_id INT,
    feedback_text VARCHAR(255),
    rating INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
    INDEX idx_feedback_guest (guest_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Discount Table (changed from discounts)
CREATE TABLE booking_discount (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    discount_percent DECIMAL(5,2),
    description VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_discount CHECK (discount_percent BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Maintenance Table
CREATE TABLE maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    staff_id INT,
    issue_description VARCHAR(255),
    status VARCHAR(45),
    request_date DATETIME,
    resolved_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES room(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES employee(employee_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_maintenance_status (status),
    INDEX idx_maintenance_room (room_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Employee Salary Table (changed from employee_salary)
CREATE TABLE salary (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    month TINYINT,
    year YEAR,
    base_salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    deductions DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_month CHECK (month BETWEEN 1 AND 12),
    INDEX idx_salary_employee (employee_id),
    INDEX idx_salary_period (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reservation Status Table (changed from reservation_status)
CREATE TABLE booking_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    status VARCHAR(45),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_booking_status (booking_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;