USE Daily_SQL;

-- ============================================================
-- DAILY SQL SESSION
-- Topic: Employee Performance & Attendance Analytics
-- ============================================================

-- ============================================================
-- DATASET
-- ============================================================

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Employee_Attendance (
    Attendance_ID INT PRIMARY KEY,
    Employee_ID INT,
    Attendance_Date DATE,
    Work_Hours DECIMAL(5,2),
    Attendance_Status VARCHAR(20),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);


-- ============================================================
-- INSERT EMPLOYEES
-- ============================================================

INSERT INTO Employees
VALUES	(1, 'Connor', 'Engineering', 'London',  '2024-01-10'),
		(2, 'Ash',    'Engineering', 'Toronto', '2024-02-15'),
		(3, 'Ethan',  'Marketing',   'Sydney',  '2024-03-05'),
		(4, 'Liam',   'Marketing',   'Berlin',  '2024-03-20'),
		(5, 'Olivia', 'Finance',     'Paris',   '2024-04-02'),
		(6, 'Mason',  'Finance',     'Toronto', '2024-04-18'),
		(7, 'Sophia', 'Engineering', 'London',  '2024-05-06'),
		(8, 'Noah',   'Finance',     'Berlin',  '2024-05-22');


-- ============================================================
-- INSERT ATTENDANCE
-- ============================================================

INSERT INTO Employee_Attendance
VALUES	(101, 1, '2025-06-01', 8.5, 'Present'),
		(102, 1, '2025-06-02', 9.0, 'Present'),
		(103, 1, '2025-06-03', 7.5, 'Present'),
		(104, 1, '2025-06-04', 8.0, 'Absent'),
		(105, 1, '2025-06-05', 9.0, 'Present'),
		(106, 1, '2025-06-07', 8.5, 'Present'),

		(107, 2, '2025-06-01', 7.5, 'Present'),
		(108, 2, '2025-06-02', 8.0, 'Present'),
		(109, 2, '2025-06-04', 9.0, 'Present'),
		(110, 2, '2025-06-05', 8.5, 'Present'),
		(111, 2, '2025-06-06', 7.0, 'Absent'),
		(112, 2, '2025-06-08', 9.0, 'Present'),

		(113, 3, '2025-06-10', 8.0, 'Present'),
		(114, 3, '2025-06-11', 8.5, 'Present'),
		(115, 3, '2025-06-12', 9.0, 'Present'),
		(116, 3, '2025-06-14', 7.5, 'Present'),
		(117, 3, '2025-06-15', 8.0, 'Absent'),
		(118, 3, '2025-06-16', 9.0, 'Present'),

		(119, 4, '2025-06-10', 9.0, 'Present'),
		(120, 4, '2025-06-11', 8.5, 'Present'),
		(121, 4, '2025-06-13', 7.5, 'Present'),
		(122, 4, '2025-06-14', 8.0, 'Present'),
		(123, 4, '2025-06-15', 8.5, 'Present'),
		(124, 4, '2025-06-17', 9.0, 'Present'),

		(125, 5, '2025-07-01', 8.0, 'Present'),
		(126, 5, '2025-07-02', 9.0, 'Present'),
		(127, 5, '2025-07-03', 8.5, 'Present'),
		(128, 5, '2025-07-05', 7.5, 'Absent'),
		(129, 5, '2025-07-06', 9.0, 'Present'),
		(130, 5, '2025-07-07', 8.5, 'Present'),

		(131, 6, '2025-07-01', 9.0, 'Present'),
		(132, 6, '2025-07-02', 8.5, 'Present'),
		(133, 6, '2025-07-04', 7.5, 'Present'),
		(134, 6, '2025-07-05', 9.0, 'Present'),
		(135, 6, '2025-07-06', 8.0, 'Present'),
		(136, 6, '2025-07-08', 8.5, 'Present'),

		(137, 7, '2025-07-10', 8.5, 'Present'),
		(138, 7, '2025-07-11', 9.0, 'Present'),
		(139, 7, '2025-07-12', 8.0, 'Present'),
		(140, 7, '2025-07-13', 9.0, 'Present'),
		(141, 7, '2025-07-15', 7.5, 'Present'),
		(142, 7, '2025-07-16', 8.5, 'Present'),

		(143, 8, '2025-07-10', 7.5, 'Present'),
		(144, 8, '2025-07-11', 8.0, 'Absent'),
		(145, 8, '2025-07-12', 8.5, 'Present'),
		(146, 8, '2025-07-13', 9.0, 'Present'),
		(147, 8, '2025-07-15', 8.0, 'Present'),
		(148, 8, '2025-07-16', 9.0, 'Present');


