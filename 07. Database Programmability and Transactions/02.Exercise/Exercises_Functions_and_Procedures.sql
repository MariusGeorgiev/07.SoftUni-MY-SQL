-- 01 usp_get_employees_salary_above_35000 

DELIMITER $$

CREATE PROCEDURE usp_get_employees_salary_above_35000()
	BEGIN
		SELECT first_name, last_name FROM employees
        WHERE salary > 35000
        ORDER BY first_name, last_name, employee_id;
    END $$

DELIMITER ;

CALL usp_get_employees_salary_above_35000();

-- 02
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above (target_salary DECIMAL(12,4))
 BEGIN
	SELECT first_name, last_name FROM employees
	WHERE salary >= target_salary
	ORDER BY first_name, last_name, employee_id;
 END $$
 
 DELIMITER ;
 
 CALL usp_get_employees_salary_above(48100);
 
 -- 03
 DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with  (chars VARCHAR(20))
 BEGIN
	SELECT name AS town_name FROM towns
	WHERE name LIKE CONCAT(chars, '%')
	ORDER BY name;
 END $$
 
 DELIMITER ;
 
 CALL usp_get_towns_starting_with ("b");
 
 -- 04
  DELIMITER $$
  DROP PROCEDURE IF EXISTS usp_get_employees_from_town;
 CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(50))
 
 
  BEGIN
	SELECT first_name, last_name FROM employees AS e
	JOIN addresses AS a
    ON e.address_id = a.address_id
    JOIN towns AS t
    ON a.town_id = t.town_id
    WHERE name = town_name
	ORDER BY first_name, last_name, employee_id;
 END $$
 
 DELIMITER ;
 
 CALL usp_get_employees_from_town('Sofia');
 
 -- 05
  DETERMINISTIC -- Returns always the same bvalue for given parameters (if it have peramameteres)
 NOT DETERMINISTIC -- Returns different values for given parameters (if it have peramameteres)
 NO SQL -- Doesn't use any table from our DB --> don't execute any SQL query
 READS SQL DATA -- Uses sql data for the query
 
DELIMITER $$
 CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(12,2))
 RETURNS VARCHAR(7)
 NO SQL 
 BEGIN
	DECLARE salary_level VARCHAR(7);
 
		IF (salary < 30000) THEN
			SET salary_level = 'Low';
		ELSEIF (salary BETWEEN 30000 AND 50000) THEN
			SET salary_level = 'Average';
		ELSE 
			SET salary_level = 'High';
		END IF;
 
	RETURN salary_level;
 END $$
 
  DELIMITER ;
  
  SELECT ufn_get_salary_level(50001);
  
  -- 06
  DELIMITER $$
 CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(12,2))
 RETURNS VARCHAR(7)
 NO SQL 
 BEGIN
	DECLARE salary_level VARCHAR(7);
 
		IF (salary < 30000) THEN
			SET salary_level = 'Low';
		ELSEIF (salary BETWEEN 30000 AND 50000) THEN
			SET salary_level = 'Average';
		ELSE 
			SET salary_level = 'High';
		END IF;
 
	RETURN salary_level;
 END $$
 
 CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(7))
 BEGIN
	SELECT first_name, last_name FROM employees
    WHERE salary_level = ufn_get_salary_level(salary)
    ORDER BY first_name DESC, last_name DESC;
 END $$
 
  DELIMITER ;
  
  CALL usp_get_employees_by_salary_level('High');
  
  -- 07
  DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))  
	RETURNS TINYINT
	NO SQL
	BEGIN
		DECLARE output TINYINT;
		SET output = (SELECT word REGEXP CONCAT ('^[', set_of_letters, ']+$'));
		RETURN output;
	END $$

  DELIMITER ;
  
  SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');
  
  -- 08
 DELIMITER $$
 
 CREATE PROCEDURE usp_get_holders_full_name()
 BEGIN
	SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM account_holders
    ORDER BY full_name, id;
 END $$
 
 DELIMITER ;
 
 CALL usp_get_holders_full_name();
 
 -- 09
 DELIMITER $$
 
 CREATE PROCEDURE usp_get_holders_with_balance_higher_than(target_balance DECIMAL(19,4))
 BEGIN
	SELECT first_name, last_name FROM account_holders AS ac
    JOIN accounts AS a
    ON ac.id = a.account_holder_id
    GROUP BY ac.id
    HAVING SUM(balance) > target_balance
    ORDER BY ac.id;
 END $$
 
 DELIMITER ;
 
 CALL usp_get_holders_with_balance_higher_than(7000);
 
 -- 10
 DELIMITER $$
 DROP FUNCTION IF EXISTS ufn_calculate_future_value;
 CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL(12,4), interest_rate DOUBLE(12, 4), years INT)
 RETURNS DECIMAL(12,4)
 NO SQL
 BEGIN
	RETURN (SELECT initial_sum * POW(1 + interest_rate, years));
 END $$
 
 DELIMITER ;
 
 SELECT ufn_calculate_future_value(1000, 0.5, 5);
 
 -- 11
  DELIMITER $$
 DROP FUNCTION IF EXISTS ufn_calculate_future_value;
 CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL(12,4), interest_rate DOUBLE(12, 4), years INT)
 RETURNS DECIMAL(12,4)
 NO SQL
 BEGIN
	RETURN (SELECT initial_sum * POW(1 + interest_rate, years));
 END $$
 
 CREATE PROCEDURE usp_calculate_future_value_for_account(acc_id INT, interest_rate DECIMAL(12,4))
 BEGIN
	SELECT a.id AS account_id, 
		first_name, 
        last_name, 
        balance AS current_balance, 
        ufn_calculate_future_value(balance, interest_rate, 5) AS balance_in_5_years
        FROM accounts AS a
        JOIN account_holders AS ac
        ON a.account_holder_id = ac.id
        WHERE a.id = acc_id;
 END $$
 
 DELIMITER ;
 
