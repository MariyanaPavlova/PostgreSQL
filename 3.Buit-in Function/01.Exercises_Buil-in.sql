--01.River info
CREATE OR REPLACE VIEW view_river_info
AS
SELECT 
	Concat('The river', ' ',
		   river_name, ' ',
		   'flows into the', ' ',
		   outflow, ' ',
		   'and is', ' ',
		   "length", ' ',
		   'kilometers long.')
	AS "River Information"
FROM rivers
ORDER BY river_name ASC

SELECT * 
FROM view_river_inf

--02.Concatenate Geography Data
CREATE OR REPLACE VIEW "view_continents_countries_currencies_details"
AS SELECT 
	concat(continents.continent_name,': ', continents.continent_code)
	AS "Continent Details",
	concat_ws(' - ', countries.country_name, countries.capital, countries.area_in_sq_km, 'km2') 
	AS "Country Information",
	concat(currencies.description, ' (', currencies.currency_code, ')')
	AS "Currencies"
FROM 
	continents,
	countries,
	currencies
WHERE 
	continents.continent_code = countries.continent_code
AND 
	countries.currency_code = currencies.currency_code
ORDER BY 
	"Country Information" ASC,
	"Currencies" ASC;


--03.Capital Code
ALTER TABLE countries
ADD COLUMN capital_code CHAR(2);

UPDATE countries
SET capital_code = SUBSTRING(capital, 1, 2)
RETURNING *;

SE--04.(Descr)iption
SELECT 
 	SUBSTRING(description, 5) AS "substring"
 	--RIGHT(description, -4) AS "substring"
FROM currencies

--05.Substring River Length
SELECT 
	(REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1] AS river_lenth
	
FROM view_river_info;

--06.Replace A
SELECT 
	Replace(mountain_range, 'a', '@') AS "replace_a",
	Replace(mountain_range, 'A', '$') AS "replace_A"
      
FROM mountains;

--07.Translate
SELECT 
	capital,
	TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name
FROM countries;

--08.LEADING
SELECT 
	continent_name,
	RTRIM(continent_name) AS trim
FROM continents;

SELECT 
	continent_name,
	LTRIM(continent_name) AS trim
FROM continents;
--09.TRAILING
SELECT 
	continent_name,
	RTRIM(continent_name) AS trim
FROM continents;

--10.LTRIM & RTRIM
SELECT 
	LTRIM(peak_name, 'M') AS "Left Trim",
	RTRIM(peak_name, 'm') AS "Right Trim"
FROM peaks;

--11.Character Length and Bits
SELECT 
	CONCAT(m.mountain_range, ' ', p.peak_name) AS "Mountain Information",
	CHAR_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "Characters Length",
	BIT_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "Bits of a String"
FROM mountains AS m,
	peaks AS p
WHERE
	m."id" = p.mountain_id

--12.Length of a Number
SELECT 
	population,
	LENGTH(CAST(population AS VARCHAR)) AS "length"
FROM 
	countries;
	
--13.Positive and Negative LEFT
SELECT 
	peak_name,
	LEFT(peak_name, 4) AS "Poistive Left",
	LEFT(peak_name, -4) AS "Negative Left"
FROM peaks;

--14.Positive and Negative RIGHT
SELECT 
	peak_name,
	RIGHT(peak_name, 4) AS "Poistive Right",
	RIGHT(peak_name, -4) AS "Negative Right"
FROM peaks;

--15.Update iso_code
UPDATE 
	countries
	
SET iso_code = UPPER(LEFT("country_name", 3))
WHERE 
	iso_code is NULL
RETURNING *;

--16.REVERSE country_code
UPDATE 
	countries
	
SET country_code = REVERSE(LOWER("country_code"))

RETURNING *;

--17.Elevation --->> Peak Name
SELECT 
	CONCAT(elevation, ' ', REPEAT('-', 3) || REPEAT('>', 2), ' ', peak_name) AS "Elevation --->> Peak Name"
FROM peaks
WHERE elevation >= 4884;

--18.Arithmetical Operators
CREATE TABLE 
	bookings_calculation
AS SELECT 
	booked_for,
	CAST(booked_for * 50 AS NUMERIC) AS multiplication,
	CAST(booked_for % 50 AS NUMERIC) AS modulo
from bookings
where apartment_id = 93;

--19.ROUND vs TRUNC
SELECT
	latitude,
	ROUND(latitude,2) AS round,
	TRUNC(latitude,2) AS trunc
FROM apartments;

--20.Absolute Value
SELECT
	longitude,
	ABS(longitude) AS abs
FROM apartments;

--21.Billing Day****
ALTER TABLE
	bookings
ADD COLUMN
	billing_day TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

SELECT
	TO_CHAR(billing_day, 'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS') AS "Billing Day"
FROM bookings;

--22.EXTRACT Booked At
SELECT 
	EXTRACT(YEAR FROM booked_at) AS YEAR,
	EXTRACT(MONTH FROM booked_at) AS MONTH,
	EXTRACT(DAY FROM booked_at) AS DAY,
	EXTRACT(HOUR FROM booked_at AT TIME ZONE 'UTC')AS HOUR,
	EXTRACT(MINUTE FROM booked_at) AS MINUTE,
	CEIL(EXTRACT(SECOND FROM booked_at)) AS SECOND
FROM bookings;

--23.Early Birds****
SELECT 
	user_id,
	AGE(starts_at, booked_at) AS "Early Birds"
FROM bookings
WHERE starts_at - booked_at >= '10 MONTHS';

--24.Match or Not
SELECT 
	companion_full_name,
	email
FROM users
WHERE companion_full_name ILIKE '%aNd%'
AND email NOT LIKE '%@gmail';

--25.* COUNT by Initial
SELECT 
	LEFT(first_name, 2) AS initials,
	COUNT('initials') AS user_count
FROM
	users
GROUP BY
	initials
ORDER BY 
	user_count DESC,
	initials ASC;
	
--26.* SUM
SELECT 
	SUM(booked_for) AS total_value
FROM
	bookings
WHERE apartment_id = 90;

--27.* Average Value
SELECT 
	AVG(multiplication) AS avarage_value
FROM
	bookings_calculation;
