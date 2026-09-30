USE Daily_SQL;

-- ============================================================
-- DAILY SQL SESSION
-- Topic: Subscription & User Activity Analytics
-- ============================================================

CREATE TABLE Subscription_Activity (
    Activity_ID INT PRIMARY KEY,
    User_ID INT,
    User_Name VARCHAR(50),
    City VARCHAR(40),
    Activity_Date DATE,
    Plan_Type VARCHAR(30),
    Activity_Type VARCHAR(30),
    Amount DECIMAL(10,2)
);

INSERT INTO Subscription_Activity
VALUES	(1,201,'Michael','London','2026-01-02','Premium','Subscription',40),
		(2,201,'Michael','London','2026-01-03','Premium','Login',0),
		(3,201,'Michael','London','2026-01-04','Premium','Login',0),
		(4,201,'Michael','London','2026-01-06','Premium','Payment',40),

		(5,202,'Sophia','Toronto','2026-01-05','Basic','Subscription',20),
		(6,202,'Sophia','Toronto','2026-01-06','Basic','Login',0),
		(7,202,'Sophia','Toronto','2026-01-09','Basic','Login',0),
		(8,202,'Sophia','Toronto','2026-01-10','Basic','Payment',20),

		(9,203,'Daniel','Berlin','2026-01-10','Premium','Subscription',40),
		(10,203,'Daniel','Berlin','2026-01-11','Premium','Login',0),
		(11,203,'Daniel','Berlin','2026-01-12','Premium','Login',0),
		(12,203,'Daniel','Berlin','2026-01-13','Premium','Login',0),
		(13,203,'Daniel','Berlin','2026-01-15','Premium','Payment',40),

		(14,204,'Emma','Paris','2026-02-01','Premium','Subscription',40),
		(15,204,'Emma','Paris','2026-02-02','Premium','Login',0),
		(16,204,'Emma','Paris','2026-02-03','Premium','Payment',40),
		(17,204,'Emma','Paris','2026-02-05','Premium','Login',0),

		(18,205,'Oliver','London','2026-02-07','Basic','Subscription',20),
		(19,205,'Oliver','London','2026-02-08','Basic','Login',0),
		(20,205,'Oliver','London','2026-02-09','Basic','Login',0),

		(21,206,'Charlotte','Toronto','2026-02-10','Premium','Subscription',40),
		(22,206,'Charlotte','Toronto','2026-02-11','Premium','Login',0),
		(23,206,'Charlotte','Toronto','2026-02-12','Premium','Login',0),
		(24,206,'Charlotte','Toronto','2026-02-13','Premium','Login',0),
		(25,206,'Charlotte','Toronto','2026-02-14','Premium','Payment',40),

		(26,207,'Henry','Berlin','2026-03-01','Basic','Subscription',20),
		(27,207,'Henry','Berlin','2026-03-03','Basic','Login',0),
		(28,207,'Henry','Berlin','2026-03-04','Basic','Login',0),
		(29,207,'Henry','Berlin','2026-03-07','Basic','Payment',20),

		(30,208,'Amelia','Paris','2026-03-05','Premium','Subscription',40),
		(31,208,'Amelia','Paris','2026-03-06','Premium','Login',0),
		(32,208,'Amelia','Paris','2026-03-07','Premium','Login',0),
		(33,208,'Amelia','Paris','2026-03-08','Premium','Login',0),
		(34,208,'Amelia','Paris','2026-03-10','Premium','Payment',40),

		(35,209,'William','London','2026-03-10','Basic','Subscription',20),
		(36,209,'William','London','2026-03-11','Basic','Login',0),
		(37,209,'William','London','2026-03-14','Basic','Login',0),

		(38,210,'Isabella','Toronto','2026-03-15','Premium','Subscription',40),
		(39,210,'Isabella','Toronto','2026-03-16','Premium','Login',0),
		(40,210,'Isabella','Toronto','2026-03-17','Premium','Login',0),
		(41,210,'Isabella','Toronto','2026-03-18','Premium','Login',0),
		(42,210,'Isabella','Toronto','2026-03-20','Premium','Payment',40);


