USE Daily_SQL;

-- ============================================================
-- DAILY SQL SESSION
-- Topic: E-Commerce Order & Customer Analysis
-- ============================================================

-- ============================================================
-- DATASET
-- ============================================================

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    City VARCHAR(50),
    Signup_Date DATE
);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_Category VARCHAR(50),
    Order_Date DATE,
    Order_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);


-- ============================================================
-- INSERT CUSTOMERS
-- ============================================================

INSERT INTO Customers
VALUES	(1, 'Connor', 'London',  '2025-01-05'),
		(2, 'Ash',     'Toronto', '2025-01-15'),
		(3, 'Ethan',   'Sydney',  '2025-02-03'),
		(4, 'Liam',    'Berlin',  '2025-02-20'),
		(5, 'Olivia',  'Paris',   '2025-03-02'),
		(6, 'Mason',   'Toronto', '2025-03-18'),
		(7, 'Sophia',  'London',  '2025-04-06'),
		(8, 'Noah',    'Berlin',  '2025-04-22');


-- ============================================================
-- INSERT ORDERS
-- ============================================================

INSERT INTO Orders
VALUES	(101, 1, 'Electronics', '2025-05-01', 1200.00, 'Completed'),
		(102, 1, 'Clothing',    '2025-05-02',  150.00, 'Completed'),
		(103, 1, 'Books',       '2025-05-04',   80.00, 'Cancelled'),
		(104, 1, 'Electronics', '2025-05-05',  900.00, 'Completed'),
		(105, 1, 'Clothing',    '2025-05-07',  220.00, 'Completed'),

		(106, 2, 'Books',       '2025-05-01',   60.00, 'Completed'),
		(107, 2, 'Electronics', '2025-05-03',  750.00, 'Completed'),
		(108, 2, 'Clothing',    '2025-05-04',  180.00, 'Cancelled'),
		(109, 2, 'Books',       '2025-05-06',  120.00, 'Completed'),
		(110, 2, 'Electronics', '2025-05-08',  950.00, 'Completed'),

		(111, 3, 'Clothing',    '2025-05-10',  200.00, 'Completed'),
		(112, 3, 'Books',       '2025-05-11',   90.00, 'Completed'),
		(113, 3, 'Electronics', '2025-05-12', 1100.00, 'Completed'),
		(114, 3, 'Clothing',    '2025-05-14',  250.00, 'Completed'),
		(115, 3, 'Books',       '2025-05-15',  130.00, 'Cancelled'),

		(116, 4, 'Electronics', '2025-05-10',  850.00, 'Completed'),
		(117, 4, 'Books',       '2025-05-11',   70.00, 'Cancelled'),
		(118, 4, 'Clothing',    '2025-05-12',  300.00, 'Completed'),
		(119, 4, 'Electronics', '2025-05-14',  950.00, 'Completed'),
		(120, 4, 'Clothing',    '2025-05-15',  180.00, 'Completed'),

		(121, 5, 'Books',       '2025-06-01',   90.00, 'Completed'),
		(122, 5, 'Clothing',    '2025-06-02',  210.00, 'Completed'),
		(123, 5, 'Electronics', '2025-06-03', 1250.00, 'Completed'),
		(124, 5, 'Books',       '2025-06-05',  140.00, 'Completed'),
		(125, 5, 'Clothing',    '2025-06-06',  260.00, 'Completed'),

		(126, 6, 'Electronics', '2025-06-01', 1400.00, 'Completed'),
		(127, 6, 'Books',       '2025-06-02',  100.00, 'Completed'),
		(128, 6, 'Clothing',    '2025-06-04',  230.00, 'Completed'),
		(129, 6, 'Electronics', '2025-06-05',  850.00, 'Completed'),
		(130, 6, 'Books',       '2025-06-06',  110.00, 'Cancelled'),

		(131, 7, 'Clothing',    '2025-06-10',  190.00, 'Completed'),
		(132, 7, 'Books',       '2025-06-11',  120.00, 'Completed'),
		(133, 7, 'Electronics', '2025-06-12', 1300.00, 'Completed'),
		(134, 7, 'Clothing',    '2025-06-13',  280.00, 'Completed'),
		(135, 7, 'Books',       '2025-06-15',  150.00, 'Completed'),

		(136, 8, 'Books',       '2025-06-10',   80.00, 'Completed'),
		(137, 8, 'Electronics', '2025-06-11', 1000.00, 'Cancelled'),
		(138, 8, 'Clothing',    '2025-06-12',  240.00, 'Completed'),
		(139, 8, 'Books',       '2025-06-13',  130.00, 'Completed'),
		(140, 8, 'Electronics', '2025-06-15', 1150.00, 'Completed');


-- ============================================================
-- INSPECT DATA
-- ============================================================


SELECT *
FROM Customers;

SELECT *
FROM Orders;


-- ============================================================
-- Q1 — CUSTOMER ORDER SUMMARY
-- ============================================================
-- Show each customer's:
--   1. Total orders
--   2. Total order amount
--   3. Average order amount
--   4. Total completed orders
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Orders
-- Total_Order_Amount
-- Average_Order_Amount
-- Total_Completed_Orders

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(O.Order_ID) AS Total_Orders,
       SUM(O.Order_Amount) AS Total_Order_Amount,
       ROUND(AVG(O.Order_Amount), 2) AS Average_Order_Amount,
       COUNT(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN 1
	   END) AS Total_Completed_Orders
