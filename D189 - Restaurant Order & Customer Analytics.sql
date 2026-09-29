-- =========================================================
-- SESSION — Restaurant Order & Customer Analytics
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — Customers
-- =========================================================

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'James Carter',    'London',  '2024-01-15'),
		(2, 'Sophia Miller',   'Toronto', '2024-02-10'),
		(3, 'Oliver Smith',    'Sydney',  '2024-03-05'),
		(4, 'Emma Wilson',     'Berlin',  '2024-03-20'),
		(5, 'Henry Brown',     'Paris',   '2024-04-12'),
		(6, 'Amelia Davis',    'London',  '2024-05-18'),
		(7, 'William Moore',   'Toronto', '2024-06-01'),
		(8, 'Charlotte Taylor', 'Sydney',  '2024-06-25'),
		(9, 'George Anderson', 'Berlin',  '2024-07-10'),
		(10,'Isabella Thomas',  'Paris',   '2024-08-05');


-- =========================================================
-- TABLE 2 — Restaurants
-- =========================================================

CREATE TABLE Restaurants (
    Restaurant_ID INT PRIMARY KEY,
    Restaurant_Name VARCHAR(100),
    City VARCHAR(50),
    Cuisine VARCHAR(50)
);

INSERT INTO Restaurants
VALUES	(101, 'The Royal Fork',    'London',  'Italian'),
		(102, 'Maple Kitchen',    'Toronto', 'Canadian'),
		(103, 'Harbour Grill',    'Sydney',  'Seafood'),
		(104, 'Berlin Bistro',    'Berlin',  'German'),
		(105, 'Paris Table',      'Paris',   'French'),
		(106, 'London Spice',     'London',  'Indian'),
		(107, 'Toronto House',    'Toronto', 'Asian'),
		(108, 'Sydney Garden',    'Sydney',  'Vegetarian');


-- =========================================================
-- TABLE 3 — Orders
-- =========================================================

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Restaurant_ID INT,
    Order_Date DATE,
    Order_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurants(Restaurant_ID)
);

INSERT INTO Orders
VALUES	(1001, 1, 101, '2025-01-05', 45,  'Completed'),
		(1002, 1, 106, '2025-02-10', 60,  'Completed'),
		(1003, 1, 101, '2025-04-15', 75,  'Cancelled'),

		(1004, 2, 102, '2025-01-12', 55,  'Completed'),
		(1005, 2, 107, '2025-03-05', 80,  'Completed'),
		(1006, 2, 102, '2025-06-20', 95,  'Completed'),

		(1007, 3, 103, '2025-01-20', 70,  'Completed'),
		(1008, 3, 108, '2025-02-15', 50,  'Completed'),
		(1009, 3, 103, '2025-05-10', 110, 'Completed'),

		(1010, 4, 104, '2025-02-05', 65,  'Completed'),
		(1011, 4, 104, '2025-04-12', 120, 'Completed'),
		(1012, 4, 104, '2025-05-20', 90,  'Cancelled'),

		(1013, 5, 105, '2025-01-15', 85,  'Completed'),
		(1014, 5, 105, '2025-03-10', 100, 'Completed'),
		(1015, 5, 105, '2025-06-15', 130, 'Completed'),

		(1016, 6, 101, '2025-02-18', 55,  'Completed'),
		(1017, 6, 106, '2025-04-01', 95,  'Completed'),
		(1018, 6, 101, '2025-07-10', 115, 'Completed'),

		(1019, 7, 102, '2025-01-25', 50,  'Completed'),
		(1020, 7, 107, '2025-03-15', 85,  'Completed'),
		(1021, 7, 102, '2025-05-25', 105, 'Completed'),

		(1022, 8, 103, '2025-02-10', 45,  'Completed'),
		(1023, 8, 108, '2025-04-20', 70,  'Completed'),
		(1024, 8, 103, '2025-05-05', 125, 'Completed'),

		(1025, 9, 104, '2025-03-01', 75,  'Completed'),
		(1026, 9, 104, '2025-04-15', 115, 'Completed'),
		(1027, 9, 104, '2025-07-01', 100, 'Completed'),

		(1028, 10, 105, '2025-02-15', 60,  'Completed'),
		(1029, 10, 105, '2025-05-10', 90,  'Completed'),
		(1030, 10, 105, '2025-06-20', 140, 'Completed');


-- =========================================================
-- TABLE 4 — Payments
-- =========================================================

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    Order_ID INT,
    Payment_Date DATE,
    Payment_Amount DECIMAL(10,2),
    Payment_Status VARCHAR(20),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

