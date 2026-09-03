USE Daily_SQL;

-- ============================================================
-- DOMAIN: App Analytics
-- ============================================================


CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    User_Name VARCHAR(50),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Users
VALUES	(1, 'Ethan',  'London',    '2026-01-05'),
		(2, 'Chloe',  'Toronto',   '2026-01-08'),
		(3, 'Lucas',  'Berlin',    '2026-01-12'),
		(4, 'Amelia', 'Sydney',    '2026-01-18'),
		(5, 'Noah',   'Amsterdam', '2026-02-03'),
		(6, 'Sophie', 'Madrid',    '2026-02-07'),
		(7, 'Liam',   'Paris',     '2026-02-11'),
		(8, 'Emma',   'Copenhagen', '2026-02-15'),
		(9, 'Oliver', 'Lisbon',    '2026-03-02'),
		(10, 'Grace', 'Vienna',    '2026-03-06'),
		(11, 'Henry', 'Zurich',    '2026-03-10'),
		(12, 'Mia',   'Dublin',    '2026-03-15');


CREATE TABLE App_Usage (
    Usage_ID INT PRIMARY KEY,
    User_ID INT,
    App_Name VARCHAR(50),
    App_Category VARCHAR(50),
    Usage_Date DATE,
    Minutes_Used INT,
    Session_Rating DECIMAL(3,1),
    Usage_Status VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

INSERT INTO App_Usage
VALUES	(101, 1,  'Streamly', 'Entertainment', '2026-03-01', 45, 4.2, 'Completed'),
		(102, 1,  'FitTrack', 'Health',        '2026-03-02', 30, 4.5, 'Completed'),
		(103, 1,  'Streamly', 'Entertainment', '2026-03-03', 60, 4.4, 'Completed'),
		(104, 1,  'ChatBox',  'Social',         '2026-03-05', 25, 4.0, 'Completed'),
		(105, 1,  'Streamly', 'Entertainment', '2026-03-06', 75, 4.7, 'Completed'),

		(106, 2,  'ChatBox',  'Social',         '2026-03-01', 40, 4.1, 'Completed'),
		(107, 2,  'Streamly', 'Entertainment', '2026-03-02', 55, 4.3, 'Completed'),
		(108, 2,  'FitTrack', 'Health',        '2026-03-04', 35, 4.6, 'Completed'),
		(109, 2,  'ChatBox',  'Social',         '2026-03-05', 50, 4.2, 'Completed'),
		(110, 2,  'Streamly', 'Entertainment', '2026-03-07', 65, 4.5, 'Completed'),

		(111, 3,  'FitTrack', 'Health',        '2026-03-02', 25, 4.0, 'Completed'),
		(112, 3,  'FitTrack', 'Health',        '2026-03-03', 40, 4.3, 'Completed'),
		(113, 3,  'ChatBox',  'Social',         '2026-03-04', 30, 3.9, 'Abandoned'),
		(114, 3,  'Streamly', 'Entertainment', '2026-03-05', 70, 4.6, 'Completed'),
		(115, 3,  'Streamly', 'Entertainment', '2026-03-06', 80, 4.8, 'Completed'),

		(116, 4,  'Streamly', 'Entertainment', '2026-03-01', 35, 4.1, 'Completed'),
		(117, 4,  'ChatBox',  'Social',         '2026-03-03', 45, 4.4, 'Completed'),
		(118, 4,  'FitTrack', 'Health',        '2026-03-04', 50, 4.5, 'Completed'),
		(119, 4,  'Streamly', 'Entertainment', '2026-03-05', 65, 4.7, 'Completed'),
		(120, 4,  'ChatBox',  'Social',         '2026-03-06', 55, 4.3, 'Completed'),

		(121, 5,  'ChatBox',  'Social',         '2026-03-02', 30, 4.0, 'Completed'),
		(122, 5,  'Streamly', 'Entertainment', '2026-03-03', 50, 4.2, 'Completed'),
		(123, 5,  'FitTrack', 'Health',        '2026-03-04', 40, 4.5, 'Completed'),
		(124, 5,  'ChatBox',  'Social',         '2026-03-06', 60, 4.4, 'Completed'),

		(125, 6,  'FitTrack', 'Health',        '2026-03-03', 45, 4.3, 'Completed'),
		(126, 6,  'Streamly', 'Entertainment', '2026-03-04', 55, 4.5, 'Completed'),
		(127, 6,  'Streamly', 'Entertainment', '2026-03-05', 70, 4.7, 'Completed'),
		(128, 6,  'ChatBox',  'Social',         '2026-03-07', 35, 4.1, 'Completed'),

		(129, 7,  'ChatBox',  'Social',         '2026-03-01', 20, 3.8, 'Completed'),
		(130, 7,  'ChatBox',  'Social',         '2026-03-02', 35, 4.0, 'Completed'),
		(131, 7,  'Streamly', 'Entertainment', '2026-03-03', 55, 4.4, 'Completed'),
		(132, 7,  'FitTrack', 'Health',        '2026-03-04', 45, 4.2, 'Completed'),
		(133, 7,  'Streamly', 'Entertainment', '2026-03-06', 75, 4.6, 'Completed'),

		(134, 8,  'FitTrack', 'Health',        '2026-03-02', 35, 4.1, 'Completed'),
		(135, 8,  'FitTrack', 'Health',        '2026-03-03', 50, 4.4, 'Completed'),
		(136, 8,  'ChatBox',  'Social',         '2026-03-04', 40, 4.2, 'Completed'),
		(137, 8,  'Streamly', 'Entertainment', '2026-03-05', 60, 4.5, 'Completed'),
		(138, 8,  'Streamly', 'Entertainment', '2026-03-06', 70, 4.7, 'Completed'),

		(139, 9,  'Streamly', 'Entertainment', '2026-03-03', 40, 4.0, 'Completed'),
		(140, 9,  'ChatBox',  'Social',         '2026-03-04', 30, 4.1, 'Completed'),
		(141, 9,  'FitTrack', 'Health',        '2026-03-05', 50, 4.4, 'Completed'),
		(142, 9,  'Streamly', 'Entertainment', '2026-03-07', 80, 4.8, 'Completed'),

		(143, 10, 'ChatBox',  'Social',         '2026-03-04', 25, 3.9, 'Completed'),
		(144, 10, 'FitTrack', 'Health',        '2026-03-05', 45, 4.3, 'Completed'),
		(145, 10, 'Streamly', 'Entertainment', '2026-03-06', 65, 4.6, 'Completed'),
		(146, 10, 'ChatBox',  'Social',         '2026-03-07', 40, 4.2, 'Completed'),

		(147, 11, 'FitTrack', 'Health',        '2026-03-05', 30, 4.1, 'Completed'),
		(148, 11, 'Streamly', 'Entertainment', '2026-03-06', 60, 4.5, 'Completed'),
		(149, 11, 'ChatBox',  'Social',         '2026-03-07', 50, 4.3, 'Completed'),

		(150, 12, 'ChatBox',  'Social',         '2026-03-06', 35, 4.0, 'Completed'),
		(151, 12, 'Streamly', 'Entertainment', '2026-03-07', 70, 4.6, 'Completed');


SELECT *
FROM Users;

SELECT *
FROM App_Usage;


-- ============================================================
-- QUESTIONS
-- ============================================================


-- Q1
-- Show each user's:
-- total usage records
-- total minutes used
-- average minutes used
-- total completed sessions.
--
-- Use both tables.
--
-- Return:
-- User_ID
-- User_Name
-- Total_Usage_Records
-- Total_Minutes_Used
-- Average_Minutes_Used
-- Total_Completed_Sessions

SELECT U.User_ID, U.User_Name,
	   COUNT(A.Usage_ID) AS Total_Usage_Records,
       SUM(A.Minutes_Used) AS Total_Minutes_Used,
       ROUND(AVG(A.Minutes_Used), 2) AS Average_Minutes_Used,
       COUNT(
       CASE
			WHEN Usage_Status = 'Completed'
			THEN 1
	   END) AS Total_Completed_Records
FROM Users U
INNER JOIN App_Usage A
	ON U.User_ID = A.User_ID
GROUP BY U.User_ID, U.User_Name;


-- Q2
-- For each app category, find:
-- total usage records
-- total completed minutes
-- average session rating
-- unique users.
--
-- Only Completed sessions should be considered.
--
-- Return:
-- App_Category
-- Total_Usage_Records
-- Total_Completed_Minutes
-- Average_Session_Rating
-- Unique_Users

SELECT App_Category,
	   COUNT(Usage_ID) AS Total_Usage_Records,
       SUM(Minutes_Used) AS Total_Completed_Minutes,
       ROUND(AVG(Session_Rating), 2) AS Average_Session_Rating,
       COUNT(DISTINCT User_ID) AS Unique_Users
FROM App_Usage
WHERE Usage_Status = 'Completed'
GROUP BY App_Category;


-- Q3
-- Find the top 3 users in each city
-- based on total completed minutes used.
--
-- If tied, return all tied users.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- User_ID
-- User_Name
-- Total_Completed_Minutes

SELECT City, User_ID, User_Name, Total_Completed_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Completed_Minutes DESC) AS D_Rank
	FROM (
		SELECT U.City, U.User_ID, U.User_Name,
			   SUM(A.Minutes_Used) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN App_Usage A
			ON U.User_ID = A.User_ID
		WHERE A.Usage_Status = 'Completed'
		GROUP BY U.City, U.User_ID, U.User_Name
	)C
)M
WHERE D_Rank <= 3;


