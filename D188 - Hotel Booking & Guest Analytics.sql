-- =========================================================
-- SESSION — Hotel Booking & Guest Analytics
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — Guests
-- =========================================================

CREATE TABLE Guests (
    Guest_ID INT PRIMARY KEY,
    Guest_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Guests
VALUES	(1, 'James Carter',   'London',   '2024-01-15'),
		(2, 'Sophia Miller',  'Toronto',  '2024-02-10'),
		(3, 'Oliver Smith',   'Sydney',   '2024-03-05'),
		(4, 'Emma Wilson',    'Berlin',   '2024-03-20'),
		(5, 'Henry Brown',    'Paris',    '2024-04-12'),
		(6, 'Amelia Davis',   'London',   '2024-05-18'),
		(7, 'William Moore',  'Toronto',  '2024-06-01'),
		(8, 'Charlotte Taylor','Sydney',   '2024-06-25'),
		(9, 'George Anderson', 'Berlin',  '2024-07-10'),
		(10,'Isabella Thomas', 'Paris',   '2024-08-05');


-- =========================================================
-- TABLE 2 — Bookings
-- =========================================================

CREATE TABLE Bookings (
    Booking_ID INT PRIMARY KEY,
    Guest_ID INT,
    Booking_Date DATE,
    Check_In_Date DATE,
    Check_Out_Date DATE,
    Room_Type VARCHAR(50),
    Booking_Amount DECIMAL(10,2),
    Booking_Status VARCHAR(20),
    FOREIGN KEY (Guest_ID) REFERENCES Guests(Guest_ID)
);

INSERT INTO Bookings
VALUES	(1001, 1, '2025-01-05', '2025-01-10', '2025-01-13',
		 'Deluxe',  600, 'Completed'),

		(1002, 1, '2025-02-15', '2025-02-20', '2025-02-24',
		 'Suite',   1200, 'Completed'),

		(1003, 1, '2025-04-05', '2025-04-10', '2025-04-12',
		 'Standard', 300, 'Cancelled'),

		(1004, 2, '2025-01-12', '2025-01-18', '2025-01-21',
		 'Deluxe',  750, 'Completed'),

		(1005, 2, '2025-03-10', '2025-03-15', '2025-03-18',
		 'Suite',   900, 'Completed'),

		(1006, 2, '2025-06-01', '2025-06-05', '2025-06-08',
		 'Deluxe',  720, 'Completed'),

		(1007, 3, '2025-01-20', '2025-01-25', '2025-01-28',
		 'Standard', 360, 'Completed'),

		(1008, 3, '2025-02-25', '2025-03-01', '2025-03-04',
		 'Deluxe',  540, 'Completed'),

		(1009, 3, '2025-05-10', '2025-05-15', '2025-05-20',
		 'Suite',   1250, 'Completed'),

		(1010, 4, '2025-02-05', '2025-02-10', '2025-02-14',
		 'Deluxe',  800, 'Completed'),

		(1011, 4, '2025-04-12', '2025-04-18', '2025-04-21',
		 'Suite',   1050, 'Completed'),

		(1012, 4, '2025-05-20', '2025-05-25', '2025-05-28',
		 'Standard', 450, 'Cancelled'),

		(1013, 5, '2025-01-15', '2025-01-20', '2025-01-22',
		 'Standard', 240, 'Completed'),

		(1014, 5, '2025-03-05', '2025-03-10', '2025-03-14',
		 'Deluxe',  680, 'Completed'),

		(1015, 5, '2025-06-15', '2025-06-20', '2025-06-23',
		 'Suite',   960, 'Completed'),

		(1016, 6, '2025-02-18', '2025-02-22', '2025-02-25',
		 'Deluxe',  630, 'Completed'),

		(1017, 6, '2025-04-01', '2025-04-05', '2025-04-09',
		 'Suite',   1100, 'Completed'),

		(1018, 6, '2025-07-10', '2025-07-15', '2025-07-18',
		 'Deluxe',  720, 'Completed'),

		(1019, 7, '2025-01-25', '2025-01-30', '2025-02-02',
		 'Standard', 300, 'Completed'),

		(1020, 7, '2025-03-15', '2025-03-20', '2025-03-24',
		 'Deluxe',   760, 'Completed'),

		(1021, 7, '2025-05-25', '2025-05-30', '2025-06-03',
		 'Suite',    1000, 'Completed'),

		(1022, 8, '2025-02-10', '2025-02-15', '2025-02-18',
		 'Standard', 330, 'Completed'),

		(1023, 8, '2025-04-20', '2025-04-25', '2025-04-28',
		 'Deluxe',   570, 'Completed'),

		(1024, 8, '2025-05-05', '2025-05-10', '2025-05-13',
		 'Suite',    900, 'Completed'),

		(1025, 9, '2025-03-01', '2025-03-05', '2025-03-08',
		 'Deluxe',   600, 'Completed'),

		(1026, 9, '2025-04-15', '2025-04-20', '2025-04-24',
		 'Suite',    1000, 'Completed'),

		(1027, 9, '2025-07-01', '2025-07-05', '2025-07-08',
		 'Deluxe',   720, 'Completed'),

		(1028, 10, '2025-02-15', '2025-02-20', '2025-02-23',
		 'Standard', 300, 'Completed'),

		(1029, 10, '2025-05-10', '2025-05-15', '2025-05-19',
		 'Deluxe',   720, 'Completed'),

		(1030, 10, '2025-06-20', '2025-06-25', '2025-06-28',
		 'Suite',    1050, 'Completed');


-- =========================================================
-- TABLE 3 — Payments
-- =========================================================

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    Booking_ID INT,
    Payment_Date DATE,
    Payment_Amount DECIMAL(10,2),
    Payment_Status VARCHAR(20),
    FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID)
);

