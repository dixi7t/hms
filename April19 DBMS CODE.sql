-- Delete and recreate the database
DROP DATABASE IF EXISTS hotel_management;
CREATE DATABASE hotel_management;
USE hotel_management;

-- Addresses Table 
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(45) NOT NULL,
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country VARCHAR(45) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_address_city (city),
    INDEX idx_address_country (country)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Star Ratings Table 
CREATE TABLE star_ratings (
    rating_id INT PRIMARY KEY,
    rating_value INT NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Chains Table 
CREATE TABLE hotel_chains (
    chain_id INT AUTO_INCREMENT PRIMARY KEY,
    chain_name VARCHAR(45) NOT NULL,
    headquarters_address_id INT,
    contact_email VARCHAR(45),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (headquarters_address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_email CHECK (contact_email LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotels Table 
CREATE TABLE hotels (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_name VARCHAR(45) NOT NULL,
    address_id INT,
    rating_id INT,
    contact_email VARCHAR(45),
    contact_phone VARCHAR(20),
    has_pool BOOLEAN DEFAULT FALSE,
    has_gym BOOLEAN DEFAULT FALSE,
    has_spa BOOLEAN DEFAULT FALSE,
    has_restaurant BOOLEAN DEFAULT FALSE,
    chain_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (chain_id) REFERENCES hotel_chains(chain_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (rating_id) REFERENCES star_ratings(rating_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_hotel_name (hotel_name),
    INDEX idx_hotel_chain (chain_id),
    CONSTRAINT chk_hotel_email CHECK (contact_email LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Chain Relationships Table 
CREATE TABLE hotel_chain_hotels (
    chain_id INT,
    hotel_id INT,
    PRIMARY KEY (chain_id, hotel_id),
    FOREIGN KEY (chain_id) REFERENCES hotel_chains(chain_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Types Table 
CREATE TABLE room_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(45),
    description VARCHAR(255),
    standard_capacity INT,
    max_capacity INT,
    base_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Rooms Table 
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT,
    type_id INT,
    room_number VARCHAR(10),
    floor INT,
    availability_status ENUM('available', 'occupied', 'maintenance'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES room_types(type_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_room_hotel (hotel_id),
    UNIQUE INDEX idx_room_unique (hotel_id, room_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Guests Table 
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    date_of_birth DATE,
    email VARCHAR(45),
    phone VARCHAR(20),
    address_id INT,
    nationality VARCHAR(45),
    passport_number VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_guest_name (last_name, first_name),
    CONSTRAINT chk_guest_email CHECK (email LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Discounts Table 
CREATE TABLE discounts (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    discount_name VARCHAR(45),
    discount_type ENUM('Percentage', 'Fixed'),
    discount_value DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    applicable_room_types VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Room Discount Relationships Table 
CREATE TABLE room_rate_discounts (
    discount_id INT,
    room_type_id INT,
    PRIMARY KEY (discount_id, room_type_id),
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_type_id) REFERENCES room_types(type_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reservation Statuses Table 
CREATE TABLE reservation_statuses (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(45),
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bookings Table 
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT,
    status_id INT,
    booking_date DATETIME,
    check_in_date DATE,
    check_out_date DATE,
    total_amount DECIMAL(10,2),
    discount_id INT,
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (status_id) REFERENCES reservation_statuses(status_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_booking_dates (check_in_date, check_out_date),
    INDEX idx_booking_guest (guest_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Booked Rooms Table 
CREATE TABLE booked_rooms (
    booking_id INT,
    room_id INT,
    rate_applied DECIMAL(10,2),
    PRIMARY KEY (booking_id, room_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel Services Table 
CREATE TABLE hotel_services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(45),
    description VARCHAR(255),
    price DECIMAL(10,2),
    availability VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Service Usages Table 
CREATE TABLE hotel_service_usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    service_id INT,
    service_date DATE,
    quantity INT,
    total_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES hotel_services(service_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_service_usage (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Invoices Table 
CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    issue_date DATE,
    due_date DATE,
    amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    payment_method VARCHAR(45),
    payment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_invoice_booking (booking_id),
    INDEX idx_invoice_status (payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Feedbacks Table 
CREATE TABLE feedbacks (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    rating INT,
    comments TEXT,
    feedback_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
    INDEX idx_feedback_booking (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Maintenances Table 
CREATE TABLE maintenances (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    maintenance_type VARCHAR(45),
    description TEXT,
    request_date DATE,
    completion_date DATE,
    status VARCHAR(20),
    cost DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_maintenance_status (status),
    INDEX idx_maintenance_room (room_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
