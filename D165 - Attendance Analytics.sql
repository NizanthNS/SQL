USE Daily_SQL;

-- DATASET : Attendance Analytics

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Employee_Attendance (
    Attendance_ID INT PRIMARY KEY,
    Employee_ID INT,
    Attendance_Date DATE,
    Hours_Worked DECIMAL(5,2),
    Attendance_Status VARCHAR(20),
    Work_Type VARCHAR(30),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

INSERT INTO Employees
VALUES	(1, 'Connor', 'London', '2025-01-10'),
		(2, 'Ash', 'Toronto', '2025-01-15'),
		(3, 'Ethan', 'Sydney', '2025-02-05'),
		(4, 'Liam', 'Berlin', '2025-02-20'),
		(5, 'Olivia', 'Paris', '2025-03-01'),
		(6, 'Mason', 'Toronto', '2025-03-12'),
		(7, 'Sophia', 'London', '2025-04-08'),
		(8, 'Noah', 'Berlin', '2025-04-18');

INSERT INTO Employee_Attendance
VALUES	(101, 1, '2025-05-01', 8.00, 'Present', 'Office'),
		(102, 1, '2025-05-02', 7.50, 'Present', 'Remote'),
		(103, 1, '2025-05-03', 6.00, 'Absent',  'Office'),
		(104, 1, '2025-05-05', 9.00, 'Present', 'Office'),

		(105, 2, '2025-05-01', 8.50, 'Present', 'Remote'),
		(106, 2, '2025-05-02', 7.00, 'Present', 'Office'),
		(107, 2, '2025-05-04', 8.00, 'Present', 'Remote'),
		(108, 2, '2025-05-05', 5.00, 'Absent',  'Office'),

		(109, 3, '2025-05-10', 8.00, 'Present', 'Office'),
		(110, 3, '2025-05-11', 9.00, 'Present', 'Remote'),
		(111, 3, '2025-05-12', 7.50, 'Present', 'Office'),
		(112, 3, '2025-05-14', 8.50, 'Present', 'Office'),

		(113, 4, '2025-05-10', 6.50, 'Present', 'Remote'),
		(114, 4, '2025-05-11', 0.00, 'Absent',  'Office'),
		(115, 4, '2025-05-12', 9.00, 'Present', 'Office'),
		(116, 4, '2025-05-14', 8.00, 'Present', 'Remote'),

		(117, 5, '2025-06-01', 8.00, 'Present', 'Office'),
		(118, 5, '2025-06-02', 8.50, 'Present', 'Remote'),
		(119, 5, '2025-06-03', 7.00, 'Present', 'Office'),
		(120, 5, '2025-06-04', 9.00, 'Present', 'Office'),

		(121, 6, '2025-06-01', 9.00, 'Present', 'Remote'),
		(122, 6, '2025-06-02', 7.50, 'Present', 'Office'),
		(123, 6, '2025-06-04', 8.50, 'Present', 'Remote'),
		(124, 6, '2025-06-05', 9.00, 'Present', 'Office'),

		(125, 7, '2025-06-10', 7.50, 'Present', 'Office'),
		(126, 7, '2025-06-11', 8.00, 'Present', 'Remote'),
		(127, 7, '2025-06-12', 9.00, 'Present', 'Office'),
		(128, 7, '2025-06-14', 6.50, 'Present', 'Remote'),

		(129, 8, '2025-06-10', 8.00, 'Present', 'Office'),
		(130, 8, '2025-06-11', 5.00, 'Absent',  'Remote'),
		(131, 8, '2025-06-12', 8.50, 'Present', 'Office'),
		(132, 8, '2025-06-14', 9.00, 'Present', 'Remote');
        

SELECT *
FROM Employees;

SELECT *
FROM Employee_Attendance;


-- Q1
-- Show each employee's:
-- total attendance records
-- total hours worked
-- average hours worked
-- total present days.
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
INNER JOIN Employee_Attendance A
	ON E.Employee_ID = A.Employee_ID
GROUP BY E.Employee_ID, E.Employee_Name;


-- Q2
-- For each work type, find:
-- total attendance records
-- total hours worked
-- average hours worked
-- unique employees.
--
-- Return:
-- Work_Type
-- Total_Attendance_Records
-- Total_Hours_Worked
-- Average_Hours_Worked
-- Unique_Employees

SELECT Work_Type,
	   COUNT(Attendance_ID) AS Total_Attendance_Records,
       SUM(Hours_Worked) AS Total_Hours_Worked,
       ROUND(AVG(Hours_Worked), 2) AS Average_Hours_Worked,
       COUNT(DISTINCT Employee_ID) AS Unique_Employees
FROM Employee_Attendance
GROUP BY Work_Type;


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
		INNER JOIN Employee_Attendance A
			ON E.Employee_ID = A.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find attendance records where the hours worked
-- are greater than the employee's previous
-- present-day hours worked.
--
-- Only Present records should be compared.
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
	INNER JOIN Employee_Attendance A
		ON E.Employee_ID = A.Employee_ID
	WHERE A.Attendance_Status = 'Present'
)P
WHERE Hours_Worked > Previous_Hours_Worked;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total employees
-- total present days
-- total present hours
-- average present hours.
--
-- Definition:
-- Cohort Month = month in which the employee joined.
--
-- Only Present attendance records should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Employees
-- Total_Present_Days
-- Total_Present_Hours
-- Average_Present_Hours

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
       SUM(A.Hours_Worked) AS Total_Present_Hours,
       ROUND(AVG(A.Hours_Worked), 2) AS Average_Present_Hours
FROM CTE C
INNER JOIN CTE2 A
	ON C.Employee_ID = A.Employee_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means being Present
-- on consecutive dates.
--
-- Ignore duplicate attendance dates for the same employee.
-- Only Present records count.
--
-- Find each employee's longest present-day streak.
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


-- BONUS+
-- Find employees whose total present hours
-- are greater than the average total present hours
-- of employees in the same city.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- City
-- Total_Present_Hours

SELECT Employee_ID, Employee_Name, City, Total_Present_Hours
FROM (
	SELECT *,
		   AVG(Total_Present_Hours) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.City,
			   SUM(A.Hours_Worked) AS Total_Present_Hours
		FROM Employees E
		INNER JOIN Employee_Attendance A
			ON E.Employee_ID = A.Employee_ID
		WHERE A.Attendance_Status = 'Present'
		GROUP BY E.Employee_ID, E.Employee_Name, E.City
	)P
)A
WHERE Total_Present_Hours > Avg_City;


-- INTERVIEW CHALLENGE
-- For each work type, find the employee
-- with the highest total hours worked
-- for that work type.
--
-- Only Present records should be considered.
--
-- If tied, return all tied employees.
--
-- Return:
-- Work_Type
-- Employee_ID
-- Employee_Name
-- Total_Present_Hours

SELECT Work_Type, Employee_ID, Employee_Name, Total_Present_Hours
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Work_Type
           ORDER BY Total_Present_Hours DESC) AS D_Rank
	FROM (
		SELECT A.Work_Type, E.Employee_ID, E.Employee_Name,
			   SUM(A.Hours_Worked) AS Total_Present_Hours
		FROM Employees E
		INNER JOIN Employee_Attendance A
			ON E.Employee_ID = A.Employee_ID
		WHERE A.Attendance_Status = 'Present'
		GROUP BY A.Work_Type, E.Employee_ID, E.Employee_Name
	)D
)T
WHERE D_Rank = 1;