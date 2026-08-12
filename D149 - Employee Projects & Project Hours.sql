USE Daily_SQL;

-- DATASET : Employee Projects & Project Hours

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Employees
VALUES	(1, 'Arun', 'IT', 'Chennai', '2024-01-10'),
		(2, 'Priya', 'HR', 'Chennai', '2024-02-15'),
		(3, 'Rahul', 'IT', 'Bangalore', '2024-01-20'),
		(4, 'Sneha', 'Finance', 'Chennai', '2024-03-05'),
		(5, 'Karthik', 'IT', 'Bangalore', '2024-03-18'),
		(6, 'Divya', 'HR', 'Hyderabad', '2024-04-12'),
		(7, 'Vijay', 'Finance', 'Chennai', '2024-02-25'),
		(8, 'Meena', 'IT', 'Hyderabad', '2024-04-20');

CREATE TABLE Project_Hours (
    Record_ID INT PRIMARY KEY,
    Employee_ID INT,
    Project_Name VARCHAR(50),
    Work_Date DATE,
    Hours_Worked DECIMAL(5,2)
);

INSERT INTO Project_Hours
VALUES	(1, 1, 'Apollo', '2024-05-01', 8),
		(2, 1, 'Apollo', '2024-05-02', 7),
		(3, 1, 'Apollo', '2024-05-03', 9),
		(4, 1, 'Phoenix', '2024-05-05', 6),
		(5, 2, 'Apollo', '2024-05-01', 7),
		(6, 2, 'Phoenix', '2024-05-02', 8),
		(7, 2, 'Phoenix', '2024-05-04', 6),
		(8, 3, 'Apollo', '2024-05-01', 9),
		(9, 3, 'Apollo', '2024-05-02', 8),
		(10, 3, 'Phoenix', '2024-05-03', 7),
		(11, 3, 'Phoenix', '2024-05-04', 9),
		(12, 4, 'Orion', '2024-05-02', 6),
		(13, 4, 'Orion', '2024-05-03', 7),
		(14, 5, 'Apollo', '2024-05-05', 8),
		(15, 5, 'Apollo', '2024-05-06', 9),
		(16, 5, 'Phoenix', '2024-05-07', 8),
		(17, 6, 'Orion', '2024-05-01', 7),
		(18, 6, 'Orion', '2024-05-02', 8),
		(19, 7, 'Phoenix', '2024-05-03', 6),
		(20, 7, 'Phoenix', '2024-05-04', 7),
		(21, 8, 'Apollo', '2024-05-01', 8),
		(22, 8, 'Apollo', '2024-05-03', 7),
		(23, 8, 'Apollo', '2024-05-04', 9);
        
SELECT *
FROM Employees;

SELECT *
FROM Project_Hours;
        
-- Q1
-- Show each employee's total work records,
-- total hours worked, and average hours worked.
--
-- Use both tables.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Total_Work_Records
-- Total_Hours_Worked
-- Average_Hours_Worked

SELECT E.Employee_ID, E.Employee_Name,
	   COUNT(P.Record_ID) AS Total_Work_Records,
       SUM(P.Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(P.Hours_Worked), 2) AS Average_Hours_Worked
FROM Employees E
INNER JOIN Project_Hours P
	ON E.Employee_ID = P.Employee_ID
GROUP BY E.Employee_ID, E.Employee_Name;


-- Q2
-- Show each project name's total work records,
-- total hours worked, and average hours worked.
--
-- Return:
-- Project_Name
-- Total_Work_Records
-- Total_Hours_Worked
-- Average_Hours_Worked

SELECT Project_Name,
	   COUNT(Record_ID) AS Total_Work_Records,
       SUM(Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(Hours_Worked), 2) AS Average_Hours_Worked
FROM Project_Hours
GROUP BY Project_Name;


-- Q3
-- Find the top 3 employees by total hours worked.
--
-- Use DENSE_RANK().
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Total_Hours_Worked

