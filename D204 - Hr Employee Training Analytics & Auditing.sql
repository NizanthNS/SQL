-- =========================================================
-- SESSION 07 — Hr Employee Training Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — EMPLOYEES
-- =========================================================

DROP TABLE IF EXISTS Training_Audit;
DROP TABLE IF EXISTS Employee_Trainings;
DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Department VARCHAR(50),
    Hire_Date DATE
);

INSERT INTO Employees
VALUES
(1,'Alexander Reed','IT','2025-01-05'),
(2,'Charlotte Evans','Finance','2025-01-10'),
(3,'Benjamin Scott','HR','2025-01-18'),
(4,'Emily Richardson','Sales','2025-02-01'),
(5,'Lucas Foster','Operations','2025-02-12'),
(6,'Olivia Hughes','IT','2025-02-20'),
(7,'James Murphy','Finance','2025-03-05'),
(8,'Ava Peterson','HR','2025-03-10'),
(9,'Liam Cooper','Sales','2025-03-18'),
(10,'Sophia Ward','Operations','2025-04-01');

-- =========================================================
-- TABLE 2 — EMPLOYEE TRAININGS
-- =========================================================

CREATE TABLE Employee_Trainings (
    Training_ID INT PRIMARY KEY,
    Employee_ID INT,
    Training_Date DATE,
    Training_Name VARCHAR(100),
    Training_Cost DECIMAL(10,2),
    Training_Status VARCHAR(20),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

INSERT INTO Employee_Trainings
VALUES
(1001,1,'2025-01-10','SQL Fundamentals',500,'Completed'),
(1002,1,'2025-01-11','Advanced Excel',400,'Completed'),
(1003,1,'2025-01-12','Power BI',600,'Completed'),
(1004,1,'2025-03-01','Python Basics',800,'Completed'),

(1005,2,'2025-01-20','SQL Fundamentals',700,'Completed'),
(1006,2,'2025-02-15','Power BI',500,'Completed'),
(1007,2,'2025-04-01','Python Basics',300,'Cancelled'),

(1008,3,'2025-01-25','HR Analytics',1200,'Completed'),
(1009,3,'2025-01-26','Advanced Excel',500,'Completed'),
(1010,3,'2025-01-27','Power BI',400,'Completed'),
(1011,3,'2025-05-01','Leadership',900,'Completed'),

(1012,4,'2025-02-05','Sales Strategy',600,'Completed'),
(1013,4,'2025-03-05','Negotiation Skills',700,'Completed'),

(1014,5,'2025-02-20','Project Management',1500,'Completed'),
(1015,5,'2025-03-20','Leadership',1300,'Completed'),

(1016,6,'2025-03-01','SQL Fundamentals',400,'Completed'),
(1017,6,'2025-03-02','Advanced Excel',450,'Completed'),
(1018,6,'2025-03-03','Power BI',350,'Completed'),

(1019,7,'2025-04-01','Financial Modeling',800,'Completed'),
(1020,7,'2025-05-01','Leadership',900,'Completed'),

(1021,8,'2025-04-10','HR Analytics',450,'Completed'),
(1022,8,'2025-06-01','Leadership',550,'Completed'),

(1023,9,'2025-04-15','Sales Strategy',300,'Completed'),
(1024,9,'2025-04-16','Negotiation Skills',400,'Completed'),
(1025,9,'2025-04-17','Leadership',500,'Completed'),

(1026,10,'2025-05-05','Project Management',1400,'Completed'),
(1027,10,'2025-06-10','Leadership',1200,'Completed');

-- =========================================================
-- TABLE 3 — TRAINING AUDIT
-- =========================================================

CREATE TABLE Training_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Training_ID INT,
    Old_Cost DECIMAL(10,2),
    New_Cost DECIMAL(10,2),
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Action_Type VARCHAR(20),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Employees;
SELECT * FROM Employee_Trainings;
SELECT * FROM Training_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find employees who attended another training
-- within 2 days of their previous training.
--
-- Return:
-- Employee_ID
-- Employee_Name

WITH CTE AS (
	SELECT E.Employee_ID, E.Employee_Name, T.Training_Date,
		   LAG(T.Training_Date) OVER(PARTITION BY E.Employee_ID
           ORDER BY T.Training_Date, T.Training_ID) AS Previous
	FROM Employees E
    INNER JOIN Employee_Trainings T
		ON E.Employee_ID = T.Employee_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Training_Date, Previous) AS Gap_Days
	FROM CTE
)
SELECT DISTINCT Employee_ID, Employee_Name
FROM CTE2
WHERE Gap_Days <= 2;