INSERT INTO Payments
VALUES	(2001, 1001, '2025-01-05', 600,  'Paid'),
		(2002, 1002, '2025-02-15', 1200, 'Paid'),
		(2003, 1003, '2025-04-05', 300,  'Refunded'),

		(2004, 1004, '2025-01-12', 750,  'Paid'),
		(2005, 1005, '2025-03-10', 900,  'Paid'),
		(2006, 1006, '2025-06-01', 720,  'Paid'),

		(2007, 1007, '2025-01-20', 360,  'Paid'),
		(2008, 1008, '2025-02-25', 540,  'Paid'),
		(2009, 1009, '2025-05-10', 1250, 'Paid'),

		(2010, 1010, '2025-02-05', 800,  'Paid'),
		(2011, 1011, '2025-04-12', 1050, 'Paid'),
		(2012, 1012, '2025-05-20', 450,  'Refunded'),

		(2013, 1013, '2025-01-15', 240,  'Paid'),
		(2014, 1014, '2025-03-05', 680,  'Paid'),
		(2015, 1015, '2025-06-15', 960,  'Paid'),

		(2016, 1016, '2025-02-18', 630,  'Paid'),
		(2017, 1017, '2025-04-01', 1100, 'Paid'),
		(2018, 1018, '2025-07-10', 720,  'Paid'),

		(2019, 1019, '2025-01-25', 300,  'Paid'),
		(2020, 1020, '2025-03-15', 760,  'Paid'),
		(2021, 1021, '2025-05-25', 1000, 'Paid'),

		(2022, 1022, '2025-02-10', 330,  'Paid'),
		(2023, 1023, '2025-04-20', 570,  'Paid'),
		(2024, 1024, '2025-05-05', 900,  'Paid'),

		(2025, 1025, '2025-03-01', 600,  'Paid'),
		(2026, 1026, '2025-04-15', 1000, 'Paid'),
		(2027, 1027, '2025-07-01', 720,  'Paid'),

		(2028, 1028, '2025-02-15', 300,  'Paid'),
		(2029, 1029, '2025-05-10', 720,  'Paid'),
		(2030, 1030, '2025-06-20', 1050, 'Paid');


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT *
FROM Guests;

SELECT *
FROM Bookings;

SELECT *
FROM Payments;

-- =========================================================
-- Q1 — Guest Booking Summary
-- =========================================================
-- For EVERY guest, calculate:
--
-- 1. Total completed bookings
-- 2. Total completed booking amount
-- 3. Average completed booking amount
-- 4. Highest completed booking amount
-- 5. Lowest completed booking amount
--
-- Include guests who have NO completed bookings.
--
-- Return:
-- Guest_ID
-- Guest_Name
-- Total_Bookings
-- Total_Booking_Amount
-- Avg_Booking_Amount
-- Highest_Booking_Amount
-- Lowest_Booking_Amount

SELECT G.Guest_ID, G.Guest_Name,
	   COALESCE(COUNT(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_ID
	   END), 0) AS Total_Bookings,
       COALESCE(SUM(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
            ELSE 0
	   END), 0) AS Total_Booking_Amount,
       COALESCE(ROUND(AVG(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
	   END), 2), 0) AS Avg_Booking_Amount,
       COALESCE(MAX(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
	   END), 0) AS Highest_Booking_Amount,
       COALESCE(MIN(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_Amount
	   END), 0) AS Lowest_Booking_Amount
