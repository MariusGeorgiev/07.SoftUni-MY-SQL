-- 01
SELECT first_name, last_name FROM employees
WHERE first_name LIKE 'sa%'
ORDER BY employee_id;

-- 02
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

-- 03
SELECT first_name FROM employees
WHERE (department_id = 3 OR department_id = 10) AND 
YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;

-- 04
SELECT first_name, last_name FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;

-- 05
SELECT name FROM towns
WHERE LENGTH(name) IN (5,6)
ORDER BY name;


-- 06
SELECT town_id, name FROM towns
WHERE LEFT(name , 1) IN ('M','K','B','E')
ORDER BY name;

-- 07
SELECT town_id, name FROM towns
WHERE LEFT(name , 1) NOT IN ('R','B','D')
ORDER BY name;

-- 08
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) > 2000;
SELECT * FROM v_employees_hired_after_2000;

-- 09
SELECT first_name, last_name FROM employees
WHERE LENGTH(last_name) = 5;

-- 10
SELECT country_name, iso_code FROM countries
WHERE country_name LIKE '%A%A%A%'
ORDER BY iso_code;

-- 11
SELECT peak_name, river_name,
LOWER(CONCAT(peak_name, SUBSTRING(river_name, 2))) AS mix
FROM peaks, rivers
WHERE RIGHT(peak_name, 1) = LEFT(river_name, 1)
ORDER BY mix;

-- 12
SELECT name, DATE_FORMAT(start, '%Y-%m-%d') AS start
 FROM games
WHERE EXTRACT(YEAR FROM start) IN (2011, 2012)
ORDER BY start, name
LIMIT 50;


-- 13
SELECT user_name, SUBSTR(email, LOCATE('@', email) +1 ) AS `email provider`
FROM users
ORDER BY `email provider`, user_name;

-- 14
SELECT user_name, ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

-- 14 With regex
SELECT user_name, ip_address FROM users
WHERE ip_address REGEXP '^[0-9]{3}[.]1[0-9]*[.][0-9]*[.][0-9]{3}$'
ORDER BY user_name;

-- 15
SELECT name,
CASE 
	WHEN HOUR(start) < 12 THEN 'Morning'
    WHEN HOUR(start) < 18 THEN 'Afternoon'
    WHEN HOUR(start) < 24 THEN 'Evening'
END as `Part of the Day`,
CASE
	WHEN duration <= 3 THEN 'Extra Short'
	WHEN duration <= 6 THEN 'Short'
    WHEN duration <= 10 THEN 'Long'
    ELSE "Extra Long"
END as Duration
FROM games;

-- 16
SELECT product_name, order_date,
DATE_ADD(order_date, INTERVAL 3 DAY) AS pay_due,
DATE_ADD(order_date, INTERVAL 1 MONTH) AS dilever_due
 FROM orders;