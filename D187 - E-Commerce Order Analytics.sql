USE Daily_SQL;

-- ============================================================
-- DAILY SQL SESSION
-- Topic: E-Commerce Order Analytics
-- ============================================================

CREATE TABLE ECommerce_Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    City VARCHAR(30),
    Order_Date DATE,
    Category VARCHAR(30),
    Order_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20)
);

INSERT INTO ECommerce_Orders
VALUES	(1,101,'James','New York','2026-01-02','Electronics',4500,'Completed'),
		(2,101,'James','New York','2026-01-04','Fashion',1800,'Completed'),
		(3,101,'James','New York','2026-01-05','Electronics',3200,'Completed'),
		(4,101,'James','New York','2026-01-08','Home',2100,'Completed'),

		(5,102,'Sophia','London','2026-01-03','Fashion',1200,'Completed'),
		(6,102,'Sophia','London','2026-01-06','Fashion',1500,'Completed'),
		(7,102,'Sophia','London','2026-01-10','Electronics',3500,'Cancelled'),

		(8,103,'Daniel','Toronto','2026-01-10','Home',2200,'Completed'),
		(9,103,'Daniel','Toronto','2026-01-11','Home',1800,'Completed'),
		(10,103,'Daniel','Toronto','2026-01-12','Home',2500,'Completed'),
		(11,103,'Daniel','Toronto','2026-01-15','Electronics',4000,'Completed'),

		(12,104,'Emma','Berlin','2026-02-01','Electronics',5000,'Completed'),
		(13,104,'Emma','Berlin','2026-02-02','Electronics',5200,'Completed'),
		(14,104,'Emma','Berlin','2026-02-03','Home',2800,'Completed'),
		(15,104,'Emma','Berlin','2026-02-06','Fashion',1900,'Completed'),

		(16,105,'Oliver','London','2026-02-07','Fashion',1300,'Completed'),
		(17,105,'Oliver','London','2026-02-09','Fashion',1600,'Completed'),
		(18,105,'Oliver','London','2026-02-10','Electronics',4200,'Completed'),

		(19,106,'Charlotte','New York','2026-03-01','Home',2300,'Completed'),
		(20,106,'Charlotte','New York','2026-03-02','Home',2400,'Completed'),
		(21,106,'Charlotte','New York','2026-03-03','Home',2500,'Completed'),

		(22,107,'Henry','Berlin','2026-03-05','Fashion',900,'Completed'),
		(23,107,'Henry','Berlin','2026-03-06','Fashion',1100,'Completed'),
		(24,107,'Henry','Berlin','2026-03-08','Electronics',3000,'Completed'),

		(25,108,'Amelia','Toronto','2026-03-10','Electronics',5500,'Completed'),
		(26,108,'Amelia','Toronto','2026-03-11','Electronics',5600,'Completed'),
		(27,108,'Amelia','Toronto','2026-03-12','Electronics',5700,'Completed'),
		(28,108,'Amelia','Toronto','2026-03-13','Electronics',5800,'Completed'),

		(29,109,'William','London','2026-03-15','Home',1500,'Completed'),
		(30,109,'William','London','2026-03-18','Home',1700,'Completed'),

		(31,110,'Isabella','Berlin','2026-03-20','Electronics',6000,'Completed'),
		(32,110,'Isabella','Berlin','2026-03-21','Fashion',2200,'Completed'),
		(33,110,'Isabella','Berlin','2026-03-25','Home',3000,'Completed');


SELECT *
FROM ECommerce_Orders;


-- ============================================================
-- Q1 — CUSTOMER ORDER SUMMARY
-- ============================================================
-- Show each customer's:
-- Total orders
-- Total completed orders
-- Total completed order amount
-- Average completed order amount
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Orders
-- Completed_Orders
-- Total_Completed_Amount
-- Average_Completed_Amount
--
-- Cancelled orders should NOT contribute to
-- completed revenue.

SELECT Customer_ID, Customer_Name,
	   COALESCE(COUNT(Order_ID), 0) AS Total_Orders,
       COALESCE(COUNT(
       CASE
			WHEN Order_Status = 'Completed'
            THEN Order_ID
	   END), 0) AS Completed_Orders,
       COALESCE(SUM(
       CASE
			WHEN Order_Status = 'Completed'
            THEN Order_Amount
            ELSE 0
	   END), 0) AS Total_Completed_Amount,
       COALESCE(ROUND(AVG(
       CASE
			WHEN Order_Status = 'Completed'
            THEN Order_Amount
	   END), 2), 0) AS Average_Completed_Amount
FROM ECommerce_Orders
GROUP BY Customer_ID, Customer_Name;


-- ============================================================
-- Q2 — CATEGORY PERFORMANCE
-- ============================================================
-- For each category, find:
-- Total completed orders
-- Total completed revenue
-- Average completed order amount
-- Number of distinct customers
--
-- Return:
-- Category
-- Total_Orders
-- Total_Revenue
-- Average_Order_Amount
-- Unique_Customers
--
-- Only consider Completed orders.