-- =========================================================
-- Q2
-- COHORT ANALYSIS
-- =========================================================

-- For each cohort month, find:
-- Total_Employees
-- Total_Training_Cost
--
-- Definition:
-- An employee's cohort month is the month
-- of their first training date.
--
-- Return:
-- Cohort_Month
-- Total_Employees
-- Total_Training_Cost

WITH CTE AS (
	SELECT Employee_ID,
		   MIN(Training_Date) AS First_
	FROM Employee_Trainings
    GROUP BY Employee_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT T.Employee_ID) AS Total_Employees,
       COALESCE(SUM(T.Training_Cost), 0) AS Total_Training_Cost
FROM CTE2 C
LEFT JOIN Employee_Trainings T
	ON C.Employee_ID = T.Employee_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each employee's
-- current training streak.
--
-- Definition:
-- Current streak = streak containing the employee's
-- most recent training date.
--
-- Note:
-- Ignore duplicate training dates if an employee
-- has multiple trainings on the same day.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only employees whose Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT E.Employee_ID, E.Employee_Name, T.Training_Date
    FROM Employees E
    INNER JOIN Employee_Trainings T
		ON E.Employee_ID = T.Employee_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Employee_ID
           ORDER BY Training_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Training_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Employee_ID, Employee_Name,
		   COUNT(*) AS Streak,
           MIN(Training_Date) AS Start_Date,
           MAX(Training_Date) AS End_Date
	FROM CTE3
    GROUP BY Employee_ID, Employee_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Employee_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Employee_ID, Employee_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >=3
AND D_Rank = 1;


-- =========================================================
-- Q4
-- CASE STATEMENT
-- =========================================================

-- Categorize employees based on completed
-- training cost.
--
-- Platinum : Cost >= 3500
-- Gold     : Cost >= 2500
-- Silver   : Cost >= 1000
-- Bronze   : Cost < 1000
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Total_Cost
-- Employee_Category

WITH CTE AS (
	SELECT E.Employee_ID, E.Employee_Name,
		   COALESCE(SUM(T.Training_Cost), 0) AS Total_Cost
	FROM Employees E
    LEFT JOIN Employee_Trainings T
		ON E.Employee_ID = T.Employee_ID
		AND T.Training_Status = 'Completed'
    GROUP BY E.Employee_ID, E.Employee_Name
)
SELECT Employee_ID, Employee_Name, Total_Cost,

	   CASE 
			WHEN Total_Cost >= 3500 THEN 'Platinum'
       
			WHEN Total_Cost >= 2500 THEN 'Gold'
            
            WHEN Total_Cost >= 1000 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Employee_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Employee_Trainings.
--
-- Requirements:
--
-- 1. When Training_Cost OR Training_Status changes,
--    insert one record into Training_Audit.
--
-- 2. Record:
--    Training_ID
--    OLD.Training_Cost
--    NEW.Training_Cost
--    OLD.Training_Status
--    NEW.Training_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Training_Cost nor Training_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Employee_Trainings
-- SET Training_Cost = 2200
-- WHERE Training_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Training_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.

SELECT * FROM Training_Audit;

DELIMITER //

CREATE TRIGGER Training_Update_Audit
AFTER UPDATE ON Employee_Trainings
FOR EACH ROW
BEGIN
	IF OLD.Training_Cost <> NEW.Training_Cost OR
	   OLD.Training_Status <> NEW.Training_Status
	THEN 
		INSERT INTO Training_Audit (Training_ID, Old_Cost, New_Cost, Old_Status, New_Status, Action_Type)
		VALUES (
			OLD.Training_ID,
            OLD.Training_Cost,
            NEW.Training_Cost,
            OLD.Training_Status,
            NEW.Training_Status,
            'Action Type'
		);
	END IF;
END //

DELIMITER ;


UPDATE Employee_Trainings
SET Training_Cost = '50'
WHERE Training_ID = 1027;