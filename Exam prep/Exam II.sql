TAXI_DB

Section 1.
-------------
create table addresses(
	id serial primary key,
	name Varchar(100) not null
);

create table categories(
	id serial primary key,
	name Varchar(10) not null
);

create table clients(
	id serial primary key,
	full_name Varchar(50) not null,
	phone_number Varchar(20) not null
);

create table drivers (
	id serial primary key,
	first_name Varchar(30) not null,
	last_name Varchar(30) not null,
	age int not null,
	rating numeric(2) default 5.5,
	
	constraint check_age CHECK (age > 0)
);

create table cars(
	id serial primary key,
	make varchar(20) not null,
	model varchar(20),
	year int default 0 not null,
	mileage int default 0,
	condition char(1) not null, 
	category_id int references categories on delete cascade on update cascade not null
	
	constraint check_year CHECK (year > 0),
	constraint check_mileage CHECK (mileage > 0)	
);

create table courses(
	id serial primary key,
	from_address_id int references addresses on delete cascade on update cascade not null,
	start timestamp not null,
	bill numeric(10, 2) default 10,
	car_id int references cars on delete cascade on update cascade not null,
	client_id int references clients on delete cascade on update cascade not null,

	constraint check_bill CHECK (bill > 0)
);

create table cars_drivers(
	car_id int references cars on delete cascade on update cascade not null,
	driver_id int references drivers on delete cascade on update cascade not null
);

Section 2.
-------------
insert into clients(full_name, phone_number)
select 
	first_name || ' ' || last_name,
	 '(088) 9999' || id *2
from drivers
where id between 10 and 20

2--
update cars 
set condition = 'C'
where (mileage >= 800000 or mileage is NULL)
	and year <= 2010
	and make != 'Mercedes-Benz'

3--
Delete from volunteers
where department_id = 2;

Delete from volunteers_departments
where department_name = 'Education program assistant';


Section 3.
-------------
5--
select 
	make,
	model,
	condition
from cars
order by id

6--
select 
	d.first_name,
	d.last_name,
	c.make,
	c.model,
	c.mileage
from cars as c
join cars_drivers as cd
on c.id = cd.car_id
join drivers as d
on cd.driver_id = d.id
where c.mileage is not null
order by c.mileage desc, d.first_name asc

7--
select
	cars.id as car_id,
	cars.make,
	cars.mileage,
	count(courses.id) as count_of_courses,
	round(avg(courses.bill),2) as average_bill

from cars
left join courses
on cars.id = courses.car_id

group by cars.id
HAVING count(courses.id) != 2
order by count_of_courses desc, 
cars.id asc

8--
select
	cl.full_name,
	count(cou.car_id) as count_of_cars,
	sum(cou.bill) as total_sum

from clients as cl
join courses as cou
on cl.id = cou.client_id

--where substring(cl.full_name, 2, 1) = 'a'
where cl.full_name like '_a%'
GROUP by cl.full_name
having count(cou.car_id) > 1
order by cl.full_name

9--
select
 	a.name as address,
	CASE
		WHEN EXTRACT(hour from co.start) BETWEEN 6 AND 20 THEN 'Day'
	ELSE 'Night'
	
	--работи и така но не и в джъдж	
	CASE
		WHEN TO_CHAR(co.start, 'HH24')::int BETWEEN 6 AND 20 THEN 'Day'
		WHEN TO_CHAR(co.start, 'HH24')::int BETWEEN 1 AND 5 THEN 'Night'
		WHEN TO_CHAR(co.start, 'HH24')::int BETWEEN 21 AND 24 THEN 'Night'
	
	END AS day_time,
	co.bill,
	cl.full_name,
	cars.make,
	cars.model,
	cat.name as category_name
	
from cars 
join courses as co
on co.car_id = cars.id	

join addresses as a
on a.id = co.from_address_id

join clients as cl
on cl.id = co.client_id

join categories as cat
on cat.id = cars.category_id

order by co.id

Section 4.
-------------

select

	count(c.full_name)
from courses as co
join clients as c
on c.id = co.client_id
where c.phone_number = '(803) 6386812'

CREATE or REPLACE FUNCTION fn_courses_by_client(
	phone_num varchar(20)
)
RETURNS INT
AS
$$
	
	BEGIN
		RETURN(select
				count(c.full_name)
			from courses as co
			join clients as c
			on c.id = co.client_id
			where c.phone_number = phone_num);
			

END;
$$
LANGUAGE plpgsql;

SELECT fn_courses_by_client('(803) 6386812')


procedure
------------


