USE Daily_SQL;

-- ============================================================
-- DOMAIN: E-Commerce Orders Analytics
-- ============================================================

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Customers
VALUES	(1,  'Connor', 'London',     '2026-01-05'),
		(2,  'Emma',   'Toronto',    '2026-01-08'),
		(3,  'Liam',   'Berlin',     '2026-01-12'),
		(4,  'Sophia', 'Sydney',     '2026-01-18'),
		(5,  'Noah',   'Amsterdam',  '2026-02-03'),
		(6,  'Olivia', 'Madrid',     '2026-02-07'),
		(7,  'Ethan',  'Paris',      '2026-02-11'),
		(8,  'Chloe',  'Copenhagen', '2026-02-15'),
		(9,  'Lucas',  'Lisbon',     '2026-03-02'),
		(10, 'Grace',  'Vienna',     '2026-03-06'),
		(11, 'Henry',  'Zurich',     '2026-03-10'),
		(12, 'Mia',    'Dublin',     '2026-03-15');


CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_Category VARCHAR(50),
    Order_Date DATE,
    Order_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Orders
VALUES	(101, 1,  'Electronics', '2026-03-01', 250.00, 'Completed'),
		(102, 1,  'Clothing',    '2026-03-02', 120.00, 'Completed'),
		(103, 1,  'Electronics', '2026-03-03', 300.00, 'Completed'),
		(104, 1,  'Books',       '2026-03-05',  80.00, 'Cancelled'),
		(105, 1,  'Electronics', '2026-03-06', 450.00, 'Completed'),

		(106, 2,  'Clothing',    '2026-03-01', 180.00, 'Completed'),
		(107, 2,  'Electronics', '2026-03-02', 350.00, 'Completed'),
		(108, 2,  'Books',       '2026-03-04',  90.00, 'Completed'),
		(109, 2,  'Clothing',    '2026-03-05', 220.00, 'Cancelled'),
		(110, 2,  'Electronics', '2026-03-07', 500.00, 'Completed'),

		(111, 3,  'Books',       '2026-03-02',  70.00, 'Completed'),
		(112, 3,  'Books',       '2026-03-03', 110.00, 'Completed'),
		(113, 3,  'Clothing',    '2026-03-04', 160.00, 'Cancelled'),
		(114, 3,  'Electronics', '2026-03-05', 400.00, 'Completed'),
		(115, 3,  'Electronics', '2026-03-06', 480.00, 'Completed'),

		(116, 4,  'Electronics', '2026-03-01', 200.00, 'Completed'),
		(117, 4,  'Clothing',    '2026-03-03', 150.00, 'Completed'),
		(118, 4,  'Books',       '2026-03-04',  90.00, 'Completed'),
		(119, 4,  'Electronics', '2026-03-05', 350.00, 'Completed'),
		(120, 4,  'Clothing',    '2026-03-06', 210.00, 'Completed'),

		(121, 5,  'Books',       '2026-03-02',  85.00, 'Completed'),
		(122, 5,  'Electronics', '2026-03-03', 280.00, 'Completed'),
		(123, 5,  'Clothing',    '2026-03-04', 175.00, 'Completed'),
		(124, 5,  'Books',       '2026-03-06', 130.00, 'Completed'),

		(125, 6,  'Clothing',    '2026-03-03', 190.00, 'Completed'),
		(126, 6,  'Electronics', '2026-03-04', 320.00, 'Completed'),
		(127, 6,  'Electronics', '2026-03-05', 410.00, 'Completed'),
		(128, 6,  'Books',       '2026-03-07',  95.00, 'Completed'),

		(129, 7,  'Clothing',    '2026-03-01', 100.00, 'Completed'),
		(130, 7,  'Clothing',    '2026-03-02', 150.00, 'Completed'),
		(131, 7,  'Electronics', '2026-03-03', 275.00, 'Completed'),
		(132, 7,  'Books',       '2026-03-04', 125.00, 'Completed'),
		(133, 7,  'Electronics', '2026-03-06', 380.00, 'Completed'),

		(134, 8,  'Books',       '2026-03-02',  95.00, 'Completed'),
		(135, 8,  'Books',       '2026-03-03', 140.00, 'Completed'),
		(136, 8,  'Clothing',    '2026-03-04', 210.00, 'Completed'),
		(137, 8,  'Electronics', '2026-03-05', 330.00, 'Completed'),
		(138, 8,  'Electronics', '2026-03-06', 420.00, 'Completed'),

		(139, 9,  'Electronics', '2026-03-03', 220.00, 'Completed'),
		(140, 9,  'Clothing',    '2026-03-04', 180.00, 'Completed'),
		(141, 9,  'Books',       '2026-03-05',  75.00, 'Completed'),
		(142, 9,  'Electronics', '2026-03-07', 460.00, 'Completed'),

		(143, 10, 'Clothing',    '2026-03-04', 130.00, 'Completed'),
		(144, 10, 'Books',       '2026-03-05', 100.00, 'Completed'),
		(145, 10, 'Electronics', '2026-03-06', 360.00, 'Completed'),
		(146, 10, 'Clothing',    '2026-03-07', 190.00, 'Completed'),

		(147, 11, 'Books',       '2026-03-05', 110.00, 'Completed'),
		(148, 11, 'Electronics', '2026-03-06', 290.00, 'Completed'),
		(149, 11, 'Clothing',    '2026-03-07', 170.00, 'Completed'),

		(150, 12, 'Clothing',    '2026-03-06', 160.00, 'Completed'),
		(151, 12, 'Electronics', '2026-03-07', 390.00, 'Completed');


