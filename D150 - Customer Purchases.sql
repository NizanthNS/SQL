USE Daily_SQL;

-- DATASET : Customer Purchases

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Purchases (
    Purchase_ID INT PRIMARY KEY,
    Customer_ID INT,
    Purchase_Date DATE,
    Product_Category VARCHAR(50),
    Purchase_Amount DECIMAL(10,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Customers
VALUES	(1, 'Arun', 'Chennai', '2025-01-10'),
		(2, 'Bala', 'Chennai', '2025-02-15'),
		(3, 'Kiran', 'Madurai', '2025-01-20'),
		(4, 'Vijay', 'Madurai', '2025-03-05'),
		(5, 'Rahul', 'Coimbatore', '2025-02-25'),
		(6, 'Suresh', 'Coimbatore', '2025-01-15');

INSERT INTO Purchases
VALUES	(101, 1, '2025-03-01', 'Electronics', 5000),
		(102, 1, '2025-03-02', 'Clothing', 2000),
		(103, 1, '2025-03-03', 'Electronics', 3000),
		(104, 1, '2025-03-10', 'Groceries', 1500),

		(105, 2, '2025-03-01', 'Clothing', 2500),
		(106, 2, '2025-03-04', 'Electronics', 4000),
		(107, 2, '2025-03-05', 'Groceries', 1800),

		(108, 3, '2025-03-01', 'Electronics', 6000),
		(109, 3, '2025-03-02', 'Electronics', 2000),
		(110, 3, '2025-03-05', 'Clothing', 3500),

		(111, 4, '2025-03-10', 'Groceries', 1200),
		(112, 4, '2025-03-11', 'Groceries', 1800),
		(113, 4, '2025-03-12', 'Electronics', 5000),

		(114, 5, '2025-03-02', 'Clothing', 3000),
		(115, 5, '2025-03-08', 'Electronics', 4500),
		(116, 5, '2025-03-09', 'Clothing', 2000),

		(117, 6, '2025-03-01', 'Groceries', 1000),
		(118, 6, '2025-03-02', 'Groceries', 1500),
		(119, 6, '2025-03-03', 'Groceries', 2000),
		(120, 6, '2025-03-04', 'Electronics', 4000);
        
SELECT *
FROM Customers;

SELECT *
FROM Purchases;

-- Q1
-- Show each customer's:
-- total purchases
-- total purchase amount
-- average purchase amount
-- number of different product categories purchased.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Purchases
-- Total_Purchase_Amount
-- Average_Purchase_Amount
-- Total_Categories

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(P.Purchase_ID) AS Total_Purchases,
       SUM(P.Purchase_Amount) AS Total_Purchase_Amount,
       ROUND(AVG(P.Purchase_Amount), 2) AS Average_Purchase_Amount,
       COUNT(DISTINCT Product_Category) AS Total_Categories
FROM Customers C
INNER JOIN Purchases P
	ON C.Customer_ID = P.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each product category, find:
-- total revenue
-- average purchase amount
-- number of unique customers.
--
-- Return:
-- Product_Category
-- Total_Revenue
-- Average_Purchase_Amount
-- Unique_Customers

SELECT Product_Category,
       SUM(Purchase_Amount) AS Total_Revenue,
       ROUND(AVG(Purchase_Amount), 2) AS Average_Purchase_Amount,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Purchases
GROUP BY Product_Category;


-- Q3
-- Find the top 3 customers in each city
-- based on total purchase amount.
--
-- If tied, return all tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Purchase_Amount

SELECT City, Customer_ID, Customer_Name, Total_Purchase_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Purchase_Amount DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(P.Purchase_Amount) AS Total_Purchase_Amount
		FROM Customers C
		INNER JOIN Purchases P
			ON C.Customer_ID = P.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)T
)D
WHERE D_Rank <= 3;


-- Q4
-- Find customers whose purchase amount increased
-- compared with their previous purchase.
--
-- Use LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Purchase_Date
-- Purchase_Amount
-- Previous_Purchase_Amount

SELECT *
FROM (
	SELECT C.Customer_ID, C.Customer_Name, P.Purchase_Date, P.Purchase_Amount,
		   LAG(P.Purchase_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY P.Purchase_Date, P.Purchase_ID) AS Previous_Purchase_Amount
	FROM Customers C
	INNER JOIN Purchases P
		ON C.Customer_ID = P.Customer_ID
)P
WHERE Purchase_Amount > Previous_Purchase_Amount;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
-- total purchase revenue
-- average purchase amount.
--
-- Definition:
-- Cohort Month = month in which the customer joined.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Purchase_Revenue
-- Average_Purchase_Amount

WITH CTE AS (
	SELECT Customer_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Customers
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       SUM(P.Purchase_Amount) AS Total_Purchase_Revenue,
       ROUND(AVG(P.Purchase_Amount), 2) AS Average_Purchase_Amount
FROM CTE C
INNER JOIN Purchases P
	ON C.Customer_ID = P.Customer_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each customer's longest consecutive
-- purchase-date streak.
--
-- Ignore duplicate purchase dates.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, P.Purchase_Date
	FROM Customers C
	INNER JOIN Purchases P
		ON C.Customer_ID = P.Customer_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Purchase_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Purchase_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
		   MIN(Purchase_Date) AS Start_Date,
           MAX(Purchase_Date) AS End_Date
	FROM CTE3
    GROUP BY Customer_ID, Customer_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Streak DESC, End_Date DESC) AS  Row_Num
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find customers whose total purchase amount
-- is greater than the average total purchase amount
-- of customers in their city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Purchase_Amount

SELECT Customer_ID, Customer_Name, City, Total_Purchase_Amount
FROM (
	SELECT *,
		   AVG(Total_Purchase_Amount) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(P.Purchase_Amount) AS Total_Purchase_Amount
		FROM Customers C
		INNER JOIN Purchases P
			ON C.Customer_ID = P.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Purchase_Amount > Avg_City;


-- INTERVIEW CHALLENGE
-- For each product category, find the customer
-- who purchased the highest total amount in that category.
--
-- If tied, return all tied customers.
--
-- Return:
-- Product_Category
-- Customer_ID
-- Customer_Name
-- Total_Purchase_Amount

SELECT Product_Category, Customer_ID, Customer_Name, Total_Purchase_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Product_Category
           ORDER BY Total_Purchase_Amount DESC) AS D_Rank
	FROM (
		SELECT P.Product_Category, C.Customer_ID, C.Customer_Name,
			   SUM(P.Purchase_Amount) AS Total_Purchase_Amount
		FROM Customers C
		INNER JOIN Purchases P
			ON C.Customer_ID = P.Customer_ID
		GROUP BY P.Product_Category, C.Customer_ID, C.Customer_Name
	)D
)H
WHERE D_Rank = 1;