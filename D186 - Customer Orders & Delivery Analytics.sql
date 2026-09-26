USE Daily_SQL;

-- =========================================================
-- SESSION — Customer Orders & Delivery Analytics
-- =========================================================

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
VALUES	(1, 'Daniel', 'London',  '2024-01-15'),
		(2, 'Sophia', 'Toronto', '2024-02-10'),
		(3, 'Liam',   'Sydney',  '2024-03-05'),
		(4, 'Emma',   'Berlin',  '2024-03-20'),
		(5, 'Noah',   'Paris',   '2024-04-12'),
		(6, 'Olivia', 'London',  '2024-05-18'),
		(7, 'Ethan',  'Toronto', '2024-06-01'),
		(8, 'Ava',    'Sydney',  '2024-06-25');


-- =========================================================
-- TABLE 2 — Orders
-- =========================================================

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Category VARCHAR(50),
    Order_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Orders
VALUES	(1001, 1, '2025-01-05', 'Electronics', 1200, 'Completed'),
		(1002, 1, '2025-01-18', 'Furniture',    800, 'Completed'),
		(1003, 1, '2025-02-10', 'Electronics', 1500, 'Completed'),
		(1004, 1, '2025-03-15', 'Furniture',    600, 'Completed'),

		(1005, 2, '2025-01-08', 'Electronics',  900, 'Completed'),
		(1006, 2, '2025-02-20', 'Electronics', 1300, 'Completed'),
		(1007, 2, '2025-03-25', 'Furniture',    700, 'Completed'),

		(1008, 3, '2025-01-12', 'Furniture',   1100, 'Completed'),
		(1009, 3, '2025-02-15', 'Electronics', 1800, 'Completed'),
		(1010, 3, '2025-04-10', 'Electronics', 1600, 'Completed'),

		(1011, 4, '2025-01-20', 'Furniture',    950, 'Completed'),
		(1012, 4, '2025-03-05', 'Electronics', 1400, 'Completed'),
		(1013, 4, '2025-04-20', 'Furniture',   1000, 'Completed'),

		(1014, 5, '2025-02-05', 'Electronics', 1250, 'Completed'),
		(1015, 5, '2025-03-18', 'Furniture',    850, 'Completed'),
		(1016, 5, '2025-05-12', 'Electronics', 1450, 'Completed'),

		(1017, 6, '2025-03-05', 'Electronics', 1000, 'Completed'),
		(1018, 6, '2025-03-20', 'Furniture',    750, 'Completed'),
		(1019, 6, '2025-04-15', 'Electronics', 1350, 'Completed'),

		(1020, 7, '2025-04-05', 'Furniture',   1150, 'Completed'),
		(1021, 7, '2025-05-10', 'Electronics', 1550, 'Completed'),
		(1022, 7, '2025-06-15', 'Furniture',    900, 'Completed'),

		(1023, 8, '2025-04-10', 'Electronics', 1100, 'Completed'),
		(1024, 8, '2025-05-20', 'Furniture',    950, 'Completed'),
		(1025, 8, '2025-07-05', 'Electronics', 1700, 'Completed');


-- =========================================================
-- TABLE 3 — Deliveries
-- =========================================================

CREATE TABLE Deliveries (
    Delivery_ID INT PRIMARY KEY,
    Order_ID INT,
    Delivery_Date DATE,
    Delivery_Status VARCHAR(20),
    Delivery_Days INT,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

INSERT INTO Deliveries
VALUES	(2001, 1001, '2025-01-08', 'Delivered', 3),
		(2002, 1002, '2025-01-23', 'Delivered', 5),
		(2003, 1003, '2025-02-14', 'Delivered', 4),
		(2004, 1004, '2025-03-20', 'Delivered', 5),

		(2005, 1005, '2025-01-11', 'Delivered', 3),
		(2006, 1006, '2025-02-25', 'Delivered', 5),
		(2007, 1007, '2025-03-31', 'Delivered', 6),

		(2008, 1008, '2025-01-17', 'Delivered', 5),
		(2009, 1009, '2025-02-20', 'Delivered', 5),
		(2010, 1010, '2025-04-15', 'Delivered', 5),

		(2011, 1011, '2025-01-25', 'Delivered', 5),
		(2012, 1012, '2025-03-10', 'Delivered', 5),
		(2013, 1013, '2025-04-27', 'Delivered', 7),

		(2014, 1014, '2025-02-10', 'Delivered', 5),
		(2015, 1015, '2025-03-23', 'Delivered', 5),
		(2016, 1016, '2025-05-18', 'Delivered', 6),

		(2017, 1017, '2025-03-10', 'Delivered', 5),
		(2018, 1018, '2025-03-25', 'Delivered', 5),
		(2019, 1019, '2025-04-20', 'Delivered', 5),

		(2020, 1020, '2025-04-10', 'Delivered', 5),
		(2021, 1021, '2025-05-15', 'Delivered', 5),
		(2022, 1022, '2025-06-21', 'Delivered', 6),

		(2023, 1023, '2025-04-15', 'Delivered', 5),
		(2024, 1024, '2025-05-25', 'Delivered', 5),
		(2025, 1025, '2025-07-10', 'Delivered', 5);


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT *
FROM Customers;

SELECT *
FROM Orders;

SELECT *
FROM Deliveries;


-- =========================================================
-- Q1 — Customer Order Summary
-- =========================================================
-- For every customer calculate:
--
-- Total completed orders
-- Total completed order amount
-- Average completed order amount
-- Highest completed order amount
-- Lowest completed order amount
--
-- Include customers with no completed orders.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Orders
-- Total_Order_Amount
-- Avg_Order_Amount
-- Highest_Order
-- Lowest_Order

SELECT C.Customer_ID, C.Customer_Name, C.City,
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
	   END), 0) AS Highest_Order,
       COALESCE(MIN(
       CASE
		   WHEN O.Order_Status = 'Completed'
           THEN O.Order_Amount
	   END), 0) AS Lowest_Order
