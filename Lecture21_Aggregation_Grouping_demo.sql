-- ============================================================
--  DBMS COURSE  |  Lecture 21 : AGGREGATION & GROUPING
--  Dr. Neha Nandal  |  New Syllabus 2025-26
--  Run each block in MySQL Workbench (or the mysql CLI)
--  and watch the summaries appear.
-- ============================================================


-- ------------------------------------------------------------
-- SETUP  |  student table with clear groups
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
    (6, 'Divya', 'CSE',  23),
    (7, 'Meena', 'ECE',  20);
-- CSE: 3 students, ECE: 3 students, MECH: 1 student

SELECT * FROM student;


-- ------------------------------------------------------------
-- 1  |  THE 5 AGGREGATE FUNCTIONS  (whole table)
-- ------------------------------------------------------------

SELECT COUNT(*) FROM student;      -- how many rows -> 7
SELECT SUM(age) FROM student;      -- total age -> 143
SELECT AVG(age) FROM student;      -- average age -> ~20.4
SELECT MIN(age) FROM student;      -- youngest -> 18
SELECT MAX(age) FROM student;      -- oldest -> 23

-- all at once:
SELECT COUNT(*), SUM(age), AVG(age), MIN(age), MAX(age) FROM student;


-- ------------------------------------------------------------
-- 2  |  COUNT VARIANTS  (a classic exam trap)
-- ------------------------------------------------------------

SELECT COUNT(*)              FROM student;   -- all rows -> 7
SELECT COUNT(dept)           FROM student;   -- non-NULL depts -> 7
SELECT COUNT(DISTINCT dept)  FROM student;   -- unique depts -> 3


-- ------------------------------------------------------------
-- 3  |  GROUP BY  (summarize per group)
-- ------------------------------------------------------------

-- how many students in each department?
SELECT dept, COUNT(*)
FROM student
GROUP BY dept;

-- average age per department
SELECT dept, AVG(age)
FROM student
GROUP BY dept;

-- oldest student per department
SELECT dept, MAX(age)
FROM student
GROUP BY dept;

-- RULE: any selected column NOT inside an aggregate
--       must appear in the GROUP BY.


-- ------------------------------------------------------------
-- 4  |  HAVING  (filter the groups)
-- ------------------------------------------------------------

-- only departments with more than 2 students
SELECT dept, COUNT(*)
FROM student
GROUP BY dept
HAVING COUNT(*) > 2;

-- WHERE vs HAVING:
--   WHERE  filters ROWS   -- BEFORE grouping
--   HAVING filters GROUPS -- AFTER grouping
-- This ERRORS (aggregate not allowed in WHERE):
--   SELECT dept FROM student WHERE COUNT(*) > 2 GROUP BY dept;
-- Use HAVING instead (correct above).


-- ------------------------------------------------------------
-- 5  |  ALL CLAUSES TOGETHER
-- ------------------------------------------------------------

-- Of students aged 19+, show departments that still have
-- more than one such student, ordered by average age.
SELECT   dept, COUNT(*), AVG(age)
FROM     student
WHERE    age >= 19          -- 2. filter rows first
GROUP BY dept               -- 3. make groups
HAVING   COUNT(*) > 1       -- 4. filter groups
ORDER BY AVG(age) DESC;     -- 6. sort the result

-- Execution order: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY


-- ============================================================
--  YOUR TURN (from the practice slide):
--  1. Count the total number of students
--  2. Average age of ALL students
--  3. Count students in each department
--  4. Average age per department
--  5. Departments having more than 2 students
-- ============================================================
