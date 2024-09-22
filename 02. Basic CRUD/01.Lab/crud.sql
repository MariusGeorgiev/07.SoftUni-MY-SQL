SELECT id, first_name, last_name, job_title
FROM employees
ORDER BY id;

SELECT
	id AS '#',
    first_name AS 'First Name',
    last_name AS 'Last Name',
    job_title AS 'Title'
FROM employees;

SELECT
	employees.id,
    employees.first_name,
    employees.last_name
FROM hotel.employees;

SELECT
	e.id,
    e.first_name,
    e.last_name
FROM hotel.employees AS e;

SELECT
	id,
    concat(first_name, " ", last_name) AS 'Full Name'
FROM employees;

SELECT
	id,
    concat(first_name, " ", last_name, ' - ', salary, ' lv.') AS 'Full Info'
FROM employees;

SELECT
	id,
    concat_ws(' >> ', first_name, last_name, job_title)
FROM employees;

SELECT
	id,
    concat(first_name, " ", last_name) AS 'full_name',
    job_title,
    salary
FROM employees
WHERE salary > 1000
ORDER BY id;

SELECT
	id,
    first_name
FROM employees
WHERE department_id = 1;

CREATE VIEW `v_dept_1_2_info` AS
	SELECT 
		id AS 'No.',
		concat(first_name, ' ', last_name) AS 'Full Name',
		salary AS 'Salary'
	FROM employees
	WHERE department_id = 1 OR department_id  = 2
	ORDER BY first_name, last_name;


SELECT * FROM v_dept_1_2_info;

CREATE VIEW `v_top_paid_employee` AS
	SELECT * FROM employees
    ORDER BY salary DESC
    LIMIT 1;
    
SELECT * FROM v_top_paid_employee;

SELECT * FROM employees;

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

SELECT salary FROM employees;


 SET SQL_SAFE_UPDATES = 0;
 
 DELETE FROM employees
 WHERE department_id IN (1, 2);
 
 SELECT * FROM employees
 ORDER BY id;
 
 SELECT * FROM employees
 WHERE department_id = 4 AND salary >= 1000
 ORDER BY id;
 
 