SELECT Category,
	   COALESCE(COUNT(Order_ID), 0) AS Total_Orders,
       COALESCE(SUM(Order_Amount), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(Order_Amount), 2), 0) AS Average_Order_Amount,
       COALESCE(COUNT(DISTINCT Customer_ID), 0) AS Unique_Customers
FROM ECommerce_Orders
WHERE Order_Status = 'Completed'
GROUP BY Category;


-- ============================================================
-- Q3 — TOP 3 CUSTOMERS BY REVENUE
-- ============================================================
-- Find the top 3 customers based on completed
-- order revenue.
--
-- Requirements:
-- Use a CTE
-- Use DENSE_RANK()
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Revenue
-- Revenue_Rank

WITH CTE AS (
	SELECT Customer_ID, Customer_Name,
		   SUM(Order_Amount) AS Total_Revenue
	FROM ECommerce_Orders
	WHERE Order_Status = 'Completed'
	GROUP BY Customer_ID, Customer_Name
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM CTE
)
SELECT Customer_ID, Customer_Name, Total_Revenue, Revenue_Rank
FROM CTE2
WHERE Revenue_Rank <= 3;


-- ============================================================
-- Q4 — REPEAT CUSTOMERS WITHIN 2 DAYS
-- ============================================================
-- Find customers who placed another completed order
-- within 2 days of their previous completed order.
--
-- Return:
-- Customer_ID
-- Customer_Name
--
-- Compare consecutive completed order dates
-- for each customer.

SELECT DISTINCT Customer_ID, Customer_Name
FROM (
	SELECT Customer_ID, Customer_Name, Order_Date,
		   LAG(Order_Date) OVER(PARTITION BY Customer_ID
		   ORDER BY Order_Date, Order_ID) AS Previous_Order_Date
	FROM ECommerce_Orders
	WHERE Order_Status = 'Completed'
)P
WHERE DATEDIFF(Order_Date, Previous_Order_Date) <= 2;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================
-- A customer's cohort month is the month of their
-- FIRST COMPLETED ORDER.
--
-- For each cohort month, find:
-- Total customers
-- Total completed orders
-- Total completed revenue
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Orders
-- Total_Revenue
--
-- Cancelled orders should NOT determine the cohort.

WITH CTE AS (
	SELECT Customer_ID,
		   MIN(Order_Date) AS First_Order_Date
	FROM ECommerce_Orders
	WHERE Order_Status = 'Completed'
    GROUP BY Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Order_Date, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT Cohort_Month,
	   COALESCE(COUNT(DISTINCT C.Customer_ID), 0) AS Total_Customers,
       COALESCE(COUNT(E.Order_ID), 0) AS Total_Orders,
       COALESCE(SUM(E.Order_Amount), 0) AS Total_Revenue
FROM CTE2 C
LEFT JOIN ECommerce_Orders E
	ON C.Customer_ID = E.Customer_ID
AND Order_Status = 'Completed'
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================
-- Find each customer's CURRENT COMPLETED-ORDER STREAK.
--
-- A streak consists of consecutive calendar days
-- with at least one completed order.
--
-- If a customer has multiple orders on the same day,
-- count that date only once.
--
-- Current streak = the streak containing the
-- customer's most recent completed order.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only customers whose Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT Customer_ID, Customer_Name, Order_Date
    FROM ECommerce_Orders
	WHERE Order_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Order_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Order_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Order_Date) AS Start_Date,
           MAX(Order_Date) AS End_Date
	FROM CTE3
    GROUP BY Customer_ID, Customer_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY End_Date DESC) AS Row_Num
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num =1
AND Streak >= 3;


-- ============================================================
-- BONUS+ — CUSTOMER SPENDING VS CITY AVERAGE
-- ============================================================
-- Calculate each customer's total completed revenue.
--
-- Then calculate the average customer revenue
-- within their city.
--
-- Return ONLY customers whose revenue is
-- above their city's average.
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
		   COALESCE(ROUND(AVG(Total_Revenue) OVER(PARTITION BY City), 2), 0) AS City_Average_Revenue
	FROM (
		SELECT Customer_ID, Customer_Name, City,
			   COALESCE(SUM(Order_Amount), 0) AS Total_Revenue
		FROM ECommerce_Orders
		WHERE Order_Status = 'Completed'
        GROUP BY Customer_ID, Customer_Name, City
	)C
)A
WHERE Total_Revenue > City_Average_Revenue;


-- ============================================================
-- INTERVIEW CHALLENGE — TOP CUSTOMER PER CITY
-- ============================================================
-- Find the highest-revenue customer in each city.
--
-- Requirements:
-- Only completed orders
-- Calculate customer-level revenue first
-- Use a window function
-- Include all customers in case of a tie
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Revenue

SELECT City, Customer_ID, Customer_Name, Total_Revenue
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS D_Rank
	FROM (
		SELECT City, Customer_ID, Customer_Name,
			   SUM(Order_Amount) AS Total_Revenue
		FROM ECommerce_Orders
		WHERE Order_Status = 'Completed'
        GROUP BY Customer_ID, Customer_Name, City
	)D
)T
WHERE D_Rank = 1;