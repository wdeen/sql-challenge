-- EmployeeSQL
-----------------------------------------------------

-- Drop table(s) if exists
DROP TABLE IF EXISTS Dept_Employees;
DROP TABLE IF EXISTS Dept_Managers;
DROP TABLE IF EXISTS Salaries;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Titles;
DROP TABLE IF EXISTS Departments;

-----------------------------------------------------
-- My Table Schemata (Data Engineering)

-- Sequence of SQL Table created = Sequence of importing CSV data into corresponding SQL Table
-- Refer to ERD image for visualisation of database design (sql-challenge\EmployeeSQL\data\EmployeeSQL_ERD.png)


-- SQL Table #1 = Departments (departments.csv)
-- Single Primary Key
-- One-to-Many Relationship w/ 'Dept_Employees' Table (Common Link = dept_id)
-- One-to-Many Relationship w/ 'Dept_Managers' Table (Common Link = dept_id)
CREATE TABLE Departments (
	dept_id VARCHAR(4) NOT NULL PRIMARY KEY,
	dept_name VARCHAR NOT NULL
);


-- SQL Table #2 = Titles (titles.csv)
-- Single Primary Key
-- One-to-Many Relationship w/ 'Employees' Table (Common Link = title_id)
CREATE TABLE Titles (
	title_id VARCHAR(5) NOT NULL PRIMARY KEY,
	title_name VARCHAR NOT NULL
);


-- SQL Table #3 = Employees (employees.csv)
-- Single Primary Key
-- One-to-One Relationship w/ 'Salaries' Table (Common Link = emp_id)
-- One-to-Many Relationship w/ 'Dept_Employees' Table (Common Link = emp_id)
-- One-to-Many Relationship w/ 'Dept_Managers' Table (Common Link = emp_id)
-- NOTE: birth_date & hire_date stored as VARCHAR; to be converted into DATE...
CREATE TABLE Employees (
	emp_id INT NOT NULL PRIMARY KEY,
	title_id VARCHAR(5) NOT NULL,
	birth_date VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex CHAR(1) NOT NULL,
	hire_date VARCHAR NOT NULL,
	FOREIGN KEY(title_id) REFERENCES Titles(title_id)
);


-- SQL Table #4 = Salaries (salaries.csv)
-- Single Primary Key
-- One-to-One Relationship w/ 'Employees' Table (Common Link = emp_id)
CREATE TABLE Salaries (
	emp_id INT NOT NULL PRIMARY KEY,
	salary INT NOT NULL,
	FOREIGN KEY(emp_id) REFERENCES Employees(emp_id)
);


-- SQL Table #5 = Dept_Employees (dept_emp.csv)
-- Composite Key
-- Many-to-One Relationship w/ 'Employees' Table (Common Link = emp_id)
-- Many-to-One Relationship w/ 'Departments' Table (Common Link = dept_id)
CREATE TABLE Dept_Employees (
	emp_id INT NOT NULL,
	dept_id VARCHAR(4) NOT NULL,
	PRIMARY KEY (emp_id, dept_id),
	FOREIGN KEY(emp_id) REFERENCES Employees(emp_id),
	FOREIGN KEY(dept_id) REFERENCES Departments(dept_id)
);


-- SQL Table #6 = Dept_Managers (dept_manager.csv)
-- Composite Key
-- Many-to-One Relationship w/ 'Departments' Table (Common Link = dept_id)
-- Many-to-One Relationship w/ 'Employees' Table (Common Link = emp_id)
CREATE TABLE Dept_Managers (
	dept_id VARCHAR(5) NOT NULL,
	emp_id INT NOT NULL,
	PRIMARY KEY (dept_id, emp_id),
	FOREIGN KEY(emp_id) REFERENCES Employees(emp_id),
	FOREIGN KEY(dept_id) REFERENCES Departments(dept_id)
);

-----------------------------------------------------
-- 'Employee' Table - Transform Date columns as 'DATE' Data Type


-- Using TO_DATE, change birth_date & hire_date format from 'MM/DD/YYYY' to 'YYYY-MM-DD' (recognisable date format for PostgreSQL)
UPDATE Employees
SET
	birth_date = TO_DATE(birth_date, 'MM/DD/YYYY'),
	hire_date = TO_DATE(hire_date, 'MM/DD/YYYY');