INSERT INTO Payments
VALUES	(2001, 1001, '2025-01-05', 45,  'Paid'),
		(2002, 1002, '2025-02-10', 60,  'Paid'),
		(2003, 1003, '2025-04-15', 75,  'Refunded'),

		(2004, 1004, '2025-01-12', 55,  'Paid'),
		(2005, 1005, '2025-03-05', 80,  'Paid'),
		(2006, 1006, '2025-06-20', 95,  'Paid'),

		(2007, 1007, '2025-01-20', 70,  'Paid'),
		(2008, 1008, '2025-02-15', 50,  'Paid'),
		(2009, 1009, '2025-05-10', 110, 'Paid'),

		(2010, 1010, '2025-02-05', 65,  'Paid'),
		(2011, 1011, '2025-04-12', 120, 'Paid'),
		(2012, 1012, '2025-05-20', 90,  'Refunded'),

		(2013, 1013, '2025-01-15', 85,  'Paid'),
		(2014, 1014, '2025-03-10', 100, 'Paid'),
		(2015, 1015, '2025-06-15', 130, 'Paid'),

		(2016, 1016, '2025-02-18', 55,  'Paid'),
		(2017, 1017, '2025-04-01', 95,  'Paid'),
		(2018, 1018, '2025-07-10', 115, 'Paid'),

		(2019, 1019, '2025-01-25', 50,  'Paid'),
		(2020, 1020, '2025-03-15', 85,  'Paid'),
		(2021, 1021, '2025-05-25', 105, 'Paid'),

		(2022, 1022, '2025-02-10', 45,  'Paid'),
		(2023, 1023, '2025-04-20', 70,  'Paid'),
		(2024, 1024, '2025-05-05', 125, 'Paid'),

		(2025, 1025, '2025-03-01', 75,  'Paid'),
		(2026, 1026, '2025-04-15', 115, 'Paid'),
		(2027, 1027, '2025-07-01', 100, 'Paid'),

		(2028, 1028, '2025-02-15', 60,  'Paid'),
		(2029, 1029, '2025-05-10', 90,  'Paid'),
		(2030, 1030, '2025-06-20', 140, 'Paid');


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Customers;

SELECT * FROM Restaurants;

SELECT * FROM Orders;

SELECT * FROM Payments;

-- =========================================================
-- Q1 — Customer Order Summary
-- =========================================================
-- For EVERY customer, calculate:
--
-- 1. Total completed orders
-- 2. Total completed order amount
-- 3. Average completed order amount
-- 4. Highest completed order amount
-- 5. Lowest completed order amount
--
-- Include customers with NO completed orders.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Orders
-- Total_Order_Amount
-- Avg_Order_Amount
-- Highest_Order_Amount
-- Lowest_Order_Amount

SELECT C.Customer_ID, C.Customer_Name,
	   COALESCE(COUNT(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_ID
	   END), 0) AS Total_Orders,
       COALESCE(SUM(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
            ELSE 0
	   END), 0) AS Total_Order_Amount,
       COALESCE(ROUND(AVG(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
	   END), 2), 0) AS Avg_Order_Amount,
       COALESCE(MAX(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
	   END), 0) AS Highest_Order_Amount,
       COALESCE(MIN(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
	   END), 0) AS Lowest_Order_Amount
FROM Customers C
LEFT JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- =========================================================
-- Q2 — Restaurant Performance
-- =========================================================
-- For each restaurant, calculate:
--
-- 1. City
-- 2. Cuisine
-- 3. Total completed orders
-- 4. Total completed revenue
-- 5. Average completed order amount
-- 6. Number of distinct customers
--
-- Include restaurants with NO completed orders.
--
-- Return:
-- Restaurant_ID
-- Restaurant_Name
-- City
-- Cuisine
-- Total_Orders
-- Total_Revenue
-- Avg_Order_Amount
-- Customer_Count

SELECT R.Restaurant_ID, R.Restaurant_Name, R.City, R.Cuisine,
	   COALESCE(COUNT(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_ID
	   END), 0) AS Total_Orders,
       COALESCE(SUM(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
            ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
	   END), 2), 0) AS Avg_Order_Amount,
       COALESCE(COUNT(DISTINCT 
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Customer_ID
	   END), 0) AS Customer_Count
FROM Restaurants R
LEFT JOIN Orders O
	ON R.Restaurant_ID = O.Restaurant_ID
GROUP BY R.Restaurant_ID, R.Restaurant_Name, R.City, R.Cuisine;


-- =========================================================
-- Q3 — Top 2 Customers Per City
-- =========================================================
-- Find the TOP 2 customers in each city based on
-- TOTAL COMPLETED ORDER REVENUE.
--
-- Requirements:
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
			   SUM(O.Order_Amount) AS Total_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE O.Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE Revenue_Rank <= 2;


