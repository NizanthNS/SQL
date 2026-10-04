-- ============================================================
-- DAILY SQL SESSION
-- Guest Analytics
-- ============================================================

USE Daily_SQL;

-- ============================================================
-- TABLE 1 — HOTEL_GUESTS
-- ============================================================

CREATE TABLE Hotel_Guests (
    Guest_ID INT PRIMARY KEY,
    Guest_Name VARCHAR(50),
    City VARCHAR(50)
);

INSERT INTO Hotel_Guests
VALUES	(1, 'James Carter', 'London'),
		(2, 'Sophia Miller', 'Toronto'),
		(3, 'Daniel Wilson', 'Berlin'),
		(4, 'Emma Davis', 'Paris'),
		(5, 'Oliver Brown', 'London'),
		(6, 'Charlotte Taylor', 'Toronto'),
		(7, 'Henry Anderson', 'Berlin'),
		(8, 'Amelia Thomas', 'Paris'),
		(9, 'William Moore', 'London'),
		(10, 'Isabella Martin', 'Toronto');


-- ============================================================
-- TABLE 2 — HOTEL_BOOKINGS
-- ============================================================

CREATE TABLE Hotel_Bookings (
    Booking_ID INT PRIMARY KEY,
    Guest_ID INT,
    Hotel_Name VARCHAR(100),
    Room_Type VARCHAR(30),
    Booking_Date DATE,
    Check_In_Date DATE,
    Check_Out_Date DATE,
    Booking_Status VARCHAR(20),
    Booking_Amount DECIMAL(10,2),

    FOREIGN KEY (Guest_ID)
        REFERENCES Hotel_Guests(Guest_ID)
);

INSERT INTO Hotel_Bookings
VALUES	(101, 1, 'Grand London Hotel', 'Deluxe',
		 '2026-01-05', '2026-01-15', '2026-01-18',
		 'Completed', 450),

		(102, 1, 'Grand London Hotel', 'Suite',
		 '2026-02-10', '2026-02-20', '2026-02-23',
		 'Completed', 720),

		(103, 1, 'Royal Paris Hotel', 'Deluxe',
		 '2026-04-02', '2026-04-12', '2026-04-15',
		 'Cancelled', 500),

		(104, 2, 'Toronto Plaza', 'Standard',
		 '2026-01-12', '2026-01-20', '2026-01-22',
		 'Completed', 300),

		(105, 2, 'Toronto Plaza', 'Deluxe',
		 '2026-03-05', '2026-03-15', '2026-03-18',
		 'Completed', 540),

		(106, 2, 'Berlin Central Hotel', 'Suite',
		 '2026-05-01', '2026-05-10', '2026-05-14',
		 'Completed', 880),

		(107, 3, 'Berlin Central Hotel', 'Standard',
		 '2026-01-08', '2026-01-12', '2026-01-14',
		 'Completed', 260),

		(108, 3, 'Berlin Central Hotel', 'Deluxe',
		 '2026-01-25', '2026-02-01', '2026-02-04',
		 'Completed', 510),

		(109, 3, 'Paris Grand Hotel', 'Suite',
		 '2026-03-10', '2026-03-20', '2026-03-25',
		 'Cancelled', 1100),

		(110, 4, 'Paris Grand Hotel', 'Deluxe',
		 '2026-02-01', '2026-02-10', '2026-02-13',
		 'Completed', 600),

		(111, 4, 'Paris Grand Hotel', 'Suite',
		 '2026-03-15', '2026-03-25', '2026-03-29',
		 'Completed', 950),

		(112, 5, 'Grand London Hotel', 'Standard',
		 '2026-01-20', '2026-02-01', '2026-02-03',
		 'Completed', 280),

		(113, 5, 'Grand London Hotel', 'Deluxe',
		 '2026-02-18', '2026-02-25', '2026-02-28',
		 'Completed', 520),

		(114, 5, 'Grand London Hotel', 'Suite',
		 '2026-04-05', '2026-04-15', '2026-04-20',
		 'Completed', 1000),

		(115, 6, 'Toronto Plaza', 'Standard',
		 '2026-01-05', '2026-01-10', '2026-01-12',
		 'Completed', 240),

		(116, 6, 'Toronto Plaza', 'Deluxe',
		 '2026-02-12', '2026-02-20', '2026-02-23',
		 'Cancelled', 580),

		(117, 6, 'Toronto Plaza', 'Suite',
		 '2026-03-01', '2026-03-10', '2026-03-14',
		 'Completed', 900),

		(118, 7, 'Berlin Central Hotel', 'Standard',
		 '2026-02-01', '2026-02-05', '2026-02-07',
		 'Completed', 250),

		(119, 7, 'Berlin Central Hotel', 'Deluxe',
		 '2026-03-05', '2026-03-12', '2026-03-15',
		 'Completed', 530),

		(120, 8, 'Paris Grand Hotel', 'Standard',
		 '2026-01-10', '2026-01-15', '2026-01-17',
		 'Completed', 270),

		(121, 8, 'Paris Grand Hotel', 'Deluxe',
		 '2026-02-10', '2026-02-18', '2026-02-21',
		 'Completed', 560),

		(122, 8, 'Paris Grand Hotel', 'Suite',
		 '2026-03-10', '2026-03-20', '2026-03-24',
		 'Completed', 920),

		(123, 9, 'Grand London Hotel', 'Deluxe',
		 '2026-02-05', '2026-02-15', '2026-02-18',
		 'Completed', 480),

		(124, 9, 'Grand London Hotel', 'Suite',
		 '2026-03-01', '2026-03-10', '2026-03-14',
		 'Completed', 850),

		(125, 10, 'Toronto Plaza', 'Standard',
		 '2026-01-15', '2026-01-20', '2026-01-22',
		 'Completed', 290),

		(126, 10, 'Toronto Plaza', 'Deluxe',
		 '2026-03-01', '2026-03-08', '2026-03-11',
		 'Completed', 550),

		(127, 10, 'Toronto Plaza', 'Suite',
		 '2026-04-01', '2026-04-10', '2026-04-14',
		 'Completed', 850);

