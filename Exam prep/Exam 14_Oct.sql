soccer_talent_db

Create table towns(
	id serial primary key,
	name varchar(45) not null
);

Create table stadiums(
	id serial primary key,
	name varchar(45) not null,
	capacity int not null,
	town_id integer REFERENCES towns on delete cascade on update cascade not null,

	constraint capacity_poz check (capacity > 0)
);

Create table teams(
	id serial primary key,
	name varchar(45) not null,
	established date not null,
	fan_base int DEFAULT 0 not null,
	stadium_id integer REFERENCES stadiums on delete cascade on update cascade not null,

	constraint fan_base_poz CHECK (fan_base >= 0)
);

Create table coaches(
	id serial primary key,
	first_name varchar(10) not null,
	last_name varchar(20) not null,
	salary numeric(10, 2) DEFAULT 0 not null,
	coach_level integer DEFAULT 0 not null,	

	constraint salary_poz CHECK (salary >= 0),
	constraint coach_level_poz CHECK (coach_level >= 0)
);

Create table skills_data(
	id serial primary key,
	dribbling int DEFAULT 0,
	pace int DEFAULT 0,
	"passing" int DEFAULT 0,
	shooting int DEFAULT 0,
	speed int DEFAULT 0,
	strength int DEFAULT 0,

	constraint dribbling_poz CHECK (dribbling >= 0),
	constraint pace_poz CHECK (pace >= 0),
	constraint passing_poz CHECK ("passing" >= 0),
	constraint shooting_poz CHECK (shooting >= 0),
	constraint speed_poz CHECK (speed >= 0),
	constraint strength_poz CHECK (strength>= 0)
	
);

Create table players(
	id serial primary key,
	first_name varchar(10) not null,
	last_name varchar(20) not null,
	age int DEFAULT 0 not null,
	"position" char(1) not null,
	salary numeric(10, 2) DEFAULT 0 not null,
	hire_date TIMESTAMP,
	skills_data_id integer REFERENCES skills_data on delete cascade on update cascade not null,
	team_id integer REFERENCES teams on delete cascade on update cascade

	constraint age_poz CHECK (age >= 0),
	constraint salary_poz CHECK (salary >=0)
	
);

Create table players_coaches(
	player_id int REFERENCES players on delete cascade on update cascade,
	coach_id int REFERENCES coaches on delete cascade on update cascade

);

Section 2
---------
insert into coaches (first_name, last_name, salary, coach_level)
select 
	first_name,
	last_name,
	salary*2 as salary,
	LENGTH(first_name) as coach_level

from players
where hire_date < '2013-12-13 07:18:46';

2--
update coaches
set salary = salary * coach_level
where first_name like 'C%'

3--
delete from players
where hire_date < '2013-12-13 07:18:46';

delete from players_coaches
where player_id in (
	select 
	id
	from players
	where hire_date < '2013-12-13 07:18:46' 
);

Section 3.
-----------
3.5---
select 
	concat(first_name, ' ', last_name) as full_name,
	age,
	hire_date
from players
where concat(first_name, ' ', last_name) like 'M%'
order by age desc, full_name

3.6---
select 
 	p.id,
	concat(p.first_name, ' ', p.last_name) as full_name,
	p.age,
	p.position,
	p.salary,
	sd.pace,
	sd.shooting

from players as p
left join teams as t
on t.id = p.team_id
join skills_data as sd
on sd.id = p.skills_data_id
where position = 'A' and t.id is NULL and (sd.pace + sd.shooting)>130

3.7--
select 
	t.id as team_id,
	t.name as team_name,
	count(p.id) as player_count,
	t.fan_base
from teams as t
left join players as p
on t.id = p.team_id
where  (t.fan_base >30000)
group by t.id
order by player_count desc, t.fan_base desc, player_count desc

3.8--
select 
	concat(c.first_name, ' ', c.last_name) as coach_full_name,
	concat(p.first_name, ' ', p.last_name) as player_full_name,
	t.name, 
	sd.passing,
	sd.shooting,
	sd.speed
from coaches as c
join players_coaches as pc
on pc.coach_id = c.id
join players as p
on p.id = pc.player_id
join teams as t
on t.id = p.team_id
join skills_data as sd
on sd.id = p.skills_data_id
order by coach_full_name asc, player_full_name desc

Section 4.
-----------

DROP FUNCTION fn_stadium_team_name

CREATE or REPLACE FUNCTION fn_stadium_team_name(
	stadium_name varchar(30)
)
RETURNS TABLE (team_name varchar)
AS
$$
	
	BEGIN
		RETURN QUERY(select 
					t.name
				from teams as t
				join stadiums as s
				on t.stadium_id = s.id
				WHERE s."name" = stadium_name
				order by t.name asc);
			

END;
$$
LANGUAGE plpgsql;

SELECT fn_stadium_team_name('Jaxworks')

procedure
------------

select 
	--concat(p.first_name, ' ', p.last_name, ''),
	t.name	
from teams as t
join players as p
on p.team_id = t.id
WHERE concat(p.first_name, ' ', p.last_name, '') = 'Walther Olenchenko'


create or replace procedure sp_players_team_name(
	in player_name varchar(50),
	out team_name varchar(50))
AS
$$
BEGIN
	team_name := (
			select 
				t.name	
			from teams as t
			join players as p
			on p.team_id = t.id
			WHERE concat(p.first_name, ' ', p.last_name, '') = player_name);
	IF team_name is null then team_name :='The player currently has no team';
	END IF;
END;
$$
LANGUAGE plpgsql;


CALL sp_players_team_name('Walther Olenchenko', '')


