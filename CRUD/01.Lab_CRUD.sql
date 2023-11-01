
serial == auto increment - в др.езици

--01.Create a Table
CREATE TABLE person (
	id serial PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20)
);
INSERT INTO person (first_name, last_name)
VALUES
 ('Koko', 'Kokov'),
 ('Boko', 'Bokob');
 
CREATE SEQUENCE person_id_by_2
START 4 
INCREMENT 2
OWNED BY person.id

--на реrson правим дефолт да е нашия сикуенс
alter table person 
alter column id set default nextval ('person_id_by_2');

сега сикуенса на id ще е 1 2 4 6 , през 2


