START TRANSACTION;

-- Step 1: Create a Booking (adjust guest_id, dates, amount as needed)
INSERT INTO bookings (
    guest_id, status_id, booking_date, check_in_date, check_out_date, 
    total_amount, discount_id, special_requests
) VALUES (
    1, 1, NOW(), '2025-04-25', '2025-04-28', 600.00, NULL, 'Requested sea-facing room'
);

-- Get the generated booking_id
SET @booking_id = LAST_INSERT_ID();

-- Step 2: Book a Room (adjust room_id, rate)
INSERT INTO booked_rooms (booking_id, room_id, rate_applied)
VALUES (@booking_id, 5, 200.00);

-- Step 3: Create Invoice for the Booking
INSERT INTO invoices (
    booking_id, issue_date, due_date, amount, tax_amount, total_amount,
    payment_status, payment_method, payment_date
) VALUES (
    @booking_id, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY), 600.00, 50.00, 650.00,
    'pending', 'credit_card', NULL
);

-- Step 4: Update Room Status
UPDATE rooms
SET availability_status = 'occupied'
WHERE room_id = 5;