FROM Guests G
LEFT JOIN Bookings B
	ON G.Guest_ID = B.Guest_ID
GROUP BY G.Guest_ID, G.Guest_Name;


-- =========================================================
-- Q2 — City Booking Performance
-- =========================================================
-- For each city, calculate:
--
-- 1. Number of guests
-- 2. Total completed bookings
-- 3. Total completed booking revenue
-- 4. Average completed booking amount
-- 5. Number of distinct guests who made a completed booking
--
-- Include cities even if a guest has no completed bookings.
--
-- Return:
-- City
-- Guest_Count
-- Total_Bookings
-- Total_Revenue
-- Avg_Booking_Amount
-- Active_Guests

SELECT G.City,
	   COALESCE(COUNT(G.Guest_ID), 0) AS Guest_Count,
       COALESCE(COUNT(
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN B.Booking_ID
	   END), 0) AS Total_Bookings,
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
	   END), 2), 0) AS Avg_Booking_Amount,
       COALESCE(COUNT(DISTINCT
       CASE
			WHEN B.Booking_Status = 'Completed'
            THEN G.Guest_ID
	   END), 0) AS Active_Guests
FROM Guests G
LEFT JOIN Bookings B
	ON G.Guest_ID = B.Guest_ID
GROUP BY G.City;


-- =========================================================
-- Q3 — Top 2 Guests Per City
-- =========================================================
-- Find the TOP 2 guests in each city based on
-- TOTAL COMPLETED BOOKING REVENUE.
--
-- Requirements:
-- - Use DENSE_RANK()
-- - Include ties
--
-- Return:
-- City
-- Guest_ID
-- Guest_Name
-- Total_Revenue
-- Revenue_Rank

SELECT City, Guest_ID, Guest_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT G.Guest_ID, G.Guest_Name, G.City,
			   SUM(B.Booking_Amount) AS Total_Revenue
		FROM Guests G
		INNER JOIN Bookings B
			ON G.Guest_ID = B.Guest_ID
		WHERE B.Booking_Status = 'Completed'
		GROUP BY G.Guest_ID, G.Guest_Name, G.City
	)C
)G
WHERE Revenue_Rank <= 2;


-- =========================================================
-- Q4 — Guest Booking Gap Analysis
-- =========================================================
-- For every guest, compare each completed booking
-- with their PREVIOUS completed booking.
--
-- Find bookings where the gap between booking dates
-- is MORE THAN 30 DAYS.
--
-- Requirements:
-- - Use LAG()
-- - Use DATEDIFF()
-- - Only completed bookings
--
-- Return:
-- Guest_ID
-- Guest_Name
-- Booking_ID
-- Booking_Date
-- Previous_Booking_Date
-- Gap_Days

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name, Booking_ID, B.Booking_Date, 
		   LAG(B.Booking_Date) OVER(PARTITION BY G.Guest_ID
           ORDER BY B.Booking_Date, B.Booking_ID) AS Previous_Booking_Date
	FROM Guests G
	INNER JOIN Bookings B
		ON G.Guest_ID = B.Guest_ID
	WHERE B.Booking_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Booking_Date, Previous_Booking_Date) AS Gap_Days
    FROM CTE
)
SELECT Guest_ID, Guest_Name, Booking_ID, Booking_Date, Previous_Booking_Date, Gap_Days
FROM CTE2
WHERE Previous_Booking_Date IS NOT NULL
AND Gap_Days > 30;


-- =========================================================
-- Q5 — Guest Cohort Analysis
-- =========================================================
-- Create cohorts based on the MONTH of each guest's
-- FIRST COMPLETED BOOKING.
--
-- For each cohort month calculate:
--
-- 1. Total guests
-- 2. Active guests
-- 3. Total completed bookings
-- 4. Total completed revenue
-- 5. Total paid bookings
-- 6. Average revenue per active guest
--
-- Return:
-- Cohort_Month
-- Total_Guests
-- Active_Guests
-- Total_Bookings
-- Total_Revenue
-- Paid_Bookings
-- Avg_Revenue_Per_Active_Guest

