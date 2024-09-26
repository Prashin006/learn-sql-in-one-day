-- Using SELECT to display messages
-- SELECT 'Hello World'; 
-- SELECT 'MySQL is fun!' AS text; 

SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS companyHR;
USE companyHR;
-- DROP DATABASE IF EXISTS companyHR; 

CREATE TABLE IF NOT EXISTS co_employees(
	id INT PRIMARY KEY AUTO_INCREMENT,
    em_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    contact_number VARCHAR(255),
    age INT NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT NOW()
);
DROP TABLE co_employees;
CREATE TABLE mentorship(
	mentor_id INT NOT NULL,
    mentee_id INT NOT NULL,
    status VARCHAR(100) NOT NULL,
    project VARCHAR(255) NOT NULL,
    PRIMARY KEY (mentor_id, mentee_id, project),
    CONSTRAINT fk1 FOREIGN KEY (mentor_id) REFERENCES co_employees (id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk2 FOREIGN KEY (mentee_id) REFERENCES co_employees (id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT mm_constraint UNIQUE(mentor_id, mentee_id)
);
SHOW TABLES;

RENAME TABLE co_employees TO employees;
RENAME TABLE mentorship TO mentorships;
ALTER TABLE employees
	DROP COLUMN age,
    ADD COLUMN salary FLOAT NOT NULL AFTER contact_number,
    ADD COLUMN years_in_company INT NOT NULL AFTER salary;
    
DESCRIBE employees;
-- we are not allowed to drop and add a foreign key with the same name using a single ALTER statement 
ALTER TABLE mentorships
	DROP FOREIGN KEY fk2;
ALTER TABLE mentorships
	ADD CONSTRAINT fk2 FOREIGN KEY (mentee_id) REFERENCES employees (id) ON DELETE CASCADE ON UPDATE CASCADE,
    DROP INDEX mm_constraint;
DROP TABLE IF EXISTS demo;

INSERT INTO employees (em_name, gender, contact_number, salary, years_in_company) VALUES
('James Lee','M','516-514-6568', 3500, 11),
('Peter Pasternak', 'M', '845-644-7919', 6010, 10),
('Clara Couto', 'F', '845-641-5236', 3900, 8),
('Walker Welch', 'M', NULL, 2500, 4),
('Li Xiao Ting', 'F', '646-218-7733', 5600, 4),
('Joyce Jones', 'F', '523-172-2191', 8000, 3),
('Jason Cerrone', 'M', '725-441-7172', 7980, 2),
('Prudence Phelps', 'F', '546-312-5112', 11000, 2),
('Larry Zucker', 'M', '817-267-9799', 3500, 1),
('Serena Parker', 'F', '621-211-7342', 12000, 1);

INSERT INTO mentorships (mentor_id, mentee_id, status, project) VALUES
(1,2,'Ongoing','SQF Limited'),
(1,3,'Past','Wayne Fibre'),
(2,3,'Ongoing','SQF Limited'),
(3,4,'Ongoing','SQF Limited'),
(6,5,'Past','Flynn Tech');

-- page 53 updating data
SELECT * FROM employees;
SELECT * FROM mentorships;
SELECT * FROM employees
WHERE em_name = 'James Lee';

UPDATE employees
SET contact_number = '516-514-1729'
WHERE id = 1;

DELETE FROM employees
WHERE id = 5;

INSERT INTO mentorships VALUES
(4,21,'Ongoing','Flynn Tech');

UPDATE employees
SET id = 11
WHERE id = 4;

SELECT em_name AS 'Employee Name', gender AS Gender FROM employees LIMIT 3;
SELECT DISTINCT gender FROM employees;
SELECT * FROM employees WHERE id != 1 AND id != 2 AND id != 10;
-- Below 2 queries give the same result
SELECT * FROM employees WHERE id BETWEEN 5 AND 11;
SELECT * FROM employees WHERE id >= 5 AND id <=11;
SELECT * FROM employees WHERE em_name LIKE '%er%';

-- select employees that have 'e' as the fifth letter in their name
SELECT * FROM employees WHERE em_name LIKE '____e%';
SELECT * FROM employees WHERE id IN (6,7,9);
SELECT * FROM employees WHERE id NOT IN (7,8);

-- select all female employees who have worked more than 5 years in the company or have salaries above 5000
SELECT * FROM employees
WHERE gender = 'F' AND (years_in_company > 5 OR salary > 5000);

SELECT * FROM employees WHERE id IN 
(SELECT mentor_id FROM mentorships WHERE project = 'SQF Limited');

SELECT employees.* 
FROM employees
INNER JOIN mentorships m
ON employees.id = m.mentor_id
WHERE m.project = 'SQF Limited';

SELECT * FROM employees ORDER BY gender DESC, em_name;
-- Built-in Functions in MySQL
SELECT CONCAT('Hello',' World') AS 'Sentence';
SELECT SUBSTRING('Programming',3,6);
SELECT CURDATE();
SELECT NOW();
SELECT CURTIME();
SELECT COUNT(*) FROM employees;
SELECT COUNT(contact_number) FROM employees;
SELECT COUNT(DISTINCT gender) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT ROUND(AVG(salary),2) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT SUM(salary) FROM employees;

SELECT em_name,salary FROM employees
ORDER BY salary DESC LIMIT 1,1;

-- page 76
SELECT gender, MAX(salary) FROM employees GROUP BY gender;
SELECT gender, MAX(salary) FROM employees GROUP BY gender HAVING MAX(salary) > 10000;

-- JOINS
CREATE TABLE one(
	A INT,
    B INT 
);
CREATE TABLE two(
	C INT,
    B INT,
    D INT
);
ALTER TABLE two
ADD PRIMARY KEY (C);
DELETE FROM two WHERE C IN (2,3,4);
INSERT INTO two VALUES 
(2,218.1,'ABC'),
(3,511.5,'DEF'),
(4,219.9,'GHI');

SELECT * FROM two;
SELECT A,C,one.B AS 'one B',two.B AS 'two B' FROM 
one 
JOIN
two ON
one.A = two.C;

SELECT A,C,one.B AS 'one B',two.B AS 'two B' FROM 
one 
LEFT JOIN
two ON
one.A = two.C;

SELECT A,C,one.B AS 'one B',two.B AS 'two B' FROM 
one 
RIGHT JOIN
two ON
one.A = two.C;

SELECT employees.id, mentorships.mentor_id, employees.em_name AS 'Mentor',mentorships.project AS 'Project Name'
FROM mentorships
JOIN employees
ON 
employees.id = mentorships.mentor_id;

SELECT employees.em_name AS 'Mentor', mentorships.project AS 'Project Name'
FROM mentorships
JOIN employees
ON 
employees.id = mentorships.mentor_id;

-- UNION keyword removes any duplicates from the result. If you do not want that to happen, you can use the UNION ALL keywords.
SELECT em_name, salary FROM employees WHERE gender = 'M' 
UNION
SELECT em_name, salary FROM employees WHERE gender = 'F';
    
SELECT mentor_id FROM mentorships 
UNION ALL
SELECT id FROM employees WHERE gender = 'F';
    

-- Creating views
CREATE VIEW myView AS 
SELECT employees.id, mentorships.mentor_id, employees.em_name as 'Mentor',mentorships.project as 'Project Name'
FROM mentorships
JOIN employees
ON mentorships.mentor_id = employees.id; 

SELECT * FROM myView;
-- NOTE USE `` instead of '' or ""
SELECT mentor_id, `Project Name` FROM myView;

ALTER VIEW myView AS
SELECT employees.id, mentorships.mentor_id, employees.em_name AS 'Mentor', mentorships.project AS 'Project'
FROM employees
JOIN mentorships
ON employees.id = mentorships.mentor_id;

DROP VIEW IF EXISTS myView;

-- Creating and using triggers

CREATE TABLE ex_employees(
	em_id INT PRIMARY KEY,
    em_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    date_left TIMESTAMP DEFAULT NOW()
);

DELIMITER $$
CREATE TRIGGER update_ex_employees 
BEFORE DELETE ON employees FOR EACH ROW
BEGIN
INSERT INTO ex_employees(em_id,em_name,gender) VALUES (OLD.id,OLD.em_name,OLD.gender);
END $$

DELIMITER ;

-- For triggers activated by a DELETE event, we use the OLD keyword to retrieve the deleted values (or values to be deleted).
-- For triggers activated by an INSERT event, we use the NEW keyword to retrieve the inserted data (or data to be inserted).
-- For triggers activated by an UPDATE event, we use the OLD keyword to retrieve the original data, and the NEW keyword to retrieve the updated data.

SELECT * FROM ex_employees;
SELECT * FROM employees;
DESCRIBE employees;
INSERT INTO employees(em_name,gender,salary,years_in_company) VALUES('Prashin Parikh','M',4500,1);
DELETE FROM employees WHERE id = 13;

DROP TRIGGER IF EXISTS update_ex_employees;

-- User defined variables in MySQL have to be prefixed with @ symbol
SET @em_id = 2;

SELECT * FROM mentorships WHERE mentor_id = @em_id;
SELECT * FROM mentorships WHERE mentee_id = @em_id;
SELECT * FROM employees WHERE id = @em_id;

SET @result = SQRT(9);
SELECT @result;

SELECT @result1 := SQRT(99);

-- A stored routine is a set of SQL statements that are grouped, named and stored together in the server.
-- There are two types of stored routines - stored procedures and stored functions.
DELIMITER $$
CREATE PROCEDURE select_info()
BEGIN
	SELECT * FROM employees;
    SELECT * FROM mentorships;
END $$
DELIMITER ;

CALL select_info();

-- Here, we declare a variable called p_em_id. You may notice that we did not prefix this variable with @.
-- This is because the variable here is a special type of variable known as a parameter. Parameters are variables that we use to pass information to, or getinformation from, our stored routines. We do not prefix parameters with @.
-- There are three types of parameters for stored procedures: IN, OUT and INOUT.
-- An IN parameter is used to pass information to the stored procedure.
-- An OUT parameter is used to get information from the stored procedure while
-- An INOUT parameter serves as both an IN and OUT parameter.

DELIMITER $$
CREATE PROCEDURE employee_info(IN p_em_id INT)
BEGIN
	SELECT * FROM mentorships WHERE mentor_id = p_em_id;
	SELECT * FROM mentorships WHERE mentee_id = p_em_id;
	SELECT * FROM employees WHERE id = p_em_id;
END $$
DELIMITER ;

CALL employee_info(1);

-- we use the INTO keyword to store the results returned by the SQL statement into the OUT parameters.
DELIMITER $$
CREATE PROCEDURE employee_name_gender(IN p_em_id INT, OUT p_name VARCHAR(255), OUT p_gender CHAR(1))
BEGIN
	SELECT em_name, gender INTO p_name, p_gender FROM employees WHERE id = p_em_id;
END $$
DELIMITER ;

-- we did not declare @v_name and @v_gender before passing them to our stored procedure. This is allowed in MySQL. When we pass in variables that have not been declared previously, MySQL will declare the variables for us. Hence, there is no need for us to declare @v_name and @v_gender before using them.
CALL employee_name_gender(1,@v_name,@v_gender);
SELECT * FROM employees WHERE gender = @v_gender;

DELIMITER $$
CREATE PROCEDURE get_mentor(INOUT p_em_id INT, IN p_project VARCHAR(255))
BEGIN
	SELECT mentor_id INTO p_em_id FROM mentorships WHERE mentee_id = p_em_id AND project = p_project;
END $$
DELIMITER ;

SET @v_id = 3;
CALL get_mentor(@v_id,'Wayne Fibre');
SELECT @v_id;

-- One of the key differences is that a stored function must return a value using the RETURN keyword. 
-- Stored functions are executed using a SELECT statement while stored procedures are executed using the CALL keyword.
DELIMITER $$
CREATE FUNCTION calculateBonus(p_salary DOUBLE, p_multiple DOUBLE) RETURNS DOUBLE DETERMINISTIC
BEGIN
	-- A local variable is a special type of variable that is declared inside a stored routine and can only be used within the routine.
	-- SYNTAX: DECLARE name_of_variable data_type [DEFAULT default_value];
    DECLARE bonus DOUBLE;
    SET bonus = p_salary * p_multiple;
	RETURN bonus;
END $$
DELIMITER ;

SELECT id, em_name,salary,calculateBonus(salary,0.1) AS Bonus FROM employees;
DROP FUNCTION IF EXISTS calculateBonus;

-- Control Flow Statements
DELIMITER $$
CREATE FUNCTION demo(x INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	IF x > 0 THEN RETURN 'x is positive';
		ELSEIF x < 0 THEN RETURN 'x is negative';
		ELSE RETURN 'x is zero';
	END IF;
END $$
DELIMITER ;

SELECT demo (-89) AS result;

DELIMITER $$
CREATE FUNCTION case_demo(x INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	CASE x
		WHEN 1 THEN RETURN 'x is 1';
        WHEN 2 THEN RETURN 'x is 2';
        ELSE RETURN 'x is None';
	END CASE;
END $$
DELIMITER ;

SELECT case_demo(5);

DELIMITER $$
CREATE FUNCTION demo_another(x INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	CASE
		WHEN x > 0 THEN RETURN 'x is positive';
        WHEN x = 0 THEN RETURN 'x is zero';
        ELSE RETURN 'x is negative';
	END CASE;
END $$
DELIMITER ;

SELECT demo_another(-9);
-- page 115

DELIMITER $$
CREATE FUNCTION while_demo(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE z VARCHAR(255);
    SET z = '';
	while_example: WHILE x < y DO
		SET x = x + 1;
        SET z = CONCAT(z,x);
	END WHILE;
    RETURN z;
END $$
DELIMITER ;

SELECT while_demo(0,5);

DELIMITER $$
CREATE FUNCTION repeat_demo(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN 
	DECLARE z VARCHAR(255);
    SET z = '';
	REPEAT
		SET x = x + 1;
		SET z = CONCAT(z,x);
        UNTIL x >= y
	END REPEAT;
    RETURN z;
END $$
DELIMITER ;

SELECT repeat_demo(1,5);

DELIMITER $$
CREATE FUNCTION loop_demo(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE z VARCHAR(255);
    SET z = '';
    simple_loop: LOOP
		SET x = x + 1;
        IF x > y THEN
			LEAVE simple_loop;
		END IF;
        SET z = CONCAT(z,x);
	END LOOP;
    RETURN z;
END $$
DELIMITER ;

SELECT loop_demo(1,5);

DELIMITER $$
CREATE FUNCTION another_loop(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE z VARCHAR(255);
    SET z = '';
    simple_loop: LOOP
		SET x = x + 1;
        IF x = 3 THEN ITERATE simple_loop;
        ELSEIF x > y THEN LEAVE simple_loop;
        END IF;
        SET z = CONCAT(z,x);
    END LOOP;
    RETURN z;
END $$
DELIMITER ;

SELECT another_loop(1,5);

-- A cursor is a mechanism that allows us to step through the rows returned by a SQL statement
-- Cursor declaration must be done after all the variables are declared

DELIMITER $$
CREATE FUNCTION get_employees() RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE v_employees VARCHAR(255) DEFAULT '';
    DECLARE v_name VARCHAR(255);
    DECLARE v_gender CHAR(1);
    DECLARE v_done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
		SELECT em_name, gender FROM employees;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
    OPEN cur;
    employees_loop: LOOP
    FETCH cur INTO v_name, v_gender;
    IF v_done = 1 THEN LEAVE employees_loop;
    ELSE SET v_employees = CONCAT(v_employees,', ',v_name,': ',v_gender);
    END IF;
    END LOOP;
	CLOSE cur;
    RETURN SUBSTRING(v_employees,3);
END $$
DELIMITER ;

SELECT SUBSTRING('Prashin',3);
SELECT get_employees();

SELECT * FROM employees ORDER BY salary DESC LIMIT 2,1;
SELECT * FROM employees;


SELECT INSTR('Prashin','A');