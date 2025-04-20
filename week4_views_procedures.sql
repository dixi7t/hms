-- =============================================
-- Week 4: Views, Stored Procedures, and Reports
-- =============================================
USE hotel_management;
-- ==========================
-- ✅ VIEWS
-- ==========================

-- View: Active bookings (not yet checked out)
CREATE OR REPLACE VIEW view_active_bookings AS
SELECT 
    b.booking_id,
    g.full_name AS guest_name,
    r.room_number,
    b.check_in,
    b.check_out,
    r.status AS room_status
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
JOIN rooms r ON b.room_id = r.room_id
WHERE r.status IN ('booked');

-- View: Revenue per room
CREATE OR REPLACE VIEW view_revenue_per_room AS
SELECT 
    r.room_number,
    SUM(p.amount) AS total_revenue
FROM rooms r
JOIN bookings b ON r.room_id = b.room_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE p.payment_status = 'paid'
GROUP BY r.room_number;

-- View: Room availability
CREATE OR REPLACE VIEW view_room_availability AS
SELECT 
    room_id,
    room_number,
    room_type,
    status AS availability
FROM rooms;

-- ==========================
-- ✅ STORED PROCEDURES
-- ==========================

-- Procedure: Check room availability for given dates
DELIMITER $$

CREATE PROCEDURE check_room_availability(
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE
)
BEGIN
    SELECT 
        b.booking_id,
        b.check_in,
        b.check_out
    FROM bookings b
    WHERE b.room_id = p_room_id
      AND (
          (p_check_in BETWEEN b.check_in AND b.check_out)
          OR (p_check_out BETWEEN b.check_in AND b.check_out)
          OR (p_check_in <= b.check_in AND p_check_out >= b.check_out)
      );
END$$

DELIMITER ;

-- Procedure: Book room if available
DELIMITER $$

CREATE PROCEDURE book_room_if_available(
    IN p_guest_id INT,
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE
)
BEGIN
    DECLARE conflict_count INT;

    -- Check for conflicts
    SELECT COUNT(*) INTO conflict_count
    FROM bookings
    WHERE room_id = p_room_id
      AND (
          (p_check_in BETWEEN check_in AND check_out)
          OR (p_check_out BETWEEN check_in AND check_out)
          OR (p_check_in <= check_in AND p_check_out >= check_out)
      );

    -- If no conflict, proceed with booking
    IF conflict_count = 0 THEN
        INSERT INTO bookings (guest_id, room_id, check_in, check_out)
        VALUES (p_guest_id, p_room_id, p_check_in, p_check_out);

        UPDATE rooms
        SET status = 'booked'
        WHERE room_id = p_room_id;

        SELECT 'Booking successful' AS message;
    ELSE
        SELECT 'Room is not available for the selected dates' AS message;
    END IF;
END$$

DELIMITER ;

-- ==========================
-- ✅ REPORTING QUERIES
-- ==========================

-- Report: Total revenue from all paid bookings
SELECT SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'paid';

-- Report: Room occupancy rate
SELECT 
    (SELECT COUNT(*) FROM rooms WHERE status = 'booked') * 100 /
    (SELECT COUNT(*) FROM rooms) AS occupancy_percentage;

-- Report: Booking summary by date
SELECT 
    check_in AS booking_date,
    COUNT(*) AS total_bookings
FROM bookings
GROUP BY check_in
ORDER BY booking_date DESC;

-- Report: Average stay duration (in days)
SELECT 
    AVG(DATEDIFF(check_out, check_in)) AS average_stay_duration
FROM bookings;
