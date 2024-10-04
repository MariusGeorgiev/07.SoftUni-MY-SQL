-- 01
SELECT 
	e.employee_id,
    CONCAT_WS(' ', first_name, last_name) AS 'full_name',
    d.department_id,
    d.name AS 'department_name'
FROM employees AS e
JOIN departments AS d
	ON e.employee_id = d.manager_id
ORDER BY employee_id
LIMIT 5;

-- 02
SELECT t.town_id, t.name, a.address_text FROM towns AS t
JOIN addresses AS a
	ON t.town_id = a.town_id
WHERE t.name IN('San Francisco', 'Sofia', 'Carnation')
ORDER BY t.town_id;

-- 03
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees 
WHERE manager_id IS NULL;

-- 04
SELECT COUNT(*)
FROM employees 
WHERE salary > (
	SELECT AVG(salary) FROM employees);