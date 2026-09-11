USE Daily_SQL;

-- ============================================================
-- DAILY SQL SESSION
-- Topic: Streaming Platform Activity Analysis
-- ============================================================


-- ============================================================
-- DATASET
-- ============================================================

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    User_Name VARCHAR(50),
    City VARCHAR(50),
    Signup_Date DATE
);

CREATE TABLE Watch_History (
    Watch_ID INT PRIMARY KEY,
    User_ID INT,
    Content_Category VARCHAR(50),
    Watch_Date DATE,
    Minutes_Watched INT,
    Watch_Status VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);


INSERT INTO Users
VALUES  (1, 'Connor', 'London',  '2025-01-05'),
        (2, 'Ash',    'Toronto', '2025-01-12'),
        (3, 'Ethan',  'Sydney',  '2025-02-03'),
        (4, 'Liam',   'Berlin',  '2025-02-18'),
        (5, 'Olivia', 'Paris',   '2025-03-02'),
        (6, 'Mason',  'Toronto', '2025-03-15'),
        (7, 'Sophia', 'London',  '2025-04-06'),
        (8, 'Noah',   'Berlin',  '2025-04-20');


INSERT INTO Watch_History
VALUES  (101, 1, 'Drama',      '2025-05-01', 60, 'Completed'),
        (102, 1, 'Comedy',     '2025-05-02', 45, 'Completed'),
        (103, 1, 'Thriller',   '2025-05-03', 30, 'Skipped'),
        (104, 1, 'Drama',      '2025-05-04', 75, 'Completed'),
        (105, 1, 'Comedy',     '2025-05-06', 50, 'Completed'),

        (106, 2, 'Drama',      '2025-05-01', 40, 'Completed'),
        (107, 2, 'Thriller',   '2025-05-02', 65, 'Completed'),
        (108, 2, 'Comedy',     '2025-05-04', 55, 'Completed'),
        (109, 2, 'Drama',      '2025-05-05', 70, 'Skipped'),
        (110, 2, 'Thriller',   '2025-05-07', 80, 'Completed'),

        (111, 3, 'Comedy',     '2025-05-10', 35, 'Completed'),
        (112, 3, 'Drama',      '2025-05-11', 60, 'Completed'),
        (113, 3, 'Thriller',   '2025-05-12', 90, 'Completed'),
        (114, 3, 'Comedy',     '2025-05-14', 45, 'Completed'),
        (115, 3, 'Drama',      '2025-05-15', 75, 'Completed'),

        (116, 4, 'Thriller',   '2025-05-10', 85, 'Completed'),
        (117, 4, 'Comedy',     '2025-05-11', 40, 'Skipped'),
        (118, 4, 'Drama',      '2025-05-12', 65, 'Completed'),
        (119, 4, 'Thriller',   '2025-05-14', 95, 'Completed'),
        (120, 4, 'Comedy',     '2025-05-15', 50, 'Completed'),

        (121, 5, 'Drama',      '2025-06-01', 70, 'Completed'),
        (122, 5, 'Comedy',     '2025-06-02', 55, 'Completed'),
        (123, 5, 'Thriller',   '2025-06-03', 80, 'Completed'),
        (124, 5, 'Drama',      '2025-06-05', 90, 'Completed'),
        (125, 5, 'Comedy',     '2025-06-06', 45, 'Completed'),

        (126, 6, 'Thriller',   '2025-06-01', 100, 'Completed'),
        (127, 6, 'Drama',      '2025-06-02', 75, 'Completed'),
        (128, 6, 'Comedy',     '2025-06-04', 60, 'Completed'),
        (129, 6, 'Thriller',   '2025-06-05', 85, 'Completed'),
        (130, 6, 'Drama',      '2025-06-06', 70, 'Skipped'),

        (131, 7, 'Comedy',     '2025-06-10', 50, 'Completed'),
        (132, 7, 'Drama',      '2025-06-11', 80, 'Completed'),
        (133, 7, 'Thriller',   '2025-06-12', 95, 'Completed'),
        (134, 7, 'Comedy',     '2025-06-13', 60, 'Completed'),
        (135, 7, 'Drama',      '2025-06-15', 85, 'Completed'),

        (136, 8, 'Drama',      '2025-06-10', 65, 'Completed'),
        (137, 8, 'Thriller',   '2025-06-11', 90, 'Skipped'),
        (138, 8, 'Comedy',     '2025-06-12', 55, 'Completed'),
        (139, 8, 'Drama',      '2025-06-13', 75, 'Completed'),
        (140, 8, 'Thriller',   '2025-06-15', 100, 'Completed');


-- ============================================================
-- VIEW DATA
-- ============================================================

SELECT *
FROM Users;

SELECT *
FROM Watch_History;


-- ============================================================
-- Q1
-- ============================================================
-- Show each user's:
-- total watch records
-- total minutes watched
-- average minutes watched
-- total completed watches.
--
-- Use both tables.
--
-- Return:
-- User_ID
-- User_Name
-- Total_Watch_Records
-- Total_Minutes_Watched
-- Average_Minutes_Watched
-- Total_Completed_Watches

SELECT U.User_ID, U.User_Name,
	   COUNT(W.Watch_ID) AS Total_Watch_Records,
       SUM(W.Minutes_Watched) AS Total_Minutes_Watched,
       ROUND(AVG(W.Minutes_Watched), 2) AS Average_Minutes_Watched,
       COUNT(
       CASE 
			WHEN W.Watch_Status = 'Completed'
            THEN 1
	   END) AS Total_Completed_Watches
