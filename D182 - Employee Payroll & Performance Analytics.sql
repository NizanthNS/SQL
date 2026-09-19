USE Daily_SQL;


-- =========================================================
-- SESSION — Employee Payroll & Performance Analytics
-- =========================================================


CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Department VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE,
    Monthly_Salary DECIMAL(10,2)
);

INSERT INTO Employees
VALUES	(1, 'Connor', 'Engineering', 'London', '2024-01-10', 6000),
		(2, 'Ash', 'Engineering', 'Toronto', '2024-02-15', 5800),
		(3, 'Ethan', 'Marketing', 'Sydney', '2024-03-05', 5200),
		(4, 'Liam', 'Marketing', 'Berlin', '2024-03-20', 5000),
		(5, 'Olivia', 'Finance', 'Paris', '2024-04-02', 6200),
		(6, 'Mason', 'Finance', 'Toronto', '2024-04-18', 5900),
		(7, 'Sophia', 'Engineering', 'London', '2024-05-06', 6100),
		(8, 'Noah', 'Finance', 'Berlin', '2024-05-22', 5700);


CREATE TABLE Employee_Performance (
    Performance_ID INT PRIMARY KEY,
    Employee_ID INT,
    Performance_Date DATE,
    Project_Name VARCHAR(100),
    Performance_Score INT,
    Hours_Worked DECIMAL(5,2),
    Performance_Status VARCHAR(20),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

INSERT INTO Employee_Performance
VALUES	(101, 1, '2025-01-05', 'Project Alpha', 88, 160, 'Completed'),
		(102, 1, '2025-02-05', 'Project Beta', 91, 165, 'Completed'),
		(103, 1, '2025-03-05', 'Project Gamma', 76, 150, 'Completed'),
		(104, 1, '2025-04-05', 'Project Delta', 94, 170, 'Completed'),
		(105, 1, '2025-05-05', 'Project Omega', 82, 155, 'Completed'),

		(106, 2, '2025-01-10', 'Project Alpha', 79, 150, 'Completed'),
		(107, 2, '2025-02-10', 'Project Beta', 85, 158, 'Completed'),
		(108, 2, '2025-03-10', 'Project Gamma', 72, 145, 'Completed'),
		(109, 2, '2025-04-10', 'Project Delta', 89, 162, 'Completed'),
		(110, 2, '2025-05-10', 'Project Omega', 93, 168, 'Completed'),

		(111, 3, '2025-02-01', 'Campaign Alpha', 84, 155, 'Completed'),
		(112, 3, '2025-03-01', 'Campaign Beta', 90, 160, 'Completed'),
		(113, 3, '2025-04-01', 'Campaign Gamma', 78, 148, 'Completed'),
		(114, 3, '2025-05-01', 'Campaign Delta', 88, 158, 'Completed'),

		(115, 4, '2025-01-15', 'Campaign Alpha', 75, 145, 'Completed'),
		(116, 4, '2025-02-15', 'Campaign Beta', 81, 150, 'Completed'),
		(117, 4, '2025-03-15', 'Campaign Gamma', 69, 138, 'Completed'),
		(118, 4, '2025-04-15', 'Campaign Delta', 86, 155, 'Completed'),
		(119, 4, '2025-05-15', 'Campaign Omega', 92, 165, 'Completed'),

		(120, 5, '2025-01-20', 'Audit Alpha', 91, 162, 'Completed'),
		(121, 5, '2025-02-20', 'Audit Beta', 87, 158, 'Completed'),
		(122, 5, '2025-03-20', 'Audit Gamma', 94, 170, 'Completed'),
		(123, 5, '2025-04-20', 'Audit Delta', 89, 160, 'Completed'),

		(124, 6, '2025-02-05', 'Audit Alpha', 80, 150, 'Completed'),
		(125, 6, '2025-03-05', 'Audit Beta', 85, 155, 'Completed'),
		(126, 6, '2025-04-05', 'Audit Gamma', 90, 165, 'Completed'),
		(127, 6, '2025-05-05', 'Audit Delta', 77, 145, 'Completed'),

		(128, 7, '2025-01-12', 'Project Alpha', 92, 165, 'Completed'),
		(129, 7, '2025-02-12', 'Project Beta', 95, 170, 'Completed'),
		(130, 7, '2025-03-12', 'Project Gamma', 89, 160, 'Completed'),
		(131, 7, '2025-04-12', 'Project Delta', 96, 175, 'Completed'),
		(132, 7, '2025-05-12', 'Project Omega', 93, 168, 'Completed'),

		(133, 8, '2025-01-18', 'Audit Alpha', 73, 140, 'Completed'),
		(134, 8, '2025-02-18', 'Audit Beta', 81, 150, 'Completed'),
		(135, 8, '2025-03-18', 'Audit Gamma', 88, 158, 'Completed'),
		(136, 8, '2025-04-18', 'Audit Delta', 79, 148, 'Completed'),
		(137, 8, '2025-05-18', 'Audit Omega', 91, 162, 'Completed');


SELECT *
FROM Employees;

SELECT *
FROM Employee_Performance;


-- =========================================================
-- Q1 — Employee Performance Summary
-- =========================================================
-- For every employee, calculate:
-- total performance records,
-- total hours worked,
-- average performance score,
-- highest performance score,
-- lowest performance score.
--
-- Include employees with no performance records.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Total_Performance_Records
-- Total_Hours_Worked
-- Average_Performance_Score
-- Highest_Performance_Score
-- Lowest_Performance_Score

SELECT E.Employee_ID, E.Employee_Name, E.Department,
	   COUNT(P.Performance_ID) AS Total_Performance_Records,
       SUM(P.Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score,
       MAX(P.Performance_Score) AS Highest_Performance_Score,
       MIN(P.Performance_Score) AS Lowest_Performance_Score
FROM Employees E
LEFT JOIN Employee_Performance P
	ON E.Employee_ID = P.Employee_ID
GROUP BY E.Employee_ID, E.Employee_Name, E.Department;


-- =========================================================
-- Q2 — Department Performance
-- =========================================================
-- For each department, calculate:
-- total performance records,
-- total hours worked,
-- average performance score,
-- employees with average score >= 85,
-- unique employees.
--
-- Return:
-- Department
-- Total_Performance_Records
-- Total_Hours_Worked
-- Average_Performance_Score
-- High_Performers
-- Unique_Employees

WITH CTE AS (
    SELECT Employee_ID,
           AVG(Performance_Score) AS Emp_Avg
    FROM Employee_Performance
    GROUP BY Employee_ID
),
CTE2 AS (
	SELECT E.Employee_ID, E.Department, A.Emp_Avg
	FROM Employees E
	JOIN CTE A
		ON E.Employee_ID = A.Employee_ID
)
SELECT E.Department,
	   COUNT(P.Performance_ID) AS Total_Performance_Records,
	   SUM(P.Hours_Worked) AS Total_Hours_Worked,
	   ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score,
       COUNT(
       CASE
			WHEN E.Emp_Avg >= 85
            THEN 1
	   END) AS High_Performers,
	   COUNT(DISTINCT E.Employee_ID) AS Unique_Employees
FROM CTE2 E
LEFT JOIN Employee_Performance P
	ON E.Employee_ID = P.Employee_ID
GROUP BY E.Department;


-- =========================================================
-- Q3 — Top 2 Employees Per Department
-- =========================================================
-- Find the top 2 employees in each department based on
-- their average performance score.
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Average_Performance_Score
-- Performance_Rank

SELECT Employee_ID, Employee_Name, Department, Average_Performance_Score, Performance_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Department
           ORDER BY Average_Performance_Score DESC) AS Performance_Rank
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score
		FROM Employees E
		INNER JOIN Employee_Performance P
			ON E.Employee_ID = P.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)A
)D
WHERE Performance_Rank <= 2;