WITH CTE AS (
	SELECT G.Guest_ID,
		   MIN(B.Booking_Date) AS First_Booking
	FROM Guests G
	INNER JOIN Bookings B
		ON G.Guest_ID = B.Guest_ID
	WHERE B.Booking_Status = 'Completed'
    GROUP BY G.Guest_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Booking, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COALESCE(COUNT(DISTINCT C.Guest_ID), 0) AS Total_Guests,
       COALESCE(COUNT(DISTINCT
       CASE
			WHEN B.Booking_ID IS NOT NULL AND B.Booking_Status = 'Completed'
            THEN C.Guest_ID
	   END), 0) AS Active_Guests,
	   COALESCE(COUNT(
       CASE
		   WHEN B.Booking_Status = 'Completed'
           THEN B.Booking_ID
	   END), 0) AS Total_Bookings,
       COALESCE(SUM(
       CASE
		   WHEN B.Booking_Status = 'Completed'
           THEN B.Booking_Amount
           ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(COUNT(
       CASE
		   WHEN P.Payment_Status = 'Paid'
           THEN P.Booking_ID
	   END), 0) AS Paid_Bookings,
       COALESCE(ROUND(SUM(
       CASE
		   WHEN B.Booking_Status = 'Completed'
           THEN B.Booking_Amount
           ELSE 0
	   END) / NULLIF(COUNT(DISTINCT
       CASE
			WHEN B.Booking_ID IS NOT NULL AND B.Booking_Status = 'Completed'
            THEN C.Guest_ID
	   END), 0), 2), 0) AS Avg_Revenue_Per_Active_Guest
FROM CTE2 C
LEFT JOIN Bookings B
	ON C.Guest_ID = B.Guest_ID
LEFT JOIN Payments P
	ON B.Booking_ID = P.Booking_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- Find the LONGEST CONSECUTIVE MONTHLY BOOKING STREAK
-- for every guest.
--
-- Rules:
-- - Only completed bookings
-- - A guest counts ONCE per month
-- - Consecutive months form one streak
-- - If multiple streaks have the same length,
--   choose the MOST RECENT streak
--
-- Return:
-- Guest_ID
-- Guest_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

SELECT * FROM Guests;

SELECT * FROM Bookings;

SELECT * FROM Payments;

WITH CTE AS (
	SELECT DISTINCT G.Guest_ID, G.Guest_Name,
		   DATE_FORMAT(B.Booking_Date, '%Y-%m-01') AS Booking_Month
	FROM Guests G
	INNER JOIN Bookings B
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
		   COUNT(*) AS Streak,
           MIN(Booking_Month) AS Streak_Start_Month,
           MAX(Booking_Month) AS Streak_End_Month
	FROM CTE3
    GROUP BY Guest_ID, Guest_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Guest_ID
           ORDER BY Streak DESC, Streak_End_Month DESC) AS Row_Num
	FROM CTE4
)
SELECT Guest_ID, Guest_Name, Streak_Start_Month, Streak_End_Month, Streak AS Streak_Months
FROM CTE5
WHERE Row_Num = 1;


-- =========================================================
-- BONUS+ — Above City Average
-- =========================================================
-- Find guests whose TOTAL COMPLETED BOOKING REVENUE
-- is GREATER THAN the average guest revenue
-- of their city.
--
-- Requirements:
-- - First calculate revenue per guest
-- - Then use a WINDOW FUNCTION
-- - Compare each guest against their city's
--   average guest revenue
--
-- Return:
-- City
-- Guest_ID
-- Guest_Name
-- Total_Revenue
-- City_Avg_Revenue

SELECT City, Guest_ID, Guest_Name, Total_Revenue, City_Avg_Revenue
FROM (
	SELECT *,
		   ROUND(AVG(Total_Revenue) OVER(PARTITION BY City), 2) AS City_Avg_Revenue
	FROM (
		SELECT G.Guest_ID, G.Guest_Name, G.City,
			   SUM(B.Booking_Amount) AS Total_Revenue
		FROM Guests G
		INNER JOIN Bookings B
			ON G.Guest_ID = B.Guest_ID
		WHERE B.Booking_Status = 'Completed'
		GROUP BY G.Guest_ID, G.Guest_Name, G.City
	)T
)A
WHERE Total_Revenue > City_Avg_Revenue;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- Find the guest(s) with the HIGHEST TOTAL COMPLETED
-- BOOKING REVENUE in each city.
--
-- Requirements:
-- - Include ties
-- - Use DENSE_RANK()
--
-- Return:
-- City
-- Guest_ID
-- Guest_Name
-- Total_Revenue
-- Revenue_Rank

SELECT City, Guest_ID, Guest_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT G.Guest_ID, G.Guest_Name, G.City,
			   SUM(B.Booking_Amount) AS Total_Revenue
		FROM Guests G
		INNER JOIN Bookings B
			ON G.Guest_ID = B.Guest_ID
		WHERE B.Booking_Status = 'Completed'
		GROUP BY G.Guest_ID, G.Guest_Name, G.City
	)D
)H
WHERE Revenue_Rank = 1;