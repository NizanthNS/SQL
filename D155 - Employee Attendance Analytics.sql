USE Daily_SQL;

-- Employee Attendance Analytics

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Department VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Attendance (
    Attendance_ID INT PRIMARY KEY,
    Employee_ID INT,
    Attendance_Date DATE,
    Hours_Worked DECIMAL(5,2),
    Attendance_Status VARCHAR(20),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

INSERT INTO Employees
VALUES	(1, 'Arun', 'IT', 'Chennai', '2024-01-15'),
		(2, 'Bala', 'HR', 'Chennai', '2024-02-10'),
		(3, 'Charan', 'IT', 'Bangalore', '2024-02-20'),
		(4, 'Deepak', 'Finance', 'Chennai', '2024-03-05'),
		(5, 'Ezhil', 'IT', 'Bangalore', '2024-03-18'),
		(6, 'Fahad', 'HR', 'Hyderabad', '2024-04-01'),
		(7, 'Gokul', 'Finance', 'Hyderabad', '2024-04-12'),
		(8, 'Hari', 'IT', 'Chennai', '2024-05-08');

INSERT INTO Attendance
VALUES	(101, 1, '2024-06-01', 8.0, 'Present'),
		(102, 1, '2024-06-02', 7.5, 'Present'),
		(103, 1, '2024-06-03', 8.5, 'Present'),
		(104, 1, '2024-06-05', 6.0, 'Present'),
		(105, 1, '2024-06-06', 0.0, 'Absent'),

		(106, 2, '2024-06-01', 8.0, 'Present'),
		(107, 2, '2024-06-03', 7.0, 'Present'),
		(108, 2, '2024-06-04', 8.0, 'Present'),
		(109, 2, '2024-06-05', 0.0, 'Absent'),

		(110, 3, '2024-06-01', 9.0, 'Present'),
		(111, 3, '2024-06-02', 8.5, 'Present'),
		(112, 3, '2024-06-03', 8.0, 'Present'),
		(113, 3, '2024-06-04', 7.5, 'Present'),
		(114, 3, '2024-06-05', 8.5, 'Present'),

		(115, 4, '2024-06-01', 7.0, 'Present'),
		(116, 4, '2024-06-02', 0.0, 'Absent'),
		(117, 4, '2024-06-04', 8.0, 'Present'),
		(118, 4, '2024-06-05', 8.5, 'Present'),

		(119, 5, '2024-06-02', 8.0, 'Present'),
		(120, 5, '2024-06-03', 8.5, 'Present'),
		(121, 5, '2024-06-04', 9.0, 'Present'),
		(122, 5, '2024-06-06', 7.5, 'Present'),

		(123, 6, '2024-06-01', 8.0, 'Present'),
		(124, 6, '2024-06-02', 0.0, 'Absent'),
		(125, 6, '2024-06-03', 7.5, 'Present'),

		(126, 7, '2024-06-01', 8.5, 'Present'),
		(127, 7, '2024-06-02', 8.0, 'Present'),
		(128, 7, '2024-06-04', 7.5, 'Present'),

		(129, 8, '2024-06-01', 9.0, 'Present'),
		(130, 8, '2024-06-02', 8.5, 'Present'),
		(131, 8, '2024-06-03', 8.0, 'Present'),
		(132, 8, '2024-06-04', 9.0, 'Present');
        
SELECT *
FROM Employees;

SELECT *
FROM Attendance;

-- Q1
-- Show each employee's:
-- total attendance records
-- total hours worked
-- average hours worked
-- total present days
--
-- Use both tables.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Total_Attendance_Records
-- Total_Hours_Worked
-- Average_Hours_Worked
-- Total_Present_Days

SELECT E.Employee_ID, E.Employee_Name,
	   COUNT(A.Attendance_ID) AS Total_Attendance_Records,
       SUM(A.Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(A.Hours_Worked), 2) AS Average_Hours_Worked,
       COUNT(CASE
				WHEN A.Attendance_Status = 'Present'
				THEN 1
	   END) AS Total_Present_Days
FROM Employees E
INNER JOIN Attendance A
	ON E.Employee_ID = A.Employee_ID
GROUP BY E.Employee_ID, E.Employee_Name;


-- Q2
-- For each department, find:
-- total attendance records
-- total hours worked
-- average hours worked
-- total absent days.
--
-- Return:
-- Department
-- Total_Attendance_Records
-- Total_Hours_Worked
-- Average_Hours_Worked
-- Total_Absent_Days

SELECT E.Department,
	   COUNT(A.Attendance_ID) AS Total_Attendance_Records,
       SUM(A.Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(A.Hours_Worked), 2) AS Average_Hours_Worked,
       COUNT(CASE
				WHEN Attendance_Status = 'Absent'
				THEN 1
	   END) AS Total_Absent_Days
FROM Employees E
INNER JOIN Attendance A
	ON E.Employee_ID = A.Employee_ID
GROUP BY E.Department;


-- Q3
-- Find the top 3 employees in each city
-- based on total hours worked.
--
-- If tied, return all tied employees.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Employee_ID
-- Employee_Name
-- Total_Hours_Worked

SELECT City, Employee_ID, Employee_Name, Total_Hours_Worked
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Hours_Worked DESC) AS D_Rank
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.City,
			   SUM(A.Hours_Worked) AS Total_Hours_Worked
		FROM Employees E
		INNER JOIN Attendance A
			ON E.Employee_ID = A.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find attendance records where the employee's
