-- Question 1: How many orders were placed in total?
SELECT COUNT(*) AS total_orders
FROM orders;
-- 99,441 orders were placed in total.

-- Question 2: How many orders were delivered successfully?
SELECT COUNT(*) AS successful_delivery
FROM orders
WHERE order_status = 'delivered';
-- 96,478 of 99,441 orders where successful. Over 97%

-- Question 3: Which month had the most orders?
SELECT order_status, COUNT(order_purchase_timestamp) AS no_of_orders,
CASE strftime('%m', order_purchase_timestamp)
WHEN '01' THEN 'January'
WHEN '02' THEN 'February'
WHEN '03' THEN 'March'
WHEN '04' THEN 'April'
WHEN '05' THEN 'May'
WHEN '06' THEN 'June'
WHEN '07' THEN 'July'
WHEN '08' THEN 'August'
WHEN '09' THEN 'September'
WHEN '10' THEN 'October'
WHEN '11' THEN 'November'
WHEN '12' THEN 'December'
END AS order_month
FROM orders
GROUP BY order_month
ORDER BY no_of_orders DESC;
-- August received the most orders. A little over 10k orders where placed.

-- Question 4: What is the total revenue generated?
SELECT '$' || printf('%,.2f',SUM(payment_value)) AS total_revenue
FROM payments;
-- Total revenue was $16,008,872.12

-- Question 5: What are the top 5 product categories by revenue?
SELECT c.product_category_name, c.product_category_name_english,
'$' || printf('%,.2f', SUM(p.payment_value)) AS revenue
FROM payments p JOIN orders o ON p.order_id = o.order_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products pr ON pr.product_id = oi.product_id
JOIN categories c ON c.product_category_name = pr.product_category_name
GROUP BY c.product_category_name
ORDER BY SUM(p.payment_value) DESC
LIMIT 5;
-- Top product categories based on revenue

-- Question 6: What is the average payment value per order?
SELECT '$' || printf('%,.2f',avg(payment_value)) AS average_payment_value
FROM payments;
-- Average Payment Value is $154.10

-- Question 7: How many orders had bad reviews (score 1 or 2)?
SELECT COUNT(order_id) AS count_bad_reviews
FROM order_reviews
WHERE review_score <=2;
-- 14,575 orders had low review tags, accounting for less than 19% of overall orders reviewed.

-- Question 8: Which sellers have the most orders?
SELECT seller_id, COUNT(order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 5;
-- The top five sellers each received at least 1,500 orders.