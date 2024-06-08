
--functions
CREATE OR REPLACE FUNCTION fn_full_name(varchar, varchar)
RETURNS varchar AS
$$
	BEGIN
		return concat($1, ' ', $2);
	END;
$$
LANGUAGE plpgsql
;
==============
CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR, VARCHAR)
RETURNS VARCHAR AS
$$
 	DECLARE
 		first_name ALIAS FOR $1;
 		last_name ALIAS FOR $2;
		greeting varchar
 	BEGIN
		greeting := 'Hello';
		RETURN concat(greeting, ' ', $1, ' ', $2);
	END
$$
LANGUAGE plpgsql;

SELECT fn_full_name('Kumcho', 'Valcho')

==============
CREATE OR REPLACE FUNCTION fn_name_len(name varchar)
RETURNS int AS
$$
	BEGIN
		RETURN length(name);
	END;
$$
LANGUAGE plpgsql
;

SELECT * FROM fn_name_len('koko')
	
=============	
CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR AS
$$
	DECLARE
		full_name VARCHAR;
	BEGIN
		IF first_name IS NULL and last_name IS NULL THEN
			full_name := last_name;
		ELSIF first_name IS NULL THEN
			full_name := last_name;
		ELSIF  last_name IS NULL THEN
			full_name := first_name;
		ELSE
			full_name := concat(first_name, ' ', last_name);
		END IF;
		RETURN full_name;
	END
$$
LANGUAGE plpgsql;

SELECT fn_full_name('Kumcho', 'Valcho')

--01--
CREATE FUNCTION fn_count_employees_by_town(town_name VARCHAR)
RETURNS INT AS
$$
	DECLARE town_count INT;
	BEGIN
		SELECT
			count(*)
		FROM employees as e
			JOIN addresses as a
			USING(address_id)
			JOIN towns as t
			USING(town_id)
		WHERE t.name = town_name 
		INTO town_count;
		RETURN town_count;
	END

$$
LANGUAGE plpgsql;
==================
CREATE OR REPLACE FUNCTION fn_get_country()
RETURNS table(id int, name varchar) AS
$$
	BEGIN
		return query(select * from country)
	END;
$$
LANGUAGE plpgsql

	
--proceducres - манипулират данните в базите, не връщат с-т
CREATE PROCEDURE sp_add_person(first_name VARCHAR, last_name VARCHAR, city_name VARCHAR)
AS
$$
	BEGIN
	INSERT INTO persons(first_name, last_name, city_id)
	VALUES(first_name, last_name, fn_get_city_id(city_name:city_name);
	END;
$$
LANGUAGE plpqsql;

CALL sp_add_person(first_name: 'Milcho', last_name: 'Kolev', city_name: 'Burgas');
SELECT * FROM persons

--02--
CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR)
AS 
$$
BEGIN
	UPDATE employees
	set salary = salary + salary * 0.05
	WHERE department_id = 
	(
		SELECT
		d.department_id
		FROM employees as e
		JOIN departments as d
		USING (department_id)
		WHERE name = department_name
		GROUP BY d.department_id
);
END;
$$
LANGUAGE plpgsql;
CALL sp_increase_salaries('Sales');

---RAISE NOTICE-
CREATE OR REPLACE FUNCTION fn_test_function(first_name VARCHAR)
RETURNS INT AS 
$$
	BEGIN
		RAISE NOTICE '%', first_name;
		RETURN NULL;
	END;
$$
LANGUAGE plpgsql;

SELECT fn_test_function('Koko')

---Transacions--
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
DECLARE
	bob_balance DECIMAL(20,2);
BEGIN
	SELECT balance INTO bob_balance FROM accounts WHERE account_id = 2;
	IF bob_balance > 1000 THEN
		RAISE NOTICE 'Bob has too much money.Rolling back trn.';
		ROLLBACK;
		RETURN;
	END IF;
END;


CREATE PROCEDURE sp_increase_salary_by_id(id int)
AS 
$$
	BEGIN
		IF(SELECT salary 
		   FROM employees 
		   WHERE employee_id = id) 
		   IS NULL THEN RETURN;
		ELSE
		   UPDATE employees
		   SET salary=salary + salary * 0.05
		   WHERE employee_id = id;
		END IF;
		COMMIT;
	END;
$$
LANGUAGE plpgsql;

---Trigger--

CREATE TABLE deleted_employees(
	employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	middle_name VARCHAR(20),
	job_title VARCHAR(50),
	department_id INT,
	salary NUMERIC(19,4)
);

CREATE OR REPLACE FUNCTION backup_fired_employees()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO deleted_employees(
		first_name,
		last_name,
		middle_name,
		job_title,
		department_id,
		salary
		)
	VALUES(
	old.first_name,
	old.last_name,
	old.middle_name,
	old.job_title,
	old.department_id,
	old.salary
	);
	RETURN new;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER backup_employees
AFTER DELETE on employees
FOR EACH ROW
EXECUTE PROCEDURE backup_fired_employees();


