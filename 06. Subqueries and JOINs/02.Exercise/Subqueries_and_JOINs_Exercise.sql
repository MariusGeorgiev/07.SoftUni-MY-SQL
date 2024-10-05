-- 01
SELECT e.employee_id, e.job_title, e.address_id, a.address_text FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
ORDER BY e.address_id
LIMIT 5;

-- 02
SELECT e.first_name, e.last_name, t.name AS town, a.address_text 
FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

-- 03
SELECT employee_id, first_name, last_name, d.name AS department_name
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY employee_id DESC;

-- 04
SELECT e.employee_id, e.first_name, e.salary, d.name AS department_name
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- 05
SELECT e.employee_id, e.first_name FROM employees AS e
LEFT JOIN employees_projects AS p_id
ON e.employee_id = p_id.employee_id
WHERE project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

-- 06
SELECT first_name, last_name, hire_date, d.name AS dept_name
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE hire_date > '1999-01-01' AND d.name = 'Sales' OR d.name = 'Finance'
ORDER BY hire_date;

-- 07
SELECT e.employee_id, e.first_name, p.name AS project_name FROM employees AS e
JOIN employees_projects AS p_id
ON e.employee_id = p_id.employee_id
JOIN projects AS p
ON p_id.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name, project_name
LIMIT 5;

-- 08
SELECT e.employee_id, e.first_name,
IF(YEAR(p.start_date) >= 2005, NULL, p.name) AS project_name
FROM employees AS e
JOIN employees_projects AS p_id
ON e.employee_id = p_id.employee_id
JOIN projects AS p
ON p_id.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY project_name;

-- 09
SELECT e.employee_id, e.first_name, e.manager_id,
 m.first_name AS manager_name
FROM employees AS e
JOIN employees AS m
ON e.manager_id = m.employee_id
WHERE e.manager_id IN (3, 7)
ORDER BY e.first_name;

-- 10
SELECT e.employee_id, 
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
d.name AS department_name
FROM employees AS e
JOIN employees AS m
ON e.manager_id = m.employee_id
JOIN departments AS d
ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

-- 11
SELECT AVG(salary) AS min_average_salary FROM employees
GROUP BY department_id
ORDER BY min_average_salary
LIMIT 1;

-- 12 
SELECT c.country_code, m.mountain_range, p.peak_name, p.elevation FROM countries AS c
JOIN mountains_countries AS id_m
ON c.country_code = id_m.country_code
JOIN mountains AS m
ON id_m.mountain_id = m.id
JOIN peaks AS p
ON id_m.mountain_id = p.mountain_id
WHERE c.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- 13
SELECT c.country_code, COUNT(*) AS mountain_range
FROM countries AS c
JOIN mountains_countries AS id_m
ON c.country_code = id_m.country_code
WHERE country_name IN('United States', 'Russia', 'Bulgaria')
GROUP BY c.country_code
ORDER BY mountain_range DESC;

-- 14
SELECT c.country_name, r.river_name  FROM countries AS c
LEFT JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
LEFT JOIN rivers AS r
ON cr.river_id = r.id
WHERE continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- 15
SELECT c.continent_code, c.currency_code, COUNT(*) AS currency_usage 
FROM countries AS c
GROUP BY c.continent_code, c.currency_code
HAVING currency_usage > 1 AND 
currency_usage = ( SELECT COUNT(*) AS currency_usage FROM countries
					WHERE continent_code = c.continent_code
                    GROUP BY currency_code
                    ORDER BY currency_usage DESC
					LIMIT 1)
ORDER BY c.continent_code, c.currency_code
;

-- 16
SELECT COUNT(*) AS country_count FROM countries AS c
LEFT JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
WHERE mc.mountain_id IS NULL;

-- 17
SELECT c.country_name, 
MAX(p.elevation) AS highest_peak_elevation, 
MAX(r.length) AS longest_river_length 
FROM countries AS c
JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
JOIN peaks AS p
ON mc.mountain_id = p.mountain_id
JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
JOIN rivers AS r
ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name
LIMIT 5;