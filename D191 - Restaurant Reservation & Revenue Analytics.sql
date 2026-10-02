-- =========================================================
-- SESSION — Restaurant Reservation & Revenue Analytics
-- =========================================================

-- =========================================================
-- TABLE 1 — CUSTOMERS
-- =========================================================

USE Daily_SQL;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Alexander Reed', 'London', '2024-01-12'),
		(2, 'Charlotte Evans', 'Toronto', '2024-02-08'),
		(3, 'Benjamin Scott', 'Sydney', '2024-02-21'),
		(4, 'Emily Turner', 'Berlin', '2024-03-14'),
		(5, 'Lucas Morgan', 'Paris', '2024-04-05'),
		(6, 'Grace Mitchell', 'London', '2024-04-19'),
		(7, 'Henry Cooper', 'Toronto', '2024-05-03'),
		(8, 'Amelia Parker', 'Sydney', '2024-05-22'),
		(9, 'Daniel Brooks', 'Berlin', '2024-06-10'),
		(10, 'Sophie Bennett', 'Paris', '2024-06-28'),
		(11, 'Jack Harrison', 'London', '2024-07-11'),
		(12, 'Olivia Foster', 'Toronto', '2024-07-25');


-- =========================================================
-- TABLE 2 — RESERVATIONS
-- =========================================================

CREATE TABLE Reservations (
    Reservation_ID INT PRIMARY KEY,
    Customer_ID INT,
    Restaurant_Name VARCHAR(100),
    City VARCHAR(50),
    Reservation_Date DATE,
    Party_Size INT,
    Reservation_Status VARCHAR(20),
    Bill_Amount DECIMAL(10,2),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID)
);

INSERT INTO Reservations
VALUES	(1001, 1, 'The Crown Table', 'London',
		 '2024-01-20', 2, 'Completed', 85.00),

		(1002, 1, 'The Crown Table', 'London',
		 '2024-02-18', 4, 'Completed', 160.00),

		(1003, 1, 'River House', 'London',
		 '2024-04-02', 3, 'Completed', 120.00),

		(1004, 2, 'Maple Dining', 'Toronto',
		 '2024-02-15', 2, 'Completed', 95.00),

		(1005, 2, 'Maple Dining', 'Toronto',
		 '2024-03-22', 5, 'Completed', 210.00),

		(1006, 2, 'Harbour Room', 'Toronto',
		 '2024-05-10', 3, 'Cancelled', 140.00),

		(1007, 3, 'Harbour House', 'Sydney',
		 '2024-03-01', 2, 'Completed', 110.00),

		(1008, 3, 'Harbour House', 'Sydney',
		 '2024-04-12', 4, 'Completed', 240.00),

		(1009, 3, 'Sydney Garden', 'Sydney',
		 '2024-06-05', 3, 'Completed', 175.00),

		(1010, 4, 'Berlin Bistro', 'Berlin',
		 '2024-03-28', 2, 'Completed', 90.00),

		(1011, 4, 'Berlin Bistro', 'Berlin',
		 '2024-05-02', 6, 'Completed', 300.00),

		(1012, 4, 'The German Table', 'Berlin',
		 '2024-07-14', 4, 'Cancelled', 220.00),

		(1013, 5, 'Paris Table', 'Paris',
		 '2024-04-15', 2, 'Completed', 125.00),

		(1014, 5, 'Paris Table', 'Paris',
		 '2024-05-20', 4, 'Completed', 260.00),

		(1015, 5, 'Le Jardin', 'Paris',
		 '2024-08-01', 3, 'Completed', 195.00),

		(1016, 6, 'The Crown Table', 'London',
		 '2024-05-08', 2, 'Completed', 100.00),

		(1017, 6, 'River House', 'London',
		 '2024-06-16', 5, 'Completed', 225.00),

		(1018, 6, 'The Crown Table', 'London',
		 '2024-08-04', 3, 'Completed', 150.00),

		(1019, 7, 'Maple Dining', 'Toronto',
		 '2024-06-02', 2, 'Completed', 80.00),

		(1020, 7, 'Toronto House', 'Toronto',
		 '2024-07-18', 4, 'Completed', 190.00),

		(1021, 8, 'Harbour House', 'Sydney',
		 '2024-06-20', 2, 'Completed', 105.00),

		(1022, 8, 'Sydney Garden', 'Sydney',
		 '2024-07-25', 5, 'Completed', 230.00),

		(1023, 9, 'Berlin Bistro', 'Berlin',
		 '2024-07-01', 2, 'Completed', 100.00),

		(1024, 9, 'Berlin Bistro', 'Berlin',
		 '2024-08-10', 4, 'Completed', 210.00),

		(1025, 10, 'Paris Table', 'Paris',
		 '2024-07-05', 2, 'Completed', 115.00),

		(1026, 10, 'Le Jardin', 'Paris',
		 '2024-08-18', 5, 'Completed', 280.00),

		(1027, 11, 'The Crown Table', 'London',
		 '2024-07-12', 2, 'Completed', 90.00),

		(1028, 11, 'River House', 'London',
		 '2024-08-22', 4, 'Completed', 205.00),

		(1029, 12, 'Maple Dining', 'Toronto',
		 '2024-08-03', 3, 'Completed', 145.00),

		(1030, 12, 'Toronto House', 'Toronto',
		 '2024-08-29', 5, 'Completed', 250.00);


