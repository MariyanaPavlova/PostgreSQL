
--01
SELECT 
	concat(a.address, ' ', a.address_2) AS apartment_address,
	b.booked_for AS nights
FROM apartments AS a
JOIN bookings AS b
ON a.booking_id = b.booking_id --USING(booking_id)
order by a.apartment_id ASC;

--02
SELECT 
	a.name,
	a.country,
	b.booked_at::date
FROM apartments AS a
LEFT JOIN bookings AS b
ON a.booking_id = b.booking_id --USING(booking_id)
LIMIT 10

--03
SELECT 
	b.booking_id,
	b.starts_at::date,
	b.apartment_id,
	concat(c.first_name, ' ', c.last_name) as customer_name
	
FROM bookings AS b
RIGHT JOIN customers AS c
ON c.customer_id = b.customer_id  --USING(customer_id)

ORDER BY customer_name ASC
LIMIT 10

--04
SELECT 
	b.booking_id,
	a.name AS apartment_owner,
	a.apartment_id,
	concat(c.first_name, ' ', c.last_name) AS customer_name
	
FROM apartments AS a

FULL JOIN bookings AS b
USING(booking_id)
FULL JOIN customers AS c
USING(customer_id)
ORDER BY 
	b.booking_id ASC,
	apartment_owner,
	customer_name
	
--06
SELECT 
	b.booking_id,
	b.apartment_id,
	c.companion_full_name
FROM bookings AS b

JOIN customers AS c
USING(customer_id)
WHERE b.apartment_id IS NULL

--07
SELECT 
	b.apartment_id,
	b.booked_for,
	c.first_name,
	c.country
FROM bookings AS b

INNER JOIN customers AS c
USING(customer_id)
WHERE c.job_type = 'Lead'

--08
SELECT 
	count(b.booking_id)

FROM bookings AS b

INNER JOIN customers AS c
USING(customer_id)
WHERE c.last_name = 'Hahn'

--09
SELECT 
	a.name,
	sum(b.booked_for)
	
FROM apartments AS a

JOIN bookings AS b
USING(apartment_id)
GROUP BY a.name
ORDER BY a.name ASC

--10
SELECT 
	a.country, 
	COUNT(b.booking_id) AS booking_count
	
FROM bookings AS b

JOIN apartments AS a
USING(apartment_id)
WHERE b.booked_at > '2021-05-18 07:52:09.904+03'
	AND b.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY a.country
ORDER BY booking_count DESC


--11
SELECT
	mc.country_code,
	m.mountain_range,
	p.peak_name,
	p.elevation
FROM mountains_countries AS mc
JOIN mountains as m
on mc.mountain_id = m.id
JOIN peaks as p
on p.mountain_id = m.id
WHERE 
	p.elevation > 2835 
	AND 
	mc.country_code = 'BG'
ORDER BY p.elevation DESC

--12
SELECT
	country_code,
	count(country_code) AS mountain_range_count
FROM mountains_countries AS ms
JOIN mountains AS m
ON m.id = ms.mountain_id
WHERE country_code IN ('US', 'RU', 'BG')
GROUP BY country_code
ORDER BY mountain_range_count DESC

--13
SELECT
	c.country_name,
	r.river_name
	
FROM countries AS c
LEFT JOIN countries_rivers AS cr
ON cr.country_code = c.country_code 
LEFT JOIN rivers AS r
ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name 
LIMIT 5

--14
SELECT
	MIN(average) AS min_average_area
FROM (
SELECT
	continent_code,
	AVG(area_in_sq_km) AS average
FROM countries
GROUP BY continent_code) AS average_area

--15
SELECT
	count(c.country_name) AS countries_without_mountains
FROM countries AS c
LEFT JOIN mountains_countries AS mc
ON mc.country_code = c.country_code
WHERE mc.mountain_id IS NULL

--18
SELECT
	tablename,
	indexname,
	indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY 
	tablename ASC,
	indexname ASC
	
--16
CREATE TABLE monasteries 
(
	id SERIAL PRIMARY KEY,
   monastery_name VARCHAR(255),
   country_code CHAR(2)
);


INSERT INTO monasteries (monastery_name, country_code)
VALUES ('Rila Monastery "St. Ivan of Rila"', 'BG'),
  ('Bachkovo Monastery "Virgin Mary"', 'BG'),
  ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
  ('Kopan Monastery', 'NP'),
  ('Thrangu Tashi Yangtse Monastery', 'NP'),
  ('Shechen Tennyi Dargyeling Monastery', 'NP'),
  ('Benchen Monastery', 'NP'),
  ('Southern Shaolin Monastery', 'CN'),
  ('Dabei Monastery', 'CN'),
  ('Wa Sau Toi', 'CN'),
  ('Lhunshigyia Monastery', 'CN'),
  ('Rakya Monastery', 'CN'),
  ('Monasteries of Meteora', 'GR'),
  ('The Holy Monastery of Stavronikita', 'GR'),
  ('Taung Kalat Monastery', 'MM'),
  ('Pa-Auk Forest Monastery', 'MM'),
  ('Taktsang Palphug Monastery', 'BT'),
  ('Sümela Monastery', 'TR');
  
ALTER TABLE countries
ADD COLUMN three_rivers BOOLEAN DEFAULT FALSE;

UPDATE countries
SET three_rivers = (
	SELECT 
		count(*) >= 3
	FROM countries_rivers AS cr
	WHERE cr.country_code = countries.country_code
);
SELECT 
	m.monastery_name,
	c.country_name
FROM monasteries AS m
JOIN countries AS c
USING (country_code)
WHERE NOT three_rivers
ORDER BY monastery_name ASC;









