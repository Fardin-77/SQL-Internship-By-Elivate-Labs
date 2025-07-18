CREATE DATABASE IF NOT EXISTS student_result_db;
USE student_result_db;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    enroll_year YEAR
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL
);

CREATE TABLE semesters (
    semester_id INT AUTO_INCREMENT PRIMARY KEY,
    semester_name VARCHAR(50) -- Example: 'Sem 1', 'Sem 2', etc.
);

CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester_id INT,
    marks INT,
    grade CHAR(2),
    gpa DECIMAL(3,2),
    
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
);

CREATE TABLE grade_scale (
    grade CHAR(2) PRIMARY KEY,
    min_marks INT,
    max_marks INT,
    gpa DECIMAL(3,2)
);


-- ✅ Use the correct database
USE student_result_db;

-- 🧑 Insert into students
INSERT INTO students (name, department, enroll_year) VALUES
('Rahul Sharma', 'Computer Science', 2021),
('Anjali Verma', 'Information Technology', 2021),
('Vikas Patel', 'Electronics', 2021),
('Meena Joshi', 'Computer Science', 2022),
('Amit Trivedi', 'Information Technology', 2022);

-- 📚 Insert into courses
INSERT INTO courses (course_name, credits) VALUES
('Data Structures', 4),
('Database Systems', 4),
('Computer Networks', 3),
('Operating Systems', 3),
('Mathematics', 2);

-- 🗓️ Insert into semesters
INSERT INTO semesters (semester_name) VALUES
('Semester 1'),
('Semester 2');

-- 📏 Fix GPA column datatype first (if not already done)
-- If error still exists, run this line before inserting into grade_scale
ALTER TABLE grade_scale MODIFY COLUMN gpa DECIMAL(4,2);

-- 🎓 Insert into grade_scale
INSERT INTO grade_scale (grade, min_marks, max_marks, gpa) VALUES
('A', 90, 100, 10.0),
('B', 80, 89, 9.0),
('C', 70, 79, 8.0),
('D', 60, 69, 7.0),
('E', 50, 59, 6.0),
('F', 0, 49, 0.0);

-- 📝 Insert into grades

-- Rahul Sharma (Student 1)
INSERT INTO grades (student_id, course_id, semester_id, marks, grade, gpa) VALUES
(1, 1, 1, 92, 'A', 10.0),
(1, 2, 1, 85, 'B', 9.0),
(1, 3, 1, 78, 'C', 8.0);

-- Anjali Verma (Student 2)
INSERT INTO grades (student_id, course_id, semester_id, marks, grade, gpa) VALUES
(2, 1, 1, 88, 'B', 9.0),
(2, 2, 1, 81, 'B', 9.0),
(2, 3, 1, 66, 'D', 7.0);

-- Vikas Patel (Student 3)
INSERT INTO grades (student_id, course_id, semester_id, marks, grade, gpa) VALUES
(3, 1, 1, 70, 'C', 8.0),
(3, 2, 1, 59, 'E', 6.0),
(3, 3, 1, 45, 'F', 0.0);

SHOW CREATE TABLE grades;

ALTER TABLE grades MODIFY COLUMN gpa DECIMAL(4,2);

INSERT INTO grades (student_id, course_id, semester_id, marks, grade, gpa) VALUES
(1, 1, 1, 92, 'A', 10.0),
(1, 2, 1, 85, 'B', 9.0),
(1, 3, 1, 78, 'C', 8.0);

DESCRIBE grades;



-- GPA per student per semester (average of GPA in grades table)
SELECT 
    s.student_id,
    s.name,
    sem.semester_name,
    ROUND(AVG(g.gpa), 2) AS semester_gpa
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN semesters sem ON g.semester_id = sem.semester_id
GROUP BY s.student_id, sem.semester_id;

-- Pass/Fail status per student per semester
SELECT 
    s.student_id,
    s.name,
    sem.semester_name,
    CASE 
        WHEN SUM(CASE WHEN g.grade = 'F' THEN 1 ELSE 0 END) > 0 THEN 'FAIL'
        ELSE 'PASS'
    END AS status
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN semesters sem ON g.semester_id = sem.semester_id
GROUP BY s.student_id, sem.semester_id;

-- Rank students based on GPA (higher GPA = better rank)
SELECT 
    student_id,
    name,
    semester_name,
    semester_gpa,
    DENSE_RANK() OVER (PARTITION BY semester_name ORDER BY semester_gpa DESC) AS rank_position
FROM (
    SELECT 
        s.student_id,
        s.name,
        sem.semester_name,
        ROUND(AVG(g.gpa), 2) AS semester_gpa
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    JOIN semesters sem ON g.semester_id = sem.semester_id
    GROUP BY s.student_id, sem.semester_id
) AS ranked;

CREATE OR REPLACE VIEW view_semester_gpa AS
SELECT 
    s.student_id,
    s.name,
    sem.semester_name,
    ROUND(AVG(g.gpa), 2) AS semester_gpa
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN semesters sem ON g.semester_id = sem.semester_id
GROUP BY s.student_id, sem.semester_id;


SELECT * FROM view_semester_gpa;

CREATE OR REPLACE VIEW view_result_summary AS
SELECT 
    s.student_id,
    s.name,
    sem.semester_name,
    ROUND(AVG(g.gpa), 2) AS semester_gpa,
    CASE 
        WHEN SUM(CASE WHEN g.grade = 'F' THEN 1 ELSE 0 END) > 0 THEN 'FAIL'
        ELSE 'PASS'
    END AS result_status
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN semesters sem ON g.semester_id = sem.semester_id
GROUP BY s.student_id, sem.semester_id;

SELECT * FROM view_result_summary;

CREATE OR REPLACE VIEW view_student_rank AS
SELECT 
    student_id,
    name,
    semester_name,
    semester_gpa,
    DENSE_RANK() OVER (PARTITION BY semester_name ORDER BY semester_gpa DESC) AS rank_position
FROM view_semester_gpa;


DELIMITER //

CREATE TRIGGER trg_assign_grade_gpa
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    DECLARE v_grade CHAR(2);
    DECLARE v_gpa DECIMAL(4,2);

    SELECT grade, gpa INTO v_grade, v_gpa
    FROM grade_scale
    WHERE NEW.marks BETWEEN min_marks AND max_marks;

    SET NEW.grade = v_grade;
    SET NEW.gpa = v_gpa;
END //

DELIMITER ;


INSERT INTO grades (student_id, course_id, semester_id, marks)
VALUES (4, 1, 1, 82);  -- For student Meena Joshi

SELECT * FROM grades WHERE student_id = 4;

DELIMITER //

CREATE PROCEDURE insert_grade_entry (
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_semester_id INT,
    IN p_marks INT
)
BEGIN
    INSERT INTO grades (student_id, course_id, semester_id, marks)
    VALUES (p_student_id, p_course_id, p_semester_id, p_marks);
END //

DELIMITER ;

CALL insert_grade_entry(5, 2, 1, 93);  -- Amit Trivedi scored 93 in course_id 2

SELECT * FROM grades WHERE student_id = 5;





