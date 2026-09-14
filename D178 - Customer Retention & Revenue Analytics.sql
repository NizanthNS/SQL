USE Daily_SQL;

-- ============================================================
-- SESSION — Customer Retention & Revenue Analytics
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

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    Order_ID INT,
    Payment_Date DATE,
    Payment_Amount DECIMAL(10,2),
    Payment_Status VARCHAR(20),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);


-- ============================================================
-- CUSTOMERS
-- ============================================================

INSERT INTO Customers
VALUES	(1, 'Connor', 'London', '2024-01-10'),
		(2, 'Ash', 'Toronto', '2024-02-15'),
		(3, 'Ethan', 'Sydney', '2024-03-05'),
		(4, 'Liam', 'Berlin', '2024-03-20'),
		(5, 'Olivia', 'Paris', '2024-04-02'),
		(6, 'Mason', 'Toronto', '2024-04-18'),
		(7, 'Sophia', 'London', '2024-05-06'),
		(8, 'Noah', 'Berlin', '2024-05-22');


-- ============================================================
-- ORDERS
-- ============================================================

INSERT INTO Orders
VALUES	(101, 1, 'Electronics', '2025-06-01', 1200.00, 'Completed'),
		(102, 1, 'Books',       '2025-06-03',  150.00, 'Completed'),
		(103, 1, 'Clothing',    '2025-06-08',  300.00, 'Cancelled'),
		(104, 1, 'Electronics', '2025-06-12',  800.00, 'Completed'),
		(105, 1, 'Books',       '2025-07-01',  200.00, 'Completed'),

		(106, 2, 'Clothing',    '2025-06-02',  450.00, 'Completed'),
		(107, 2, 'Electronics', '2025-06-05',  900.00, 'Completed'),
		(108, 2, 'Books',       '2025-06-10',  100.00, 'Cancelled'),
		(109, 2, 'Clothing',    '2025-06-15',  600.00, 'Completed'),
		(110, 2, 'Electronics', '2025-07-05', 1100.00, 'Completed'),

		(111, 3, 'Books',       '2025-06-01',  120.00, 'Completed'),
		(112, 3, 'Electronics', '2025-06-04',  700.00, 'Completed'),
		(113, 3, 'Clothing',    '2025-06-09',  350.00, 'Completed'),
		(114, 3, 'Books',       '2025-07-02',  180.00, 'Completed'),
		(115, 3, 'Electronics', '2025-07-08',  950.00, 'Cancelled'),

		(116, 4, 'Electronics', '2025-06-03',  500.00, 'Completed'),
		(117, 4, 'Books',       '2025-06-06',  250.00, 'Completed'),
		(118, 4, 'Clothing',    '2025-06-14',  400.00, 'Completed'),
		(119, 4, 'Electronics', '2025-07-03',  650.00, 'Completed'),
		(120, 4, 'Books',       '2025-07-10',  180.00, 'Cancelled'),

		(121, 5, 'Clothing',    '2025-06-02',  300.00, 'Completed'),
		(122, 5, 'Electronics', '2025-06-07', 1500.00, 'Completed'),
		(123, 5, 'Books',       '2025-06-11',  200.00, 'Cancelled'),
		(124, 5, 'Clothing',    '2025-06-20',  550.00, 'Completed'),
		(125, 5, 'Electronics', '2025-07-04', 1300.00, 'Completed'),

		(126, 6, 'Books',       '2025-06-01',  100.00, 'Completed'),
		(127, 6, 'Clothing',    '2025-06-05',  500.00, 'Completed'),
		(128, 6, 'Electronics', '2025-06-12',  850.00, 'Completed'),
		(129, 6, 'Books',       '2025-07-01',  250.00, 'Completed'),
		(130, 6, 'Clothing',    '2025-07-06',  700.00, 'Completed'),

		(131, 7, 'Electronics', '2025-06-03', 1000.00, 'Completed'),
		(132, 7, 'Books',       '2025-06-08',  220.00, 'Completed'),
		(133, 7, 'Clothing',    '2025-06-15',  450.00, 'Completed'),
		(134, 7, 'Electronics', '2025-07-02',  900.00, 'Completed'),
		(135, 7, 'Books',       '2025-07-09',  150.00, 'Cancelled'),

		(136, 8, 'Clothing',    '2025-06-02',  400.00, 'Completed'),
		(137, 8, 'Books',       '2025-06-05',  180.00, 'Completed'),
		(138, 8, 'Electronics', '2025-06-11', 1200.00, 'Completed'),
		(139, 8, 'Clothing',    '2025-07-01',  500.00, 'Completed'),
		(140, 8, 'Electronics', '2025-07-07',  750.00, 'Completed');


