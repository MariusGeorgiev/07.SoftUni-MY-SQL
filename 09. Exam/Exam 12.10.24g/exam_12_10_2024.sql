CREATE DATABASE summer_olympics;
USE summer_olympics;

-- SECTION 1
-- 01
CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE sports(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE disciplines(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    sport_id INT NOT NULL,
    
    FOREIGN KEY (sport_id)
    REFERENCES sports(id)
    
);

CREATE TABLE athletes(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT NOT NULL,
    country_id INT NOT NULL,
    
    FOREIGN KEY (country_id)
    REFERENCES countries(id)
);

CREATE TABLE medals(
	id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE disciplines_athletes_medals(
	discipline_id INT NOT NULL,
    athlete_id INT NOT NULL,
    medal_id INT NOT NULL,

   PRIMARY KEY (discipline_id, athlete_id),
   FOREIGN KEY (discipline_id)
   REFERENCES disciplines(id),
   
	FOREIGN KEY (athlete_id)
    REFERENCES athletes(id),
    
    FOREIGN KEY (medal_id)
    REFERENCES medals(id)
    
);

-- SECTION 2
-- 02
INSERT INTO athletes(first_name, last_name, age, country_id)
SELECT UPPER(a.first_name), 
CONCAT(a.last_name, ' comes from ', c.name),
a.age + a.country_id,
a.country_id
FROM athletes AS a
JOIN countries AS c
ON a.country_id = c.id
WHERE c.name LIKE 'A%';

-- 03
UPDATE disciplines
SET name = REPLACE(name, 'weight', '')
WHERE name LIKE '%weight%';

SELECT * FROM disciplines;

-- 04
DELETE FROM athletes
WHERE age > 35;

-- SECTION 3
-- 05
SELECT c.id, c.name 
FROM countries AS c
LEFT JOIN athletes AS a
ON c.id = a.country_id
WHERE a.id IS NULL
ORDER BY c.name DESC
LIMIT 15;

-- 06
SELECT CONCAT(first_name, ' ', last_name) AS full_name, age
FROM athletes AS a
LEFT JOIN disciplines_athletes_medals AS dam
ON a.id = dam.athlete_id
LEFT JOIN medals AS m
ON dam.medal_id = m.id
WHERE a.age = (SELECT MIN(age) FROM athletes) AND m.id IS NOT NULL
ORDER BY a.id;

-- 07
SELECT a.id, a.first_name, a.last_name 
FROM athletes AS a
LEFT JOIN disciplines_athletes_medals AS dam
ON a.id = dam.athlete_id
LEFT JOIN medals AS m
ON dam.medal_id = m.id
WHERE m.id IS NULL
ORDER BY a.id;

-- 08
SELECT a.id, a.first_name, a.last_name,
 COUNT(*) AS medals_count, s.name 
 FROM athletes AS a
JOIN disciplines_athletes_medals AS dam
ON a.id = dam.athlete_id
JOIN medals AS m
ON dam.medal_id =  m.id
JOIN disciplines AS d
ON dam.discipline_id = d.id
JOIN sports AS s
ON d.sport_id = s.id
GROUP BY a.id, a.first_name, a.last_name, s.name
ORDER BY medals_count DESC, a.first_name
LIMIT 10;


-- 09
SELECT 
CONCAT(first_name, ' ', last_name) AS full_name,
CASE
		WHEN age <= 18 THEN 'Teenager'
		WHEN age <= 25 THEN 'Young adult'
		WHEN age >= 26 THEN 'Adult'
        
END AS age_group
 FROM athletes
ORDER BY age DESC, first_name;

-- SECTION 4
-- 10
SELECT COUNT(*) FROM countries c
JOIN athletes AS a
ON c.id = a.country_id
JOIN disciplines_athletes_medals AS dam
ON a.id = dam.athlete_id
JOIN medals AS m
ON dam.medal_id = m.id
WHERE c.name = 'Bahamas';

DELIMITER $$
CREATE FUNCTION udf_total_medals_count_by_country (target_name VARCHAR(40)) 
RETURNS INT
DETERMINISTIC
BEGIN
			RETURN (SELECT COUNT(*) FROM countries c
					JOIN athletes AS a
					ON c.id = a.country_id
					JOIN disciplines_athletes_medals AS dam
					ON a.id = dam.athlete_id
					JOIN medals AS m
					ON dam.medal_id = m.id
					WHERE c.name = target_name);

END $$

DELIMITER ;

SELECT udf_total_medals_count_by_country('Bahamas');

-- 11
DELIMITER $$
CREATE PROCEDURE udp_first_name_to_upper_case(letter CHAR(1))
BEGIN 
			UPDATE athletes
			SET first_name = CASE 
			WHEN RIGHT(first_name, 1) = letter THEN UPPER(first_name)
			ELSE first_name
			END;

END $$
DELIMITER ;

CALL udp_first_name_to_upper_case ('s');

SELECT * FROM athletes
WHERE RIGHT(first_name, 1) LIKE 's';