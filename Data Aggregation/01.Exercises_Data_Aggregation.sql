--1.COUNT of Records
SELECT 
	count(*) AS "Count"
FROM wizard_deposits
	
--2.Total Deposit Amount
SELECT 
	SUM(deposit_amount) AS "total_amount"
FROM wizard_deposits

--3.AVG Magic Wand Size
SELECT 
	ROUND(AVG(magic_wand_size), 3) AS average_magic_wand_size
FROM wizard_deposits

--4.MIN Deposit Charge
SELECT 
	MIN(deposit_charge) AS minimum_deposit_charge
FROM wizard_deposits

--5.MAX Age
SELECT 
	MAX(age) AS maximum_age
FROM wizard_deposits

--6.GROUP BY Deposit Interest
SELECT
	deposit_group,
	SUM(deposit_interest) AS "Deposit Interest"
	
FROM wizard_deposits
GROUP BY deposit_group
ORDER BY "Deposit Interest" DESC;

--7.LIMIT the Magic Wand Creator
SELECT
	magic_wand_creator,
	MIN(magic_wand_size) AS "minimum_wand_size"
	
FROM wizard_deposits
GROUP BY magic_wand_creator
ORDER BY "minimum_wand_size" ASC
LIMIT 5;

--8.Bank Profitability
SELECT
	deposit_group,
	is_deposit_expired,
	Floor(AVG(deposit_interest)) AS "Deposit Interest"
FROM wizard_deposits

WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group, is_deposit_expired

ORDER BY "deposit_group" DESC,
		is_deposit_expired ASC;

--9.Notes with Dumbledore
SELECT
	last_name,
	count(notes)
FROM wizard_deposits

WHERE notes LIKE('%Dumbledore%')
GROUP BY last_name

--10.Wizard View
CREATE VIEW "view_wizard_deposits_with_expiration_date_before_1983_08_17"
AS SELECT
	CONCAT(first_name, ' ', last_name) AS "Wizard Name",
	deposit_start_date AS "Start Date",
	deposit_expiration_date AS "Expiration Date",
	SUM(deposit_amount) AS "Amount"
		
FROM wizard_deposits
WHERE deposit_expiration_date <= '1983-08-17'
GROUP BY "Wizard Name", 
	"Start Date",
	"Expiration Date"
ORDER BY "Expiration Date" ASC

--11.Filter Max Deposit
SELECT
	magic_wand_creator,
	MAX(deposit_amount)
	
FROM wizard_deposits
GROUP BY magic_wand_creator, 
	deposit_amount
ORDER BY deposit_amount DESC
LIMIT 3

--12.Age Group
SELECT
	CASE
		WHEN age >=0 AND age <=10 THEN '[0-10]'
		WHEN age >=11 AND age <=20 THEN '[11-20]'
		WHEN age >=21 AND age <=30 THEN '[21-30]'
		WHEN age >=31 AND age <=40 THEN '[31-40]'
		WHEN age >=41 AND age <=50 THEN '[41-50]'
		WHEN age >=51 AND age <=60 THEN '[51-60]'
		WHEN age >=61 THEN '[61+]'
		ELSE 'Other'
	END AS age_group,
	COUNT(age) AS "count"
	
FROM wizard_deposits
GROUP BY age_group
ORDER BY age_group ASC

--13.SUM the Employees
SELECT 
	COUNT(CASE WHEN department_id = 1 THEN 1 END) AS "Engineering",
	COUNT(CASE WHEN department_id = 2 THEN 1 END) AS "Tool Design",
	COUNT(CASE WHEN department_id = 3 THEN 1 END) AS "Sales",
	COUNT(CASE WHEN department_id = 4 THEN 1 END) AS "Marketing",
	COUNT(CASE WHEN department_id = 5 THEN 1 END) AS "Purchasing",
	COUNT(CASE WHEN department_id = 6 THEN 1 END) AS "Research and Development",
	COUNT(CASE WHEN department_id = 7 THEN 1 END) AS "Production"

FROM employees;

--14.Update Employees' Data
SELECT 
	job_title,
	CASE 
		WHEN AVG(salary) > 45800 THEN 'Good'
		WHEN AVG(salary) BETWEEN 27500 AND 45800 THEN 'Medium'
		WHEN AVG(salary) < 27500 THEN 'Need Improvement'
	END AS "category"
	
FROM employees
GROUP BY job_title
ORDER BY "category" ASC, job_title ASC

--15.Categorizes Salary
SELECT 
	job_title,
	CASE 
		WHEN AVG(salary) > 45800 THEN 'Good'
		WHEN AVG(salary) BETWEEN 27500 AND 45800 THEN 'Medium'
		WHEN AVG(salary) < 27500 THEN 'Need Improvement'
	END AS "category"
	
FROM employees
GROUP BY job_title
ORDER BY "category" ASC, job_title ASC

--16.WHERE Project Status
SELECT 
	project_name,
	CASE
		WHEN start_date IS NULL AND end_date IS NULL THEN 'Ready for development'
		WHEN start_date IS NOT NULL AND end_date IS NULL THEN 'In Progress'
		ELSE 'Done'
	END AS project_status
	
FROM projects
WHERE project_name LIKE '%Mountain%';

--17.HAVING Salary Level
SELECT 
	department_id,
	COUNT(first_name) AS num_employees,
	CASE
		WHEN AVG(salary) > 50000 THEN 'Above average'
		WHEN AVG(salary) <= 50000 THEN 'Below average'
	END AS salary_level

FROM employees

GROUP by department_id
HAVING AVG(salary) > 30000
ORDER BY department_id

--18.*Nested CASE Conditions

--19.* Foreign Key

--20.* JOIN Tables
