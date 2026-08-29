USE Daily_SQL;

-- DATASET : Website Analytics

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    User_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Users
VALUES	(1, 'Connor', 'London', '2025-01-10'),
		(2, 'Ash', 'Toronto', '2025-01-15'),
		(3, 'Ethan', 'Sydney', '2025-02-05'),
		(4, 'Liam', 'Berlin', '2025-02-20'),
		(5, 'Noah', 'Paris', '2025-03-01'),
		(6, 'Mason', 'London', '2025-03-12'),
		(7, 'Oliver', 'Toronto', '2025-04-08'),
		(8, 'Lucas', 'Sydney', '2025-04-18');


CREATE TABLE Website_Activity (
    Activity_ID INT PRIMARY KEY,
    User_ID INT,
    Page_Name VARCHAR(100),
    Activity_Date DATE,
    Minutes_Spent INT,
    Activity_Status VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

INSERT INTO Website_Activity
VALUES	(1, 1, 'Home', '2025-05-01', 12, 'Completed'),
		(2, 1, 'Products', '2025-05-02', 18, 'Completed'),
		(3, 1, 'Checkout', '2025-05-03', 25, 'Completed'),
		(4, 1, 'Profile', '2025-05-05', 10, 'Completed'),
		(5, 2, 'Home', '2025-05-01', 15, 'Completed'),
		(6, 2, 'Products', '2025-05-03', 22, 'Completed'),
		(7, 2, 'Cart', '2025-05-04', 17, 'Pending'),
		(8, 2, 'Checkout', '2025-05-05', 30, 'Completed'),
		(9, 3, 'Home', '2025-05-02', 10, 'Completed'),
		(10, 3, 'Products', '2025-05-03', 20, 'Completed'),
		(11, 3, 'Products', '2025-05-04', 25, 'Completed'),
		(12, 3, 'Checkout', '2025-05-06', 35, 'Completed'),
		(13, 4, 'Home', '2025-05-01', 8, 'Completed'),
		(14, 4, 'Search', '2025-05-02', 14, 'Completed'),
		(15, 4, 'Products', '2025-05-03', 21, 'Completed'),
		(16, 4, 'Cart', '2025-05-04', 28, 'Completed'),
		(17, 5, 'Home', '2025-05-03', 11, 'Completed'),
		(18, 5, 'Products', '2025-05-04', 16, 'Pending'),
		(19, 5, 'Checkout', '2025-05-06', 24, 'Completed'),
		(20, 6, 'Home', '2025-05-01', 13, 'Completed'),
		(21, 6, 'Products', '2025-05-02', 19, 'Completed'),
		(22, 6, 'Cart', '2025-05-03', 27, 'Completed'),
		(23, 6, 'Checkout', '2025-05-04', 32, 'Completed'),
		(24, 7, 'Home', '2025-05-02', 9, 'Completed'),
		(25, 7, 'Search', '2025-05-03', 15, 'Completed'),
		(26, 7, 'Products', '2025-05-05', 23, 'Completed'),
		(27, 7, 'Checkout', '2025-05-06', 29, 'Completed'),
		(28, 8, 'Home', '2025-05-01', 7, 'Completed'),
		(29, 8, 'Products', '2025-05-02', 18, 'Completed'),
		(30, 8, 'Cart', '2025-05-03', 20, 'Pending'),
		(31, 8, 'Checkout', '2025-05-04', 31, 'Completed');
        

SELECT *
FROM Users;

SELECT *
FROM Website_Activity;


-- Q1
-- Show each user's:
-- total activity records
-- total minutes spent
-- average minutes spent
-- total completed activities.
--
-- Use both tables.
--
-- Return:
-- User_ID
-- User_Name
-- Total_Activity_Records
-- Total_Minutes_Spent
-- Average_Minutes_Spent
-- Total_Completed_Activities

SELECT U.User_ID, U.User_Name,
	   COUNT(W.Activity_ID) AS Total_Activity_Records,
       SUM(W.Minutes_Spent) AS Total_Minutes_Spent,
       ROUND(AVG(W.Minutes_Spent), 2) AS Average_Minutes_Spent,
	   COUNT(
	   CASE
			WHEN Activity_Status = 'Completed'
			THEN 1
	   END) AS Total_Completed_Activities
FROM Users U
INNER JOIN Website_Activity W
	ON U.User_ID = W.User_ID
GROUP BY U.User_ID, U.User_Name;


-- Q2
-- For each page, find:
-- total activity records
-- total minutes spent
-- average minutes spent
-- unique users.
--
-- Return:
-- Page_Name
-- Total_Activity_Records
-- Total_Minutes_Spent
-- Average_Minutes_Spent
-- Unique_Users

SELECT Page_Name,
	   COUNT(Activity_ID) AS Total_Activity_Records,
       SUM(Minutes_Spent) AS Total_Minutes_Spent,
       ROUND(AVG(Minutes_Spent), 2) AS Average_Minutes_Spent,
       COUNT(DISTINCT User_ID) AS Unique_Users
FROM Website_Activity
GROUP BY Page_Name;


-- Q3
-- Find the top 3 users in each city
-- based on total completed minutes spent.
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
			   SUM(W.Minutes_Spent) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Website_Activity W
			ON U.User_ID = W.User_ID
		WHERE Activity_Status = 'Completed'
		GROUP BY U.City, U.User_ID, U.User_Name
	)T
)D
WHERE D_Rank <= 3;