-- Q4
-- Find usage sessions where the user's
-- minutes used are greater than their previous
-- completed session.
--
-- Only Completed sessions should be compared.
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
	WHERE A.Usage_Status = 'Completed'
)P
WHERE Minutes_Used > Previous_Minutes_Used;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total users
-- total completed sessions
-- total completed minutes
-- average completed minutes.
--
-- Definition:
-- Cohort Month = month in which the user signed up.
--
-- Only Completed sessions should be considered
-- for activity metrics.
--
-- Total_Users should include ALL users in the cohort,
-- even users with no completed sessions.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Completed_Sessions
-- Total_Completed_Minutes
-- Average_Completed_Minutes

WITH CTE AS (
    SELECT User_ID,
           DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
    FROM Users
),
CTE2 AS (
	SELECT *
    FROM App_Usage
    WHERE Usage_Status = 'Completed'
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
       COUNT(A.Usage_ID) AS Total_Completed_Sessions,
       SUM(A.Minutes_Used) AS Total_Completed_Minutes,
       ROUND(AVG(A.Minutes_Used), 2) AS Average_Completed_Minutes
FROM CTE C
LEFT JOIN CTE2 A
	ON C.User_ID = A.User_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS (GAP & ISLAND)
-- ============================================================
-- A streak means having a Completed usage session
-- on consecutive dates.
--
-- Ignore duplicate usage dates for the same user.
-- Only Completed sessions count.
--
-- Find each user's longest completed-usage
-- date streak.
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
	WHERE Usage_Status = 'Completed'
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


-- ============================================================
-- BONUS+
-- ============================================================
-- Find users whose total completed minutes
-- are greater than the average total completed minutes
-- of users in the same city.
--
-- Return:
-- User_ID
-- User_Name
-- City
-- Total_Completed_Minutes

SELECT User_ID, User_Name, City, Total_Completed_Minutes
FROM (
	SELECT *,
		   AVG(Total_Completed_Minutes) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(A.Minutes_Used) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN App_Usage A
			ON U.User_ID = A.User_ID
		WHERE Usage_Status = 'Completed'
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)A
WHERE Total_Completed_Minutes > Avg_City;


-- ============================================================
-- INTERVIEW CHALLENGE
-- ============================================================
-- For each app category, find the user
-- with the highest total completed minutes used
-- in that category.
--
-- Only Completed sessions should be considered.
--
-- If tied, return all tied users.
--
-- Return:
-- App_Category
-- User_ID
-- User_Name
-- Total_Completed_Minutes

SELECT App_Category, User_ID, User_Name, Total_Completed_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY App_Category
           ORDER BY Total_Completed_Minutes DESC) AS D_Rank
	FROM (
		SELECT A.App_Category, U.User_ID, U.User_Name,
			   SUM(A.Minutes_Used) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN App_Usage A
			ON U.User_ID = A.User_ID
		WHERE Usage_Status = 'Completed'
		GROUP BY A.App_Category, U.User_ID, U.User_Name
	)D
)H
WHERE D_Rank = 1;