FROM Customers C
LEFT JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- ============================================================
-- Q2 — CATEGORY PERFORMANCE
-- ============================================================
-- For each product category, find:
--   1. Total orders
--   2. Total completed orders
--   3. Total completed revenue
--   4. Average completed order amount
--   5. Number of unique customers
--
-- Return:
-- Product_Category
-- Total_Orders
-- Total_Completed_Orders
-- Total_Completed_Revenue
-- Average_Completed_Order_Amount
-- Unique_Customers

SELECT Product_Category,
	   COUNT(Order_ID) AS Total_Orders,
       COUNT(
       CASE
			WHEN Order_Status = 'Completed'
            THEN 1
	   END) AS Total_Completed_Orders,
       SUM(
       CASE
			WHEN Order_Status = 'Completed'
            THEN Order_Amount
            ELSE 0
	   END) AS Total_Completed_Revenue,
       ROUND(AVG(
       CASE
			WHEN Order_Status = 'Completed'
            THEN Order_Amount
	   END), 2) AS Average_Completed_Order_Amount,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Orders
GROUP BY Product_Category;


-- ============================================================
-- Q3 — TOP CUSTOMERS BY CITY
-- ============================================================
-- Find the TOP 2 customers in each city based on
-- their TOTAL COMPLETED REVENUE.
--
-- Use DENSE_RANK().
-- Include ties.
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Completed_Revenue

SELECT City, Customer_ID, Customer_Name, Total_Completed_Revenue
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Completed_Revenue DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Completed_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)R
)D
WHERE D_Rank <= 2;


-- ============================================================
-- Q4 — DATE LOGIC
-- ============================================================
-- Find customers who placed a COMPLETED order
-- within 2 days of their previous COMPLETED order.
--
-- Ignore Cancelled orders when calculating the gap.
-- Use LAG() + DATEDIFF().
--
-- Return:
-- Customer_ID
-- Customer_Name

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, O.Order_Date,
		   LAG(O.Order_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY O.Order_Date, O.Order_ID) AS Previous_Order
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE Order_Status = 'Completed'
)
SELECT DISTINCT Customer_ID, Customer_Name
FROM CTE 
WHERE Previous_Order IS NOT NULL
AND DATEDIFF(Order_Date, Previous_Order) <= 2;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================
-- Group customers by their SIGNUP MONTH.
--
-- For each signup cohort month, calculate:
--   1. Total customers
--   2. Total completed orders
--   3. Total completed revenue
--   4. Average completed order amount
--
-- Only COMPLETED orders should contribute to
-- the order/revenue metrics.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Completed_Orders
-- Total_Completed_Revenue
-- Average_Completed_Order_Amount

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
),
CTE2 AS (
	SELECT *
    FROM Orders
    WHERE Order_Status = 'Completed'
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) Total_Customers,
       COUNT(O.Order_ID) AS Total_Completed_Orders,
       SUM(O.Order_Amount) AS Total_Completed_Revenue,
       ROUND(AVG(O.Order_Amount), 2) AS Average_Completed_Order_Amount
FROM CTE C
LEFT JOIN CTE2 O
	ON C.Customer_ID = O.Customer_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================
-- Find each customer's LONGEST STREAK of consecutive
-- COMPLETED order dates.
--
-- Rules:
--   - Only Completed orders count.
--   - Ignore Cancelled orders.
--   - If a customer has multiple orders on the same date,
--     treat that date only once.
--   - If two streaks have the same length,
--     choose the MOST RECENT streak.
--
-- Expected pattern:
-- DISTINCT dates
-- -> ROW_NUMBER()
-- -> DATE_SUB()
-- -> GROUP BY Group_Key
-- -> MIN / MAX / COUNT
-- -> rank streaks
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, O.Order_Date
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
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
           ORDER BY Streak DESC, End_Date DESC) AS Row_Num
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- ============================================================
-- BONUS+ — CITY REVENUE COMPARISON
-- ============================================================
-- Find customers whose TOTAL COMPLETED REVENUE is
-- greater than the AVERAGE TOTAL COMPLETED REVENUE
-- of customers in their own city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Completed_Revenue

SELECT Customer_ID, Customer_Name, City, Total_Completed_Revenue
FROM (
	SELECT *,
		   AVG(Total_Completed_Revenue) OVER(PARTITION BY City) AS City_Average_Sales
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Completed_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)D
)A
WHERE Total_Completed_Revenue > City_Average_Sales;


-- ============================================================
-- INTERVIEW CHALLENGE
-- ============================================================
-- For each Product_Category, find the customer who has
-- the HIGHEST TOTAL COMPLETED REVENUE in that category.
--
-- If multiple customers are tied for the highest revenue,
-- return ALL tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- Product_Category
-- Customer_ID
-- Customer_Name
-- Total_Completed_Revenue
-- ============================================================

SELECT Product_Category, Customer_ID, Customer_Name, Total_Completed_Revenue
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Product_Category
           ORDER BY Total_Completed_Revenue DESC) AS D_Rank
	FROM (
		SELECT O.Product_Category, C.Customer_ID, C.Customer_Name,
			   SUM(O.Order_Amount) AS Total_Completed_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Completed'
		GROUP BY O.Product_Category, C.Customer_ID, C.Customer_Name
	)D
)T
WHERE D_Rank = 1;