
--functions
CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR, VARCHAR)
RETURNS VARCHAR AS
$$
 	BEGIN
		RETURN concat($1, ' ', $2);
	END
$$
LANGUAGE plpgsql;

SELECT fn_full_name('Kumcho', 'Valcho')

--
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
		WHERE t.name = town_name INTO town_count;
		RETURN town_count;
	END

$$
LANGUAGE plpgsql;
 
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


---

