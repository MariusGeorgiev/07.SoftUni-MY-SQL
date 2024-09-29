-- 01
SELECT title
FROM books
WHERE substring(title, 1, 3) = 'The'
ORDER BY id;

-- 02
SELECT
replace(title, 'The', '***') 
FROM books
WHERE substr(title, 1, 3) = 'the'
ORDER BY id;

-- 03
SELECT round(SUM(cost), 2) AS 'Total Price'
FROM books;

-- 04
SELECT 
    concat_ws(' ', first_name, last_name) AS 'Full Name',
    TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived'
    FROM authors;
    
-- 05
SELECT title FROM books
WHERE title LIKE "Harry Potter%";