SELECT *
FROM Hotel_Guests;

SELECT *
FROM Hotel_Bookings;

-- ============================================================
-- Q1 — GUEST BOOKING SUMMARY
-- ============================================================
-- For each guest, find:
--
-- 1. Total bookings
-- 2. Completed bookings
-- 3. Cancelled bookings
-- 4. Total completed revenue
-- 5. Average completed booking amount
--
-- Include guests even if they have no bookings.
--
-- Return:
--
-- Guest_ID
-- Guest_Name
-- City
-- Total_Bookings
-- Completed_Bookings
-- Cancelled_Bookings
-- Total_Revenue
-- Avg_Booking_Amount
--
-- ============================================================

SELECT G.Guest_ID, G.Guest_Name, G.City,
	   COUNT(B.Booking_ID) AS Total_Bookings,
       COUNT(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_ID
	   END) AS Completed_Bookings,
       COUNT(
       CASE
			WHEN B.Booking_Status = 'Cancelled'
            THEN B.Booking_ID
	   END) AS Cancelled_Bookings,
       COALESCE(SUM(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
            ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
	   END), 2), 0) AS Avg_Booking_Amount
FROM Hotel_Guests G
LEFT JOIN Hotel_Bookings B
	ON G.Guest_ID = B.Guest_ID
GROUP BY G.Guest_ID, G.Guest_Name, G.City;
       

-- ============================================================
-- Q2 — HOTEL & ROOM TYPE PERFORMANCE
-- ============================================================
-- For each combination of:
--
-- Hotel_Name
-- Room_Type
--
-- Calculate:
--
-- 1. Total completed bookings
-- 2. Total revenue
-- 3. Average booking amount
-- 4. Highest booking amount
--
-- Only Completed bookings should contribute.
--
-- Return:
--
-- Hotel_Name
-- Room_Type
-- Completed_Bookings
-- Total_Revenue
-- Avg_Booking_Amount
-- Highest_Booking_Amount
--
-- Sort by:
--
-- Total_Revenue DESC
--
-- ============================================================

SELECT Hotel_Name, Room_Type,
	   COUNT(Booking_ID) AS Completed_Bookings,
       COALESCE(SUM(Booking_Amount), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(Booking_Amount), 2), 0) AS Avg_Booking_Amount,
       MAX(Booking_Amount) AS Highest_Booking_Amount