-- =========================================================
-- TABLE 3 — PAYMENTS
-- =========================================================

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    Reservation_ID INT,
    Payment_Date DATE,
    Payment_Status VARCHAR(20),
    Payment_Amount DECIMAL(10,2),

    FOREIGN KEY (Reservation_ID)
        REFERENCES Reservations(Reservation_ID)
);

INSERT INTO Payments
VALUES	(5001, 1001, '2024-01-20', 'Paid', 85.00),
		(5002, 1002, '2024-02-18', 'Paid', 160.00),
		(5003, 1003, '2024-04-02', 'Paid', 120.00),
		(5004, 1004, '2024-02-15', 'Paid', 95.00),
		(5005, 1005, '2024-03-22', 'Paid', 210.00),
		(5006, 1006, '2024-05-10', 'Refunded', 140.00),
		(5007, 1007, '2024-03-01', 'Paid', 110.00),
		(5008, 1008, '2024-04-12', 'Paid', 240.00),
		(5009, 1009, '2024-06-05', 'Paid', 175.00),
		(5010, 1010, '2024-03-28', 'Paid', 90.00),
		(5011, 1011, '2024-05-02', 'Paid', 300.00),
		(5012, 1012, '2024-07-14', 'Refunded', 220.00),
		(5013, 1013, '2024-04-15', 'Paid', 125.00),
		(5014, 1014, '2024-05-20', 'Paid', 260.00),
		(5015, 1015, '2024-08-01', 'Paid', 195.00),
		(5016, 1016, '2024-05-08', 'Paid', 100.00),
		(5017, 1017, '2024-06-16', 'Paid', 225.00),
		(5018, 1018, '2024-08-04', 'Paid', 150.00),
		(5019, 1019, '2024-06-02', 'Paid', 80.00),
		(5020, 1020, '2024-07-18', 'Paid', 190.00),
		(5021, 1021, '2024-06-20', 'Paid', 105.00),
		(5022, 1022, '2024-07-25', 'Paid', 230.00),
		(5023, 1023, '2024-07-01', 'Paid', 100.00),
		(5024, 1024, '2024-08-10', 'Paid', 210.00),
		(5025, 1025, '2024-07-05', 'Paid', 115.00),
		(5026, 1026, '2024-08-18', 'Paid', 280.00),
		(5027, 1027, '2024-07-12', 'Paid', 90.00),
		(5028, 1028, '2024-08-22', 'Paid', 205.00),
		(5029, 1029, '2024-08-03', 'Paid', 145.00),
		(5030, 1030, '2024-08-29', 'Paid', 250.00);


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT *
FROM Customers;

SELECT *
FROM Reservations;

SELECT *
FROM Payments;


-- =========================================================
-- Q1 — CUSTOMER RESERVATION SUMMARY
-- =========================================================
-- For every customer, calculate:
-- 1. Total completed reservations
-- 2. Total completed bill amount
-- 3. Average completed bill amount
-- 4. Highest completed bill amount
-- 5. Lowest completed bill amount
-- 6. Total paid amount
--
-- Include customers even if they have no completed reservations.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Completed_Reservations
-- Total_Bill_Amount
-- Avg_Bill_Amount
-- Highest_Bill
-- Lowest_Bill
-- Total_Paid_Amount

SELECT C.Customer_ID, C.Customer_Name, C.City,
	   COALESCE(COUNT(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Reservation_ID
	   END), 0) AS Completed_Reservations,
       COALESCE(SUM(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Bill_Amount
            ELSE 0
	   END), 0) AS Total_Bill_Amount,
       COALESCE(ROUND(AVG(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Bill_Amount
	   END), 2), 0) AS Avg_Bill_Amount,
       COALESCE(MAX(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Bill_Amount
	   END), 0) AS Highest_Bill,
       COALESCE(MIN(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Bill_Amount
	   END), 0) AS Lowest_Bill,
       COALESCE(SUM(
       CASE
			WHEN P.Payment_Status = 'Paid'
            THEN P.Payment_Amount
            ELSE 0
	   END), 0) AS Total_Paid_Amount
