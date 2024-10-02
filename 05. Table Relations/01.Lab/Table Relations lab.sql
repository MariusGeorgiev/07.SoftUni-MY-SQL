-- 01
CREATE TABLE mountains(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100)
);

CREATE TABLE peaks(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
mountain_id INT,

CONSTRAINT fk_peaks_mountains
FOREIGN KEY (mountain_id)
REFERENCES mountains(id)
);

-- 02
SELECT v.driver_id, v.vehicle_type,
CONCAT(c.first_name, " ", c.last_name) AS driver_name
FROM vehicles AS v
JOIN campers AS c ON v.driver_id = c.id;

-- 03
SELECT starting_point AS route_starting_point,
end_point AS route_ending_point, leader_id,
CONCAT(c.first_name, ' ', c.last_name) AS leader_name
FROM routes AS r
JOIN campers AS c ON c.id = r.leader_id;

-- 04
CREATE TABLE mountains(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE peaks(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    mountain_id INT,
    
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
    ON DELETE CASCADE
);

-- 04 inserts 
INSERT INTO mountains(name) VALUES
('Vitosha'), ('Rila');

INSERT INTO peaks(name, mountain_id) VALUES
('Cherni Vrah', 1), 
('Musala', 2),
('Malyovica', 2);

-- 05
CREATE DATABASE lab_05;
USE lab_05;

CREATE TABLE clients(
	id 	INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100)
);

CREATE TABLE projects(
	id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    project_lead_id INT,
    
    FOREIGN KEY (client_id)
    REFERENCES clients(id)
);

CREATE TABLE employees(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    project_id INT,
    
	FOREIGN KEY (project_id)
    REFERENCES projects(id)
);

ALTER TABLE projects
ADD FOREIGN KEY (project_lead_id)
REFERENCES employees(id);