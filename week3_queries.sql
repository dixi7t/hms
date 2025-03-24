-- Insert a new guest
INSERT INTO guests (full_name, phone, email, id_proof, nationality)
VALUES ('Emily Brown', '9876543211', 'emily@example.com', 'EM123456', 'Canada');

-- Insert booking using guest_id from Emily Brown
INSERT INTO bookings (guest_id, room_id, check_in, check_out)
VALUES (
    (SELECT guest_id FROM guests WHERE full_name = 'Emily Brown' ORDER BY guest_id DESC LIMIT 1),
    1,
    '2025-04-10',
    '2025-04-15'
);

-- Insert payment for Emily's booking using PRIMARY KEY in subquery
INSERT INTO payments (booking_id, amount, payment_method, payment_status, payment_date)
VALUES (
    (SELECT booking_id FROM bookings WHERE guest_id = (
        SELECT guest_id FROM guests WHERE full_name = 'Emily Brown' ORDER BY guest_id DESC LIMIT 1
    ) ORDER BY booking_id DESC LIMIT 1),
    300.00,
    'Cash',
    'paid',
    '2025-04-10'
);

-- ✅ UPDATE using PRIMARY KEY (guest_id)
UPDATE guests
SET phone = '8888888888'
WHERE guest_id = (
    SELECT guest_id FROM (
        SELECT guest_id FROM guests WHERE full_name = 'Emily Brown' ORDER BY guest_id DESC LIMIT 1
    ) AS temp
);

-- ✅ UPDATE using PRIMARY KEY (room_id)
UPDATE rooms
SET status = 'booked'
WHERE room_id = 1;

-- ✅ DELETE payment using PRIMARY KEY (booking_id)
DELETE FROM payments
WHERE booking_id = (
    SELECT booking_id FROM (
        SELECT booking_id FROM bookings WHERE guest_id = (
            SELECT guest_id FROM guests WHERE full_name = 'Emily Brown' ORDER BY guest_id DESC LIMIT 1
        ) ORDER BY booking_id DESC LIMIT 1
    ) AS temp
);

-- ✅ DELETE booking using PRIMARY KEY (booking_id)
DELETE FROM bookings
WHERE booking_id = (
    SELECT booking_id FROM (
        SELECT booking_id FROM bookings WHERE guest_id = (
            SELECT guest_id FROM guests WHERE full_name = 'Emily Brown' ORDER BY guest_id DESC LIMIT 1
        ) ORDER BY booking_id DESC LIMIT 1
    ) AS temp
);

-- ✅ SELECT: Total revenue from paid payments
SELECT SUM(amount) AS total_revenue 
FROM payments 
WHERE payment_status = 'paid';

-- ✅ SELECT: Count of rooms currently booked
SELECT COUNT(*) AS occupied_rooms 
FROM rooms 
WHERE status = 'booked';
