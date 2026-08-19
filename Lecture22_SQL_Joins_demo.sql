-- ============================================================
--  DBMS COURSE  |  Lecture 22 : SQL JOINS
--  Dr. Neha Nandal  |  New Syllabus 2025-26
--  Three tables this time: student, course, enroll.
--  Run each block in MySQL Workbench (or the mysql CLI).
-- ============================================================


-- ------------------------------------------------------------
-- SETUP  |  three related tables
-- ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS college;
USE college;

DROP TABLE IF EXISTS enroll;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS course;

CREATE TABLE student (
    sid   INT PRIMARY KEY,
    name  VARCHAR(50) NOT NULL,
    dept  VARCHAR(20)
);

CREATE TABLE course (
    cid   VARCHAR(10) PRIMARY KEY,
    title VARCHAR(50)
);

CREATE TABLE enroll (
    sid   INT,
    cid   VARCHAR(10),
    grade CHAR(1),
    FOREIGN KEY (sid) REFERENCES student(sid),
    FOREIGN KEY (cid) REFERENCES course(cid)
);

INSERT INTO student VALUES
    (1,'Ravi','CSE'), (2,'Priya','ECE'), (3,'Ahmed','CSE');
-- note: Priya (sid 2) has NO enrollment -- watch her in the joins!

INSERT INTO course VALUES
    ('C01','DBMS'), ('C02','OS'), ('C03','AI');
-- note: AI (C03) has NOBODY enrolled

INSERT INTO enroll VALUES
    (1,'C01','A'), (1,'C02','B'), (3,'C01','A');

SELECT * FROM student;
SELECT * FROM course;
SELECT * FROM enroll;


-- ------------------------------------------------------------
-- 0  |  THE CARTESIAN PRODUCT  (where joins come from)
-- ------------------------------------------------------------

-- pair EVERY student with EVERY enroll row (no condition):
SELECT * FROM student, enroll;
-- 3 students x 3 enrolments = 9 rows, most of them nonsense!

-- the explicit keyword for this is CROSS JOIN:
SELECT s.name, e.cid FROM student s CROSS JOIN enroll e;

-- A JOIN = this product + a matching condition (the ON clause).
-- WARNING: forgetting ON/WHERE gives you this product by accident.
-- On big tables that can be millions of junk rows -- always add ON!


-- ------------------------------------------------------------
-- 1  |  INNER JOIN  (only matching rows)
-- ------------------------------------------------------------

SELECT s.name, e.cid, e.grade
FROM student s
JOIN enroll e ON s.sid = e.sid;
-- Priya disappears -- she has no matching enroll row

-- old-style equivalent (comma + WHERE):
SELECT s.name, e.cid, e.grade
FROM student s, enroll e
WHERE s.sid = e.sid;


-- ------------------------------------------------------------
-- 2  |  THREE-TABLE JOIN  (get the course titles)
-- ------------------------------------------------------------

SELECT s.name, c.title, e.grade
FROM student s
JOIN enroll e ON s.sid = e.sid
JOIN course c ON e.cid = c.cid;


-- ------------------------------------------------------------
-- 3  |  LEFT JOIN  (keep ALL students)
-- ------------------------------------------------------------

SELECT s.name, e.cid, e.grade
FROM student s
LEFT JOIN enroll e ON s.sid = e.sid;
-- Priya stays, with NULL cid and grade


-- find students enrolled in NOTHING (NULL after LEFT JOIN):
SELECT s.name
FROM student s
LEFT JOIN enroll e ON s.sid = e.sid
WHERE e.cid IS NULL;


-- ------------------------------------------------------------
-- 4  |  RIGHT JOIN  (keep ALL of the right table)
-- ------------------------------------------------------------

-- courses nobody takes: LEFT JOIN from course
SELECT c.title, e.sid
FROM course c
LEFT JOIN enroll e ON c.cid = e.cid
WHERE e.sid IS NULL;
-- AI (C03) has nobody -> shows up with NULL


-- ------------------------------------------------------------
-- 5  |  JOIN + GROUP BY + HAVING  (it all stacks!)
-- ------------------------------------------------------------

-- students enrolled in 2 or more courses
SELECT   s.name, COUNT(*) AS courses
FROM     student s
JOIN     enroll e ON s.sid = e.sid
GROUP BY s.name
HAVING   COUNT(*) >= 2;


-- ============================================================
--  YOUR TURN (from the practice slide):
--  1. INNER JOIN student and enroll on sid
--  2. Each student's name AND course title (3-table join)
--  3. LEFT JOIN to find students with NO enrolment (NULL cid)
--  4. Count how many courses each student takes
--  5. Course titles nobody is enrolled in (LEFT JOIN from course)
-- ============================================================
