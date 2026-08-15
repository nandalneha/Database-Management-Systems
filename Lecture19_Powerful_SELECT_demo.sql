-- ============================================================
--  DBMS COURSE  |  Lecture 19 : POWERFUL SELECT QUERIES
--  Dr. Neha Nandal  |  New Syllabus 2025-26
--  Run each block in MySQL Workbench (or the mysql CLI)
--  and watch how the results change.
-- ============================================================


-- ------------------------------------------------------------
-- SETUP  |  our student table (continued from Lecture 18)
-- ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS college;
USE college;

DROP TABLE IF EXISTS student;
CREATE TABLE student (
    sid   INT PRIMARY KEY,
    name  VARCHAR(50) NOT NULL,
    dept  VARCHAR(20),
    age   INT
);

INSERT INTO student (sid, name, dept, age) VALUES
    (1, 'Ravi',  'CSE',  19),
    (2, 'Priya', 'ECE',  20),
    (3, 'Ahmed', 'CSE',  22),
    (4, 'Sneha', 'MECH', 18),
    (5, 'Kiran', 'ECE',  21),
    (6, 'Divya', 'CSE',  23);

SELECT * FROM student;


-- ------------------------------------------------------------
-- 1  |  WHERE : comparison + AND / OR / NOT
-- ------------------------------------------------------------

SELECT * FROM student WHERE age > 20;
SELECT * FROM student WHERE dept = 'CSE' AND age > 20;
SELECT * FROM student WHERE dept = 'CSE' OR age > 20;
SELECT * FROM student WHERE NOT dept = 'CSE';


-- ------------------------------------------------------------
-- 2  |  BETWEEN (range)  and  IN (list)
-- ------------------------------------------------------------

SELECT * FROM student WHERE age BETWEEN 18 AND 20;   -- inclusive
SELECT * FROM student WHERE dept IN ('CSE', 'ECE');

-- these are just cleaner forms of:
SELECT * FROM student WHERE age >= 18 AND age <= 20;
SELECT * FROM student WHERE dept = 'CSE' OR dept = 'ECE';


-- ------------------------------------------------------------
-- 3  |  LIKE : pattern matching  ( % = any chars, _ = one char )
-- ------------------------------------------------------------

SELECT * FROM student WHERE name LIKE 'R%';    -- starts with R
SELECT * FROM student WHERE name LIKE '%a';    -- ends with a
SELECT * FROM student WHERE name LIKE '%i%';   -- contains i
SELECT * FROM student WHERE name LIKE '_r%';   -- 2nd letter is r


-- ------------------------------------------------------------
-- 4  |  ORDER BY : sorting
-- ------------------------------------------------------------

SELECT * FROM student ORDER BY age ASC;        -- youngest first (default)
SELECT * FROM student ORDER BY age DESC;       -- oldest first
SELECT * FROM student ORDER BY dept, age DESC; -- by dept, then age


-- ------------------------------------------------------------
-- 5  |  DISTINCT : remove duplicate rows
-- ------------------------------------------------------------

SELECT dept FROM student;            -- 6 rows, with repeats
SELECT DISTINCT dept FROM student;   -- 3 rows, one of each


-- ------------------------------------------------------------
-- 6  |  SET OPERATIONS
-- ------------------------------------------------------------

-- UNION : combine both result sets, no duplicates (works on all MySQL)
SELECT name FROM student WHERE dept = 'CSE'
UNION
SELECT name FROM student WHERE age > 20;

-- INTERSECT : rows in BOTH  (MySQL 8.0.31+)
-- SELECT name FROM student WHERE dept = 'CSE'
-- INTERSECT
-- SELECT name FROM student WHERE age > 20;

-- INTERSECT the portable way (works on ANY MySQL version):
SELECT name FROM student
WHERE dept = 'CSE'
  AND name IN (SELECT name FROM student WHERE age > 20);

-- EXCEPT : in first but not second  (MySQL 8.0.31+)
-- SELECT name FROM student WHERE dept = 'CSE'
-- EXCEPT
-- SELECT name FROM student WHERE age > 20;

-- EXCEPT the portable way:
SELECT name FROM student
WHERE dept = 'CSE'
  AND name NOT IN (SELECT name FROM student WHERE age > 20);


-- ------------------------------------------------------------
-- 7  |  THE PAYOFF : everything in one query
-- ------------------------------------------------------------

SELECT DISTINCT dept, name, age
FROM student
WHERE dept IN ('CSE', 'ECE')
  AND age BETWEEN 18 AND 22
ORDER BY age DESC;


-- ============================================================
--  YOUR TURN (from the practice slide):
--  1. Students whose name contains 'i'      (LIKE '%i%')
--  2. Students in CSE or MECH               (IN)
--  3. Ages between 19 and 22, youngest first (BETWEEN + ORDER BY)
--  4. The distinct list of ages             (DISTINCT)
--  5. UNION: CSE students OR students older than 21
-- ============================================================