FROM Customers C
LEFT JOIN Reservations R
	ON C.Customer_ID = R.Customer_ID
LEFT JOIN Payments P
	ON R.Reservation_ID = P.Reservation_ID
GROUP BY C.Customer_ID, C.Customer_Name, C.City;


-- =========================================================
-- Q2 — CITY RESTAURANT PERFORMANCE
-- =========================================================
-- For every city, calculate:
-- 1. Number of restaurants
-- 2. Total completed reservations
-- 3. Total completed revenue
-- 4. Average completed bill amount
-- 5. Number of distinct customers with completed reservations
-- 6. Total paid revenue
--
-- Return:
-- City
-- Restaurant_Count
-- Completed_Reservations
-- Total_Revenue
-- Avg_Bill_Amount
-- Distinct_Customers
-- Paid_Revenue

SELECT C.City,
	   COUNT(DISTINCT R.Restaurant_Name) AS Restaurant_Count,
	   COUNT(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Reservation_ID
	   END) AS Completed_Reservations,
       COALESCE(SUM(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Bill_Amount
            ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Bill_Amount
	   END), 2), 0) AS Avg_Bill_Amount,
       COUNT(DISTINCT
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Customer_ID
	   END) AS Distinct_Customers,
       COALESCE(SUM(
       CASE
			WHEN P.Payment_Status = 'Paid'
            THEN P.Payment_Amount
            ELSE 0
	   END), 0) AS Paid_Revenue
FROM Customers C
LEFT JOIN Reservations R
	ON C.Customer_ID = R.Customer_ID
LEFT JOIN Payments P
	ON R.Reservation_ID = P.Reservation_ID
GROUP BY C.City;


-- =========================================================
-- Q3 — TOP 2 CUSTOMERS PER CITY
-- =========================================================
-- Find the top 2 customers in each city based on
-- total completed reservation revenue.
--
-- Requirements:
-- - Completed reservations only
-- - Calculate customer-level revenue first
-- - Use DENSE_RANK()
-- - Include ties
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Revenue
-- Revenue_Rank

SELECT City, Customer_ID, Customer_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   COALESCE(SUM(R.Bill_Amount), 0) AS Total_Revenue
		FROM Customers C
		INNER JOIN Reservations R
			ON C.Customer_ID = R.Customer_ID
		WHERE R.Reservation_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE Revenue_Rank BETWEEN 1 AND 2;


-- =========================================================
-- Q4 — CUSTOMER RESERVATION GAP ANALYSIS
-- =========================================================
-- For every customer, calculate the number of days between
-- their current completed reservation and previous completed
-- reservation.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Return ONLY reservations where the gap is greater than 30 days.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Reservation_ID
-- Reservation_Date
-- Previous_Reservation_Date
-- Gap_Days

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, R.Reservation_ID, R.Reservation_Date, 
		   LAG(R.Reservation_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY R.Reservation_Date, R.Reservation_ID) AS Previous_Reservation_Date
	FROM Customers C
	INNER JOIN Reservations R
		ON C.Customer_ID = R.Customer_ID
	WHERE R.Reservation_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Reservation_Date, Previous_Reservation_Date) AS Gap_Days
    FROM CTE
)
SELECT Customer_ID, Customer_Name, Reservation_ID, Reservation_Date, Previous_Reservation_Date, Gap_Days
FROM CTE2
WHERE Previous_Reservation_Date IS NOT NULL
AND Gap_Days > 30;


-- =========================================================
-- Q5 — CUSTOMER COHORT ANALYSIS
-- =========================================================
-- Define each customer's cohort month as the month of their
-- FIRST completed reservation.
--
-- For each cohort month, calculate:
-- 1. Total customers in the cohort
-- 2. Active customers in the cohort during the dataset period
-- 3. Total completed reservations
-- 4. Total completed revenue
-- 5. Total paid reservations
-- 6. Average completed revenue per active customer
--
-- Important:
-- Cohort membership must be based ONLY on the first
-- completed reservation.
--
-- Return:
-- Cohort_Month
-- Cohort_Customers
-- Active_Customers
-- Completed_Reservations
-- Total_Revenue
-- Paid_Reservations
-- Avg_Revenue_Per_Active_Customer

