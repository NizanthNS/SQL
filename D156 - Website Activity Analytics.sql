USE Daily_SQL;

-- Website Activity Analytics

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    User_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Users
VALUES	(1, 'Arun', 'Chennai', '2025-01-15'),
		(2, 'Bala', 'Chennai', '2025-02-10'),
		(3, 'Charan', 'Bangalore', '2025-01-20'),
		(4, 'Deepak', 'Bangalore', '2025-03-05'),
		(5, 'Eshan', 'Mumbai', '2025-02-18'),
		(6, 'Fahad', 'Mumbai', '2025-01-25'),
		(7, 'Gokul', 'Chennai', '2025-03-12'),
		(8, 'Hari', 'Bangalore', '2025-02-22');

CREATE TABLE Website_Activity (
    Activity_ID INT PRIMARY KEY,
    User_ID INT,
    Activity_Type VARCHAR(50),
    Activity_Date DATE,
    Minutes_Spent INT,
    Activity_Status VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

INSERT INTO Website_Activity
VALUES	(101, 1, 'Browsing',  '2025-04-01', 30, 'Success'),
		(102, 1, 'Video',     '2025-04-02', 45, 'Success'),
		(103, 1, 'Browsing',  '2025-04-03', 20, 'Failed'),
		(104, 1, 'Shopping',  '2025-04-05', 60, 'Success'),

		(105, 2, 'Browsing',  '2025-04-01', 25, 'Success'),
		(106, 2, 'Shopping',  '2025-04-02', 50, 'Success'),
		(107, 2, 'Video',     '2025-04-04', 40, 'Failed'),
		(108, 2, 'Browsing',  '2025-04-05', 35, 'Success'),

		(109, 3, 'Video',     '2025-04-01', 55, 'Success'),
		(110, 3, 'Browsing',  '2025-04-02', 30, 'Success'),
		(111, 3, 'Video',     '2025-04-03', 65, 'Success'),
		(112, 3, 'Shopping',  '2025-04-05', 70, 'Success'),

		(113, 4, 'Browsing',  '2025-04-02', 20, 'Failed'),
		(114, 4, 'Video',     '2025-04-03', 50, 'Success'),
		(115, 4, 'Shopping',  '2025-04-04', 80, 'Success'),
		(116, 4, 'Browsing',  '2025-04-06', 25, 'Success'),

		(117, 5, 'Shopping',  '2025-04-01', 90, 'Success'),
		(118, 5, 'Browsing',  '2025-04-02', 35, 'Success'),
		(119, 5, 'Video',     '2025-04-04', 60, 'Failed'),
		(120, 5, 'Shopping',  '2025-04-05', 75, 'Success'),

		(121, 6, 'Video',     '2025-04-01', 40, 'Success'),
		(122, 6, 'Browsing',  '2025-04-02', 25, 'Success'),
		(123, 6, 'Shopping',  '2025-04-03', 55, 'Success'),
		(124, 6, 'Video',     '2025-04-04', 70, 'Success'),

		(125, 7, 'Browsing',  '2025-04-01', 15, 'Success'),
		(126, 7, 'Video',     '2025-04-02', 35, 'Success'),
		(127, 7, 'Shopping',  '2025-04-03', 45, 'Failed'),
		(128, 7, 'Browsing',  '2025-04-04', 30, 'Success'),

		(129, 8, 'Video',     '2025-04-01', 50, 'Success'),
		(130, 8, 'Shopping',  '2025-04-02', 65, 'Success'),
		(131, 8, 'Browsing',  '2025-04-03', 30, 'Success'),
		(132, 8, 'Video',     '2025-04-05', 80, 'Success');


SELECT *
FROM Users;

SELECT *
FROM Website_Activity;


-- Q1
-- Show each user's:
-- total activities
-- total minutes spent
-- average minutes spent
-- total successful activities.
--
-- Use both tables.
--
-- Return:
-- User_ID
-- User_Name
-- Total_Activities
-- Total_Minutes_Spent
-- Average_Minutes_Spent
-- Total_Successful_Activities

SELECT U.User_ID, U.User_Name,
	   COUNT(W.Activity_ID) AS Total_Activities,
       SUM(W.Minutes_Spent) AS Total_Minutes_Spent,
       ROUND(AVG(W.Minutes_Spent), 2) AS Average_Minutes_Spent,
       COUNT(CASE
				WHEN Activity_Status = 'Success'
                THEN 1
			  END) AS Total_Successful_Activities
FROM Users U
INNER JOIN Website_Activity W
	ON U.User_ID = W.User_ID
GROUP BY U.User_ID, U.User_Name;
    

-- Q2
-- For each activity type, find:
-- total activities
-- total minutes spent
-- average minutes spent
-- unique users.
--
-- Return:
-- Activity_Type
-- Total_Activities
-- Total_Minutes_Spent
-- Average_Minutes_Spent
-- Unique_Users

SELECT Activity_Type,
	   COUNT(Activity_ID) AS Total_Activities,
       SUM(Minutes_Spent) AS Total_Minutes_Spent,
       ROUND(AVG(Minutes_Spent), 2) AS Average_Minutes_Spent,
       COUNT(DISTINCT User_ID) AS Unique_Users
FROM Website_Activity
GROUP BY Activity_Type;


-- Q3
-- Find the top 3 users in each city
-- based on total minutes spent.
--
-- If tied, return all tied users.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- User_ID
-- User_Name
-- Total_Minutes_Spent

SELECT City, User_ID, User_Name, Total_Minutes_Spent
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Minutes_Spent DESC) AS D_Rank
	FROM (
		SELECT U.City, U.User_ID, U.User_Name,
			   SUM(W.Minutes_Spent) AS Total_Minutes_Spent
		FROM Users U
		INNER JOIN Website_Activity W
			ON U.User_ID = W.User_ID
		GROUP BY U.City, U.User_ID, U.User_Name
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find activities where the minutes spent
-- are greater than the user's previous activity.
--
-- Use JOIN + LAG().
--
-- Return:
-- User_ID
-- User_Name
-- Activity_Date
-- Minutes_Spent
-- Previous_Minutes_Spent

SELECT *
FROM (
	SELECT U.User_ID, U.User_Name, W.Activity_Date, W.Minutes_Spent,
		   LAG(W.Minutes_Spent) OVER(PARTITION BY U.User_ID
		   ORDER BY W.Activity_Date, W.Activity_ID) AS Previous_Minutes_Spent
	FROM Users U
	INNER JOIN Website_Activity W
		ON U.User_ID = W.User_ID
)P
WHERE Minutes_Spent > Previous_Minutes_Spent;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total users
-- total activities
-- total minutes spent
-- average minutes spent.
--
-- Definition:
-- Cohort Month = month in which the user joined.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Activities
-- Total_Minutes_Spent
-- Average_Minutes_Spent

WITH CTE AS (
    SELECT User_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Users
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
       COUNT(W.Activity_ID) AS Total_Activities,
       SUM(W.Minutes_Spent) AS Total_Minutes_Spent,
       ROUND(AVG(W.Minutes_Spent), 2) AS Average_Minutes_Spent
FROM CTE C
INNER JOIN Website_Activity W
	ON C.User_ID = W.User_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means activity occurring on consecutive dates.
--
-- Ignore duplicate activity dates for the same user.
--
-- Find each user's longest activity-date streak.
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
	SELECT DISTINCT U.User_ID, U.User_Name, W.Activity_Date
	FROM Users U
	INNER JOIN Website_Activity W
		ON U.User_ID = W.User_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Activity_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Activity_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT User_ID, User_Name,
		   COUNT(*) AS Streak,
           MIN(Activity_Date) AS Start_Date,
           MAX(Activity_Date) AS End_Date
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
-- Find users whose total minutes spent
-- are greater than the average total minutes spent
-- of users in the same city.
--
-- Return:
-- User_ID
-- User_Name
-- City
-- Total_Minutes_Spent

SELECT User_ID, User_Name, City, Total_Minutes_Spent
FROM (
	SELECT *,
		   AVG(Total_Minutes_Spent) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(W.Minutes_Spent) AS Total_Minutes_Spent
		FROM Users U
		INNER JOIN Website_Activity W
			ON U.User_ID = W.User_ID
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)A
WHERE Total_Minutes_Spent> Avg_City;


-- INTERVIEW CHALLENGE
-- For each activity type, find the user
-- with the highest total minutes spent
-- for that activity type.
--
-- If tied, return all tied users.
--
-- Return:
-- Activity_Type
-- User_ID
-- User_Name
-- Total_Minutes_Spent

SELECT Activity_Type, User_ID, User_Name, Total_Minutes_Spent
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Activity_Type
           ORDER BY Total_Minutes_Spent DESC) AS D_Rank
	FROM (
		SELECT W.Activity_Type, U.User_ID, U.User_Name,
			   SUM(W.Minutes_Spent) AS Total_Minutes_Spent
		FROM Users U
		INNER JOIN Website_Activity W
			ON U.User_ID = W.User_ID
		GROUP BY W.Activity_Type, U.User_ID, U.User_Name
	)D
)A
WHERE D_Rank = 1;