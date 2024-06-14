String up to 25 symbols VARCHAR(25)
String limited to 1 character CHAR(1)

bio_bakery_db

Section 1
-----------
create table countries(
	id serial primary key,
	name varchar(50) UNIQUE not null
);

create table customers(
	id serial primary key,
	first_name varchar(25) not null,
	last_name varchar(50) not null,
	gender char(1),
	age int not null,
	phone_number char(10) not null,
	country_id int REFERENCES countries on delete cascade on update cascade not null,

	constraint gender_check CHECK (gender in ('M', 'F')),
	constraint age_check CHECK (age > 0)
);

create table products(
	id serial primary key,
	name varchar(25) not null,
	description varchar(250),
	recipe text,
	price numeric(10, 2) not null,
	
	constraint price_check CHECK (price > 0)
);

create table feedbacks(
	id serial primary key,
	description varchar(255),
	rate numeric(4, 2),
	product_id int REFERENCES products on delete cascade on update cascade not null,
	customer_id int REFERENCES customers on delete cascade on update cascade not null
	
	constraint rate_check CHECK (rate between 0 and 10)
);

create table distributors(
	id serial primary key,
	name varchar(25) UNIQUE not null,
	address varchar(30) not null,
	summary varchar(200) not null,
	country_id int REFERENCES countries on delete cascade on update cascade not null
);

create table ingredients(
	id serial primary key,
	name varchar(30) not null,
	description varchar(200),
	country_id int REFERENCES countries on delete cascade on update cascade not null,
	distributor_id int REFERENCES distributors on delete cascade on update cascade not null
);

create table products_ingredients(
	product_id int REFERENCES products on delete cascade on update cascade,
	ingredient_id int REFERENCES ingredients on delete cascade on update cascade
);


Section 2
-----------
CREATE TABLE gift_recipients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country_id INT NOT NULL,
    gift_sent BOOLEAN DEFAULT FALSE
);
INSERT INTO gift_recipients (name, country_id)
SELECT CONCAT(first_name, ' ', last_name) AS name, country_id
FROM customers;

UPDATE gift_recipients
SET gift_sent = TRUE
WHERE country_id IN (7, 8, 14, 17, 26);


2--
UPDATE products
SET price = price * 1.10
WHERE id in(
	select product_id
	from feedbacks
	where rate > 8
)

3--
delete from distributors
WHERE name LIKE 'L%';


Section 3
-----------
3.5--
SELECT name, recipe, price
FROM products
WHERE price BETWEEN 10 AND 20
ORDER BY price DESC;

3.6--
SELECT 
    p.name AS product_name,
    ROUND(AVG(p.price), 2) AS average_price,
    COUNT(f.id) AS total_feedbacks
FROM 
    products as p
JOIN 
    feedbacks as f ON p.id = f.product_id
WHERE 
    p.price > 15
GROUP BY 
    p.id, p.name
HAVING 
    COUNT(f.id) > 1
ORDER BY 
    total_feedbacks ASC, 
    average_price DESC;
    
3.7--
SELECT 
    p.name AS product_name,
    ROUND(AVG(p.price), 2) AS average_price,
    COUNT(f.id) AS total_feedbacks
FROM 
    products as p
JOIN 
    feedbacks as f ON p.id = f.product_id
WHERE 
    p.price > 15
GROUP BY 
    p.id, p.name
HAVING 
    COUNT(f.id) > 1
ORDER BY 
    total_feedbacks ASC, 
    average_price DESC;


3.8--
SELECT
	i.name AS ingredient_name,
    p.name AS product_name,
    d.name AS distributor_name
FROM 
    products as p
JOIN 
    products_ingredients as pi 
ON p.id = pi.product_id
JOIN 
    ingredients as i ON pi.ingredient_id = i.id
JOIN 
    distributors as d ON i.distributor_id = d.id
WHERE 
    LOWER(i.name) LIKE '%mustard%'
    AND d.country_id = 16
ORDER BY 
    product_name ASC;
    
3.9--
SELECT 
    d.name AS distributor_name,
    i.name AS ingredient_name,
    p.name AS product_name,
	AVG(f.rate) AS avarage_rate
FROM 
    distributors as d
JOIN 
    ingredients as i ON d.id = i.distributor_id
JOIN 
    products_ingredients as pi ON i.id = pi.ingredient_id
JOIN 
    products as p ON pi.product_id = p.id
JOIN feedbacks as f ON p.id = f.product_id
GROUP BY
     p.id, d.name,i.name, p.name
HAVING 
      AVG(rate) BETWEEN 5 AND 8
ORDER BY 
    distributor_name ASC,
    ingredient_name ASC,
    product_name ASC;



Section 4
-----------

    SELECT 
        c.id AS customer_id,
        c.first_name AS customer_name,
        f.description AS feedback_description,
        f.rate AS feedback_rate
    FROM 
        products as p
    JOIN 
        feedbacks as f ON p.id = f.product_id
    JOIN 
        customers as c ON f.customer_id = c.id
    WHERE 
        p.name = product_name
    ORDER BY 
        c.id ASC;


CREATE OR REPLACE FUNCTION fn_feedbacks_for_product(product_name VARCHAR(25))
RETURNS TABLE (
    customer_id INT,
    customer_name VARCHAR(75),
    feedback_description VARCHAR(255),
    feedback_rate NUMERIC(4, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id AS customer_id,
        c.first_name AS customer_name,
        f.description AS feedback_description,
        f.rate AS feedback_rate
    FROM 
        products as p
    JOIN 
        feedbacks as f ON p.id = f.product_id
    JOIN 
        customers as c ON f.customer_id = c.id
    WHERE 
        p.name = product_name
    ORDER BY 
        c.id ASC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fn_feedbacks_for_product('Bread');



procedure
-----------
CREATE OR REPLACE procedure sp_customer_country_name(
	in customer_full_name VARCHAR(50),
	out country_name VARCHAR(50)) 
AS 
$$

BEGIN
	country_name := (SELECT
					co.name
			FROM customers as cust
			JOIN countries as co ON cust.country_id = co.id
			WHERE CONCAT(cust.first_name, ' ', cust.last_name, '') = customer_full_name);

END;
$$ LANGUAGE plpgsql;

CALL sp_customer_country_name('Betty Wallace', '')


SELECT 
	co.name
FROM customers as cust
JOIN countries as co ON cust.country_id = co.id
WHERE CONCAT(cust.first_name, ' ', cust.last_name, '') = 'Betty Wallace';