CALL usp_calculate_future_value_for_account(1, 0.1);

-- 12
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(acc_id INT, money_amount DECIMAL(12,4))
BEGIN
	 START TRANSACTION;
     IF (money_amount <= 0 OR (SELECT COUNT(*) FROM accounts WHERE id = acc_id) = 0) THEN
		ROLLBACK;
	 ELSE 
			UPDATE accounts SET balance = balance + money_amount
			WHERE id = acc_id;
            COMMIT;
     END IF;
     
END $$

DELIMITER ;

CALL usp_deposit_money(1, 10);
SELECT * FROM accounts WHERE id = 1;

-- 13
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(acc_id INT, money_amount DECIMAL(12,4)) 
BEGIN
	 START TRANSACTION;
     IF (money_amount <= 0 OR (SELECT COUNT(*) FROM accounts WHERE id = acc_id) = 0 
     OR (SELECT balance FROM accounts WHERE id = acc_id) < money_amount ) THEN
	 ROLLBACK;
	 ELSE 
			UPDATE accounts SET balance = balance - money_amount
			WHERE id = acc_id;
            COMMIT;
     END IF;
END $$
DELIMITER ;

CALL usp_withdraw_money(1, 10);
SELECT * FROM accounts WHERE id = 1;

-- 14
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, money_amount DECIMAL(12,4))  
BEGIN
	 START TRANSACTION;
     IF (money_amount <= 0 OR 
     (SELECT COUNT(*) FROM accounts WHERE id = from_account_id) = 0 OR
     (SELECT COUNT(*) FROM accounts WHERE id = to_account_id) = 0 OR
     (SELECT balance FROM accounts WHERE id = from_account_id) < money_amount ) THEN
	 ROLLBACK;
	 ELSE 
			UPDATE accounts SET balance = balance - money_amount
			WHERE id = from_account_id;
            
            UPDATE accounts SET balance = balance + money_amount
			WHERE id = to_account_id;
            COMMIT;
     END IF;
END $$
DELIMITER ;

CALL usp_transfer_money(1, 2, 10);
SELECT * FROM accounts WHERE id = 1 OR id = 2;

-- 15
CREATE TABLE logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_sum DECIMAL(19, 4),
    new_sum DECIMAL(19, 4)
);

CREATE TRIGGER tr_accounts_update
AFTER UPDATE 
ON accounts
FOR EACH ROW
INSERT INTO logs(account_id, old_sum, new_sum) VALUE
(new.id, old.balance, new.balance);

-- 16
CREATE TABLE logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_sum DECIMAL(19, 4),
    new_sum DECIMAL(19, 4)
);

CREATE TRIGGER tr_accounts_update
AFTER UPDATE 
ON accounts
FOR EACH ROW
INSERT INTO logs(account_id, old_sum, new_sum) VALUE
(new.id, old.balance, new.balance);

CREATE TABLE notification_emails(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    recipient INT,
    subject VARCHAR(255),
    body TEXT
);

CREATE TRIGGER tr_logs_insert
AFTER INSERT
ON logs
FOR EACH ROW 
INSERT INTO notification_emails(recipient, subject, body) VALUE
(new.account_id,
CONCAT('Balance change for account: ', new.account_id),
CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y'), ' at ',
DATE_FORMAT(NOW(), '%r'), 'your balance was changed from',
ROUND(new.old_sum, 0), ' to', ROUND(new.new_sum, 0), '.' ));

CALL usp_deposit_money(1, 10);