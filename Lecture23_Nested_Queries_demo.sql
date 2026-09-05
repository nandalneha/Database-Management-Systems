-- ============================================================
--  DBMS COURSE  |  Lecture 23 : NESTED QUERIES (SUBQUERIES)
--  Dr. Neha Nandal  |  New Syllabus 2025-26
--  Same three tables as Lecture 22: student, course, enroll.
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
    sid INT PRIMARY KEY, name VARCHAR(50), dept VARCHAR(20), age INT
);
CREATE TABLE course (
    cid VARCHAR(10) PRIMARY KEY, title VARCHAR(50)
);
CREATE TABLE enroll (
    sid INT, cid VARCHAR(10), grade CHAR(1),
    FOREIGN KEY (sid) REFERENCES student(sid),
    FOREIGN KEY (cid) REFERENCES course(cid)
);

INSERT INTO student VALUES
    (1,'Ravi','CSE',19), (2,'Priya','ECE',20),
    (3,'Ahmed','CSE',22), (4,'Sneha','MECH',18);
-- Priya (2) and Sneha (4) have NO enrollment

INSERT INTO course VALUES
    ('C01','DBMS'), ('C02','OS'), ('C03','AI');
-- AI (C03) has nobody enrolled

INSERT INTO enroll VALUES
    (1,'C01','A'), (1,'C02','B'), (3,'C01','A');

SELECT * FROM student;
SELECT * FROM enroll;


-- ------------------------------------------------------------
-- 1  |  SCALAR subquery  (returns ONE value)
-- ------------------------------------------------------------

-- students older than the average age
SELECT name, age
FROM student
WHERE age > (SELECT AVG(age) FROM student);
-- inner query = 19.75; keeps Priya(20) and Ahmed(22)


-- ------------------------------------------------------------
-- 2  |  IN  (subquery returns a LIST)
-- ------------------------------------------------------------

-- students who ARE enrolled in something
SELECT name
FROM student
WHERE sid IN (SELECT sid FROM enroll);        -- Ravi, Ahmed

-- students enrolled specifically in C01
SELECT name
FROM student
WHERE sid IN (SELECT sid FROM enroll WHERE cid = 'C01');


-- ------------------------------------------------------------
-- 3  |  NOT IN  (the opposite)
-- ------------------------------------------------------------

-- students NOT enrolled in anything
SELECT name
FROM student
WHERE sid NOT IN (SELECT sid FROM enroll);    -- Priya, Sneha

-- WARNING (NULL trap): if the subquery could return a NULL sid,
-- NOT IN returns NO rows. Prefer NOT EXISTS when NULLs are possible.


-- ------------------------------------------------------------
-- 4  |  EXISTS / NOT EXISTS  (correlated -- the SQL form of exists)
-- ------------------------------------------------------------

-- students who have at least one enrollment  (EXISTS = there-exists)
SELECT name
FROM student s
WHERE EXISTS (SELECT * FROM enroll e WHERE e.sid = s.sid);

-- students with NO enrollment  (NOT EXISTS = not-exists)
SELECT name
FROM student s
WHERE NOT EXISTS (SELECT * FROM enroll e WHERE e.sid = s.sid);

-- courses nobody is enrolled in
SELECT title
FROM course c
WHERE NOT EXISTS (SELECT * FROM enroll e WHERE e.cid = c.cid);   -- AI


-- ------------------------------------------------------------
-- 5  |  ANY  and  ALL
-- ------------------------------------------------------------

-- older than EVERY MECH student  ( > ALL = bigger than the MAX )
SELECT name, age
FROM student
WHERE age > ALL (SELECT age FROM student WHERE dept = 'MECH');

-- older than SOME CSE student  ( > ANY = bigger than the MIN )
SELECT name, age
FROM student
WHERE age > ANY (SELECT age FROM student WHERE dept = 'CSE');

-- the oldest student  (nobody is older)
SELECT name, age
FROM student
WHERE age >= ALL (SELECT age FROM student);


-- ============================================================
--  YOUR TURN (from the practice slide):
--  1. Students younger than the average age (scalar)
--  2. Students enrolled in course C01 (IN)
--  3. Students NOT enrolled in anything (NOT IN / NOT EXISTS)
--  4. The oldest student (age >= ALL ages)
--  5. Courses nobody is enrolled in (NOT EXISTS)
-- ============================================================