-- hours worked are greater than their previous
-- attendance record.
--
-- Use JOIN + LAG().
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Attendance_Date
-- Hours_Worked
-- Previous_Hours_Worked

SELECT *
FROM (
	SELECT E.Employee_ID, E.Employee_Name, A.Attendance_Date, A.Hours_Worked,
		   LAG(A.Hours_Worked) OVER(PARTITION BY E.Employee_ID
		   ORDER BY A.Attendance_Date, A.Attendance_ID) AS Previous_Hours_Worked
	FROM Employees E
	INNER JOIN Attendance A
		ON E.Employee_ID = A.Employee_ID
)P
WHERE Hours_Worked > Previous_Hours_Worked;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total employees
-- total attendance records
-- total hours worked
-- average hours worked.
--
-- Definition:
-- Cohort Month = month in which the employee joined.
--
-- Return:
-- Cohort_Month
-- Total_Employees
-- Total_Attendance_Records
-- Total_Hours_Worked
-- Average_Hours_Worked

WITH CTE AS (
    SELECT Employee_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Employees
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Employee_ID) AS Total_Employees,
       COUNT(A.Attendance_ID) AS Total_Attendance_Records,
       SUM(A.Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(A.Hours_Worked), 2) AS Average_Hours_Worked
FROM CTE C
INNER JOIN Attendance A
	ON C.Employee_ID = A.Employee_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means being Present on consecutive dates.
--
-- Ignore duplicate attendance dates for the same employee.
--
-- Find each employee's longest Present streak.
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
	SELECT DISTINCT E.Employee_ID, E.Employee_Name, A.Attendance_Date
	FROM Employees E
	INNER JOIN Attendance A
		ON E.Employee_ID = A.Employee_ID
	WHERE A.Attendance_Status = 'Present'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Employee_ID
           ORDER BY Attendance_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Attendance_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Employee_ID, Employee_Name,
		   COUNT(*) AS Streak,
           MIN(Attendance_Date) AS Start_Date,
           MAX(Attendance_Date) AS End_Date
	FROM CTE3
    GROUP BY Employee_ID, Employee_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Employee_ID
           ORDER BY Streak DESC, End_Date DESC) AS Row_Num
	FROM CTE4
)
SELECT Employee_ID, Employee_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find employees whose total hours worked
-- are greater than the average total hours worked
-- of employees in the same department.
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
			   SUM(A.Hours_Worked) AS Total_Hours_Worked
		FROM Employees E
		INNER JOIN Attendance A
			ON E.Employee_ID = A.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)D
)A
WHERE Total_Hours_Worked > Avg_Dep;


-- INTERVIEW CHALLENGE
-- For each department, find the employee
-- with the highest total hours worked.
--
-- If tied, return all tied employees.
--
-- Return:
-- Department
-- Employee_ID
-- Employee_Name
-- Total_Hours_Worked

SELECT Department, Employee_ID, Employee_Name, Total_Hours_Worked
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Department
           ORDER BY Total_Hours_Worked DESC) AS D_Rank
	FROM (
		SELECT E.Department, E.Employee_ID, E.Employee_Name,
			   SUM(A.Hours_Worked) AS Total_Hours_Worked
		FROM Employees E
		INNER JOIN Attendance A
			ON E.Employee_ID = A.Employee_ID
		GROUP BY E.Department, E.Employee_ID, E.Employee_Name
	)D
)T
WHERE D_Rank = 1;