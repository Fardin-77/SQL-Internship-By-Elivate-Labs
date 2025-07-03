USE task5_db;

-- View to show customers along with their orders
CREATE VIEW view_customer_orders AS
SELECT 
    c.customer_id,
    c.name,
    c.city,
    o.order_id,
    o.order_date,
    o.amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

SELECT * FROM view_customer_orders;

-- View showing total order amount per customer
CREATE VIEW view_total_spent AS
SELECT 
    c.customer_id,
    c.name,
    SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;


SELECT * FROM view_total_spent
ORDER BY total_spent DESC;


-- View to filter high-value orders only
CREATE VIEW view_high_value_orders AS
SELECT 
    o.order_id,
    c.name AS customer_name,
    o.amount,
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.amount > 2500;


SELECT * FROM view_high_value_orders;


-- Replace an existing view definition
CREATE OR REPLACE VIEW view_total_spent AS
SELECT 
    c.customer_id,
    c.name,
    c.city,
    SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city;


DROP VIEW IF EXISTS view_high_value_orders;