-- ============================================================
-- PAYMENTS
-- ============================================================

INSERT INTO Payments
VALUES	(201, 101, '2025-06-01', 1200.00, 'Paid'),
		(202, 102, '2025-06-03',  150.00, 'Paid'),
		(203, 104, '2025-06-12',  800.00, 'Paid'),
		(204, 105, '2025-07-01',  200.00, 'Paid'),

		(205, 106, '2025-06-02',  450.00, 'Paid'),
		(206, 107, '2025-06-05',  900.00, 'Paid'),
		(207, 109, '2025-06-15',  600.00, 'Paid'),
		(208, 110, '2025-07-05', 1100.00, 'Paid'),

		(209, 111, '2025-06-01',  120.00, 'Paid'),
		(210, 112, '2025-06-04',  700.00, 'Paid'),
		(211, 113, '2025-06-09',  350.00, 'Paid'),
		(212, 114, '2025-07-02',  180.00, 'Paid'),

		(213, 116, '2025-06-03',  500.00, 'Paid'),
		(214, 117, '2025-06-06',  250.00, 'Paid'),
		(215, 118, '2025-06-14',  400.00, 'Paid'),
		(216, 119, '2025-07-03',  650.00, 'Paid'),

		(217, 121, '2025-06-02',  300.00, 'Paid'),
		(218, 122, '2025-06-07', 1500.00, 'Paid'),
		(219, 124, '2025-06-20',  550.00, 'Paid'),
		(220, 125, '2025-07-04', 1300.00, 'Paid'),

		(221, 126, '2025-06-01',  100.00, 'Paid'),
		(222, 127, '2025-06-05',  500.00, 'Paid'),
		(223, 128, '2025-06-12',  850.00, 'Paid'),
		(224, 129, '2025-07-01',  250.00, 'Paid'),
		(225, 130, '2025-07-06',  700.00, 'Paid'),

		(226, 131, '2025-06-03', 1000.00, 'Paid'),
		(227, 132, '2025-06-08',  220.00, 'Paid'),
		(228, 133, '2025-06-15',  450.00, 'Paid'),
		(229, 134, '2025-07-02',  900.00, 'Paid'),

		(230, 136, '2025-06-02',  400.00, 'Paid'),
		(231, 137, '2025-06-05',  180.00, 'Paid'),
		(232, 138, '2025-06-11', 1200.00, 'Paid'),
		(233, 139, '2025-07-01',  500.00, 'Paid'),
		(234, 140, '2025-07-07',  750.00, 'Paid');


-- ============================================================
-- CHECK DATA
-- ============================================================

SELECT *
FROM Customers;

SELECT *
FROM Orders;

SELECT *
FROM Payments;


-- ============================================================
-- Q1 — Customer Order Summary
-- ============================================================
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Orders
-- Total_Order_Amount
-- Average_Order_Amount
-- Completed_Orders

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(O.Order_ID) AS Total_Orders,
       SUM(O.Order_Amount) AS Total_Order_Amount,
       ROUND(AVG(O.Order_Amount), 2) AS Average_Order_Amount,
       COUNT(
       CASE
			WHEN O.Order_Status = 'Completed'
            THEN 1
	   END) AS Completed_Orders
FROM Customers C
INNER JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- ============================================================
-- Q2 — Payment Performance
-- ============================================================
-- Consider only Payments where Payment_Status = 'Paid'.
-- Return one row per customer.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Paid_Orders
-- Total_Paid_Amount
-- Average_Paid_Amount
-- Highest_Paid_Amount

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(P.Order_ID) AS Total_Paid_Orders,
       SUM(P.Payment_Amount) AS Total_Paid_Amount,
	   ROUND(AVG(P.Payment_Amount), 2) AS Average_Paid_Amount,
       MAX(P.Payment_Amount) AS Highest_Paid_Amount
FROM Customers C
LEFT JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
LEFT JOIN Payments P
	ON O.Order_ID = P.Order_ID
	AND P.Payment_Status = 'Paid'
GROUP BY C.Customer_ID, C.Customer_Name;


-- ============================================================
-- Q3 — Top 2 Customers Per City by Paid Revenue
-- ============================================================
-- Consider only completed orders with a matching Paid payment.
-- Rank customers within each city using DENSE_RANK().
-- Include ties.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Paid_Revenue
-- Revenue_Rank

