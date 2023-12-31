01
CREATE TABLE 
	employees(
		id serial PRIMARY KEY NOT NULL,
		first_name VARCHAR(30),
		last_name VARCHAR(50),
		hiring_date DATE DEFAULT '2023-01-01',
		salary NUMERIC(10,2),
		devices_number int
	);
CREATE TABLE
	departments(
		id serial NOT NULL PRIMARY KEY,
		"name" VARCHAR(50),
		code CHAR(3),
		description text
	);
	
CREATE TABLE
	issues(
		id serial PRIMARY KEY UNIQUE,
		description VARCHAR(150),
		"date" date,
		"start" TIMESTAMP
		
	)
	
02
ALTER TABLE employees
add column middle_name varchar(50)

03
ALTER TABLE employees
add column middle_name varchar(50)

04
ALTER TABLE employees
ALTER COLUMN salary SET NOT NULL,
ALTER COLUMN salary SET Default 0,
ALTER COLUMN hiring_date SET NOT NULL;

05
TRUNCATE TABLE issues;

07
DROP TABLE departments;
