-- =========================================================
-- SESSION — Online Learning Platform Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — STUDENTS
-- =========================================================

DROP TABLE IF EXISTS Course_Audit;
DROP TABLE IF EXISTS Course_Enrollments;
DROP TABLE IF EXISTS Students;

CREATE TABLE Students (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(100),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Students
VALUES	(1, 'Aarav Sharma',      'Mumbai',    '2025-01-05'),
		(2, 'Emma Wilson',       'London',    '2025-01-08'),
		(3, 'Noah Brown',        'Toronto',   '2025-01-15'),
		(4, 'Sophia Taylor',     'Sydney',    '2025-02-01'),
		(5, 'Liam Johnson',      'Berlin',    '2025-02-12'),
		(6, 'Olivia Martin',     'Paris',     '2025-02-18'),
		(7, 'Lucas Thomas',      'London',    '2025-03-02'),
		(8, 'Mia Anderson',      'Toronto',   '2025-03-10'),
		(9, 'Ethan White',       'Sydney',    '2025-03-20'),
		(10,'Charlotte Harris',  'Berlin',    '2025-04-01');

-- =========================================================
-- TABLE 2 — COURSE ENROLLMENTS
-- =========================================================

CREATE TABLE Course_Enrollments (
    Enrollment_ID INT PRIMARY KEY,
    Student_ID INT,
    Enrollment_Date DATE,
    Course_Name VARCHAR(100),
    Course_Fee DECIMAL(10,2),
    Enrollment_Status VARCHAR(20),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID)
);

INSERT INTO Course_Enrollments
VALUES	(1001,1,'2025-01-10','SQL Basics',300,'Completed'),
		(1002,1,'2025-01-11','Excel Analytics',250,'Completed'),
		(1003,1,'2025-01-13','Python Fundamentals',500,'Completed'),
		(1004,1,'2025-03-01','Data Visualization',450,'Completed'),

		(1005,2,'2025-01-12','SQL Basics',300,'Completed'),
		(1006,2,'2025-02-15','Python Fundamentals',500,'Completed'),
		(1007,2,'2025-04-10','Machine Learning',900,'Cancelled'),

		(1008,3,'2025-01-20','SQL Basics',300,'Completed'),
		(1009,3,'2025-01-21','Excel Analytics',250,'Completed'),
		(1010,3,'2025-01-22','Python Fundamentals',500,'Completed'),
		(1011,3,'2025-05-01','Power BI',600,'Completed'),

		(1012,4,'2025-02-05','SQL Basics',300,'Completed'),
		(1013,4,'2025-03-05','Power BI',600,'Completed'),

		(1014,5,'2025-02-20','Machine Learning',1000,'Completed'),
		(1015,5,'2025-03-20','Deep Learning',1200,'Completed'),

		(1016,6,'2025-03-01','Excel Analytics',250,'Completed'),
		(1017,6,'2025-03-02','SQL Basics',300,'Completed'),
		(1018,6,'2025-03-03','Python Fundamentals',500,'Completed'),

		(1019,7,'2025-04-01','Power BI',600,'Completed'),
		(1020,7,'2025-05-01','Machine Learning',900,'Completed'),

		(1021,8,'2025-04-10','SQL Basics',300,'Completed'),
		(1022,8,'2025-06-01','Python Fundamentals',500,'Completed'),

		(1023,9,'2025-04-15','Excel Analytics',250,'Completed'),
		(1024,9,'2025-04-16','SQL Basics',300,'Completed'),
		(1025,9,'2025-04-17','Power BI',600,'Completed'),

		(1026,10,'2025-05-05','Machine Learning',900,'Completed'),
		(1027,10,'2025-06-10','Deep Learning',1200,'Completed');

-- =========================================================
-- TABLE 3 — COURSE AUDIT
-- =========================================================

CREATE TABLE Course_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Enrollment_ID INT,
    Old_Fee DECIMAL(10,2),
    New_Fee DECIMAL(10,2),
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Action_Type VARCHAR(20),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Students;
SELECT * FROM Course_Enrollments;
SELECT * FROM Course_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find students who enrolled in another course
-- within 2 days of their previous enrollment.
--
-- Return:
-- Student_ID
-- Student_Name

WITH CTE AS (
	SELECT S.Student_ID, S.Student_Name, C.Enrollment_Date,
		   LAG(C.Enrollment_Date) OVER(PARTITION BY S.Student_ID
           ORDER BY C.Enrollment_Date, C.Enrollment_ID) AS Previous
	FROM Students S
    INNER JOIN Course_Enrollments C
		ON S.Student_ID = C.Student_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Enrollment_Date, Previous) AS Days_Gap
	FROM CTE
)
SELECT DISTINCT Student_ID, Student_Name
FROM CTE2
WHERE Previous IS NOT NULL
AND Days_Gap <= 2;


