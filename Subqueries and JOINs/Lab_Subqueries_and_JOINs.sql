
--01
select 
	t.town_id,
	t.name,
	a.address_text
from towns as t
join addresses as a
on t.town_id = a.town_id
where t.name IN ('San Francisco','Sofia', 'Carnation')
order by t.town_id, a.address_id;

--02
select 
	e.employee_id,
	concat(e.first_name, ' ', e.last_name) as full_name,
	d.department_id,
	d.name as department_name
from employees as e
join departments as d  --може и с RIGHT JOIN
on e.employee_id=d.manager_id
order by employee_id
limit 5

--03
select 
	e.employee_id,
	concat(e.first_name, ' ', e.last_name) as full_name,
	p.project_id,
	p.name
from employees as e
join employees_projects as ep
on e.employee_id=ep.employee_id -- =using(employee_id)
join projects as p
using(project_id)
where p.project_id = 1

--04
select 
	count(*) from employees
where salary > (
	select 
	avg(salary)
	from employees
)

