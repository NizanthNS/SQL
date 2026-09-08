USE Daily_SQL;

-- ============================================================
-- DOMAIN: Food Analytics
-- ============================================================

-- ============================================================
-- CUSTOMERS
-- ============================================================

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Customers
VALUES	(1,  'Ethan',  'London',     '2026-01-05'),
		(2,  'Olivia', 'Paris',      '2026-01-09'),
		(3,  'Liam',   'Berlin',     '2026-01-15'),
		(4,  'Sophia', 'Toronto',    '2026-01-20'),
		(5,  'Noah',   'Amsterdam',  '2026-02-03'),
		(6,  'Emma',   'Madrid',     '2026-02-08'),
		(7,  'Lucas',  'London',     '2026-02-14'),
		(8,  'Chloe',  'Paris',      '2026-02-19'),
		(9,  'Henry',  'Berlin',     '2026-03-02'),
		(10, 'Grace',  'Toronto',    '2026-03-07'),
		(11, 'James',  'Amsterdam',  '2026-03-12'),
		(12, 'Mia',    'Madrid',     '2026-03-18');


-- ============================================================
-- FOOD ORDERS
-- ============================================================

CREATE TABLE Food_Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Restaurant_Name VARCHAR(50),
    Food_Category VARCHAR(50),
    Order_Date DATE,
    Order_Amount DECIMAL(10,2),
    Delivery_Minutes INT,
    Order_Status VARCHAR(20),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID)
);

INSERT INTO Food_Orders
VALUES	(101, 1, 'Burger House',  'Fast Food', '2026-03-01', 25.00, 30, 'Delivered'),
		(102, 1, 'Pizza Corner',  'Italian',   '2026-03-02', 40.00, 35, 'Delivered'),
		(103, 1, 'Sushi World',   'Japanese',  '2026-03-03', 55.00, 40, 'Delivered'),
		(104, 1, 'Burger House',  'Fast Food', '2026-03-05', 30.00, 32, 'Cancelled'),
		(105, 1, 'Pizza Corner',  'Italian',   '2026-03-06', 70.00, 45, 'Delivered'),
		(106, 2, 'Sushi World',   'Japanese',  '2026-03-01', 60.00, 38, 'Delivered'),
		(107, 2, 'Burger House',  'Fast Food', '2026-03-02', 35.00, 28, 'Delivered'),
		(108, 2, 'Pizza Corner',  'Italian',   '2026-03-04', 50.00, 36, 'Delivered'),
		(109, 2, 'Burger House',  'Fast Food', '2026-03-05', 45.00, 31, 'Cancelled'),
		(110, 2, 'Sushi World',   'Japanese',  '2026-03-07', 80.00, 42, 'Delivered'),
		(111, 3, 'Pizza Corner',  'Italian',   '2026-03-02', 30.00, 33, 'Delivered'),
		(112, 3, 'Pizza Corner',  'Italian',   '2026-03-03', 45.00, 35, 'Delivered'),
		(113, 3, 'Burger House',  'Fast Food', '2026-03-04', 55.00, 40, 'Cancelled'),
		(114, 3, 'Sushi World',   'Japanese',  '2026-03-05', 75.00, 44, 'Delivered'),
		(115, 3, 'Sushi World',   'Japanese',  '2026-03-06', 90.00, 48, 'Delivered'),
		(116, 4, 'Burger House',  'Fast Food', '2026-03-01', 28.00, 29, 'Delivered'),
		(117, 4, 'Pizza Corner',  'Italian',   '2026-03-03', 48.00, 37, 'Delivered'),
		(118, 4, 'Sushi World',   'Japanese',  '2026-03-04', 65.00, 41, 'Delivered'),
		(119, 4, 'Burger House',  'Fast Food', '2026-03-05', 38.00, 34, 'Delivered'),
		(120, 4, 'Pizza Corner',  'Italian',   '2026-03-06', 60.00, 39, 'Delivered'),
		(121, 5, 'Pizza Corner',  'Italian',   '2026-03-02', 35.00, 34, 'Delivered'),
		(122, 5, 'Sushi World',   'Japanese',  '2026-03-03', 65.00, 42, 'Delivered'),
		(123, 5, 'Burger House',  'Fast Food', '2026-03-04', 40.00, 30, 'Delivered'),
		(124, 5, 'Pizza Corner',  'Italian',   '2026-03-06', 50.00, 36, 'Delivered'),
		(125, 6, 'Burger House',  'Fast Food', '2026-03-03', 45.00, 31, 'Delivered'),
		(126, 6, 'Sushi World',   'Japanese',  '2026-03-04', 70.00, 43, 'Delivered'),
		(127, 6, 'Sushi World',   'Japanese',  '2026-03-05', 85.00, 47, 'Delivered'),
		(128, 6, 'Pizza Corner',  'Italian',   '2026-03-07', 40.00, 35, 'Delivered'),
		(129, 7, 'Burger House',  'Fast Food', '2026-03-01', 22.00, 27, 'Delivered'),
		(130, 7, 'Burger House',  'Fast Food', '2026-03-02', 32.00, 29, 'Delivered'),
		(131, 7, 'Pizza Corner',  'Italian',   '2026-03-03', 55.00, 36, 'Delivered'),
		(132, 7, 'Sushi World',   'Japanese',  '2026-03-04', 68.00, 40, 'Delivered'),
		(133, 7, 'Pizza Corner',  'Italian',   '2026-03-06', 75.00, 44, 'Delivered'),
		(134, 8, 'Pizza Corner',  'Italian',   '2026-03-02', 38.00, 35, 'Delivered'),
		(135, 8, 'Pizza Corner',  'Italian',   '2026-03-03', 52.00, 37, 'Delivered'),
		(136, 8, 'Burger House',  'Fast Food', '2026-03-04', 42.00, 31, 'Delivered'),
		(137, 8, 'Sushi World',   'Japanese',  '2026-03-05', 72.00, 43, 'Delivered'),
		(138, 8, 'Sushi World',   'Japanese',  '2026-03-06', 88.00, 46, 'Delivered'),
		(139, 9, 'Sushi World',   'Japanese',  '2026-03-03', 45.00, 37, 'Delivered'),
		(140, 9, 'Burger House',  'Fast Food', '2026-03-04', 30.00, 29, 'Delivered'),
		(141, 9, 'Pizza Corner',  'Italian',   '2026-03-05', 35.00, 34, 'Delivered'),
		(142, 9, 'Sushi World',   'Japanese',  '2026-03-07', 85.00, 45, 'Delivered'),
		(143, 10, 'Burger House',  'Fast Food', '2026-03-04', 28.00, 30, 'Delivered'),
		(144, 10, 'Pizza Corner',  'Italian',   '2026-03-05', 42.00, 35, 'Delivered'),
		(145, 10, 'Sushi World',   'Japanese',  '2026-03-06', 78.00, 44, 'Delivered'),
		(146, 10, 'Burger House',  'Fast Food', '2026-03-07', 36.00, 32, 'Delivered'),
		(147, 11, 'Pizza Corner',  'Italian',   '2026-03-05', 40.00, 36, 'Delivered'),
		(148, 11, 'Sushi World',   'Japanese',  '2026-03-06', 65.00, 41, 'Delivered'),
		(149, 11, 'Burger House',  'Fast Food', '2026-03-07', 35.00, 30, 'Delivered'),
		(150, 12, 'Burger House',  'Fast Food', '2026-03-06', 45.00, 33, 'Delivered'),
		(151, 12, 'Sushi World',   'Japanese',  '2026-03-07', 80.00, 42, 'Delivered');
        
        