FROM Users U
LEFT JOIN Watch_History W
	ON U.User_ID = W.User_ID
GROUP BY U.User_ID, U.User_Name;


-- ============================================================
-- Q2
-- ============================================================
-- For each content category, find:
-- total watch records
-- total completed watches
-- total completed minutes
-- average completed minutes
-- unique users.
--
-- Only completed watches should be considered
-- for completed minutes and average minutes.
--
-- Return:
-- Content_Category
-- Total_Watch_Records
-- Total_Completed_Watches
-- Total_Completed_Minutes
-- Average_Completed_Minutes
-- Unique_Users

SELECT Content_Category,
	   COUNT(Watch_ID) AS Total_Watch_Records,
	   COUNT(
       CASE 
			WHEN Watch_Status = 'Completed'
            THEN 1
	   END) AS Total_Completed_Watches,
       SUM(
       CASE 
			WHEN Watch_Status = 'Completed'
            THEN Minutes_Watched
            ELSE 0
	   END) AS Total_Completed_Minutes,
       ROUND(AVG(
       CASE 
			WHEN Watch_Status = 'Completed'
            THEN Minutes_Watched
	   END), 2) AS Average_Completed_Minutes,
       COUNT(DISTINCT User_ID) AS Unique_Users
FROM Watch_History
GROUP BY Content_Category;


-- ============================================================
-- Q3
-- ============================================================
-- Find the top 2 users in each city
-- based on total completed minutes watched.
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
			   SUM(W.Minutes_Watched) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Watch_History W
			ON U.User_ID = W.User_ID
		WHERE W.Watch_Status = 'Completed'
		GROUP BY U.City, U.User_ID, U.User_Name
	)C
)D
WHERE D_Rank <= 2;


-- ============================================================
-- Q4 — DATE LOGIC
-- ============================================================
-- Find users who made a completed watch
-- within 2 days of their previous completed watch.
--
-- Ignore skipped watches when calculating the gap.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Return:
-- User_ID
-- User_Name

WITH CTE AS (
	SELECT U.User_ID, U.User_Name, W.Watch_Date,
		   LAG(W.Watch_Date) OVER(PARTITION BY U.User_ID
           ORDER BY W.Watch_Date, W.Watch_ID) AS Previous_Watch
	FROM Users U
	INNER JOIN Watch_History W
		ON U.User_ID = W.User_ID
	WHERE W.Watch_Status = 'Completed'
)
SELECT DISTINCT User_ID, User_Name
FROM CTE 
WHERE Previous_Watch IS NOT NULL
AND DATEDIFF(Watch_Date, Previous_Watch) <= 2;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================
-- For each signup cohort month, find:
-- total users
-- total completed watches
-- total completed minutes
-- average completed minutes.
--
-- Definition:
-- Cohort Month = month in which the user signed up.
--
-- Only Completed watches should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Completed_Watches
-- Total_Completed_Minutes
-- Average_Completed_Minutes

WITH CTE AS (
	SELECT User_ID,
		   DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
	FROM Users
),
CTE2 AS (
	SELECT *
    FROM Watch_History
    WHERE Watch_Status = 'Completed'
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
	   COUNT(W.Watch_ID) AS Total_Completed_Watches,
       SUM(W.Minutes_Watched) AS Total_Completed_Minutes,
       ROUND(AVG(W.Minutes_Watched), 2) AS Average_Completed_Minutes
FROM CTE C
INNER JOIN CTE2 W
	ON C.User_ID = W.User_ID
GROUP BY C.Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND 🔥
-- ============================================================
-- A streak means having a Completed watch
-- on consecutive dates.
--
-- Ignore duplicate watch dates for the same user.
--
-- Skipped watches do NOT count.
--
-- Find each user's longest completed-watch
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
	SELECT DISTINCT U.User_ID, U.User_Name, W.Watch_Date
	FROM Users U
	INNER JOIN Watch_History W
		ON U.User_ID = W.User_ID
	WHERE W.Watch_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Watch_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Watch_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT User_ID, User_Name,
		   COUNT(*) AS Streak,
           MIN(Watch_Date) AS Start_Date,
           MAX(Watch_Date) AS End_Date
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
		   ROUND(AVG(Total_Completed_Minutes) OVER(PARTITION BY City), 2) AS City_Average
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(W.Minutes_Watched) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Watch_History W
			ON U.User_ID = W.User_ID
		WHERE W.Watch_Status = 'Completed'
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)A
WHERE Total_Completed_Minutes > City_Average;


-- ============================================================
-- INTERVIEW CHALLENGE 🧠
-- ============================================================
-- For each content category, find the user
-- with the highest total completed minutes watched
-- for that category.
--
-- If tied, return all tied users.
--
-- Use DENSE_RANK().
--
-- Return:
-- Content_Category
-- User_ID
-- User_Name
-- Total_Completed_Minutes

SELECT Content_Category, User_ID, User_Name, Total_Completed_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Content_Category
           ORDER BY Total_Completed_Minutes DESC) D_Rank
	FROM (
		SELECT W.Content_Category, U.User_ID, U.User_Name,
			   SUM(W.Minutes_Watched) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Watch_History W
			ON U.User_ID = W.User_ID
		WHERE W.Watch_Status = 'Completed'
		GROUP BY W.Content_Category, U.User_ID, U.User_Name
	)C
)A
WHERE D_Rank = 1;