SELECT Employee_ID, Employee_Name, Department, Total_Hours_Worked
FROM (
	SELECT *,
		   DENSE_RANK() OVER(ORDER BY Total_Hours_Worked DESC) AS D_Rank
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   SUM(P.Hours_Worked) AS Total_Hours_Worked
		FROM Employees E
		INNER JOIN Project_Hours P
			ON E.Employee_ID = P.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)D
)T
WHERE D_Rank <= 3;


-- Q4
-- Find employees who worked within 2 days
-- of their previous work date.
--
-- Use JOIN + LAG().
--
-- Return:
-- Employee_ID
-- Employee_Name

SELECT DISTINCT Employee_ID, Employee_Name
FROM (
	SELECT E.Employee_ID, E.Employee_Name, P.Work_Date,
		   LAG(P.Work_Date) OVER(PARTITION BY Employee_ID
           ORDER BY P.Work_Date, P.Record_ID) AS Previous
	FROM Employees E
	INNER JOIN Project_Hours P
		ON E.Employee_ID = P.Employee_ID
)P
WHERE Previous IS NOT NULL
AND DATEDIFF(Work_Date, Previous) <= 2;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total employees
-- total hours worked
-- average hours worked
--
-- Definition:
-- Cohort Month = Month in which the employee joined.
--
-- Use both tables.
--
-- Return:
-- Cohort_Month
-- Total_Employees
-- Total_Hours_Worked
-- Average_Hours_Worked

WITH CTE AS (
	SELECT Employee_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Employees
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Employee_ID) AS Total_Employees,
       SUM(P.Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(P.Hours_Worked), 2) AS Average_Hours_Worked
FROM CTE C
INNER JOIN Project_Hours P
	ON C.Employee_ID = P.Employee_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each employee's longest consecutive
-- working-day streak.
--
-- A streak means working on consecutive dates.
--
-- Ignore duplicate work dates for the same employee.
--
-- If multiple streaks have the same length,
-- return the most recent streak.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT E.Employee_ID, E.Employee_Name, P.Work_Date
	FROM Employees E
	INNER JOIN Project_Hours P
		ON E.Employee_ID = P.Employee_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Employee_ID
           ORDER BY Work_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Work_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Employee_ID, Employee_Name,
		   COUNT(*) AS Streak,
		   MIN(Work_Date) AS Start_Date,
           MAX(Work_Date) AS End_Date
	FROM CTE3
    GROUP BY Employee_ID, Employee_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Employee_ID
           ORDER BY Streak DESC, End_Date DESC) AS  Row_Num
	FROM CTE4
)
SELECT Employee_ID, Employee_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find employees whose total hours worked
-- are greater than the average total hours worked
-- by employees in the same department.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Total_Hours_Worked

SELECT Employee_ID, Employee_Name, Department, Total_Hours_Worked
FROM (
	SELECT *,
		   AVG(Total_Hours_Worked) OVER(PARTITION BY Department) AS Avg_Dep
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   SUM(P.Hours_Worked) AS Total_Hours_Worked
		FROM Employees E
		INNER JOIN Project_Hours P
			ON E.Employee_ID = P.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)P
)A
WHERE Total_Hours_Worked > Avg_Dep;


-- INTERVIEW CHALLENGE
-- For each project, find the employee who worked
-- the greatest total number of hours on that project.
--
-- If tied, return all tied employees.
--
-- Return:
-- Project_Name
-- Employee_ID
-- Employee_Name
-- Total_Hours_Worked

SELECT Project_Name, Employee_ID, Employee_Name, Total_Hours_Worked
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Project_Name
           ORDER BY Total_Hours_Worked DESC) AS D_Rank
	FROM (
		SELECT P.Project_Name, E.Employee_ID, E.Employee_Name,
			   SUM(P.Hours_Worked) AS Total_Hours_Worked
		FROM Employees E
		INNER JOIN Project_Hours P
			ON E.Employee_ID = P.Employee_ID
		GROUP BY P.Project_Name, E.Employee_ID, E.Employee_Name
	)D
)T
WHERE D_Rank = 1;