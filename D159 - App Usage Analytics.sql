USE Daily_SQL;

-- ============================================
-- DATASET: App Usage Analytics
-- ============================================

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    User_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE App_Usage (
    Usage_ID INT PRIMARY KEY,
    User_ID INT,
    App_Name VARCHAR(50),
    Usage_Date DATE,
    Minutes_Used INT,
    Usage_Status VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

INSERT INTO Users
VALUES	(1, 'Arun', 'Chennai', '2026-01-05'),
		(2, 'Bala', 'Chennai', '2026-01-12'),
		(3, 'Kavin', 'Madurai', '2026-02-03'),
		(4, 'Naveen', 'Madurai', '2026-02-15'),
		(5, 'Ravi', 'Coimbatore', '2026-02-20'),
		(6, 'Sanjay', 'Coimbatore', '2026-03-02'),
		(7, 'Vijay', 'Chennai', '2026-03-10'),
		(8, 'Hari', 'Madurai', '2026-03-18');

INSERT INTO App_Usage
VALUES	(101, 1, 'YouTube', '2026-03-01', 60, 'Completed'),
		(102, 1, 'Instagram', '2026-03-02', 40, 'Completed'),
		(103, 1, 'YouTube', '2026-03-03', 80, 'Completed'),
		(104, 1, 'Netflix', '2026-03-05', 100, 'Completed'),

		(105, 2, 'Instagram', '2026-03-01', 30, 'Completed'),
		(106, 2, 'WhatsApp', '2026-03-02', 25, 'Completed'),
		(107, 2, 'Instagram', '2026-03-04', 50, 'Completed'),
		(108, 2, 'Netflix', '2026-03-05', 90, 'Cancelled'),

		(109, 3, 'YouTube', '2026-03-02', 70, 'Completed'),
		(110, 3, 'Netflix', '2026-03-03', 120, 'Completed'),
		(111, 3, 'YouTube', '2026-03-04', 90, 'Completed'),
		(112, 3, 'Instagram', '2026-03-06', 45, 'Completed'),

		(113, 4, 'WhatsApp', '2026-03-01', 20, 'Completed'),
		(114, 4, 'YouTube', '2026-03-02', 60, 'Completed'),
		(115, 4, 'Netflix', '2026-03-03', 80, 'Completed'),
		(116, 4, 'Netflix', '2026-03-04', 100, 'Completed'),

		(117, 5, 'Instagram', '2026-03-05', 40, 'Completed'),
		(118, 5, 'YouTube', '2026-03-06', 70, 'Completed'),
		(119, 5, 'Netflix', '2026-03-07', 110, 'Completed'),
		(120, 5, 'Instagram', '2026-03-09', 60, 'Cancelled'),

		(121, 6, 'WhatsApp', '2026-03-01', 25, 'Completed'),
		(122, 6, 'YouTube', '2026-03-02', 55, 'Completed'),
		(123, 6, 'YouTube', '2026-03-03', 75, 'Completed'),
		(124, 6, 'Netflix', '2026-03-05', 95, 'Completed'),

		(125, 7, 'Instagram', '2026-03-10', 35, 'Completed'),
		(126, 7, 'YouTube', '2026-03-11', 65, 'Completed'),
		(127, 7, 'Netflix', '2026-03-12', 100, 'Completed'),
		(128, 7, 'Instagram', '2026-03-14', 45, 'Completed'),

		(129, 8, 'Netflix', '2026-03-12', 90, 'Completed'),
		(130, 8, 'YouTube', '2026-03-13', 60, 'Completed'),
		(131, 8, 'Netflix', '2026-03-14', 120, 'Completed'),
		(132, 8, 'WhatsApp', '2026-03-16', 30, 'Completed');
        

SELECT *
FROM Users;

SELECT *
FROM App_Usage;


-- ============================================
-- QUESTIONS
-- ============================================

-- Q1
-- Show each user's:
-- total usage records
-- total minutes used
-- average minutes used
-- total completed usage records.
--
-- Use both tables.
--
-- Return:
-- User_ID
-- User_Name
-- Total_Usage_Records
-- Total_Minutes_Used
-- Average_Minutes_Used
-- Total_Completed_Records

SELECT U.User_ID, U.User_Name,
	   COUNT(A.Usage_ID) AS Total_Usage_Records,
       SUM(A.Minutes_Used) AS Total_Minutes_Used,
       ROUND(AVG(A.Minutes_Used), 2) AS Average_Minutes_Used,
       COUNT(CASE
				WHEN Usage_Status = 'Completed'
                THEN 1
	   END) AS Total_Completed_Records
FROM Users U
INNER JOIN App_Usage A
	ON U.User_ID = A.User_ID
GROUP BY U.User_ID, U.User_Name;


-- Q2
-- For each app, find:
-- total usage records
-- total minutes used
-- average minutes used
-- unique users.
--
-- Return:
-- App_Name
-- Total_Usage_Records
-- Total_Minutes_Used
-- Average_Minutes_Used
-- Unique_Users

SELECT App_Name,
	   COUNT(Usage_ID) AS Total_Usage_Records,
       SUM(Minutes_Used) AS Total_Minutes_Used,
       ROUND(AVG(Minutes_Used), 2) AS Average_Minutes_Used,
       COUNT(DISTINCT User_ID) AS Unique_Users
FROM App_Usage
GROUP BY App_Name;


-- Q3
-- Find the top 3 users in each city
-- based on total minutes used.
--
-- If tied, return all tied users.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- User_ID
-- User_Name
-- Total_Minutes_Used

SELECT City, User_ID, User_Name, Total_Minutes_Used
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Minutes_Used DESC) AS D_Rank
	FROM (
		SELECT U.City, U.User_ID, U.User_Name,
			   SUM(A.Minutes_Used) AS Total_Minutes_Used
		FROM Users U
		INNER JOIN App_Usage A
			ON U.User_ID = A.User_ID
		GROUP BY U.City, U.User_ID, U.User_Name
	)C
)M
WHERE D_Rank <= 3;


