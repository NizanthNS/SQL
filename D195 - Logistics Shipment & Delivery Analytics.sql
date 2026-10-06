-- =========================================================
-- SESSION — Logistics Shipment & Delivery Analytics
-- =========================================================
-- Focus:
--   • Multi-table aggregation
--   • Conditional aggregation
--   • Latest shipment status
--   • Ranking / Window Functions
--   • LAG + DATEDIFF
--   • Cohort Analysis
--   • Gap & Island
--
-- Difficulty: Strong Intermediate → Early Advanced
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — Customers
-- =========================================================

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(100),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Alexander Reed', 'London', '2024-01-15'),
		(2, 'Charlotte Evans', 'Toronto', '2024-02-10'),
		(3, 'Benjamin Scott', 'Sydney', '2024-03-05'),
		(4, 'Emily Richardson', 'Berlin', '2024-01-28'),
		(5, 'Lucas Foster', 'Paris', '2024-04-12'),
		(6, 'Olivia Hughes', 'London', '2024-05-20'),
		(7, 'James Murphy', 'Toronto', '2024-03-18'),
		(8, 'Ava Peterson', 'Sydney', '2024-06-08'),
		(9, 'Lucas Morgan', 'Berlin', '2024-02-22'),
		(10, 'Mia Cooper', 'Paris', '2024-07-14'),
		(11, 'Benjamin Ward', 'London', '2024-08-01'),
		(12, 'Charlotte Hayes', 'Toronto', '2024-09-11');


-- =========================================================
-- TABLE 2 — Shipments
-- =========================================================

DROP TABLE IF EXISTS Shipments;