-- Q4
-- Find website activities where the user's
-- minutes spent are greater than their previous
-- completed activity.
--
-- Only Completed activities should be compared.
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
	WHERE Activity_Status = 'Completed'
)P
WHERE Minutes_Spent > Previous_Minutes_Spent;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total users
-- total completed activities
-- total completed minutes
-- average completed minutes.
--
-- Definition:
-- Cohort Month = month in which the user joined.
--
-- Only Completed activities should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Completed_Activities
-- Total_Completed_Minutes
-- Average_Completed_Minutes

WITH CTE AS (
    SELECT User_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Users
),
CTE2 AS (
	SELECT *
    FROM Website_Activity
    WHERE Activity_Status = 'Completed'
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
       COUNT(W.Activity_ID) AS Total_Completed_Activities,
       SUM(W.Minutes_Spent) AS Total_Completed_Minutes,
       ROUND(AVG(W.Minutes_Spent), 2) AS Average_Completed_Minutes
FROM CTE C
INNER JOIN CTE2 W
	ON C.User_ID = W.User_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means having a Completed website activity
-- on consecutive dates.
--
-- Ignore duplicate activity dates for the same user.
-- Only Completed activities count.
--
-- Find each user's longest completed-activity
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
	SELECT DISTINCT U.User_ID, U.User_Name, W.Activity_Date
	FROM Users U
	INNER JOIN Website_Activity W
		ON U.User_ID = W.User_ID
	WHERE W.Activity_Status = 'Completed'
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
			   SUM(W.Minutes_Spent) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Website_Activity W
			ON U.User_ID = W.User_ID
		WHERE Activity_Status = 'Completed'
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)A
WHERE Total_Completed_Minutes > Avg_City;


-- INTERVIEW CHALLENGE
-- For each page, find the user
-- with the highest total completed minutes
-- spent on that page.
--
-- Only Completed activities should be considered.
--
-- If tied, return all tied users.
--
-- Return:
-- Page_Name
-- User_ID
-- User_Name
-- Total_Completed_Minutes

SELECT Page_Name, User_ID, User_Name, Total_Completed_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Page_Name
           ORDER BY Total_Completed_Minutes DESC) AS D_Rank
	FROM (
		SELECT W.Page_Name, U.User_ID, U.User_Name,
			   SUM(W.Minutes_Spent) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Website_Activity W
			ON U.User_ID = W.User_ID
		WHERE Activity_Status = 'Completed'
		GROUP BY W.Page_Name, U.User_ID, U.User_Name
	)D
)W
WHERE D_Rank = 1;