FROM Hotel_Bookings
WHERE Booking_Status = 'Completed'
GROUP BY Hotel_Name, Room_Type;


-- ============================================================
-- Q3 — TOP 3 GUESTS BY REVENUE WITHIN EACH CITY
-- ============================================================
-- Find the top 3 guests in each city based on their
-- total completed booking revenue.
--
-- Requirements:
--
-- 1. Use a CTE
-- 2. Use JOIN
-- 3. Use DENSE_RANK()
--
-- Return:
--
-- City
-- Guest_ID
-- Guest_Name
-- Total_Revenue
-- Revenue_Rank
--
-- Only return:
--
-- Revenue_Rank <= 3
--
-- ============================================================

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name, G.City,
		   COALESCE(SUM(Booking_Amount), 0) AS Total_Revenue
	FROM Hotel_Guests G
	INNER JOIN Hotel_Bookings B
		ON G.Guest_ID = B.Guest_ID
	WHERE B.Booking_Status = 'Completed'
	GROUP BY G.Guest_ID, G.Guest_Name, G.City
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM CTE
)
SELECT City, Guest_ID, Guest_Name, Total_Revenue, Revenue_Rank
FROM CTE2
WHERE Revenue_Rank BETWEEN 1 AND 3;
-- WHERE Revenue_Rank <= 3


-- ============================================================
-- Q4 — REPEAT BOOKING WITHIN 30 DAYS
-- ============================================================
-- For each guest, examine their completed bookings
-- in chronological order.
--
-- Find bookings where the current Booking_Date occurred
-- within 30 days of their previous completed booking date.
--
-- Requirements:
--
-- 1. Use LAG()
-- 2. Use DATEDIFF()
-- 3. Ignore cancelled bookings completely.
--
-- Return:
--
-- Guest_ID
-- Guest_Name
-- Booking_ID
-- Booking_Date
-- Previous_Booking_Date
-- Days_Since_Previous
--
-- Only return:
--
-- Days_Since_Previous <= 30
--
-- ============================================================

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name, B.Booking_ID, B.Booking_Date,
		   LAG(B.Booking_Date) OVER(PARTITION BY Guest_ID
           ORDER BY B.Booking_Date, Booking_ID) AS Previous_Booking_Date
	FROM Hotel_Guests G
	INNER JOIN Hotel_Bookings B
		ON G.Guest_ID = B.Guest_ID
	WHERE B.Booking_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Booking_Date, Previous_Booking_Date) AS Days_Since_Previous
	FROM CTE
)
SELECT Guest_ID, Guest_Name, Booking_ID, Booking_Date, Previous_Booking_Date, Days_Since_Previous
FROM CTE2
WHERE Days_Since_Previous <= 30;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================
-- A guest's cohort month is the month of their
-- FIRST COMPLETED booking.
--
-- For each cohort month, find:
--
-- 1. Total guests
-- 2. Total completed bookings
-- 3. Total revenue
-- 4. Average booking value
-- 5. Total cancelled bookings made by those cohort guests
--
-- Important:
--
-- Cohort is determined by the first COMPLETED booking.
--
-- NOT:
-- first cancelled booking
-- first booking of any status
--
-- Return:
--
-- Cohort_Month
-- Total_Guests
-- Completed_Bookings
-- Total_Revenue
-- Avg_Booking_Value
-- Cancelled_Bookings
--
-- ============================================================

WITH CTE AS (
	SELECT Guest_ID,
		   MIN(Booking_Date) AS First_Booking_Date
	FROM Hotel_Bookings
    WHERE Booking_Status = 'Completed'
    GROUP BY Guest_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Booking_Date, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT C.Guest_ID) AS Total_Guests,
       COUNT(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_ID
	   END) AS Completed_Bookings,
       COALESCE(SUM(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
            ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
	   END), 2), 0) AS Avg_Booking_Value,
       COUNT(
       CASE
			WHEN B.Booking_Status = 'Cancelled'
            THEN B.Booking_ID
	   END) AS Cancelled_Bookings
FROM CTE2 C
LEFT JOIN Hotel_Bookings B
	ON C.Guest_ID = B.Guest_ID
GROUP BY C.Cohort_Month;