-- Alter both date columns to 'DATE' data type
ALTER TABLE Employees
ALTER COLUMN birth_date TYPE DATE USING birth_date::DATE,
ALTER COLUMN hire_date TYPE DATE USING hire_date::DATE;

-- Show first 100 rows from 'Employees'
SELECT *
FROM Employees
ORDER BY emp_id ASC LIMIT 100;

-----------------------------------------------------
-- My SQL Queries (Data Analysis)
-- NOTE: Each SQL query is stored in its own view

-- List the employee number, last name, first name, sex, and salary of each employee
-- Total Employees = 300,024
DROP VIEW IF EXISTS employee_salaries;

CREATE VIEW employee_salaries AS
SELECT emp.emp_id, emp.last_name, emp.first_name, emp.sex, s.salary
FROM Employees AS emp
JOIN Salaries AS s ON (emp.emp_id = s.emp_id);

SELECT *
FROM employee_salaries;


-- List the first name, last name, and hire date for the employees who were hired in 1986
-- Total 1986 Employees = 36,150
DROP VIEW IF EXISTS employee_1986;

CREATE VIEW employee_1986 AS
SELECT first_name, last_name, hire_date
FROM Employees
WHERE EXTRACT(YEAR FROM hire_date) =  1986;

SELECT *
FROM employee_1986;


-- List the manager of each department along with their department number, department name, employee number, last name, and first name
-- Total Managers = 24
DROP VIEW IF EXISTS manager_list;

CREATE VIEW manager_list AS
SELECT dm.dept_id, dept.dept_name, dm.emp_id, emp.last_name, emp.first_name
FROM Dept_Managers AS dm
JOIN Departments AS dept
ON (dm.dept_id = dept.dept_id)
	JOIN Employees AS emp
	ON (dm.emp_id = emp.emp_id);
	
SELECT *
FROM manager_list;


-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name
-- Total Employees listed in Departments = 331,603
-- NOTE: employees can belong in more than one department
DROP VIEW IF EXISTS employee_dept_list;

CREATE VIEW employee_dept_list AS
SELECT de.dept_id, de.emp_id, emp.last_name, emp.first_name, dept.dept_name
FROM Dept_Employees AS de
JOIN Employees AS emp
ON (de.emp_id = emp.emp_id)
	JOIN Departments AS dept
	ON (de.dept_id = dept.dept_id);
	
SELECT *
FROM employee_dept_list;


-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
-- Total Employees Named as 'Hercules B...' = 20
DROP VIEW IF EXISTS employee_hercules_b;

CREATE VIEW employee_hercules_b AS
SELECT first_name, last_name, sex
FROM Employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

SELECT *
FROM employee_hercules_b;


-- List each employee in the Sales department, including their employee number, last name, and first name
-- Total Employees in 'Sales' = 52,245
DROP VIEW IF EXISTS sales_department;

CREATE VIEW sales_department AS
SELECT de.emp_id, emp.last_name, emp.first_name
FROM Dept_Employees AS de
JOIN Employees AS emp
ON (de.emp_id = emp.emp_id)
WHERE de.dept_id IN
(
	SELECT dept_id
	FROM Departments
	WHERE dept_name = 'Sales'
);

SELECT *
FROM sales_department;


-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
-- Total Employees in 'Sales' OR 'Development' = 137,952
DROP VIEW IF EXISTS sd_department;

CREATE VIEW sd_department AS
SELECT de.emp_id, emp.last_name, emp.first_name, dept.dept_name
FROM Dept_Employees AS de
JOIN Employees AS emp
ON (de.emp_id = emp.emp_id)
	JOIN Departments AS dept
	ON (de.dept_id = dept.dept_id)
WHERE de.dept_id IN
(
	SELECT dept_id
	FROM Departments
	WHERE dept_name = 'Sales'
	OR dept_name = 'Development'
);

SELECT *
FROM sd_department;


-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
-- Total Unique Surnames = 1,638
DROP VIEW IF EXISTS employee_freq_surname;

CREATE VIEW employee_freq_surname AS
SELECT last_name, COUNT(*) AS Count
FROM Employees
GROUP BY last_name
ORDER BY Count DESC;

SELECT *
FROM employee_freq_surname;