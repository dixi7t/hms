--  1. Track Payments and Balances (Per Booking)
SELECT 
    i.invoice_id,
    b.booking_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    i.total_amount,
    i.payment_status,
    i.payment_method,
    i.payment_date
FROM invoices i
JOIN bookings b ON i.booking_id = b.booking_id
JOIN guests g ON b.guest_id = g.guest_id
ORDER BY i.invoice_id DESC;

-- 2. Outstanding Payments (Unpaid Invoices)
SELECT 
    i.invoice_id,
    b.booking_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    i.total_amount,
    i.payment_status
FROM invoices i
JOIN bookings b ON i.booking_id = b.booking_id
JOIN guests g ON b.guest_id = g.guest_id
WHERE i.payment_status = 'pending';

--  3. Revenue by Room Type
SELECT rt.type_name,
       COUNT(DISTINCT br.booking_id) AS total_bookings,
       SUM(br.rate_applied) AS total_revenue
FROM booked_rooms br
JOIN rooms r ON br.room_id = r.room_id
JOIN room_types rt ON r.type_id = rt.type_id
GROUP BY rt.type_name;

--  4. Revenue by Hotel
SELECT h.hotel_name,
       SUM(br.rate_applied) AS hotel_revenue
FROM booked_rooms br
JOIN rooms r ON br.room_id = r.room_id
JOIN hotels h ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_name
ORDER BY hotel_revenue DESC;

--  5. Revenue Breakdown with Discount Info
SELECT 
    b.booking_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    b.total_amount,
    d.discount_name,
    d.discount_type,
    d.discount_value
FROM bookings b
LEFT JOIN discounts d ON b.discount_id = d.discount_id
JOIN guests g ON b.guest_id = g.guest_id
ORDER BY b.booking_id DESC;

--  6. MIS Financial Report View
CREATE OR REPLACE VIEW full_financial_summary AS
SELECT 
    i.invoice_id,
    b.booking_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    b.check_in_date,
    b.check_out_date,
    i.issue_date,
    i.due_date,
    i.amount,
    i.tax_amount,
    i.total_amount,
    i.payment_status,
    i.payment_method,
    i.payment_date
FROM invoices i
JOIN bookings b ON i.booking_id = b.booking_id
JOIN guests g ON b.guest_id = g.guest_id;
SELECT * FROM full_financial_summary;