-- ============================================================
-- BONUS — BOOKING STREAK
-- ============================================================
-- Find guests who had a completed booking streak
-- of at least 2 consecutive months.
--
-- Requirements:
--
-- 1. Consider only completed bookings.
-- 2. Convert booking dates to months.
-- 3. Identify consecutive booking months.
-- 4. Use the Gap & Island technique.
-- 5. Find the longest streak for each guest.
-- 6. Return guests whose longest streak >= 2.
--
-- Return:
--
-- Guest_ID
-- Guest_Name
-- Longest_Streak
--
-- ============================================================

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name,
		   CAST(DATE_FORMAT(B.Booking_Date, '%Y-%m-01') AS DATE) AS Booking_Month
	FROM Hotel_Guests G
	INNER JOIN Hotel_Bookings B
		ON G.Guest_ID = B.Guest_ID
	WHERE B.Booking_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Guest_ID
           ORDER BY Booking_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Booking_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Guest_ID, Guest_Name,
		   COUNT(*) AS Longest_Streak
	FROM CTE3
    GROUP BY Guest_ID, Guest_Name, GK
)
SELECT Guest_ID, Guest_Name, Longest_Streak
FROM CTE4
WHERE Longest_Streak >= 2;


-- ============================================================
-- BONUS+ — CITY REVENUE VS CITY AVERAGE
-- ============================================================
-- For each guest:
--
-- 1. Calculate their total completed revenue.
-- 2. Calculate the average guest revenue within their city.
-- 3. Find guests whose revenue is greater than their
--    city's average guest revenue.
--
-- Use a window function such as:
--
-- AVG(...) OVER (PARTITION BY City)
--
-- Return:
--
-- City
-- Guest_ID
-- Guest_Name
-- Total_Revenue
-- City_Avg_Revenue
-- Revenue_Difference
--
-- Where:
--
-- Revenue_Difference =
-- Total_Revenue - City_Avg_Revenue
--
-- Sort by:
--
-- City
-- Revenue_Difference DESC
--
-- ============================================================

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name, G.City,
		   COALESCE(SUM(Booking_Amount), 0) AS Total_Revenue
	FROM Hotel_Guests G
	INNER JOIN Hotel_Bookings B
		ON G.Guest_ID = B.Guest_ID
	WHERE B.Booking_Status = 'Completed'
	GROUP BY G.Guest_ID, G.Guest_Name, G.City
),
CTE2 AS (
	SELECT *,
		   AVG(Total_Revenue) OVER(PARTITION BY City) AS City_Avg_Revenue
	FROM CTE
),
CTE3 AS (
	SELECT City, Guest_ID, Guest_Name, Total_Revenue,
		   ROUND(City_Avg_Revenue, 2) AS City_Avg_Revenue,
		   ROUND(Total_Revenue - City_Avg_Revenue, 2) AS Revenue_Difference
	FROM CTE2
)
SELECT City, Guest_ID, Guest_Name, Total_Revenue, City_Avg_Revenue, Revenue_Difference
FROM CTE3
WHERE Total_Revenue > City_Avg_Revenue
ORDER BY City, Revenue_Difference DESC;


-- ============================================================
-- INTERVIEW CHALLENGE
-- ============================================================
-- Find the highest-revenue guest(s) in each city based
-- on completed bookings.
--
-- Important:
--
-- 1. If two guests tie for the highest revenue,
--    return BOTH.
-- 2. Cancelled bookings must not contribute.
-- 3. Guests with no completed bookings should not win.
--
-- Return:
--
-- City
-- Guest_ID
-- Guest_Name
-- Total_Revenue
-- Revenue_Rank
--
-- Use a window-ranking function.
--
-- ============================================================

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name, G.City,
		   COALESCE(SUM(Booking_Amount), 0) AS Total_Revenue
	FROM Hotel_Guests G
	INNER JOIN Hotel_Bookings B
		ON G.Guest_ID = B.Guest_ID
	WHERE B.Booking_Status = 'Completed'
	GROUP BY G.Guest_ID, G.Guest_Name, G.City
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM CTE
)
SELECT City, Guest_ID, Guest_Name, Total_Revenue, Revenue_Rank
FROM CTE2
WHERE Revenue_Rank = 1;