-- Q4
-- Find usage records where the minutes used
-- are greater than the user's previous usage.
--
-- Use JOIN + LAG().
--
-- Return:
-- User_ID
-- User_Name
-- Usage_Date
-- Minutes_Used
-- Previous_Minutes_Used

SELECT *
FROM (
	SELECT U.User_ID, U.User_Name, A.Usage_Date, A.Minutes_Used,
		   LAG(A.Minutes_Used) OVER(PARTITION BY U.User_ID
		   ORDER BY A.Usage_Date, A.Usage_ID) AS Previous_Minutes_Used
	FROM Users U
	INNER JOIN App_Usage A
		ON U.User_ID = A.User_ID
)P
WHERE Minutes_Used > Previous_Minutes_Used;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total users
-- total usage records
-- total minutes used
-- average minutes used.
--
-- Definition:
-- Cohort Month = month in which the user joined.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Usage_Records
-- Total_Minutes_Used
-- Average_Minutes_Used

WITH CTE AS (
    SELECT User_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Users
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
       COUNT(A.Usage_ID) AS Total_Usage_Records,
       SUM(A.Minutes_Used) AS Total_Minutes_Used,
       ROUND(AVG(A.Minutes_Used), 2) AS Average_Minutes_Used
FROM CTE C
INNER JOIN App_Usage A
	ON C.User_ID = A.User_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means using an app on consecutive dates.
--
-- Ignore duplicate usage dates for the same user.
--
-- Find each user's longest usage-date streak.
--
-- If multiple streaks have the same length,
-- return the most recent streak.
--
-- Return:
-- User_ID
-- User_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT U.User_ID, U.User_Name, A.Usage_Date
	FROM Users U
	INNER JOIN App_Usage A
		ON U.User_ID = A.User_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Usage_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Usage_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT User_ID, User_Name,
		   COUNT(*) AS Streak,
           MIN(Usage_Date) AS Start_Date,
           MAX(Usage_Date) AS End_Date
	FROM CTE3
    GROUP BY User_ID, User_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Streak DESC, End_Date DESC) AS Row_Num
	FROM CTE4
)
SELECT User_ID, User_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find users whose total minutes used
-- are greater than the average total minutes used
-- of users in the same city.
--
-- Return:
-- User_ID
-- User_Name
-- City
-- Total_Minutes_Used

SELECT User_ID, User_Name, City, Total_Minutes_Used
FROM (
	SELECT *,
		   AVG(Total_Minutes_Used) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(A.Minutes_Used) AS Total_Minutes_Used
		FROM Users U
		INNER JOIN App_Usage A
			ON U.User_ID = A.User_ID
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)A
WHERE Total_Minutes_Used > Avg_City;


-- INTERVIEW CHALLENGE
-- For each app, find the user
-- with the highest total minutes used
-- for that app.
--
-- If tied, return all tied users.
--
-- Return:
-- App_Name
-- User_ID
-- User_Name
-- Total_Minutes_Used

SELECT App_Name, User_ID, User_Name, Total_Minutes_Used
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY App_Name
           ORDER BY Total_Minutes_Used DESC) AS D_Rank
	FROM (
		SELECT A.App_Name, U.User_ID, U.User_Name,
			   SUM(A.Minutes_Used) AS Total_Minutes_Used
		FROM Users U
		INNER JOIN App_Usage A
			ON U.User_ID = A.User_ID
		GROUP BY A.App_Name, U.User_ID, U.User_Name
	)D
)H
WHERE D_Rank = 1;