-- =========================================================
-- Q4 — Performance Improvement Within 30 Days
-- =========================================================
-- Find performance records where an employee's score is
-- higher than their previous performance score AND the
-- performance occurred within 30 days of the previous
-- performance.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Performance_Date
-- Previous_Performance_Date
-- Performance_Score
-- Previous_Performance_Score
-- Days_Between_Performances

WITH CTE AS (
	SELECT E.Employee_ID, E.Employee_Name, P.Performance_Date, P.Performance_Score,
		   LAG(P.Performance_Date) OVER(PARTITION BY E.Employee_ID
           ORDER BY P.Performance_Date, P.Performance_ID) AS Previous_Performance_Date,
           LAG(P.Performance_Score) OVER(PARTITION BY E.Employee_ID
           ORDER BY P.Performance_Date, P.Performance_ID) AS Previous_Performance_Score
	FROM Employees E
	INNER JOIN Employee_Performance P
		ON E.Employee_ID = P.Employee_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Performance_Date, Previous_Performance_Date) AS Days_Between_Performances
	FROM CTE
)
SELECT Employee_ID, Employee_Name, Performance_Date, Previous_Performance_Date,
	   Performance_Score, Previous_Performance_Score, Days_Between_Performances
FROM CTE2
WHERE Performance_Score > Previous_Performance_Score
AND Days_Between_Performances <= 30;


