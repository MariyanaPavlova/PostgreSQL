

--Find Book Titles
SELECT
	title,
FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;

SELECT
	id,
	title
FROM books
WHERE title like 'The%'
ORDER BY ID

--Replace Titles
SELECT
	REPLACE(title, 'The', '***') AS "Title"
FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;

--вадим си първото име от колона с 2 имена и го слагаме в нова колона first_name
select
	full_name,
	left(full_name, position(' ' in full_name)) AS first_name,
	substring(full_name, 1, position(' ' in full_name)) AS last_name,
	right(full_name, length(full_name) - position(' ' in full_name)) AS last_name,
	substring(full_name, position(' ' in full_name), lenght(full_name)) AS last_name,
from new_friends
	
--Triangles on Bookshelves
SELECT 
	id, 
	side * height / 2 AS area
FROM 
	triangles
ORDER BY id

--Format Costs
SELECT 
	title,
	round(cost, 3) AS modified_price
FROM 
	books
ORDER by id

--Year of Birth
SELECT 
	 first_name,
	 last_name,
	 to_char(born, 'YYYY') as year
FROM 
	authors;	
	
--Format Date of Birth
SELECT 
	 last_name AS "Last Name",
	 to_char(born, 'DD (Dy) Mon YYYY') as "Date of Birth"
FROM 
	authors	
	
--Harry Potter Books
SELECT 
	 title
FROM 
	books	
WHERE title LIKE 'Harry Potter%';