SELECT *
FROM Customers;

SELECT *
FROM Food_Orders;


-- ============================================================
-- Q1
-- ============================================================

-- For each customer, find:
-- Total orders
-- Total delivered orders
-- Total delivered sales
-- Average delivered order amount
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Orders
-- Total_Delivered_Orders
-- Total_Delivered_Sales
-- Average_Delivered_Order_Amount

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(F.Order_ID) AS Total_Orders,
       COUNT(
       CASE
			WHEN F.Order_Status = 'Delivered' 
            THEN 1
       END) AS Total_Delivered_Orders,
       SUM(
       CASE
			WHEN F.Order_Status = 'Delivered' 
            THEN F.Order_Amount
            ELSE 0
       END) AS Total_Delivered_Sales,
       ROUND(AVG(
       CASE
			WHEN F.Order_Status = 'Delivered' 
            THEN F.Order_Amount
       END), 2) AS Average_Delivered_Order_Amount
FROM Customers C
INNER JOIN Food_Orders F
	ON C.Customer_ID = F.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- ============================================================
-- Q2
-- ============================================================

-- For each Food_Category, consider only Delivered orders.
--
-- Find:
-- Total orders
-- Total sales
-- Average delivery time
-- Unique customers
--
-- Return:
-- Food_Category
-- Total_Orders
-- Total_Sales
-- Average_Delivery_Minutes
-- Unique_Customers

SELECT Food_Category,
	   COUNT(Order_ID) AS Total_Orders,
       SUM(Order_Amount) AS Total_Sales,
       ROUND(AVG(Delivery_Minutes), 2) AS Average_Delivery_Minutes,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Food_Orders
WHERE Order_Status = 'Delivered'
GROUP BY Food_Category;