CREATE TABLE Shipments (
    Shipment_ID INT PRIMARY KEY,
    Customer_ID INT,
    Shipment_Date DATE,
    Delivery_Date DATE,
    Shipment_Status VARCHAR(30),
    Shipping_Fee DECIMAL(10,2),
    Shipment_Value DECIMAL(10,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Shipments
VALUES	(1001, 1, '2024-01-20', '2024-01-23', 'Delivered', 12.00, 180.00),
		(1002, 2, '2024-02-15', '2024-02-19', 'Delivered', 15.00, 250.00),
		(1003, 3, '2024-03-10', '2024-03-14', 'Delivered', 18.00, 320.00),
		(1004, 4, '2024-04-02', '2024-04-06', 'Delivered', 14.00, 210.00),
		(1005, 5, '2024-04-18', '2024-04-23', 'Delivered', 20.00, 450.00),
		(1006, 6, '2024-05-25', NULL, 'Cancelled', 10.00, 160.00),
		(1007, 7, '2024-04-05', '2024-04-09', 'Delivered', 13.00, 275.00),
		(1008, 8, '2024-06-15', '2024-06-20', 'Delivered', 22.00, 390.00),
		(1009, 9, '2024-03-01', '2024-03-05', 'Delivered', 16.00, 230.00),
		(1010, 10, '2024-07-20', '2024-07-25', 'Delivered', 19.00, 510.00),
		(1011, 11, '2024-08-10', '2024-08-14', 'Delivered', 11.00, 195.00),
		(1012, 12, '2024-09-20', NULL, 'Cancelled', 17.00, 340.00),

		(1013, 1, '2024-02-20', '2024-02-24', 'Delivered', 14.00, 220.00),
		(1014, 2, '2024-03-25', '2024-03-29', 'Delivered', 16.00, 280.00),
		(1015, 3, '2024-04-15', '2024-04-20', 'Delivered', 21.00, 360.00),
		(1016, 4, '2024-05-10', '2024-05-15', 'Delivered', 15.00, 240.00),
		(1017, 5, '2024-06-12', '2024-06-17', 'Delivered', 23.00, 490.00),
		(1018, 6, '2024-06-25', '2024-06-30', 'Delivered', 12.00, 175.00),
		(1019, 7, '2024-05-08', '2024-05-12', 'Delivered', 14.00, 290.00),
		(1020, 8, '2024-07-10', '2024-07-15', 'Delivered', 20.00, 410.00),
		(1021, 9, '2024-04-10', '2024-04-15', 'Delivered', 17.00, 260.00),
		(1022, 10, '2024-08-05', '2024-08-10', 'Delivered', 18.00, 530.00),
		(1023, 11, '2024-09-01', '2024-09-05', 'Delivered', 13.00, 205.00),
		(1024, 12, '2024-10-01', '2024-10-06', 'Delivered', 19.00, 370.00),

		(1025, 1, '2024-04-20', '2024-04-25', 'Delivered', 13.00, 240.00),
		(1026, 2, '2024-05-20', '2024-05-24', 'Delivered', 15.00, 300.00),
		(1027, 3, '2024-06-20', '2024-06-25', 'Delivered', 19.00, 380.00),
		(1028, 4, '2024-07-18', '2024-07-23', 'Delivered', 16.00, 270.00),
		(1029, 5, '2024-08-15', '2024-08-20', 'Delivered', 24.00, 520.00),
		(1030, 6, '2024-09-15', '2024-09-20', 'Delivered', 13.00, 190.00);


-- =========================================================
-- TABLE 3 — Shipment_Events
-- =========================================================
-- Each shipment can have multiple tracking events.
-- The latest event represents the shipment's current state.

DROP TABLE IF EXISTS Shipment_Events;

CREATE TABLE Shipment_Events (
    Event_ID INT PRIMARY KEY,
    Shipment_ID INT,
    Event_Date DATE,
    Event_Status VARCHAR(30),
    FOREIGN KEY (Shipment_ID) REFERENCES Shipments(Shipment_ID)
);

INSERT INTO Shipment_Events
VALUES	(5001, 1001, '2024-01-20', 'Picked Up'),
		(5002, 1001, '2024-01-21', 'In Transit'),
		(5003, 1001, '2024-01-23', 'Delivered'),

		(5004, 1002, '2024-02-15', 'Picked Up'),
		(5005, 1002, '2024-02-17', 'In Transit'),
		(5006, 1002, '2024-02-19', 'Delivered'),

		(5007, 1003, '2024-03-10', 'Picked Up'),
		(5008, 1003, '2024-03-12', 'In Transit'),
		(5009, 1003, '2024-03-14', 'Delivered'),

		(5010, 1004, '2024-04-02', 'Picked Up'),
		(5011, 1004, '2024-04-04', 'In Transit'),
		(5012, 1004, '2024-04-06', 'Delivered'),

		(5013, 1005, '2024-04-18', 'Picked Up'),
		(5014, 1005, '2024-04-20', 'In Transit'),
		(5015, 1005, '2024-04-23', 'Delivered'),

		(5016, 1006, '2024-05-25', 'Picked Up'),
		(5017, 1006, '2024-05-27', 'Cancelled'),

		(5018, 1007, '2024-04-05', 'Picked Up'),
		(5019, 1007, '2024-04-07', 'In Transit'),
		(5020, 1007, '2024-04-09', 'Delivered'),

		(5021, 1008, '2024-06-15', 'Picked Up'),
		(5022, 1008, '2024-06-18', 'Delayed'),
		(5023, 1008, '2024-06-20', 'Delivered'),

		(5024, 1009, '2024-03-01', 'Picked Up'),
		(5025, 1009, '2024-03-03', 'In Transit'),
		(5026, 1009, '2024-03-05', 'Delivered'),

		(5027, 1010, '2024-07-20', 'Picked Up'),
		(5028, 1010, '2024-07-23', 'In Transit'),
		(5029, 1010, '2024-07-25', 'Delivered'),

		(5030, 1011, '2024-08-10', 'Picked Up'),
		(5031, 1011, '2024-08-12', 'In Transit'),
		(5032, 1011, '2024-08-14', 'Delivered'),

		(5033, 1012, '2024-09-20', 'Picked Up'),
		(5034, 1012, '2024-09-22', 'Cancelled'),

		(5035, 1013, '2024-02-20', 'Picked Up'),
		(5036, 1013, '2024-02-22', 'In Transit'),
		(5037, 1013, '2024-02-24', 'Delivered'),

		(5038, 1014, '2024-03-25', 'Picked Up'),
		(5039, 1014, '2024-03-27', 'In Transit'),
		(5040, 1014, '2024-03-29', 'Delivered'),

		(5041, 1015, '2024-04-15', 'Picked Up'),
		(5042, 1015, '2024-04-18', 'In Transit'),
		(5043, 1015, '2024-04-20', 'Delivered'),

		(5044, 1016, '2024-05-10', 'Picked Up'),
		(5045, 1016, '2024-05-13', 'In Transit'),
		(5046, 1016, '2024-05-15', 'Delivered'),

		(5047, 1017, '2024-06-12', 'Picked Up'),
		(5048, 1017, '2024-06-14', 'In Transit'),
		(5049, 1017, '2024-06-17', 'Delivered'),

		(5050, 1018, '2024-06-25', 'Picked Up'),
		(5051, 1018, '2024-06-28', 'In Transit'),
		(5052, 1018, '2024-06-30', 'Delivered'),

		(5053, 1019, '2024-05-08', 'Picked Up'),
		(5054, 1019, '2024-05-10', 'In Transit'),
		(5055, 1019, '2024-05-12', 'Delivered'),

		(5056, 1020, '2024-07-10', 'Picked Up'),
		(5057, 1020, '2024-07-13', 'In Transit'),
		(5058, 1020, '2024-07-15', 'Delivered'),

		(5059, 1021, '2024-04-10', 'Picked Up'),
		(5060, 1021, '2024-04-12', 'In Transit'),
		(5061, 1021, '2024-04-15', 'Delivered'),

		(5062, 1022, '2024-08-05', 'Picked Up'),
		(5063, 1022, '2024-08-08', 'In Transit'),
		(5064, 1022, '2024-08-10', 'Delivered'),

		(5065, 1023, '2024-09-01', 'Picked Up'),
		(5066, 1023, '2024-09-03', 'In Transit'),
		(5067, 1023, '2024-09-05', 'Delivered'),

		(5068, 1024, '2024-10-01', 'Picked Up'),
		(5069, 1024, '2024-10-03', 'In Transit'),
		(5070, 1024, '2024-10-06', 'Delivered'),

		(5071, 1025, '2024-04-20', 'Picked Up'),
		(5072, 1025, '2024-04-22', 'In Transit'),
		(5073, 1025, '2024-04-25', 'Delivered'),

		(5074, 1026, '2024-05-20', 'Picked Up'),
		(5075, 1026, '2024-05-22', 'In Transit'),
		(5076, 1026, '2024-05-24', 'Delivered'),

		(5077, 1027, '2024-06-20', 'Picked Up'),
		(5078, 1027, '2024-06-23', 'In Transit'),
		(5079, 1027, '2024-06-25', 'Delivered'),

		(5080, 1028, '2024-07-18', 'Picked Up'),
		(5081, 1028, '2024-07-21', 'In Transit'),
		(5082, 1028, '2024-07-23', 'Delivered'),

		(5083, 1029, '2024-08-15', 'Picked Up'),
		(5084, 1029, '2024-08-18', 'In Transit'),
		(5085, 1029, '2024-08-20', 'Delivered'),

		(5086, 1030, '2024-09-15', 'Picked Up'),
		(5087, 1030, '2024-09-18', 'In Transit'),
		(5088, 1030, '2024-09-20', 'Delivered');


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Customers;

SELECT * FROM Shipments;

SELECT * FROM Shipment_Events;

-- =========================================================
-- Q1 — Customer Shipment Summary
-- =========================================================
-- Show every customer, including customers with no shipments.
--
-- Calculate:
--   1. Total completed shipments
--   2. Total completed shipment value
--   3. Total shipping fees from completed shipments
--   4. Average completed shipment value
--   5. Highest completed shipment value
--   6. Number of delivered shipments
--
-- Use Shipment_Status = 'Delivered' as the completed shipment
-- condition.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Completed_Shipments
-- Total_Shipment_Value
-- Total_Shipping_Fees
-- Avg_Shipment_Value
-- Highest_Shipment_Value
-- Delivered_Shipments

SELECT C.Customer_ID, C.Customer_Name, C.City,
	   COUNT(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_ID
	   END) AS Total_Completed_Shipments,
       COALESCE(SUM(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_Value
            ELSE 0
	   END), 0) AS Total_Shipment_Value,
       COALESCE(SUM(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipping_Fee
            ELSE 0
	   END), 0) AS Total_Shipping_Fees,
       COALESCE(ROUND(AVG(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_Value
	   END), 2), 0) AS Avg_Shipment_Value,
       COALESCE(MAX(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_Value
	   END), 0) AS Highest_Shipment_Value,
       COUNT(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_ID
	   END) AS Delivered_Shipments
FROM Customers C
LEFT JOIN Shipments S
	ON C.Customer_ID = S.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name, C.City;


-- =========================================================
-- Q2 — City Delivery Performance
-- =========================================================
-- Analyze delivery performance by customer city.
--
-- For delivered shipments calculate:
--   1. Customer count
--   2. Delivered shipment count
--   3. Total shipment value
--   4. Average shipment value
--   5. Average delivery time in days
--      = DATEDIFF(Delivery_Date, Shipment_Date)
--
-- Also calculate:
--   6. Number of delayed shipments
--
-- A shipment is considered delayed if its Shipment_Events
-- history contains at least one Event_Status = 'Delayed'.
--
-- Return:
-- City
-- Customer_Count
-- Delivered_Shipments
-- Total_Shipment_Value
-- Avg_Shipment_Value
-- Avg_Delivery_Days
-- Delayed_Shipments

WITH CTE AS (
	SELECT DISTINCT Shipment_ID
	FROM Shipment_Events
	WHERE Event_Status = 'Delayed'
)
SELECT C.City,
	   COUNT(DISTINCT C.Customer_ID) AS Customer_Count,
	   COUNT(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_ID
	   END) AS Delivered_Shipments,
       COALESCE(SUM(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_Value
            ELSE 0
	   END), 0) AS Total_Shipment_Value,
       COALESCE(ROUND(AVG(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_Value
	   END), 2), 0) AS Avg_Shipment_Value,
       COALESCE(ROUND(AVG(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN DATEDIFF(S.Delivery_Date, S.Shipment_Date)
	   END), 2), 0) AS Avg_Delivery_Days,
       COUNT(E.Shipment_ID) AS Delayed_Shipments
FROM Customers C
LEFT JOIN Shipments S
	ON C.Customer_ID = S.Customer_ID
LEFT JOIN CTE E
	ON S.Shipment_ID = E.Shipment_ID
GROUP BY C.City;


-- =========================================================
-- Q3 — Top 2 Customers Per City
-- =========================================================
-- Find the top 2 customers in every city based on
-- total completed shipment value.
--
-- Requirements:
--   • Only Delivered shipments count.
--   • Calculate revenue/value per customer first.
--   • Rank customers within each city.
--   • Use DENSE_RANK so ties receive the same rank.
--   • Return only Rank <= 2.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Shipment_Value
-- City_Rank

SELECT Customer_ID, Customer_Name, City, Total_Shipment_Value, City_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Shipment_Value DESC) AS City_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   COALESCE(SUM(S.Shipment_Value), 0) AS Total_Shipment_Value
		FROM Customers C
		INNER JOIN Shipments S
			ON C.Customer_ID = S.Customer_ID
		WHERE S.Shipment_Status = 'Delivered'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE City_Rank <= 2;


-- =========================================================
-- Q4 — Customer Shipment Gap Analysis
-- =========================================================
-- For every customer, analyze the gap between consecutive
-- completed shipments.
--
-- Use:
--   LAG()
--   DATEDIFF()
--
-- Only Delivered shipments should be considered.
--
-- Return only shipment records where the gap from the
-- previous completed shipment is greater than 30 days.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Shipment_ID
-- Shipment_Date
-- Previous_Shipment_Date
-- Gap_Days


WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, S.Shipment_ID, S.Shipment_Date, 
		   LAG(S.Shipment_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY S.Shipment_Date, S.Shipment_ID) AS Previous_Shipment_Date
	FROM Customers C
	INNER JOIN Shipments S
		ON C.Customer_ID = S.Customer_ID
	WHERE S.Shipment_Status = 'Delivered'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Shipment_Date, Previous_Shipment_Date) AS Gap_Days
    FROM CTE
)
SELECT Customer_ID, Customer_Name, Shipment_ID, Shipment_Date, Previous_Shipment_Date, Gap_Days
FROM CTE2
WHERE Previous_Shipment_Date IS NOT NULL
AND Gap_Days > 30;