-- =========================================================
-- Q5 — Employee Cohort Performance Analysis
-- =========================================================
-- Group employees by Join Month.
--
-- Calculate:
-- total employees,
-- employees with performance records,
-- total performance records,
-- total hours worked,
-- average performance score.
--
-- Return:
-- Cohort_Month
-- Total_Employees
-- Active_Employees
-- Total_Performance_Records
-- Total_Hours_Worked
-- Average_Performance_Score

WITH CTE AS (
	SELECT Employee_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Employees
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Employee_ID) AS Total_Employees,
       COUNT(DISTINCT
       CASE 
			WHEN P.Performance_ID IS NOT NULL
            THEN C.Employee_ID
	   END) AS Active_Employees,
       COUNT(P.Performance_ID) AS Total_Performance_Records,
       SUM(P.Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score
FROM CTE C
LEFT JOIN Employee_Performance P
	ON C.Employee_ID = P.Employee_ID
GROUP BY Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- Find each employee's longest consecutive MONTHLY
-- performance-record streak.
--
-- Rules:
-- 1. Multiple records in the same month count ONCE.
-- 2. Consecutive months form a streak.
-- 3. Find the longest streak per employee.
-- 4. If tied, choose the most recent streak.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT E.Employee_ID, E.Employee_Name,
		   DATE_FORMAT(P.Performance_Date, '%Y-%m-01') AS Performance_Month
	FROM Employees E
	INNER JOIN Employee_Performance P
		ON E.Employee_ID = P.Employee_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Employee_ID
           ORDER BY Performance_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Performance_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Employee_ID, Employee_Name,
		   COUNT(*) AS Streak,
           MIN(Performance_Month) AS Streak_Start_Month,
           MAX(Performance_Month) AS Streak_End_Month
	FROM CTE3
    GROUP BY Employee_ID, Employee_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Employee_ID
           ORDER BY Streak DESC, Streak_End_Month DESC) AS Row_Num
	FROM CTE4
)
SELECT Employee_ID, Employee_Name, Streak_Start_Month, Streak_End_Month, Streak AS Streak_Months
FROM CTE5
WHERE Row_Num = 1;


-- =========================================================
-- BONUS+ — Above-Department-Average Performance
-- =========================================================
-- Find employees whose average performance score is
-- greater than the average employee score in their
-- department.
--
-- Use a window function.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Average_Performance_Score
-- Department_Average_Score

SELECT Employee_ID, Employee_Name, Department, Average_Performance_Score, Department_Average_Score
FROM (
	SELECT *,
		   ROUND(AVG(Average_Performance_Score) OVER(PARTITION BY Department), 2) AS Department_Average_Score
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score
		FROM Employees E
		INNER JOIN Employee_Performance P
			ON E.Employee_ID = P.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)D
)A
WHERE Average_Performance_Score > Department_Average_Score;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each project, find the employee(s) with the highest
-- performance score.
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- Project_Name
-- Employee_ID
-- Employee_Name
-- Performance_Score
-- Score_Rank

SELECT Project_Name, Employee_ID, Employee_Name, Performance_Score, Score_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Project_Name
           ORDER BY Performance_Score DESC) AS Score_Rank
	FROM (
		SELECT P.Project_Name, E.Employee_ID, E.Employee_Name, P.Performance_Score
		FROM Employees E
		INNER JOIN Employee_Performance P
			ON E.Employee_ID = P.Employee_ID
	)D
)P
WHERE Score_Rank = 1;