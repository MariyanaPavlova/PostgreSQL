board_games_db


Section 1. 
-----------
create table categories(
	id serial primary key,
	name varchar(30) not null
);

create table addresses(
	id serial primary key,
	street_name varchar(100) not null,
	street_number int not null CHECK(street_number > 0),
	town varchar(30) not null, 
	country varchar(50) not null,
	zip_code int not null CHECK(zip_code > 0)
	
--	constraint street_number_check CHECK(street_number > 0),
--	constraint zip_code_check CHECK(zip_code > 0)
);

create table publishers(
	id serial primary key,
	name varchar(30) not null,
	address_id int REFERENCES addresses on delete cascade on update cascade not null,
	website varchar(40),
	phone varchar(20)
);
create table players_ranges(
	id serial primary key,
	min_players int not null,
	max_players int not null,

	constraint min_players_check CHECK(min_players > 0),
	constraint max_players_check CHECK(max_players > 0)
);

create table creators(
	id serial primary key,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
	email varchar(30) not null
);

create table board_games(
	id serial primary key,
	name varchar(30) not null,
	release_year int not null,
	rating NUMERIC(4, 2) not null,
	category_id int REFERENCES categories on delete cascade on update cascade not null,
	publisher_id int REFERENCES publishers on delete cascade on update cascade not null,
	players_range_id int REFERENCES players_ranges on delete cascade on update cascade not null
	
	constraint release_year_check CHECK(release_year > 0)
);


create table creators_board_games(
	creator_id int REFERENCES creators on delete cascade on update cascade not null,
	board_game_id int REFERENCES board_games on delete cascade on update cascade not null
	
);


Section 2.
-----------
insert into board_games(name,release_year,rating,category_id,publisher_id,players_range_id)
VALUES ('Deep Blue', 2019, 5.67, 1, 15, 7),
		('Paris', 2016, 9.78, 7, 1, 5),
		('Catan', 2021, 9.87, 7, 13, 6),
		('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
		('One Small Step', 2019, 5.75, 5, 9, 2);

insert into publishers(name, address_id, website, phone)
VALUES ('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
		('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
		('BattleBooks', 13, 'www.battlebooks.com', '+12345678907');

update--
update players_ranges
set max_players = max_players + 1

where max_players =2 and 
	min_players = 2;

UPDATE board_games
SET name = name || ' V2'
WHERE release_year >= 2020;

del--0точки
DELETE FROM publishers
WHERE address_id IN (
    SELECT id
    FROM addresses
    WHERE town LIKE 'L%'
);
DELETE FROM publishers
WHERE address_id IN (
    SELECT id
    FROM addresses
    WHERE town LIKE 'L%'
);

-- Delete records from addresses table
DELETE FROM addresses
WHERE town LIKE 'L%';

	
3.5--
SELECT 
	name, 
	rating
FROM board_games
ORDER BY 
    release_year ASC, name DESC;

3.6--
SELECT 
    bg.id,
    bg.name,
    bg.release_year,
    c.name
FROM 
    board_games as bg
JOIN 
    categories as c ON c.id = bg.category_id

WHERE c.name IN ('Strategy Games', 'Wargames')
ORDER BY 
    bg.release_year DESC;
    
3.7--
SELECT 
    c.id,
    CONCAT(c.first_name, ' ', c.last_name) AS creator_name,
    c.email

FROM 
    creators as c
left join creators_board_games as cbg
	on cbg.creator_id = c.id

WHERE 
    cbg.creator_id IS NULL
ORDER BY 
    creator_name ASC;
    

3.8--0 точки
SELECT 
    bg.name,
    bg.rating,
    c.name as category_name

FROM 
    board_games as bg
left JOIN 
    categories as c ON c.id = bg.category_id
left join 
	players_ranges as pr on pr.id = bg.players_range_id
	
	WHERE 
    (bg.name LIKE '%a%' and bg.rating > 7.00)
	OR (bg.rating > 7.50
       AND pr.min_players >= 2
		and pr.max_players <= 5)
	
ORDER BY 
    bg.name ASC,
    bg.rating DESC
LIMIT 5;
  
3.9--
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
     c.email,
	MAX(bg.rating) as rating
FROM creators as c
JOIN creators_board_games as cbg
on cbg.creator_id = c.id
JOIN board_games as bg 
ON cbg.board_game_id = bg.id

	WHERE c.email LIKE '%.com'
	group by c.id, full_name, c.email
order by full_name

3.10--
SELECT
    c.last_name,
	ceiling((bg.rating)) as avarage_rating,
	p.name as publisher_name
FROM creators as c
JOIN creators_board_games as cbg
	on cbg.creator_id = c.id
JOIN board_games as bg 
	ON cbg.board_game_id = bg.id
join publishers as p
	on bg.publisher_id = p.id
where p.name = 'Stonemaier Games'
order by avarage_rating desc, last_name
 
Section 3.
----------
	
    SELECT COUNT(bg.id)
    FROM board_games as bg
	join creators_board_games as cbg
		on cbg.board_game_id = bg.id
		
    JOIN creators as c ON c.id = cbg.creator_id
    WHERE c.first_name = 'Bruno';


CREATE OR REPLACE FUNCTION fn_creator_with_board_games(creator_first_name VARCHAR(30))
RETURNS INTEGER 
AS 
$$
DECLARE
    total_board_games INTEGER;
BEGIN
    SELECT COUNT(bg.id) INTO total_board_games
    FROM board_games as bg
	join creators_board_games as cbg
		on cbg.board_game_id = bg.id
		
    JOIN creators as c ON c.id = cbg.creator_id
    WHERE c.first_name = creator_first_name;

    RETURN total_board_games;
END;
$$ LANGUAGE plpgsql;

SELECT fn_creator_with_board_games('Bruno')
SELECT fn_creator_with_board_games('Alexander')

Section 4.
----------

