CREATE DATABASE go_roadie;
USE go_roadie;

-- SECTION 1
-- 01
CREATE TABLE cities(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE instructors(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    has_a_license_from DATE NOT NULL
);

CREATE TABLE driving_schools(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    night_time_driving BOOL NOT NULL,
    average_lesson_price DECIMAL(10, 2),
    car_id INT NOT NULL,
    city_id INT NOT NULL,
    
     FOREIGN KEY (car_id)
     REFERENCES cars(id),
     
     FOREIGN KEY (city_id)
     REFERENCES cities(id)
);

CREATE TABLE students(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    age INT,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE instructors_driving_schools(
	instructor_id INT,
    driving_school_id INT NOT NULL,
    
    KEY (instructor_id, driving_school_id),
    
    FOREIGN KEY (instructor_id)
	REFERENCES instructors(id),
    
    FOREIGN KEY (driving_school_id)
	REFERENCES driving_schools(id)
);

CREATE TABLE instructors_students(
	instructor_id INT NOT NULL,
    student_id INT NOT NULL,
    
    KEY (instructor_id, student_id),
    
    FOREIGN KEY (instructor_id)
	REFERENCES instructors(id),
    
    FOREIGN KEY (student_id)
	REFERENCES students(id)
);

-- SECTION 2
-- 02
INSERT INTO students(first_name, last_name, age, phone_number) 
SELECT 
reverse(lower(first_name)), 
reverse(lower(last_name)),
-- age + LEFT(phone_number, 1)
age + CAST(substr(phone_number, 1, 1) AS UNSIGNED),
CONCAT('1+', phone_number) 
FROM students
WHERE age < 20;


-- 03
UPDATE driving_schools AS ds
JOIN cities AS c
ON ds.city_id = c.id
SET average_lesson_price = average_lesson_price + 30
WHERE c.name = 'London' AND ds.night_time_driving IS TRUE;

-- 04
DELETE FROM driving_schools 
WHERE night_time_driving IS FALSE;

-- SECTION 3
-- 05
SELECT CONCAT(first_name, " ", last_name) AS full_name, age
 FROM students
 WHERE first_name LIKE '%a%' AND age = (SELECT MIN(age) FROM students)
ORDER BY id;

-- 06
SELECT ds.id, ds.name, c.brand
FROM driving_schools AS ds
JOIN cars AS c
ON ds.car_id = c.id
LEFT JOIN instructors_driving_schools AS ids
ON ds.id = ids.driving_school_id
LEFT JOIN instructors AS i
ON ids.instructor_id = i.id
WHERE has_a_license_from IS NULL
ORDER BY c.brand, id
LIMIT 5;

-- 07
SELECT i.first_name, i.last_name,
 COUNT(*) AS students_count, c.name
 FROM instructors AS i
JOIN instructors_driving_schools AS ids
ON i.id = ids.instructor_id
JOIN driving_schools AS ds
ON ids.driving_school_id = ds.id
JOIN cities AS c
ON ds.city_id = c.id
JOIN instructors_students AS isc
ON i.id = isc.instructor_id
JOIN students AS s
ON isc.student_id = s.id
GROUP BY i.first_name, i.last_name, c.name
HAVING students_count > 1
ORDER BY students_count DESC, i.first_name;


-- 08
SELECT c.name, COUNT(*) AS instructors_count FROM instructors AS i
JOIN instructors_driving_schools AS ids
ON i.id = ids.instructor_id
JOIN driving_schools AS ds
ON ids.driving_school_id = ds.id
JOIN cities AS c
ON ds.city_id = c.id
GROUP BY c.name
ORDER BY instructors_count DESC;

-- 09
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
CASE 
	WHEN YEAR(has_a_license_from) BETWEEN 1980 AND 1989 THEN "Specialist"
	WHEN YEAR(has_a_license_from) BETWEEN 1990 AND 1999 THEN "Advanced"
	WHEN YEAR(has_a_license_from) BETWEEN 2000 AND 2007 THEN "Experienced"
	WHEN YEAR(has_a_license_from) BETWEEN 2008 AND 2014 THEN "Qualified"
	WHEN YEAR(has_a_license_from) BETWEEN 2015 AND 2019 THEN "Provisional"
	WHEN YEAR(has_a_license_from) >= 2020 THEN "Trainee"
END AS level
 FROM instructors
 ORDER BY YEAR(has_a_license_from), first_name;
 
 -- SECTION 4
 -- 10
SELECT AVG(average_lesson_price)
FROM cities AS c
JOIN driving_schools AS ds
ON c.id = ds.city_id
WHERE c.name = 'London';
 
 DELIMITER $$
 CREATE FUNCTION udf_average_lesson_price_by_city(target_name VARCHAR(40)) 
 RETURNS DECIMAL(19, 2)
 DETERMINISTIC
 BEGIN
	RETURN (SELECT AVG(ds.average_lesson_price)
			FROM cities AS c
			JOIN driving_schools AS ds
			ON c.id = ds.city_id
			WHERE c.name = target_name);
 END $$
 
 DELIMITER ;
 
SELECT udf_average_lesson_price_by_city('London');


-- 11
DELIMITER $$
CREATE PROCEDURE udp_find_school_by_car(target_brand VARCHAR(20))
BEGIN
	SELECT  ds.name, ds.average_lesson_price
	FROM cars AS c
	JOIN driving_schools AS ds
	ON c.id = ds.car_id
	WHERE c.brand = target_brand
    ORDER BY average_lesson_price DESC;
END $$

DELIMITER ;

CALL udp_find_school_by_car('Mercedes-Benz');
