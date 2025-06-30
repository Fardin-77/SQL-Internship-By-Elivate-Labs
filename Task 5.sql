-- Create database and use it
CREATE DATABASE IF NOT EXISTS task5_db;
USE task5_db;

-- Table 1: Customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

-- Table 2: Orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert into customers
INSERT INTO customers (name, city) VALUES
('Rahul Sharma', 'Delhi'),
('Anjali Verma', 'Mumbai'),
('Meena Patel', 'Bangalore'),
('Vikas Singh', 'Kolkata');

-- Insert into orders
INSERT INTO orders (customer_id, order_date, amount) VALUES
(1, '2024-01-15', 2500.00),
(1, '2024-03-10', 1800.00),
(2, '2024-02-20', 3000.00),
(4, '2024-04-05', 2200.00);

-- Customers who placed orders
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- All customers and their orders (null where no orders)
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- All orders and their customer info (null where no customer)
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- Simulate FULL JOIN using LEFT + RIGHT + UNION
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id

UNION

SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