-- ============================================================
-- Q3
-- ============================================================

-- Find the top 3 customers in each city
-- based on Total Delivered Sales.
--
-- Include ties.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Delivered_Sales
-- Rank

WITH CTE AS (
	SELECT C.City, C.Customer_ID, C.Customer_Name,
		   SUM(F.Order_Amount) AS Total_Delivered_Sales
	FROM Customers C
	INNER JOIN Food_Orders F
		ON C.Customer_ID = F.Customer_ID
	WHERE F.Order_Status = 'Delivered'
	GROUP BY C.Customer_ID, C.Customer_Name
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Delivered_Sales DESC) AS D_Rank
	FROM CTE
)
SELECT City, Customer_ID, Customer_Name, Total_Delivered_Sales, D_Rank
FROM CTE2
WHERE D_Rank <= 3;


-- ============================================================
-- Q4
-- ============================================================

-- Find every Delivered order where the order amount
-- is greater than the customer's previous Delivered order.
--
-- Only Delivered orders should be compared.
--
-- Use LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Order_ID
-- Order_Date
-- Order_Amount
-- Previous_Order_Amount

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, F.Order_ID, F.Order_Date, F.Order_Amount,
		   LAG(F.Order_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY F.Order_Date, F.Order_ID) AS Previous_Order_Amount
	FROM Customers C
	INNER JOIN Food_Orders F
		ON C.Customer_ID = F.Customer_ID
	WHERE F.Order_Status = 'Delivered'
)
SELECT *
FROM CTE
WHERE Order_Amount > Previous_Order_Amount;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================

-- Group customers by Signup Month.
--
-- For each cohort, calculate:
-- Total customers
-- Total delivered orders
-- Total delivered sales
-- Average delivered order amount
--
-- IMPORTANT:
-- Total_Customers must include every customer
-- in the cohort, even if they have no Delivered orders.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Delivered_Orders
-- Total_Delivered_Sales
-- Average_Delivered_Order_Amount

WITH CTE AS (
	SELECT Customer_ID,
		   DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
	FROM Customers
),
CTE2 AS (
	SELECT *
    FROM Food_Orders
    WHERE Order_Status = 'Delivered'
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
	   COUNT(F.Order_ID) AS Total_Delivered_Orders,
       SUM(F.Order_Amount) AS Total_Delivered_Sales,
       ROUND(AVG(F.Order_Amount), 2) AS Average_Delivered_Order_Amount
FROM CTE C
LEFT JOIN CTE2 F
	ON C.Customer_ID = F.Customer_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================

-- For each customer, find their longest streak of
-- consecutive dates on which they placed Delivered orders.
--
-- Ignore duplicate orders on the same date.
--
-- Only Delivered orders count.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, F.Order_Date
    FROM Customers C
    INNER JOIN Food_Orders F
		ON C.Customer_ID = F.Customer_ID
	WHERE F.Order_Status = 'Delivered'
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

-- Find customers whose Total Delivered Sales
-- are greater than the average Total Delivered Sales
-- of customers in their city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Delivered_Sales
-- City_Average_Delivered_Sales

SELECT Customer_ID, Customer_Name, City, Total_Delivered_Sales, City_Average_Delivered_Sales
FROM (
	SELECT *,
		   ROUND(AVG(Total_Delivered_Sales) OVER(PARTITION BY City), 2) AS City_Average_Delivered_Sales
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(F.Order_Amount) AS Total_Delivered_Sales
		FROM Customers C
		INNER JOIN Food_Orders F
			ON C.Customer_ID = F.Customer_ID
		WHERE F.Order_Status = 'Delivered'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Delivered_Sales > City_Average_Delivered_Sales;


-- ============================================================
-- INTERVIEW CHALLENGE
-- ============================================================

-- For each Food_Category, find the customer
-- with the highest Total Delivered Sales.
--
-- Include ties.
--
-- Return:
-- Food_Category
-- Customer_ID
-- Customer_Name
-- Total_Delivered_Sales
-- Rank

SELECT Food_Category, Customer_ID, Customer_Name, Total_Delivered_Sales, D_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Food_Category
           ORDER BY Total_Delivered_Sales DESC) AS D_Rank
	FROM (
		SELECT F.Food_Category, C.Customer_ID, C.Customer_Name,
			   SUM(F.Order_Amount) AS Total_Delivered_Sales
		FROM Customers C
		INNER JOIN Food_Orders F
			ON C.Customer_ID = F.Customer_ID
		WHERE F.Order_Status = 'Delivered'
		GROUP BY F.Food_Category, C.Customer_ID, C.Customer_Name
	)D
)F
WHERE D_Rank = 1;