-- ============================================================
-- INSPECT DATA
-- ============================================================

SELECT *
FROM Employees;

SELECT *
FROM Employee_Attendance;


-- ============================================================
-- Q1 — EMPLOYEE ATTENDANCE SUMMARY
-- ============================================================
-- Show each employee's:
--   1. Total attendance records
--   2. Total work hours
--   3. Average work hours
--   4. Total present days
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Total_Attendance_Records
-- Total_Work_Hours
-- Average_Work_Hours
-- Total_Present_Days

SELECT E.Employee_ID, E.Employee_Name,
	   COUNT(A.Attendance_ID) AS Total_Attendance_Records,
       SUM(A.Work_Hours) AS Total_Work_Hours,
       ROUND(AVG(A.Work_Hours), 2) AS Average_Work_Hours,
       COUNT(CASE
				WHEN A.Attendance_Status = 'Present'
				THEN 1
	   END) AS Total_Present_Days
FROM Employees E
INNER JOIN Employee_Attendance A
	ON E.Employee_ID = A.Employee_ID
GROUP BY E.Employee_ID, E.Employee_Name;


-- ============================================================
-- Q2 — DEPARTMENT PERFORMANCE
-- ============================================================
-- For each department, find:
--   1. Total attendance records
--   2. Total present days
--   3. Total work hours on Present days
--   4. Average work hours on Present days
--   5. Number of unique employees
--
-- Return:
-- Department
-- Total_Attendance_Records
-- Total_Present_Days
-- Total_Present_Work_Hours
-- Average_Present_Work_Hours
-- Unique_Employees

SELECT E.Department,
	   COUNT(A.Attendance_ID) AS Total_Attendance_Records,
       COUNT(
       CASE
			WHEN A.Attendance_Status = 'Present'
			THEN 1
	   END) AS Total_Present_Days,
       SUM(
       CASE
			WHEN A.Attendance_Status = 'Present'
			THEN A.Work_Hours
            ELSE 0
	   END) AS Total_Present_Work_Hours,
       ROUND(AVG(
       CASE
			WHEN A.Attendance_Status = 'Present'
			THEN A.Work_Hours
	   END), 2) AS Average_Present_Work_Hours,
       COUNT(DISTINCT E.Employee_ID) AS Unique_Employees
FROM Employees E
INNER JOIN Employee_Attendance A
	ON E.Employee_ID = A.Employee_ID
GROUP BY E.Department;


-- ============================================================
-- Q3 — TOP 2 EMPLOYEES BY DEPARTMENT
-- ============================================================
-- Find the TOP 2 employees in each department based on
-- their TOTAL PRESENT WORK HOURS.
--
-- Use DENSE_RANK().
-- Include ties.
--
-- Return:
-- Department
-- Employee_ID
-- Employee_Name
-- Total_Present_Work_Hours

SELECT Department, Employee_ID, Employee_Name, Total_Present_Work_Hours
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Department
           ORDER BY Total_Present_Work_Hours DESC) AS D_Rank
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   SUM(A.Work_Hours) AS Total_Present_Work_Hours
		FROM Employees E
		INNER JOIN Employee_Attendance A
			ON E.Employee_ID = A.Employee_ID
		WHERE A.Attendance_Status = 'Present'
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)T
)D
WHERE D_Rank <= 2;


-- ============================================================
-- Q4 — DATE LOGIC
-- ============================================================
-- Find employees who had a PRESENT attendance record
-- within 2 days of their previous PRESENT attendance record.
--
-- Ignore Absent records when calculating the gap.
--
-- Use:
-- LAG() + DATEDIFF()
--
-- Return:
-- Employee_ID
-- Employee_Name