-- =========================================================
-- Q2
-- COHORT ANALYSIS
-- =========================================================

-- For each cohort month, find:
-- Total_Students
-- Total_Course_Revenue
--
-- Definition:
-- A student's cohort month is the month
-- of their first enrollment date.
--
-- Return:
-- Cohort_Month
-- Total_Students
-- Total_Course_Revenue

WITH CTE AS (
	SELECT Student_ID,
		   MIN(Enrollment_Date) AS First_Enroll
	FROM Course_Enrollments
    GROUP BY Student_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Enroll, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C2.Cohort_Month,
	   COUNT(DISTINCT C.Student_ID) AS Total_Students,
       COALESCE(SUM(C.Course_Fee), 0) AS Total_Course_Revenue
FROM CTE2 C2
LEFT JOIN Course_Enrollments C
	ON C2.Student_ID = C.Student_ID
GROUP BY C2.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each student's
-- current enrollment streak.
--
-- Definition:
-- Current streak = streak containing the student's
-- most recent enrollment date.
--
-- Note:
-- Ignore duplicate enrollment dates if a student
-- has multiple enrollments on the same day.
--
-- Return:
-- Student_ID
-- Student_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only students whose Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT S.Student_ID, S.Student_Name, C.Enrollment_Date
    FROM Students S
    INNER JOIN Course_Enrollments C
		ON S.Student_ID = C.Student_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Student_ID
           ORDER BY Enrollment_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Enrollment_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Student_ID, Student_Name,
		   COUNT(*) AS Streak,
           MIN(Enrollment_Date) AS Start_Date,
           MAX(Enrollment_Date) AS End_Date
	FROM CTE3
    GROUP BY Student_ID, Student_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Student_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Student_ID, Student_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >=3
AND D_Rank = 1;


-- =========================================================
-- Q4
-- CASE STATEMENT
-- =========================================================

-- Categorize students based on completed
-- course revenue.
--
-- Platinum : Revenue >= 2000
-- Gold     : Revenue >= 1000
-- Silver   : Revenue >= 500
-- Bronze   : Revenue < 500
--
-- Return:
-- Student_ID
-- Student_Name
-- Total_Revenue
-- Student_Category

WITH CTE AS (
	SELECT S.Student_ID, S.Student_Name,
		   COALESCE(SUM(C.Course_Fee), 0) AS Total_Revenue
	FROM Students S
    LEFT JOIN Course_Enrollments C
		ON S.Student_ID = C.Student_ID
		AND C.Enrollment_Status = 'Completed'
    GROUP BY S.Student_ID, S.Student_Name
)
SELECT Student_ID, Student_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 2000 THEN 'Platinum'
       
			WHEN Total_Revenue >= 1000 THEN 'Gold'
            
            WHEN Total_Revenue >= 500 THEN 'Silver'
            
            WHEN Total_Revenue < 500 THEN 'Bronze'
	   END AS Student_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Course_Enrollments.
--
-- Requirements:
--
-- 1. When Course_Fee OR Enrollment_Status changes,
--    insert one record into Course_Audit.
--
-- 2. Record:
--    Enrollment_ID
--    OLD.Course_Fee
--    NEW.Course_Fee
--    OLD.Enrollment_Status
--    NEW.Enrollment_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Course_Fee nor Enrollment_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Course_Enrollments
-- SET Course_Fee = 1500
-- WHERE Enrollment_ID = 1014;
--
-- Verify:
--
SELECT * FROM Course_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.

DELIMITER //

CREATE TRIGGER Student_Update
AFTER UPDATE ON Course_Enrollments
FOR EACH ROW
BEGIN
	IF OLD.Course_Fee <> NEW.Course_Fee OR
	   OLD.Enrollment_Status <> NEW.Enrollment_Status
	THEN
		INSERT INTO Course_Audit (Enrollment_ID, Old_Fee, New_Fee, Old_Status, New_Status, Action_Type)
        VALUES (
			OLD.Enrollment_ID,
            OLD.Course_Fee,
            NEW.Course_Fee,
            OLD.Enrollment_Status,
            NEW.Enrollment_Status,
            'UPDATE'
		);
	END IF;

END //

DELIMITER ;

UPDATE Course_Enrollments
SET Course_Fee = 2000
WHERE Enrollment_ID = 1014;