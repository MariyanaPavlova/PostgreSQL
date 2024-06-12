DB ZOO

Section 1.
-------------
create table owners(
	id serial primary key,
	name varchar(50) not null,
	phone_number varchar(15) not null,
	address varchar(50)
);

Create table animal_types(
	id serial primary key,
	animal_type varchar(30) not null
);

create table cages(
	id serial primary key,
	animal_type_id integer REFERENCES animal_types on delete cascade on update cascade not null

);

create table animals(
	id serial primary key,
	name varchar(30) not null,
	birthdate DATE not null,
	owner_id integer references owners on delete cascade on update cascade,
	animal_type_id integer references animal_types on delete cascade on update cascade not null
);

create table volunteers_departments(
	id serial primary key,
	department_name	varchar(30) not null
);

create table volunteers(
	id serial primary key,
	name varchar(50) not null,
	phone_number varchar(15) not null,
	address varchar(50),
	animal_id integer references animals on delete cascade on update cascade,
	department_id integer references volunteers_departments on delete cascade on update cascade not null
);

create table animals_cages(
	cage_id integer references cages on delete cascade on update cascade not null,
	animal_id integer references animals on delete cascade on update cascade not null
);


Section 2. 
--------------
insert into volunteers("name", phone_number, address, animal_id, department_id)
VALUES
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223', NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5)
;

insert into animals("name", birthdate, owner_id, animal_type_id)
VALUES 
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4)
;

------
select id from owners where name = 'Kaloqn Stoqnov'

update animals
set owner_id = 4
where owner_id is null

select * from animals

------
select * from volunteers

select * from volunteers_departments where department_name = 'Education program assistant'

Delete from volunteers
where department_id = 2;

Delete from volunteers_departments
where department_name = 'Education program assistant';

Section 3
---------------
drop table animals, animals_cages, cages, owners, volunteers, volunteers_departments
пускаме пак create и insert-a от файла

5--
select 
	name,
	phone_number,
	address,
	animal_id,
	department_id
from volunteers
order by name, animal_id, department_id asc

6--
select 
	a.name,
	at.animal_type,
	TO_CHAR(a.birthdate, 'DD.MM.YYYY')  
from animals as a
join animal_types as at
on a.animal_type_id = at.id
order by name asc;

7--
select 
	o.name as owner,
	count (a.id) as count_of_animals
	
from animals as a
join owners as o
on a.owner_id = o.id
group by o.name
order by count_of_animals desc, owner asc
limit 5

8--
select 
	concat(o.name,' - ', a.name) as "owners - animals",

	o.phone_number,
	ac.cage_id
from owners as o

join animals as a
on o.id = a.owner_id

join animals_cages as ac
on ac.animal_id = a.id

join animal_types as at
on at.id = a.animal_type_id

where at.animal_type = 'Mammals'
order by o.name asc, a.name desc

9--
select 
	v.name as volunteers,
	v.phone_number,
	trim(v.address, 'Sofia, ')
--	substring(trim(replace(v.address, 'Sofia', '')),3) as address

from volunteers as v
join volunteers_departments as vd
on vd.id = v.department_id
where vd.department_name = 'Education program assistant' 
and v.address like  '%Sofia%'
order by v.name as

10--
select 
	a.name as animal,
	--	extract('year' from birthdate) as birth_year,
	TO_CHAR(a.birthdate, 'YYYY') as birth_year,
	at.animal_type

from animals as a
join animal_types as at
ON at.id = a.animal_type_id
	
where not at.animal_type='Birds'
	and a.owner_id is NULL
	and age('01/01/2022', a.birthdate) < '5 year'

order by a.name asc


Section 4
--------------
select 
	count(*)
from volunteers as v
join volunteers_departments as vd
on vd.id = v.department_id
where vd.department_name = 'Zoo events'

CREATE or REPLACE FUNCTION fn_get_volunteers_count_from_department(searched_volunteers_department varchar(30))
RETURNS INT
AS
$$
	DECLARE
	outputt INT;
BEGIN
	select 
		count(*)
	INTO outputt
	from volunteers as v
	join volunteers_departments as vd
	on vd.id = v.department_id
	WHERE vd.department_name=searched_volunteers_department;
	return outputt;
END;
$$
LANGUAGE plpgsql;

--може с и query
CREATE or REPLACE FUNCTION fn_get_volunteers_count_from_department(searched_volunteers_department varchar(30))
RETURNS INT
AS
$$
	DECLARE
	outputt INT;
BEGIN
	RETURN (
	select 
	 count(*)
	from volunteers as v
	join volunteers_departments as vd
	on vd.id = v.department_id
	WHERE vd.department_name=searched_volunteers_department
	);
END;
$$
LANGUAGE plpgsql;

--резултата се връща в outputt със селект
CREATE or REPLACE FUNCTION fn_get_volunteers_count_from_department(searched_volunteers_department varchar(30))
RETURNS INT
AS
$$
	DECLARE
	outputt INT;
BEGIN
	outputt := (
	select 
	 count(*)
	from volunteers as v
	join volunteers_departments as vd
	on vd.id = v.department_id
	WHERE vd.department_name=searched_volunteers_department
	);
	RETURN outputt;
END;
$$
LANGUAGE plpgsql;


---------
procedure
create or replace procedure sp_animals_with_owners_or_not(
	in animal_name varchar(30),
	out result varchar(30))
AS
$$
BEGIN
	result := (
		select 
		o.name
		from animals as a
		join owners as o
		on o.id = a.owner_id
		where a.name = animal_name);
	IF result is null then result :='For adoption';
	END IF;
END;
$$
LANGUAGE plpgsql;

