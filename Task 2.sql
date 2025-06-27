CREATE DATABASE IF NOT EXISTS task2_db;
USE task2_db;

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    department VARCHAR(100),
    salary DECIMAL(10,2),
    joining_date DATE
);


-- Insert complete data
INSERT INTO employees (name, age, department, salary, joining_date)
VALUES ('Rahul Sharma', 28, 'Finance', 45000.00, '2021-06-15');

-- Insert with NULL values
INSERT INTO employees (name, age, department, salary, joining_date)
VALUES ('Anjali Verma', NULL, 'Marketing', NULL, NULL);

-- Insert with missing department
INSERT INTO employees (name, age, department, salary, joining_date)
VALUES ('Vikas Singh', 32, NULL, 50000.00, '2022-01-10');

-- Insert more records
INSERT INTO employees (name, age, department, salary, joining_date)
VALUES 
('Meena Patel', 26, 'HR', 40000.00, '2023-02-01'),
('Amit Joshi', NULL, 'IT', NULL, '2022-05-21'),
('Priya Nair', 30, 'Sales', 48000.00, NULL);


-- Update NULL age for Anjali Verma
UPDATE employees
SET age = 27
WHERE name = 'Anjali Verma';

-- Update department for Vikas Singh
UPDATE employees
SET department = 'Operations'
WHERE name = 'Vikas Singh';

-- Set default salary if NULL (say default = 35000)
UPDATE employees
SET salary = 35000.00
WHERE salary IS NULL;

-- Set current date for NULL joining_date
UPDATE employees
SET joining_date = CURDATE()
WHERE joining_date IS NULL;


-- Delete employee with name 'Amit Joshi' (sample delete)
DELETE FROM employees
WHERE name = 'Amit Joshi';

-- Delete any rows where department is still NULL
DELETE FROM employees
WHERE department IS NULL;


SELECT * FROM employees;
