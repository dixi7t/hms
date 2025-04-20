
/*******************************************************
*                                                     *
*               🚨 RUN EACH QUERY ONE BY ONE 🚨         *
*                                                     *
*     This script includes multiple report queries.   *
*     To avoid issues, please run them individually.  *
*                                                     *
*******************************************************/


-- 📈 1. Daily Revenue Report
SELECT DATE(booking_date) AS booking_day,
       SUM(total_amount) AS daily_revenue
FROM bookings
GROUP BY booking_day
ORDER BY booking_day DESC;

-- 📅 2. Monthly Revenue Report
SELECT DATE_FORMAT(booking_date, '%Y-%m') AS month,
       SUM(total_amount) AS monthly_revenue
FROM bookings
GROUP BY month
ORDER BY month DESC;

-- 📊 3. Occupancy Rate for a Specific Date (Replace with any date)
SELECT 
    (SELECT COUNT(*) FROM rooms) AS total_rooms,
    (SELECT COUNT(DISTINCT br.room_id)
     FROM bookings b
     JOIN booked_rooms br ON b.booking_id = br.booking_id
     WHERE '2025-04-25' BETWEEN b.check_in_date AND b.check_out_date) AS occupied_rooms,
    ROUND(
        (SELECT COUNT(DISTINCT br.room_id)
         FROM bookings b
         JOIN booked_rooms br ON b.booking_id = br.booking_id
         WHERE '2025-04-25' BETWEEN b.check_in_date AND b.check_out_date)
        /
        (SELECT COUNT(*) FROM rooms) * 100, 2
    ) AS occupancy_percentage;

-- 💵 4. ADR (Average Daily Rate)
SELECT 
    ROUND(SUM(total_amount) / SUM(DATEDIFF(check_out_date, check_in_date)), 2) AS ADR
FROM bookings;

-- 💰 5. RevPAR (Revenue Per Available Room)
SELECT 
    ROUND(SUM(total_amount) / (SELECT COUNT(*) FROM rooms), 2) AS RevPAR
FROM bookings;

-- 📖 6. Guest Booking History
SELECT g.guest_id, CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
       b.booking_id, b.check_in_date, b.check_out_date, b.total_amount
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
ORDER BY g.guest_id, b.check_in_date DESC;

-- 🛏️ 7. Room Usage Stats
SELECT r.room_id, COUNT(br.booking_id) AS times_booked,
       MAX(b.check_out_date) AS last_checkout
FROM rooms r
LEFT JOIN booked_rooms br ON r.room_id = br.room_id
LEFT JOIN bookings b ON br.booking_id = b.booking_id
GROUP BY r.room_id
ORDER BY times_booked DESC;

-- 🧾 8. Views

-- 📌 View: Monthly Revenue
CREATE OR REPLACE VIEW monthly_revenue_view AS
SELECT DATE_FORMAT(booking_date, '%Y-%m') AS month,
       SUM(total_amount) AS revenue
FROM bookings
GROUP BY month;

-- 📌 View: Guest Booking Summary
CREATE OR REPLACE VIEW guest_booking_summary AS
SELECT g.guest_id, CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
       COUNT(b.booking_id) AS total_bookings,
       SUM(b.total_amount) AS total_spent
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id;