SELECT *
FROM Subscription_Activity;


-- ============================================================
-- Q1 — USER ACTIVITY SUMMARY
-- ============================================================
-- Show each user's:
-- 1. Total activities
-- 2. Total logins
-- 3. Total payments
-- 4. Total amount paid
--
-- Return:
-- User_ID
-- User_Name
-- Total_Activities
-- Total_Logins
-- Total_Payments
-- Total_Amount_Paid

SELECT User_ID, User_Name,
	   COALESCE(COUNT(Activity_ID), 0) AS Total_Activities,
       COALESCE(COUNT(
       CASE
			WHEN Activity_Type = 'Login'
            THEN Activity_ID
	   END), 0) AS Total_Logins,
       COALESCE(COUNT(
       CASE
			WHEN Activity_Type = 'Payment'
            THEN Activity_ID
	   END), 0) AS Total_Payments,
       COALESCE(SUM(Amount), 0) AS Total_Amount_Paid
FROM Subscription_Activity
GROUP BY User_ID, User_Name;


-- ============================================================
-- Q2 — PLAN PERFORMANCE
-- ============================================================
-- For each plan type, find:
-- 1. Total users
-- 2. Total logins
-- 3. Total payments
-- 4. Total revenue
-- 5. Average payment amount
--
-- Return:
-- Plan_Type
-- Total_Users
-- Total_Logins
-- Total_Payments
-- Total_Revenue
-- Average_Payment_Amount

SELECT Plan_Type,
	   COALESCE(COUNT(DISTINCT User_ID), 0) AS Total_Users,
       COALESCE(COUNT(
       CASE
			WHEN Activity_Type = 'Login'
            THEN Activity_ID
	   END), 0) AS Total_Logins,
       COALESCE(COUNT(
       CASE
			WHEN Activity_Type = 'Payment'
            THEN Activity_ID
	   END), 0) AS Total_Payments,
       COALESCE(SUM(Amount), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(
       CASE
			WHEN Activity_Type = 'Payment'
            THEN Amount
	   END), 2), 0) AS Average_Payment_Amount
FROM Subscription_Activity
GROUP BY Plan_Type;


-- ============================================================
-- Q3 — TOP 3 USERS BY LOGIN ACTIVITY
-- ============================================================
-- Find the top 3 users based on total number of logins.
--
-- Requirements:
-- Use a CTE
-- Use DENSE_RANK()
--
-- Return:
-- User_ID
-- User_Name
-- Total_Logins
-- Login_Rank

WITH CTE AS (
	SELECT User_ID, User_Name,
		   COUNT(
		   CASE
				WHEN Activity_Type = 'Login'
				THEN Activity_ID
		   END) AS Total_Logins
	FROM Subscription_Activity
	GROUP BY User_ID, User_Name
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(ORDER BY Total_Logins DESC) AS Login_Rank
	FROM CTE
)
SELECT User_ID, User_Name, Total_Logins, Login_Rank
FROM CTE2
WHERE Login_Rank <= 3;


-- ============================================================
-- Q4 — REPEAT LOGIN WITHIN 2 DAYS
-- ============================================================
-- Find users who logged in within 2 days of
-- their previous login.
--
-- Only consider Activity_Type = 'Login'.
--
-- Return:
-- User_ID
-- User_Name
--
-- Use:
-- LAG()
-- DATEDIFF()