SELECT *
FROM Customers;

SELECT *
FROM Orders;


-- ============================================================
-- QUESTIONS
-- ============================================================

-- Q1
-- For each customer, find:
-- Total orders, Total completed orders,
-- Total completed amount, Average completed order amount.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Orders
-- Total_Completed_Orders
-- Total_Completed_Amount
-- Average_Completed_Order_Amount

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(O.Order_ID) AS Total_Orders,
       COUNT(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN 1
	   END) AS Total_Completed_Orders,
       SUM(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
            ELSE 0
	   END) AS Total_Completed_Amount,
       ROUND(AVG(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN O.Order_Amount
	   END), 2) AS Average_Completed_Order_Amount
FROM Customers C
INNER JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each product category, find only Completed orders:
-- Total orders, Total sales, Average order amount,
-- and number of unique customers.
--
-- Return:
-- Product_Category
-- Total_Orders
-- Total_Sales
-- Average_Order_Amount
-- Unique_Customers

SELECT Product_Category,
	   COUNT(Order_ID) AS Total_Orders,
       SUM(Order_Amount) AS Total_Sales,
       ROUND(AVG(Order_Amount), 2) AS Average_Order_Amount,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY Product_Category;


-- Q3
-- Find the top 3 customers in each city
-- based on Total Completed Amount.
-- Include ties.
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Completed_Amount
-- Rank

SELECT City, Customer_ID, Customer_Name, Total_Completed_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Completed_Amount DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Completed_Amount
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find every Completed order where the order amount
-- is greater than the customer's previous Completed order.
-- Use LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Order_ID
-- Order_Date
-- Order_Amount
-- Previous_Order_Amount

SELECT *
FROM (
	SELECT C.Customer_ID, C.Customer_Name, O.Order_ID, O.Order_Date, O.Order_Amount,
		   LAG(O.Order_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY O.Order_Date, O.Order_ID) AS Previous_Order_Amount
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE Order_Status = 'Completed'
)P
WHERE Order_Amount > Previous_Order_Amount;


-- Q5 — COHORT ANALYSIS
-- Group customers by Signup Month.
-- For each cohort, calculate:
-- Total users,
-- Total completed orders,
-- Total completed sales,
-- Average completed order amount.
--
-- IMPORTANT:
-- Total_Users must include every customer in the cohort,
-- even if they have no Completed orders.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Completed_Orders
-- Total_Completed_Sales
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
       COUNT(DISTINCT C.Customer_ID) AS Total_Users,
       COUNT(O.Order_ID) AS Total_Completed_Orders,
       SUM(O.Order_Amount) AS Total_Completed_Sales,
       ROUND(AVG(O.Order_Amount), 2) AS Average_Completed_Order_Amount
FROM CTE C
LEFT JOIN CTE2 O
	ON C.Customer_ID = O.Customer_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================

-- For each customer, find their longest streak of
-- consecutive days on which they placed Completed orders.
--
-- Ignore duplicate orders on the same date.
--
-- If two streaks have the same length,
-- return the most recent streak.
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
-- BONUS+
-- ============================================================

-- Find customers whose Total Completed Sales
-- are greater than the average Total Completed Sales
-- of their city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Completed_Sales
-- City_Average_Sales

SELECT Customer_ID, Customer_Name, City, Total_Completed_Sales, City_Average_Sales
FROM (
	SELECT *,
		   AVG(Total_Completed_Sales) OVER(PARTITION BY City) AS City_Average_Sales
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Completed_Sales
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)D
)A
WHERE Total_Completed_Sales > City_Average_Sales;


-- ============================================================
-- INTERVIEW CHALLENGE
-- ============================================================

-- Find the customer who generated the highest
-- Total Completed Sales in each Product_Category.
--
-- Include ties.
--
-- Return:
-- Product_Category
-- Customer_ID
-- Customer_Name
-- Total_Completed_Sales
-- Rank

SELECT Product_Category, Customer_ID, Customer_Name, Total_Completed_Sales, D_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Product_Category
           ORDER BY Total_Completed_Sales DESC) AS D_Rank
	FROM (
		SELECT O.Product_Category, C.Customer_ID, C.Customer_Name,
			   SUM(O.Order_Amount) AS Total_Completed_Sales
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Completed'
		GROUP BY O.Product_Category, C.Customer_ID, C.Customer_Name
	)D
)T
WHERE D_Rank = 1;