-- =========================================================
-- Q4 — Customer Order Gap Analysis
-- =========================================================
-- For every customer, compare each completed order
-- with their PREVIOUS completed order.
--
-- Find orders where the gap between order dates
-- is MORE THAN 30 DAYS.
--
-- Requirements:
-- - Use LAG()
-- - Use DATEDIFF()
-- - Only completed orders
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Order_ID
-- Order_Date
-- Previous_Order_Date
-- Gap_Days

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, O.Order_ID, O.Order_Date, 
		   LAG(O.Order_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY O.Order_Date, O.Order_ID) AS Previous_Order_Date
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE O.Order_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Order_Date, Previous_Order_Date) AS Gap_Days
    FROM CTE
)
SELECT Customer_ID, Customer_Name, Order_ID, Order_Date, Previous_Order_Date, Gap_Days
FROM CTE2
WHERE Previous_Order_Date IS NOT NULL
AND Gap_Days > 30;


-- =========================================================
-- Q5 — Customer Cohort Analysis
-- =========================================================
-- Create cohorts based on the MONTH of each customer's
-- FIRST COMPLETED ORDER.
--
-- For each cohort month calculate:
--
-- 1. Total customers
-- 2. Active customers
-- 3. Total completed orders
-- 4. Total completed revenue
-- 5. Total paid orders
-- 6. Average revenue per active customer
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Active_Customers
-- Total_Orders
-- Total_Revenue
-- Paid_Orders
-- Avg_Revenue_Per_Active_Customer

WITH CTE AS (
	SELECT C.Customer_ID,
		   MIN(O.Order_Date) AS First_Order
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE O.Order_Status = 'Completed'
    GROUP BY C.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Order, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COALESCE(COUNT(DISTINCT C.Customer_ID), 0) AS Total_Customers,
       COALESCE(COUNT(DISTINCT
       CASE
			WHEN O.Order_ID IS NOT NULL AND O.Order_Status = 'Completed'
            THEN C.Customer_ID
	   END), 0) AS Active_Customers,
	   COALESCE(COUNT(
       CASE
		   WHEN O.Order_Status = 'Completed'
           THEN O.Order_ID
	   END), 0) AS Total_Orders,
       COALESCE(SUM(
       CASE
		   WHEN O.Order_Status = 'Completed'
           THEN O.Order_Amount
           ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(COUNT(
       CASE
		   WHEN P.Payment_Status = 'Paid'
           THEN P.Order_ID
	   END), 0) AS Paid_Orders,
       COALESCE(ROUND(SUM(
       CASE
		   WHEN O.Order_Status = 'Completed'
           THEN O.Order_Amount
           ELSE 0
	   END) / NULLIF(COUNT(DISTINCT
       CASE
			WHEN O.Order_ID IS NOT NULL AND O.Order_Status = 'Completed'
            THEN C.Customer_ID
	   END), 0), 2), 0) AS Avg_Revenue_Per_Active_Customer
FROM CTE2 C
LEFT JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
LEFT JOIN Payments P
	ON O.Order_ID = P.Order_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- Find the LONGEST CONSECUTIVE MONTHLY ORDERING STREAK
-- for every customer.
--
-- Rules:
-- - Only completed orders
-- - A customer counts ONCE per month
-- - Consecutive months form one streak
-- - If multiple streaks have the same length,
--   choose the MOST RECENT streak
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name,
		   DATE_FORMAT(O.Order_Date, '%Y-%m-01') AS Order_Month
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE O.Order_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Order_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Order_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Order_Month) AS Streak_Start_Month,
           MAX(Order_Month) AS Streak_End_Month
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
-- BONUS+ — Above City Average
-- =========================================================
-- Find customers whose TOTAL COMPLETED ORDER REVENUE
-- is GREATER THAN the average customer revenue
-- of their city.
--
-- Requirements:
-- - First calculate revenue per customer
-- - Then use a WINDOW FUNCTION
-- - Compare each customer against their city's
--   average customer revenue
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
		   ROUND(AVG(Total_Revenue) OVER(PARTITION BY City), 2) AS City_Avg_Revenue
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE O.Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE Total_Revenue > City_Avg_Revenue;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- Find the restaurant(s) with the HIGHEST TOTAL
-- COMPLETED REVENUE in each city.
--
-- Requirements:
-- - Include ties
-- - Use DENSE_RANK()
--
-- Return:
-- City
-- Restaurant_ID
-- Restaurant_Name
-- Total_Revenue
-- Revenue_Rank

SELECT City, Restaurant_ID, Restaurant_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT R.Restaurant_ID, R.Restaurant_Name, R.City,
			   SUM(O.Order_Amount) AS Total_Revenue
		FROM Restaurants R
		INNER JOIN Orders O
			ON R.Restaurant_ID = O.Restaurant_ID
		WHERE O.Order_Status = 'Completed'
		GROUP BY R.Restaurant_ID, R.Restaurant_Name, R.City
	)R
)D
WHERE Revenue_Rank = 1;