WITH CTE AS (
	SELECT User_ID, User_Name, Activity_Date,
		   LAG(Activity_Date) OVER(PARTITION BY User_ID
           ORDER BY Activity_Date, Activity_ID) AS Previous
	FROM Subscription_Activity
    WHERE Activity_Type = 'Login'
)
SELECT DISTINCT User_ID, User_Name
FROM CTE
WHERE Previous IS NOT NULL
AND DATEDIFF(Activity_Date, Previous) <= 2;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================
-- A user's cohort month is the month of their
-- FIRST SUBSCRIPTION activity.
--
-- For each cohort month, find:
-- 1. Total users
-- 2. Total login activities
-- 3. Total payment activities
-- 4. Total revenue
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Logins
-- Total_Payments
-- Total_Revenue
--
-- Important:
-- Cohort is determined by the first Subscription activity,
-- not the first Login or Payment.

WITH CTE AS (
	SELECT User_ID,
		   MIN(Activity_Date) AS First_Activity_Date
	FROM Subscription_Activity
    WHERE Activity_Type = 'Subscription'
    GROUP BY User_ID
),
CTE2 AS (
	SELECT *,
           DATE_FORMAT(First_Activity_Date, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT Cohort_Month,
	   COALESCE(COUNT(DISTINCT C.User_ID), 0) AS Total_Users,
       COALESCE(COUNT(
       CASE
			WHEN S.Activity_Type = 'Login'
            THEN S.Activity_ID
	   END), 0) AS Total_Logins,
       COALESCE(COUNT(
       CASE
			WHEN S.Activity_Type = 'Payment'
            THEN S.Activity_ID
	   END), 0) AS Total_Payments,
       COALESCE(SUM(S.Amount), 0) AS Total_Revenue
FROM CTE2 C
INNER JOIN Subscription_Activity S
	ON C.User_ID = S.User_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================
-- Find each user's CURRENT LOGIN STREAK.
--
-- A streak consists of consecutive calendar days
-- on which the user logged in.
--
-- If a user has multiple Login activities on the same
-- day, count that date only once.
--
-- Current streak = the streak containing the user's
-- most recent login date.
--
-- Return:
-- User_ID
-- User_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return ONLY users whose Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT User_ID, User_Name, Activity_Date
    FROM Subscription_Activity
    WHERE Activity_Type = 'Login'
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
           ORDER BY End_Date DESC) AS Row_Num
	FROM CTE4
)		   
SELECT User_ID, User_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1
AND Streak >= 3;


-- ============================================================
-- BONUS+ — USER LOGIN ACTIVITY VS CITY AVERAGE
-- ============================================================
-- Calculate each user's total number of logins.
--
-- Then calculate the average number of logins
-- among users in the same city.
--
-- Return ONLY users whose login count is
-- above their city's average.
--
-- Return:
-- User_ID
-- User_Name
-- City
-- Total_Logins
-- City_Average_Logins

SELECT User_ID, User_Name, City, Total_Logins, City_Average_Logins
FROM (
	SELECT *,
		   ROUND(AVG(Total_Logins) OVER(PARTITION BY City), 2) AS City_Average_Logins
	FROM (
		SELECT User_ID, User_Name, City,
			   COUNT(Activity_ID) AS Total_Logins
		FROM Subscription_Activity
		WHERE Activity_Type = 'Login'
        GROUP BY User_ID, User_Name, City
	)A
)C
WHERE Total_Logins > City_Average_Logins;


-- ============================================================
-- INTERVIEW CHALLENGE — TOP USER PER CITY
-- ============================================================
-- Find the user with the highest number of logins
-- in each city.
--
-- Requirements:
-- 1. Calculate user-level login counts first
-- 2. Use a window function
-- 3. Include all users in case of a tie
--
-- Return:
-- City
-- User_ID
-- User_Name
-- Total_Logins

SELECT City, User_ID, User_Name, Total_Logins
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Logins DESC) AS D_Rank
	FROM (
		SELECT User_ID, User_Name, City,
			   COUNT(Activity_ID) AS Total_Logins
		FROM Subscription_Activity
		WHERE Activity_Type = 'Login'
        GROUP BY User_ID, User_Name, City
	)L
)D
WHERE D_Rank = 1;