SELECT Customer_ID, Customer_Name, City, Total_Paid_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Paid_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(P.Payment_Amount) AS Total_Paid_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
			AND O.Order_Status = 'Completed'
		INNER JOIN Payments P
			ON O.Order_ID = P.Order_ID 
            AND P.Payment_Status = 'Paid'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)R
)D
WHERE Revenue_Rank <= 2;


-- ============================================================
-- Q4 — Repeat Customers Within 3 Days
-- ============================================================
-- For each customer, consider only completed orders.
-- Find customers who placed a completed order within
-- 3 days of their previous completed order.
--
-- Use LAG() + DATEDIFF().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Order_Date
-- Previous_Order_Date
-- Days_Since_Previous_Order

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, O.Order_Date,
		   LAG(O.Order_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY O.Order_Date, O.Order_ID) AS Previous_Order_Date
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE O.Order_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Order_Date, Previous_Order_Date) AS Days_Since_Previous_Order
	FROM CTE
)
SELECT Customer_ID, Customer_Name, Order_Date, Previous_Order_Date, Days_Since_Previous_Order
FROM CTE2
WHERE Days_Since_Previous_Order <= 3;


-- ============================================================
-- Q5 — Customer Cohort Revenue Analysis
-- ============================================================
-- Group customers by their Signup Month.
-- Consider only completed orders with Paid payments.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Paying_Customers
-- Total_Paid_Revenue
-- Average_Paid_Revenue_Per_Paying_Customer

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
),
CTE2 AS (
	SELECT O.Customer_ID, P.Payment_Amount
    FROM Orders O
    INNER JOIN Payments P
		ON O.Order_ID = P.Order_ID
    WHERE O.Order_Status = 'Completed'
    AND P.Payment_Status = 'Paid'
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(DISTINCT O.Customer_ID) AS Paying_Customers,
       SUM(O.Payment_Amount) AS Total_Paid_Revenue,
       ROUND(SUM(O.Payment_Amount) / COUNT(DISTINCT O.Customer_ID), 2) AS Average_Paid_Revenue_Per_Paying_Customer
FROM CTE C
LEFT JOIN CTE2 O
	ON C.Customer_ID = O.Customer_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — Gap & Island
-- ============================================================
-- Find each customer's longest streak of consecutive
-- completed order dates.
--
-- Rules:
-- 1. Ignore cancelled orders.
-- 2. If a customer has multiple orders on the same date,
--    count that date only once.
-- 3. Consecutive means exactly 1 day apart.
-- 4. If there is a tie, choose the most recent streak.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Streak_Start
-- Streak_End
-- Streak_Length

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
           MIN(Order_Date) AS Streak_Start,
           MAX(Order_Date) AS Streak_End
	FROM CTE3
    GROUP BY Customer_ID, Customer_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Streak DESC, Streak_End DESC) AS Row_Num
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak AS Streak_Length,
	   Streak_Start, Streak_End
FROM CTE5
WHERE Row_Num = 1;


-- ============================================================
-- BONUS+ — Above-City-Average Revenue
-- ============================================================
-- Find customers whose total paid revenue is greater than
-- the average total paid revenue of customers in their city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Paid_Revenue
-- City_Average_Revenue

SELECT Customer_ID, Customer_Name, City, Total_Paid_Revenue, City_Average_Revenue
FROM (
	SELECT *,
		   ROUND(AVG(Total_Paid_Revenue) OVER(PARTITION BY City), 2) AS City_Average_Revenue
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(P.Payment_Amount) AS Total_Paid_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		INNER JOIN Payments P
			ON O.Order_ID = P.Order_ID
            AND P.Payment_Status = 'Paid'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)P
)A
WHERE Total_Paid_Revenue > City_Average_Revenue;


-- ============================================================
-- INTERVIEW CHALLENGE — Best Customer Per Category
-- ============================================================
-- For each Product_Category, find the customer(s) with the
-- highest total paid revenue in that category.
-- Include ties.
--
-- Return:
-- Product_Category
-- Customer_ID
-- Customer_Name
-- Total_Paid_Revenue
-- Revenue_Rank

SELECT Product_Category, Customer_ID, Customer_Name, Total_Paid_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Product_Category
           ORDER BY Total_Paid_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT O.Product_Category, C.Customer_ID, C.Customer_Name,
			   SUM(P.Payment_Amount) AS Total_Paid_Revenue
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		INNER JOIN Payments P
			ON O.Order_ID = P.Order_ID
            AND P.Payment_Status = 'Paid'
		GROUP BY O.Product_Category, C.Customer_ID, C.Customer_Name
	)D
)H
WHERE Revenue_Rank = 1;