WITH CTE AS (
	SELECT C.Customer_ID,
		   MIN(R.Reservation_Date) AS First_Date
	FROM Customers C
	INNER JOIN Reservations R
		ON C.Customer_ID = R.Customer_ID
	WHERE R.Reservation_Status = 'Completed'
    GROUP BY C.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Date, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COALESCE(COUNT(DISTINCT C.Customer_ID), 0) AS Cohort_Customers,
       COALESCE(COUNT(DISTINCT
       CASE
			WHEN R.Reservation_ID IS NOT NULL AND R.Reservation_Status = 'Completed'
            THEN C.Customer_ID
	   END), 0) AS Active_Customers,
	   COALESCE(COUNT(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Reservation_ID
	   END), 0) AS Completed_Reservations,
       COALESCE(SUM(
       CASE
			WHEN R.Reservation_Status = 'Completed'
            THEN R.Bill_Amount
            ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(COUNT(
       CASE
			WHEN P.Payment_Status = 'Paid'
            THEN P.Payment_ID
	   END), 0) AS Paid_Reservations,
       COALESCE(ROUND(SUM(
       CASE
		   WHEN R.Reservation_Status = 'Completed'
           THEN R.Bill_Amount
           ELSE 0
	   END) / NULLIF(COUNT(DISTINCT
       CASE
			WHEN R.Reservation_ID IS NOT NULL AND R.Reservation_Status = 'Completed'
            THEN C.Customer_ID
	   END), 0), 2), 0) AS Avg_Revenue_Per_Active_Customer
FROM CTE2 C
LEFT JOIN Reservations R
	ON C.Customer_ID = R.Customer_ID
LEFT JOIN Payments P
	ON R.Reservation_ID = P.Reservation_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- BONUS — GAP & ISLAND
-- =========================================================
-- Find each customer's longest consecutive monthly
-- reservation streak.
--
-- Requirements:
-- - Completed reservations only
-- - A customer must have at least one completed reservation
--   in each consecutive month
-- - Use the classic:
--     DISTINCT entity/month
--     ROW_NUMBER()
--     DATE_SUB()
--     GROUP BY
--     ranking
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name,
		   CAST(DATE_FORMAT(R.Reservation_Date, '%Y-%m-01') AS DATE) AS Reservation_Month
	FROM Customers C
	INNER JOIN Reservations R
		ON C.Customer_ID = R.Customer_ID
	WHERE R.Reservation_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Reservation_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Reservation_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Reservation_Month) AS Streak_Start_Month,
           MAX(Reservation_Month) AS Streak_End_Month
	FROM CTE3
    GROUP BY Customer_ID, Customer_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Streak DESC, Streak_End_Month DESC) AS Row_Num
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak_Start_Month, Streak_End_Month, Streak AS Streak_Months
FROM CTE5
WHERE Row_Num = 1;


-- =========================================================
-- BONUS+ — ABOVE CITY AVERAGE
-- =========================================================
-- Find customers whose total completed reservation revenue
-- is greater than the average customer revenue in their city.
--
-- Requirements:
-- - Completed reservations only
-- - Calculate revenue per customer first
-- - Use a window function for the city average
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Revenue
-- City_Avg_Revenue

SELECT City, Customer_ID, Customer_Name, Total_Revenue, City_Avg_Revenue
FROM (
	SELECT *,
		   ROUND(Exact_Avg, 2) AS City_Avg_Revenue
	FROM (
		SELECT *,
			   AVG(Total_Revenue) OVER(PARTITION BY City) AS Exact_Avg
		FROM (
			SELECT C.Customer_ID, C.Customer_Name, C.City,
				   COALESCE(SUM(R.Bill_Amount), 0) AS Total_Revenue
			FROM Customers C
			INNER JOIN Reservations R
				ON C.Customer_ID = R.Customer_ID
			WHERE R.Reservation_Status = 'Completed'
			GROUP BY C.Customer_ID, C.Customer_Name, C.City
		)C
	)A
)E
WHERE Total_Revenue > City_Avg_Revenue;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each city, find the restaurant(s) with the highest
-- total completed revenue.
--
-- Requirements:
-- - Completed reservations only
-- - Calculate restaurant-level revenue first
-- - Use DENSE_RANK()
-- - Include ties
--
-- Return:
-- City
-- Restaurant_Name
-- Total_Revenue
-- Revenue_Rank

SELECT City, Restaurant_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT Restaurant_Name, City,
			   COALESCE(SUM(Bill_Amount), 0) AS Total_Revenue
		FROM Reservations
		WHERE Reservation_Status = 'Completed'
		GROUP BY Restaurant_Name, City
	)R
)D
WHERE Revenue_Rank = 1;