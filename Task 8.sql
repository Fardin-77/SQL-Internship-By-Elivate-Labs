USE task5_db;

-- Drop if already exists
DROP PROCEDURE IF EXISTS get_orders_by_customer;

DELIMITER //

CREATE PROCEDURE get_orders_by_customer(IN cust_id INT)
BEGIN
    SELECT o.order_id, o.order_date, o.amount
    FROM orders o
    WHERE o.customer_id = cust_id;
END //

DELIMITER ;

CALL get_orders_by_customer(1);

-- Drop if already exists
DROP PROCEDURE IF EXISTS insert_new_customer;

DELIMITER //

CREATE PROCEDURE insert_new_customer(
    IN cname VARCHAR(100),
    IN ccity VARCHAR(50)
)
BEGIN
    INSERT INTO customers (name, city)
    VALUES (cname, ccity);
END //

DELIMITER ;


CALL insert_new_customer('Amit Trivedi', 'Pune');


-- Drop if already exists
DROP FUNCTION IF EXISTS get_total_spent;

DELIMITER //

CREATE FUNCTION get_total_spent(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(amount) INTO total
    FROM orders
    WHERE customer_id = cust_id;

    RETURN IFNULL(total, 0.00);
END //

DELIMITER ;


SELECT name, get_total_spent(customer_id) AS total_spent
FROM customers;

