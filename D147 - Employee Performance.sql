USE Daily_SQL;

-- DATASET: Employee Performance

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Department VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Employees
VALUES	(1,'Arun','IT','Chennai','2024-01-10'),
		(2,'Divya','HR','Bangalore','2024-02-15'),
		(3,'Karthik','IT','Chennai','2024-03-20'),
		(4,'Sneha','Finance','Hyderabad','2024-01-25'),
		(5,'Rahul','HR','Bangalore','2024-04-12'),
		(6,'Priya','Finance','Hyderabad','2024-02-28'),
		(7,'Vijay','IT','Chennai','2024-05-05'),
		(8,'Anitha','HR','Bangalore','2024-03-18');

CREATE TABLE Performance (
    Performance_ID INT PRIMARY KEY,
    Employee_ID INT,
    Review_Date DATE,
    Rating INT,
    Performance_Score DECIMAL(5,2),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

INSERT INTO Performance
VALUES	(101,1,'2024-06-01',4,82.5),
		(102,1,'2024-07-01',5,91.0),
		(103,1,'2024-08-01',4,87.5),

		(104,2,'2024-06-05',3,72.0),
		(105,2,'2024-07-05',4,81.5),
		(106,2,'2024-08-05',4,84.0),

		(107,3,'2024-06-03',5,94.0),
		(108,3,'2024-07-03',5,96.5),
		(109,3,'2024-08-03',4,89.0),

		(110,4,'2024-06-02',3,68.0),
		(111,4,'2024-07-02',3,71.5),
		(112,4,'2024-08-02',4,80.0),

		(113,5,'2024-06-06',4,85.0),
		(114,5,'2024-07-06',4,83.5),
		(115,5,'2024-08-06',5,92.0),

		(116,6,'2024-06-04',5,90.0),
		(117,6,'2024-07-04',4,86.0),
		(118,6,'2024-08-04',5,93.5),

		(119,7,'2024-06-10',3,74.0),
		(120,7,'2024-07-10',4,82.0),
		(121,7,'2024-08-10',4,88.0),

		(122,8,'2024-06-07',4,80.5),
		(123,8,'2024-07-07',3,75.0),
		(124,8,'2024-08-07',4,84.5);
        
SELECT *
FROM Employees;

SELECT *
FROM Performance;

-- Q1
-- Show each employee's:
-- total reviews,
-- total performance score,
-- average performance score,
-- number of reviews with Rating >= 4.
--
-- Use both tables.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Total_Reviews
-- Total_Performance_Score
-- Average_Performance_Score
-- High_Rating_Reviews

SELECT E.Employee_ID, E.Employee_Name,
       COUNT(P.Performance_ID) AS Total_Reviews,
       SUM(P.Performance_Score) AS Total_Performance_Score,
       ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score,
       SUM(CASE
               WHEN P.Rating >= 4 THEN 1
               ELSE 0
           END) AS High_Rating_Reviews
FROM Employees E
INNER JOIN Performance P
    ON E.Employee_ID = P.Employee_ID
GROUP BY E.Employee_ID, E.Employee_Name;


-- Q2
-- Show each department's:
-- total reviews,
-- average performance score,
-- number of high-rating reviews.
--
-- High-rating review = Rating >= 4.
--
-- Return:
-- Department
-- Total_Reviews
-- Average_Performance_Score
-- High_Rating_Reviews

SELECT E.Department,
	   COUNT(P.Performance_ID) AS Total_Reviews,
	   ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score,
       SUM(CASE
				WHEN P.Rating >= 4 THEN 1
                ELSE 0
		   END) AS High_Rating_Reviews
FROM Employees E
INNER JOIN Performance P
	ON E.Employee_ID = P.Employee_ID
GROUP BY E.Department;


-- Q3
-- Find the top 3 employees by average performance score.
--
-- Use DENSE_RANK().
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Average_Performance_Score

WITH CTE AS (
	SELECT E.Employee_ID, E.Employee_Name, E.Department,
		   ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score
	FROM Employees E
	INNER JOIN Performance P
		ON E.Employee_ID = P.Employee_ID
	GROUP BY E.Employee_ID, E.Employee_Name, E.Department
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(ORDER BY Average_Performance_Score DESC) AS D_Rank
	FROM CTE
)
SELECT Employee_ID, Employee_Name, Department, Average_Performance_Score
FROM CTE2
WHERE D_Rank <= 3;


-- Q4
-- Find employees whose performance score improved
-- compared with their previous review.
--
-- Use JOIN + LAG().
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Review_Date
-- Performance_Score
-- Previous_Score

WITH CTE AS (
	SELECT E.Employee_ID, E.Employee_Name, P.Review_Date, P.Performance_Score,
		   LAG(P.Performance_Score) OVER(PARTITION BY E.Employee_ID
		   ORDER BY P.Review_Date) AS Previous_Score
	FROM Employees E
	INNER JOIN Performance P
		ON E.Employee_ID = P.Employee_ID
)
SELECT *
FROM CTE
WHERE Performance_Score > Previous_Score;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total employees,
-- average performance score,
-- total high-rating reviews.
--
-- Definition:
-- Cohort Month = Month in which the employee joined.
--
-- Return:
-- Cohort_Month
-- Total_Employees
-- Average_Performance_Score
-- High_Rating_Reviews

WITH CTE AS (
	SELECT Employee_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Employees
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Employee_ID) AS Total_Employees,
       ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score,
	   SUM(CASE
               WHEN P.Rating >= 4 THEN 1
               ELSE 0
	   END) AS High_Rating_Reviews
FROM CTE C
INNER JOIN Performance P
	ON C.Employee_ID = P.Employee_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each employee's longest streak of reviews
-- where Rating >= 4.
--
-- A streak means reviews occurring in consecutive months.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Longest_Streak
-- Start_Date
-- End_Date
--
-- If multiple streaks have the same length,
-- return the most recent streak.

WITH CTE AS (
	SELECT E.Employee_ID, E.Employee_Name, P.Review_Date
	FROM Employees E
	INNER JOIN Performance P
		ON E.Employee_ID = P.Employee_ID
	WHERE P.Rating >= 4
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Employee_ID
		   ORDER BY Review_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Review_Date, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Employee_ID, Employee_Name,
		   COUNT(*) AS Streak,
		   MIN(Review_Date) AS Start_Date,
           MAX(Review_Date) AS End_Date
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
-- Find employees whose average performance score
-- is greater than the average performance score
-- of employees in the same department.
--
-- Return:
-- Employee_ID
-- Employee_Name
-- Department
-- Average_Performance_Score

SELECT Employee_ID, Employee_Name, Department, Average_Performance_Score
FROM (
	SELECT *,
		   AVG(Average_Performance_Score) OVER(PARTITION BY Department) AS Avg_Score
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   ROUND(AVG(P.Performance_Score), 2) AS Average_Performance_Score
		FROM Employees E
		INNER JOIN Performance P
			ON E.Employee_ID = P.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)A
)P
WHERE Average_Performance_Score > Avg_Score;


-- INTERVIEW CHALLENGE
-- For each department, find the employee who has:
-- the highest number of high-rating reviews.
--
-- If tied, return all tied employees.
--
-- High-rating review = Rating >= 4.
--
-- Return:
-- Department
-- Employee_ID
-- Employee_Name
-- High_Rating_Reviews

SELECT Department, Employee_ID, Employee_Name, High_Rating_Reviews
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Department
           ORDER BY High_Rating_Reviews DESC) AS D_Rank
	FROM (
		SELECT E.Employee_ID, E.Employee_Name, E.Department,
			   SUM(CASE
               WHEN P.Rating >= 4 THEN 1
               ELSE 0
	    END) AS High_Rating_Reviews
		FROM Employees E
		INNER JOIN Performance P
			ON E.Employee_ID = P.Employee_ID
		GROUP BY E.Employee_ID, E.Employee_Name, E.Department
	)H
)P
WHERE D_Rank = 1;