-- =========================================================
-- Q5 — Customer Shipment Cohort Analysis
-- =========================================================
-- Define a customer's cohort as the month of their
-- FIRST completed/delivered shipment.
--
-- For each cohort month calculate:
--
--   1. Cohort customers
--   2. Active customers
--      = customers from the cohort who had a completed
--        shipment in that month
--   3. Completed shipments
--   4. Total shipment value
--   5. Total shipping fees
--   6. Average shipment value per active customer
--
-- Important:
--   • Cancelled shipments must NOT determine the cohort.
--   • Active customer count must be DISTINCT.
--
-- Return:
-- Cohort_Month
-- Cohort_Customers
-- Active_Customers
-- Completed_Shipments
-- Total_Shipment_Value
-- Total_Shipping_Fees
-- Avg_Value_Per_Active_Customer

WITH CTE AS (
	SELECT Customer_ID,
		   MIN(Shipment_Date) AS First_Shipment_Date
	FROM Shipments
	WHERE Shipment_Status = 'Delivered'
    GROUP BY Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Shipment_Date, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Cohort_Customers,
       COUNT(DISTINCT
       CASE
			WHEN S.Shipment_ID IS NOT NULL AND S.Shipment_Status = 'Delivered'
            THEN C.Customer_ID
	   END) AS Active_Customers,
	   COUNT(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_ID
	   END) AS Completed_Shipments,
       COALESCE(SUM(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_Value
            ELSE 0
	   END), 0) AS Total_Shipment_Value,
       COALESCE(SUM(
       CASE
			WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipping_Fee
            ELSE 0
	   END), 0) AS Total_Shipping_Fees,
       COALESCE(ROUND(SUM(
       CASE
		    WHEN S.Shipment_Status = 'Delivered'
            THEN S.Shipment_Value
			ELSE 0
	   END) / NULLIF(COUNT(DISTINCT
       CASE
			WHEN S.Shipment_ID IS NOT NULL AND S.Shipment_Status = 'Delivered'
            THEN C.Customer_ID
	   END), 0), 2), 0) AS Avg_Value_Per_Active_Customer
FROM CTE2 C
LEFT JOIN Shipments S
	ON C.Customer_ID = S.Customer_ID
    AND Shipment_Status = 'Delivered'
GROUP BY C.Cohort_Month;


-- =========================================================
-- BONUS — Longest Consecutive Monthly Shipment Streak
-- =========================================================
-- Find each customer's longest consecutive-month streak
-- of completed shipments.
--
-- Use the classic Gap & Island approach:
--
--   1. DISTINCT customer + shipment month
--   2. ROW_NUMBER()
--   3. DATE_SUB(month, INTERVAL RN MONTH)
--   4. GROUP BY the generated island key
--   5. Calculate streak length
--   6. Rank streaks per customer
--
-- Return the longest streak for every customer.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name,
		   CAST(DATE_FORMAT(S.Shipment_Date, '%Y-%m-01') AS DATE) AS Ship_Month
	FROM Customers C
	INNER JOIN Shipments S
		ON C.Customer_ID = S.Customer_ID
	WHERE S.Shipment_Status = 'Delivered'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Ship_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Ship_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Ship_Month) AS Streak_Start_Month,
           MAX(Ship_Month) AS Streak_End_Month
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
-- BONUS+ — Customers Above Their City's Average
-- =========================================================
-- First calculate each customer's total completed shipment
-- value.
--
-- Then calculate the average customer shipment value
-- within each city using a WINDOW FUNCTION.
--
-- Return only customers whose total completed shipment
-- value is greater than their city's average.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Shipment_Value
-- City_Avg_Shipment_Value

