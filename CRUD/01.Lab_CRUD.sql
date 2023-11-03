
serial == auto increment - в др.езици

--01.Create a Table
CREATE TABLE person (
	id serial PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20)
);
INSERT INTO person (first_name, last_name)
VALUES
 ('Koko', 'Kokov'),
 ('Boko', 'Bokob');
 
CREATE SEQUENCE person_id_by_2
START 4 
INCREMENT 2
OWNED BY person.id

--на реrson правим дефолт да е нашия сикуенс
alter table person 
alter column id set default nextval ('person_id_by_2');

сега сикуенса на id ще е 1 2 4 6 , през 2


--01.Select and Display Employee Information by Concatenating Columns
SELECT 
	id,
	concat(first_name, ' ', last_name) AS "Full Name", 
	job_title AS "Job Title"
	
FROM employees


--02.Select Employees by Filtering and Ordering
SELECT *
FROM employees
LIMIT 5

select * 
from employees
order by first_name, last_name


--03.Select Employees by Multiple Filters
SELECT
	id,
	first_name,
	last_name,
	job_title,
	department_id,
	salary
from 
	employees
WHERE department_id = 4 
	AND salary > 1000
	
	
--04.Insert Data into Employees Table
INSERT INTO employees(
	first_name,
	last_name,
	job_title,
	department_id,
	salary)
VALUES 
	('Samantha', 'Young', 'Housekeeping', 4, 900),
	('Roger', 'Palmer', 'Waiter', 3, 928.33);

SELECT * from employees;


--05.Update Employees Salary
UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

SELECT * from employees
WHERE job_title = 'Manager';

--06.Delete from Table
DELETE from employees
WHERE department_id BETWEEN 1 and 2;


select * from employees

--07.Create a View for Top Paid Employee
CREATE VIEW top_paid_employee_view
AS 
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

SELECT * FROM top_paid_employee_view;
