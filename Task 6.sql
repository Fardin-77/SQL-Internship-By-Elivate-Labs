USE task5_db;

-- Show each customer and their total orders amount using subquery in SELECT
SELECT 
    name,
    (SELECT SUM(amount) 
     FROM orders 
     WHERE orders.customer_id = customers.customer_id) AS total_order_amount
FROM customers;


-- Get customers who have placed orders
SELECT * 
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

-- Get customers who have at least one order
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
);

-- Get customer who spent the highest total amount (1 row only)
SELECT name
FROM customers
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- Get average order amount per customer using subquery as table
SELECT name, avg_amount
FROM (
    SELECT customer_id, AVG(amount) AS avg_amount
    FROM orders
    GROUP BY customer_id
) AS avg_orders
JOIN customers ON customers.customer_id = avg_orders.customer_id;

-- Get all orders greater than average amount of that customer's orders
SELECT *
FROM orders o1
WHERE amount > (
    SELECT AVG(amount)
    FROM orders o2
    WHERE o2.customer_id = o1.customer_id
);

