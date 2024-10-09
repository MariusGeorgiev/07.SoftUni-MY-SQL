-- SECTION 1 Data Definition Language
-- is 40 pts. +exe = 3.00 
-- 0.0 Create and Use Database
CREATE DATABASE wildlife;
USE wildlife;

-- 0.1 Create all tables with thirs requirements
CREATE TABLE continents(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    country_code VARCHAR(10) NOT NULL UNIQUE,
    continent_id INT NOT NULL,
    
    FOREIGN KEY (continent_id)
    REFERENCES  continents(id)
);

CREATE TABLE preserves(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    area INT,
    type VARCHAR(20),
    established_on DATE
);

CREATE TABLE positions(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    description TEXT,
    is_dangerous BOOLEAN NOT NULL
);

CREATE TABLE workers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT,
    personal_number VARCHAR(20) NOT NULL UNIQUE,
    salary DECIMAL(19,2),
    is_armed BOOLEAN NOT NULL,
    start_date DATE,
    preserve_id INT,
    position_id INT NOT NULL,
    
    FOREIGN KEY (preserve_id)
    REFERENCES  preserves(id),
    
	FOREIGN KEY (position_id)
    REFERENCES positions(id)
);

CREATE TABLE countries_preserves(
	country_id INT NOT NULL,
    preserve_id INT NOT NULL,
    
    KEY (country_id, preserve_id),
	FOREIGN KEY (country_id)
    REFERENCES  countries(id),
    
	FOREIGN KEY (preserve_id)
    REFERENCES preserves(id)
);

-- SECTION 2 Data Manipulation Language
-- is 30 pts. + previous and exe. = 3.85

-- 02 Insert data with Select 
INSERT INTO preserves(name, latitude, longitude, area, type, established_on)
SELECT CONCAT(name, ' is in South Hemisphere'), 
latitude, longitude, 
area * id,
LOWER(type),
established_on
FROM preserves
WHERE latitude < 0;

-- 03 Update data
UPDATE workers SET salary = salary + 500
WHERE position_id IN (5, 8, 11, 13);

-- 04.00. dissable safe mod for update 
SET SQL_SAFE_UPDATES = 0;
-- 04 Delete data
DELETE FROM preserves WHERE established_on IS NULL;

-- SECTION 3  QUERYING 
-- is 50 pts + two previous and exe. = 5.50
-- 05 
SELECT CONCAT(first_name, " ", last_name) AS full_name, 
DATEDIFF('2024-01-01', start_date) AS days_of_experience FROM workers
WHERE 2024 - YEAR(start_date) > 5
-- WHERE TIMESTAMPDIFF(YEAR, start_date, '2024-01-01') > 5
ORDER BY days_of_experience DESC
LIMIT 10;

-- 06
SELECT w.id, w.first_name, 
w.last_name, p.name AS preserve_name, 
c.country_code
FROM workers AS w
JOIN preserves AS p
ON w.preserve_id = p.id
JOIN countries_preserves AS cp
ON p.id = cp.preserve_id
JOIN countries AS c 
ON cp.country_id = c.id
WHERE w.salary > 5000 AND w.age < 50
ORDER BY c.country_code;

-- 07
SELECT p.name AS preserve_name, COUNT(*) AS armed_workers FROM workers AS w
JOIN preserves AS p
ON w.preserve_id = p.id
WHERE w.is_armed > 0
GROUP BY p.name
ORDER BY armed_workers DESC, p.name ;

-- 08
SELECT p.name, c.country_code, YEAR(established_on) AS founded_in FROM preserves AS p
JOIN countries_preserves AS cp
ON p.id = cp.preserve_id
JOIN countries AS c
ON cp.country_id = c.id
WHERE MONTH(established_on) = 5
ORDER BY founded_in;

-- 09
SELECT id, name,
CASE 
 WHEN area <= 100 THEN 'very small'
 WHEN area < 1000 THEN 'small'
 WHEN area < 10000 THEN 'medium'
 WHEN area < 50000 THEN 'large'
 ELSE  'very large'
END AS category
FROM preserves
ORDER BY area DESC;

-- SECTION 4 Programmability
-- is 30 pts + three previous and exe. = 6.00

-- 10
SELECT p.name, AVG(w.salary) AS position_average_salary 
FROM workers AS w
JOIN positions AS p
ON w.position_id = p.id
WHERE p.name = "Forester"
GROUP BY p.name;

DELIMITER $$
CREATE FUNCTION udf_average_salary_by_position_name(target_name VARCHAR(40))
RETURNS DECIMAL(19,2)
DETERMINISTIC
BEGIN
	RETURN	(SELECT AVG(w.salary)
		FROM workers AS w
		JOIN positions AS p
		ON w.position_id = p.id
		WHERE p.name = target_name);

END $$
DELIMITER ;

SELECT udf_average_salary_by_position_name('Forester');

-- 11
SELECT first_name, last_name, salary FROM workers AS w 
JOIN preserves AS p ON w.preserve_id = p.id
JOIN countries_preserves AS cp ON p.id = cp.preserve_id
JOIN countries AS c ON cp.country_id = c.id
WHERE c.name = 'Germany';

DELIMITER $$
CREATE PROCEDURE udp_increase_salaries_by_country(country_name VARCHAR(40))
BEGIN 
		UPDATE workers AS w 
        JOIN preserves AS p ON w.preserve_id = p.id
        JOIN countries_preserves AS cp ON p.id = cp.preserve_id
        JOIN countries AS c ON cp.country_id = c.id
        SET salary = salary * 1.05
        WHERE c.name = country_name;
        
END $$

DELIMITER ;

CALL udp_increase_salaries_by_country('Germany');