FROM Customers C
LEFT JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name, C.City;


-- =========================================================
-- Q2 — City Order Performance
-- =========================================================
-- For each city calculate:
--
-- Customer_Count
-- Total completed orders
-- Total completed order amount
-- Average order amount
--
-- Include all customers in the city.
--
-- Return:
-- City
-- Customer_Count
-- Total_Orders
-- Total_Order_Amount
-- Avg_Order_Amount

SELECT C.City,
	   COALESCE(COUNT(C.Customer_ID), 0) AS Customer_Count,
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
	   END), 2), 0) AS Avg_Order_Amount
FROM Customers C
LEFT JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
GROUP BY C.City;


-- =========================================================
-- Q3 — Top 2 Customers Per City
-- =========================================================
-- Find the top 2 customers in each city
-- based on total completed order amount.
--
-- Include ties.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Order_Amount
-- Revenue_Rank

SELECT City, Customer_ID, Customer_Name, Total_Order_Amount, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Order_Amount DESC) AS Revenue_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Order_Amount
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE O.Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)R
WHERE Revenue_Rank <= 2;


-- =========================================================
-- Q4 — Customer Order Gap Analysis
-- =========================================================
-- For each customer, find orders where the gap
-- from the previous completed order is greater than 30 days.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Order_Date
-- Previous_Order_Date
-- Gap_Days

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, O.Order_Date,
		   LAG(O.Order_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY O.Order_Date, O.Order_ID) AS Previous_Order_Date
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE Order_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Order_Date, Previous_Order_Date) AS Gap_Days
    FROM CTE
)
SELECT Customer_ID, Customer_Name, Order_Date, Previous_Order_Date, Gap_Days
FROM CTE2
WHERE Previous_Order_Date IS NOT NULL
AND Gap_Days > 30;


-- =========================================================
-- Q5 — Customer Cohort Order Analysis
-- =========================================================
-- Group customers by the month of their FIRST
-- completed order.
--
-- For each cohort month calculate:
--
-- Total customers
-- Active customers
-- Total orders
-- Total revenue
-- Total delivered orders
-- Average revenue per active customer
--
-- A customer is active if they have at least one
-- completed order.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Active_Customers
-- Total_Orders
-- Total_Revenue
-- Delivered_Orders
-- Avg_Revenue_Per_Active_Customer

WITH CTE AS (
	SELECT C.Customer_ID,
		   MIN(O.Order_Date) AS First_order
	FROM Customers C
    INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE O.Order_Status = 'Completed'
    GROUP BY C.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_order, '%Y-%m') AS Cohort_Month
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
		   WHEN D.Delivery_Status = 'Delivered'
           THEN D.Delivery_ID
	   END), 0) AS Delivered_Orders,
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
LEFT JOIN Deliveries D
	ON O.Order_ID = D.Order_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- For each customer, find their longest consecutive
-- monthly ordering streak.
--
-- A month counts once even if the customer placed
-- multiple orders in that month.
--
-- If there is a tie, return the most recent streak.
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
-- BONUS+ — Customer Above-Average Revenue
-- =========================================================
-- Find customers whose total completed order revenue
-- is greater than the average customer revenue
-- of their city.
--
-- Use a window function.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Revenue
-- City_Average_Revenue

SELECT Customer_ID, Customer_Name, City, Total_Revenue, City_Average_Revenue
FROM (
	SELECT *,
		   ROUND(AVG(Total_Revenue) OVER(PARTITION BY City), 2) AS City_Average_Revenue
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE O.Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Revenue > City_Average_Revenue;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each city, find the customer(s) with the
-- highest total completed order revenue.
--
-- Include ties.
--
-- Use DENSE_RANK().
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
	)D
)H
WHERE Revenue_Rank = 1;