SELECT DISTINCT Employee_ID, Employee_Name
FROM (
	SELECT E.Employee_ID, E.Employee_Name, A.Attendance_Date,
		   LAG(A.Attendance_Date) OVER(PARTITION BY E.Employee_ID
		   ORDER BY A.Attendance_Date, A.Attendance_ID) AS Previous_Work_Date
	FROM Employees E
	INNER JOIN Employee_Attendance A
		ON E.Employee_ID = A.Employee_ID
	WHERE A.Attendance_Status = 'Present'
)P
WHERE Previous_Work_Date IS NOT NULL
AND DATEDIFF(Attendance_Date, Previous_Work_Date) <= 2;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================
-- Group employees by their JOIN MONTH.
--
-- For each join cohort month, calculate:
--   1. Total employees
--   2. Total present days
--   3. Total present work hours
--   4. Average present work hours
--
-- Only PRESENT attendance records should contribute
-- to attendance metrics.
--
-- Return:
-- Cohort_Month
-- Total_Employees
-- Total_Present_Days
-- Total_Present_Work_Hours
-- Average_Present_Work_Hours

WITH CTE AS (
    SELECT Employee_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Employees
),
CTE2 AS (
	SELECT *
    FROM Employee_Attendance
    WHERE Attendance_Status = 'Present'
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Employee_ID) AS Total_Employees,
       COUNT(A.Attendance_ID) AS Total_Present_Days,
       SUM(A.Work_Hours) AS Total_Present_Work_Hours,
       ROUND(AVG(A.Work_Hours), 2) AS Average_Present_Work_Hours
FROM CTE C
LEFT JOIN CTE2 A
	ON C.Employee_ID = A.Employee_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================
-- Find each employee's LONGEST STREAK of consecutive
-- PRESENT attendance dates.
--
-- Rules:
--   - Only Present dates count.
--   - Ignore Absent records.
--   - Duplicate dates should count only once.
--   - If two streaks have the same length,
--     choose the MOST RECENT streak.
--
-- Expected pattern:
-- DISTINCT dates
-- -> ROW_NUMBER()
-- -> DATE_SUB()
-- -> GROUP BY Group_Key
-- -> MIN / MAX / COUNT
-- -> rank streaks
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
	INNER JOIN Employee_Attendance A
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


-- ============================================================
-- BONUS+ — ABOVE-DEPARTMENT-AVERAGE
-- ============================================================
-- Find employees whose TOTAL PRESENT WORK HOURS are
-- greater than the AVERAGE TOTAL PRESENT WORK HOURS
-- of employees in their own department.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Total_Present_Work_Hours

SELECT Employee_ID, Employee_Name, Department, Total_Present_Work_Hours
FROM (
	SELECT *,
		   AVG(Total_Present_Work_Hours) OVER(PARTITION BY Department) AS Avg_D
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   SUM(A.Work_Hours) AS Total_Present_Work_Hours
		FROM Employees E
		INNER JOIN Employee_Attendance A
			ON E.Employee_ID = A.Employee_ID
		WHERE A.Attendance_Status = 'Present'
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)T
)A
WHERE Total_Present_Work_Hours > Avg_D;


-- ============================================================
-- INTERVIEW CHALLENGE
-- ============================================================
-- For each department, find the employee(s) with the
-- HIGHEST TOTAL PRESENT WORK HOURS.
--
-- If multiple employees are tied for the highest value,
-- return ALL tied employees.
--
-- Use DENSE_RANK().
--
-- Return:
-- Department
-- Employee_ID
-- Employee_Name
-- Total_Present_Work_Hours
-- ============================================================

SELECT Department, Employee_ID, Employee_Name, Total_Present_Work_Hours
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Department
           ORDER BY Total_Present_Work_Hours DESC) AS D_Rank
	FROM (
		SELECT E.Department, E.Employee_ID, E.Employee_Name,
			   SUM(A.Work_Hours) AS Total_Present_Work_Hours
		FROM Employees E
		INNER JOIN Employee_Attendance A
			ON E.Employee_ID = A.Employee_ID
		WHERE A.Attendance_Status = 'Present'
		GROUP BY E.Department, E.Employee_ID, E.Employee_Name
	)D
)T
WHERE D_Rank = 1;