SELECT Customer_ID, Customer_Name, City, Total_Shipment_Value, City_Avg_Shipment_Value
FROM (
	SELECT *,
		   ROUND(Exact_Avg, 2) AS City_Avg_Shipment_Value
    FROM (
		SELECT *,
			   AVG(Total_Shipment_Value) OVER(PARTITION BY City) AS Exact_Avg
		FROM (
			SELECT C.Customer_ID, C.Customer_Name, C.City,
				   COALESCE(SUM(S.Shipment_Value), 0) AS Total_Shipment_Value
			FROM Customers C
			INNER JOIN Shipments S
				ON C.Customer_ID = S.Customer_ID
			WHERE S.Shipment_Status = 'Delivered'
			GROUP BY C.Customer_ID, C.Customer_Name, C.City
		)C
	)A
)E
WHERE Total_Shipment_Value > Exact_Avg;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- Find the customer with the highest total completed
-- shipment value in each city.
--
-- Requirements:
--   • Delivered shipments only.
--   • Aggregate customer-level shipment value first.
--   • Rank customers within each city.
--   • Handle ties correctly.
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Shipment_Value
-- City_Rank

SELECT City, Customer_ID, Customer_Name, Total_Shipment_Value, City_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Shipment_Value DESC) AS City_Rank
	FROM (
		SELECT C.City, C.Customer_ID, C.Customer_Name,
			   COALESCE(SUM(S.Shipment_Value), 0) AS Total_Shipment_Value
		FROM Customers C
		INNER JOIN Shipments S
			ON C.Customer_ID = S.Customer_ID
		WHERE S.Shipment_Status = 'Delivered'
		GROUP BY C.City, C.Customer_ID, C.Customer_Name
	)C
)D
WHERE City_Rank = 1;


-- =========================================================
-- SESSION — END
-- =========================================================