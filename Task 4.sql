USE task2_db;

-- Total number of employees
SELECT COUNT(*) AS total_employees FROM employees;


-- Total salary paid to all employees
SELECT SUM(salary) AS total_salary FROM employees;


-- Average salary of employees
SELECT AVG(salary) AS average_salary FROM employees;


-- Minimum and maximum salary
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees;


-- Total employees in each department
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department;


-- Average salary in each department
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;


-- Total salary paid to each department
SELECT department, SUM(salary) AS total_salary
FROM employees
GROUP BY department;


-- Departments with more than 1 employee
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

-- Departments with average salary > 40000
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 40000;


