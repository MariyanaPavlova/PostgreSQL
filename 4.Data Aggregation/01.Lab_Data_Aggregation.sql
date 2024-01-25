--Departments Info (by id)
SELECT 
	department_id,
	count(department_id)
FROM employees
GROUP BY department_id
ORDER BY department_id ASC

--Departments Info (by salary)
SELECT 
	department_id,
	count(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id ASC

--Sum Salaries per Department
SELECT 
	department_id,
	sum(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id ASC

--Maximum Salary per Department
SELECT 
	department_id,
	MAX(salary) AS "max_salary"
FROM employees
GROUP BY department_id
ORDER BY department_id

--Minimum Salary per Department
SELECT 
	department_id,
	MIN(salary) AS "min_salary"
FROM employees
GROUP BY department_id
ORDER BY department_id

--Average Salary per Department
SELECT 
	department_id,
	AVG(salary) AS "avg_salary"
FROM employees
GROUP BY department_id
ORDER BY department_id

--Filter Total Salaries
SELECT 
	department_id,
	sum(salary) AS "Total Salary"
FROM employees
GROUP BY department_id
HAVING sum(salary) <= 4200
ORDER BY department_id

--Department Names
SELECT 
	id,
	first_name,
	last_name,
	trunc(salary,2),
	department_id,
	CASE
		WHEN department_id = 1 THEN 'Management'
		WHEN department_id = 2 THEN 'Kitchen Staff'
		WHEN department_id = 1 THEN 'Service Staff'
		ELSE 'Other'
	END AS department_name
FROM employees

