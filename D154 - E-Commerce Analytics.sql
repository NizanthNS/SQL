USE Daily_SQl;

-- E-Commerce Analytics

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Product_Category VARCHAR(50),
    Order_Status VARCHAR(30),
    Order_Amount DECIMAL(10,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Customers
VALUES	(1, 'Arun',   'Chennai',   '2025-01-10'),
		(2, 'Bala',   'Chennai',   '2025-02-15'),
		(3, 'Cathy',  'Bangalore', '2025-01-20'),
		(4, 'Divya',  'Bangalore', '2025-03-05'),
		(5, 'Eshan',  'Mumbai',    '2025-02-25'),
		(6, 'Farah',  'Mumbai',    '2025-04-10'),
		(7, 'Gokul',  'Chennai',   '2025-03-18'),
		(8, 'Hema',   'Bangalore', '2025-04-22');

INSERT INTO Orders
VALUES	(101, 1, '2025-05-01', 'Electronics', 'Delivered', 1200.00),
		(102, 1, '2025-05-02', 'Books',       'Delivered',  500.00),
		(103, 1, '2025-05-04', 'Electronics', 'Cancelled',  800.00),

		(104, 2, '2025-05-01', 'Clothing',    'Delivered',  700.00),
		(105, 2, '2025-05-03', 'Electronics', 'Delivered', 1500.00),

		(106, 3, '2025-05-01', 'Books',       'Delivered',  400.00),
		(107, 3, '2025-05-02', 'Books',       'Delivered',  600.00),
		(108, 3, '2025-05-03', 'Electronics', 'Delivered', 1800.00),
		(109, 3, '2025-05-06', 'Clothing',    'Cancelled',  900.00),

		(110, 4, '2025-05-02', 'Electronics', 'Delivered', 2000.00),
		(111, 4, '2025-05-05', 'Clothing',    'Delivered',  900.00),

		(112, 5, '2025-05-01', 'Books',       'Delivered',  550.00),
		(113, 5, '2025-05-02', 'Electronics', 'Cancelled', 1300.00),
		(114, 5, '2025-05-03', 'Clothing',    'Delivered',  750.00),

		(115, 6, '2025-05-04', 'Electronics', 'Delivered', 1100.00),

		(116, 7, '2025-05-01', 'Clothing',    'Delivered',  600.00),
		(117, 7, '2025-05-02', 'Clothing',    'Delivered',  800.00),
		(118, 7, '2025-05-03', 'Books',       'Delivered',  450.00),
		(119, 7, '2025-05-05', 'Electronics', 'Delivered', 1600.00),

		(120, 8, '2025-05-01', 'Books',       'Cancelled',  500.00),
		(121, 8, '2025-05-02', 'Electronics', 'Delivered', 1400.00);
        
SELECT *
FROM Customers;

SELECT *
FROM Orders;

-- Q1
-- Show each customer's:
-- total orders
-- total delivered orders
-- total delivered amount
-- average delivered order amount
-- total cancelled orders.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Orders
-- Total_Delivered_Orders
-- Total_Delivered_Amount
-- Average_Delivered_Order_Amount
-- Total_Cancelled_Orders

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(O.Order_ID) AS Total_Orders,
       COUNT(CASE 
				WHEN O.Order_Status = 'Delivered'
                THEN 1
	   END) AS Total_Delivered_Orders,
       SUM(CASE 
				WHEN O.Order_Status = 'Delivered'
				THEN O.Order_Amount
                ELSE 0
	   END) AS Total_Delivered_Amount,
       ROUND(AVG(CASE 
				WHEN O.Order_Status = 'Delivered'
				THEN O.Order_Amount
	   END), 2) AS Average_Delivered_Order_Amount,
       COUNT(CASE
				WHEN O.Order_Status = 'Cancelled' THEN 1
       END) AS Total_Cancelled_Orders
FROM Customers C
INNER JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each product category, find:
-- total orders
-- total delivered revenue
-- total cancelled orders
-- unique customers.
--
-- Return:
-- Product_Category
-- Total_Orders
-- Total_Delivered_Revenue
-- Total_Cancelled_Orders
-- Unique_Customers

SELECT Product_Category,
	   COUNT(Order_ID) AS Total_Orders,
       SUM(CASE 
				WHEN Order_Status = 'Delivered'
				THEN Order_Amount
                ELSE 0
	   END) AS Total_Delivered_Revenue,
       COUNT(CASE
				WHEN Order_Status = 'Cancelled' THEN 1
       END) AS Total_Cancelled_Orders,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Orders
GROUP BY Product_Category;


-- Q3
-- Find the top 3 customers in each city
-- based on total delivered amount.
--
-- If tied, return all tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Delivered_Amount

SELECT City, Customer_ID, Customer_Name, Total_Delivered_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Delivered_Amount DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(CASE 
						WHEN O.Order_Status = 'Delivered'
						THEN O.Order_Amount
						ELSE 0
			   END) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find orders where the order amount is greater
-- than the customer's previous order amount.
--
-- Only compare Delivered orders.
--
-- Use LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Order_Date
-- Order_Amount
-- Previous_Order_Amount

SELECT *
FROM (
	SELECT C.Customer_ID, C.Customer_Name, O.Order_Date, O.Order_Amount,
		   LAG(O.Order_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY O.Order_Date, O.Order_ID) AS Previous_Order_Amount
	FROM Customers C
	INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
	WHERE Order_Status = 'Delivered'
)P
WHERE Order_Amount > Previous_Order_Amount;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
-- total delivered orders
-- total delivered revenue
-- average delivered order amount.
--
-- Definition:
-- Cohort Month = month in which the customer joined.
--
-- Only Delivered orders should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Delivered_Orders
-- Total_Delivered_Revenue
-- Average_Delivered_Order_Amount

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(O.Order_ID) AS Total_Delivered_Orders,
       SUM(O.Order_Amount) AS Total_Delivered_Revenue,
       ROUND(AVG(O.Order_Amount), 2) AS Average_Delivered_Order_Amount
FROM CTE C
INNER JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
WHERE Order_Status = 'Delivered'
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each customer's longest consecutive
-- delivered-order date streak.
--
-- Ignore duplicate order dates.
--
-- If multiple streaks have the same length,
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
	WHERE Order_Status = 'Delivered'
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


-- BONUS+
-- Find customers whose total delivered amount
-- is greater than the average total delivered amount
-- of customers in the same city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Delivered_Amount

SELECT Customer_ID, Customer_Name, City, Total_Delivered_Amount
FROM (
	SELECT *,
		   AVG(Total_Delivered_Amount) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(O.Order_Amount) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Delivered'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)D
)A
WHERE Total_Delivered_Amount > Avg_City;


-- INTERVIEW CHALLENGE
-- For each product category, find the customer
-- with the highest total delivered amount
-- in that category.
--
-- If tied, return all tied customers.
--
-- Return:
-- Product_Category
-- Customer_ID
-- Customer_Name
-- Total_Delivered_Amount

SELECT Product_Category, Customer_ID, Customer_Name, Total_Delivered_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Product_Category
           ORDER BY Total_Delivered_Amount DESC) AS D_Rank
	FROM (
		SELECT O.Product_Category, C.Customer_ID, C.Customer_Name,
			   SUM(O.Order_Amount) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		WHERE Order_Status = 'Delivered'
		GROUP BY O.Product_Category, C.Customer_ID, C.Customer_Name
	)D
)T
WHERE D_Rank = 1;