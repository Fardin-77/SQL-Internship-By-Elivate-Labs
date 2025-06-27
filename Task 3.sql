USE task2_db;

-- Select all columns from employees
SELECT * FROM employees;

-- Select only name and department
SELECT name, department FROM employees;

-- Select employees from 'HR' department
SELECT * FROM employees
WHERE department = 'HR';

-- Select employees with salary more than 40000
SELECT name, salary FROM employees
WHERE salary > 40000;



-- Employees from IT department with salary > 30000
SELECT * FROM employees
WHERE department = 'IT' AND salary > 30000;

-- Employees in HR or Sales department
SELECT * FROM employees
WHERE department = 'HR' OR department = 'Sales';



-- Names starting with 'P'
SELECT * FROM employees
WHERE name LIKE 'P%';

-- Names ending with 'a'
SELECT * FROM employees
WHERE name LIKE '%a';


-- Employees aged between 25 and 30
SELECT * FROM employees
WHERE age BETWEEN 25 AND 30;

-- Employees with salary between 35000 and 50000
SELECT name, salary FROM employees
WHERE salary BETWEEN 35000 AND 50000;



-- Order employees by salary ascending
SELECT * FROM employees
ORDER BY salary ASC;

-- Order by joining_date descending
SELECT * FROM employees
ORDER BY joining_date DESC;


-- Get only top 3 employees
SELECT * FROM employees
LIMIT 3;

-- Get top 2 highest paid employees
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 2;



