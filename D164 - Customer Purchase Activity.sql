USE Daily_SQL;

-- Customer Purchase Activity

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Customer_Purchases (
    Purchase_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_Category VARCHAR(50),
    Purchase_Date DATE,
    Purchase_Amount DECIMAL(10,2),
    Purchase_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Customers
VALUES	(1, 'Connor', 'London', '2025-01-10'),
		(2, 'Ash', 'Toronto', '2025-01-15'),
		(3, 'Ethan', 'Sydney', '2025-02-05'),
		(4, 'Liam', 'Berlin', '2025-02-20'),
		(5, 'Olivia', 'Paris', '2025-03-01'),
		(6, 'Mason', 'Toronto', '2025-03-12'),
		(7, 'Sophia', 'London', '2025-04-08'),
		(8, 'Noah', 'Berlin', '2025-04-18');

INSERT INTO Customer_Purchases
VALUES	(101, 1, 'Electronics', '2025-05-01', 850.00, 'Completed'),
		(102, 1, 'Clothing',    '2025-05-02', 120.00, 'Completed'),
		(103, 1, 'Books',       '2025-05-03',  45.00, 'Cancelled'),
		(104, 1, 'Electronics', '2025-05-05', 920.00, 'Completed'),

		(105, 2, 'Books',       '2025-05-01',  60.00, 'Completed'),
		(106, 2, 'Clothing',    '2025-05-02', 180.00, 'Completed'),
		(107, 2, 'Electronics', '2025-05-04', 700.00, 'Completed'),
		(108, 2, 'Books',       '2025-05-05',  80.00, 'Cancelled'),

		(109, 3, 'Electronics', '2025-05-10', 600.00, 'Completed'),
		(110, 3, 'Clothing',    '2025-05-11', 150.00, 'Completed'),
		(111, 3, 'Books',       '2025-05-12',  90.00, 'Completed'),
		(112, 3, 'Electronics', '2025-05-14', 750.00, 'Completed'),

		(113, 4, 'Books',       '2025-05-10',  55.00, 'Completed'),
		(114, 4, 'Clothing',    '2025-05-11', 210.00, 'Cancelled'),
		(115, 4, 'Electronics', '2025-05-12', 950.00, 'Completed'),
		(116, 4, 'Books',       '2025-05-14',  75.00, 'Completed'),

		(117, 5, 'Clothing',    '2025-06-01', 300.00, 'Completed'),
		(118, 5, 'Electronics', '2025-06-02', 800.00, 'Completed'),
		(119, 5, 'Books',       '2025-06-03',  65.00, 'Completed'),
		(120, 5, 'Clothing',    '2025-06-04', 350.00, 'Completed'),

		(121, 6, 'Electronics', '2025-06-01', 900.00, 'Completed'),
		(122, 6, 'Books',       '2025-06-02',  70.00, 'Completed'),
		(123, 6, 'Clothing',    '2025-06-04', 250.00, 'Completed'),
		(124, 6, 'Electronics', '2025-06-05', 950.00, 'Completed'),

		(125, 7, 'Books',       '2025-06-10',  50.00, 'Completed'),
		(126, 7, 'Clothing',    '2025-06-11', 275.00, 'Completed'),
		(127, 7, 'Electronics', '2025-06-12', 880.00, 'Completed'),
		(128, 7, 'Books',       '2025-06-14',  95.00, 'Completed'),

		(129, 8, 'Electronics', '2025-06-10', 700.00, 'Completed'),
		(130, 8, 'Clothing',    '2025-06-11', 220.00, 'Cancelled'),
		(131, 8, 'Books',       '2025-06-12',  85.00, 'Completed'),
		(132, 8, 'Electronics', '2025-06-14', 780.00, 'Completed');
        
SELECT *
FROM Customers;

SELECT *
FROM Customer_Purchases;


-- Q1
-- Show each customer's:
-- total purchases
-- total purchase amount
-- average purchase amount
-- total completed purchases.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Purchases
-- Total_Purchase_Amount
-- Average_Purchase_Amount
-- Total_Completed_Purchases

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(P.Purchase_ID) AS Total_Purchases,
       SUM(P.Purchase_Amount) AS Total_Purchase_Amount,
       ROUND(AVG(P.Purchase_Amount), 2) AS Average_Purchase_Amount,
       COUNT(
       CASE
		   WHEN Purchase_Status = 'Completed'
		   THEN 1
       END) AS Total_Completed_Purchases
FROM Customers C
INNER JOIN Customer_Purchases P
	ON C.Customer_ID = P.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each product category, find:
-- total purchases
-- total completed revenue
-- total cancelled purchases
-- unique customers.
--
-- Return:
-- Product_Category
-- Total_Purchases
-- Total_Completed_Revenue
-- Total_Cancelled_Purchases
-- Unique_Customers

SELECT Product_Category,
	   COUNT(Purchase_ID) AS Total_Purchases,
       SUM(
       CASE 
		   WHEN Purchase_Status = 'Completed'
		   THEN Purchase_Amount
           ELSE 0
       END) AS Total_Completed_Revenue,
       COUNT(
       CASE
		   WHEN Purchase_Status = 'Cancelled'
		   THEN 1
       END) AS Total_Cancelled_Purchases,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Customer_Purchases
GROUP BY Product_Category;


-- Q3
-- Find the top 3 customers in each city
-- based on total completed purchase amount.
--
-- If tied, return all tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Completed_Amount

SELECT City, Customer_ID, Customer_Name, Total_Completed_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Completed_Amount DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(
			   CASE 
				   WHEN Purchase_Status = 'Completed'
				   THEN Purchase_Amount
				   ELSE 0
			   END) AS Total_Completed_Amount
		FROM Customers C
		INNER JOIN Customer_Purchases P
			ON C.Customer_ID = P.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)T
)D
WHERE D_Rank <= 3;


-- Q4
-- Find purchases where the purchase amount
-- is greater than the customer's previous
-- completed purchase amount.
--
-- Only Completed purchases should be compared.
--
-- Use JOIN + LAG().
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
	INNER JOIN Customer_Purchases P
		ON C.Customer_ID = P.Customer_ID
	WHERE P.Purchase_Status = 'Completed'
)P
WHERE Purchase_Amount > Previous_Purchase_Amount;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
-- total completed purchases
-- total completed revenue
-- average completed purchase amount.
--
-- Definition:
-- Cohort Month = month in which the customer joined.
--
-- Only Completed purchases should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Completed_Purchases
-- Total_Completed_Revenue
-- Average_Completed_Purchase_Amount

WITH CTE AS (
	SELECT Customer_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Customers
),
CTE2 AS (
	SELECT *
    FROM Customer_Purchases
    WHERE Purchase_Status = 'Completed'
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(P.Purchase_ID) AS Total_Completed_Purchases,
       SUM(P.Purchase_Amount) AS Total_Completed_Revenue,
       ROUND(AVG(P.Purchase_Amount), 2) AS Average_Completed_Purchase_Amount
FROM CTE C
LEFT JOIN CTE2 P
	ON C.Customer_ID = P.Customer_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means having a Completed purchase
-- on consecutive dates.
--
-- Ignore duplicate purchase dates for the same customer.
-- Only Completed purchases count.
--
-- Find each customer's longest completed-purchase
-- date streak.
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
	INNER JOIN Customer_Purchases P
		ON C.Customer_ID = P.Customer_ID
	WHERE P.Purchase_Status = 'Completed'
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
-- Find customers whose total completed purchase amount
-- is greater than the average total completed purchase amount
-- of customers in the same city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Completed_Amount

SELECT Customer_ID, Customer_Name, City, Total_Completed_Amount
FROM (
	SELECT *,
		   AVG(Total_Completed_Amount) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(P.Purchase_Amount) AS Total_Completed_Amount
		FROM Customers C
		INNER JOIN Customer_Purchases P
			ON C.Customer_ID = P.Customer_ID
		WHERE P.Purchase_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Completed_Amount > Avg_City;


-- INTERVIEW CHALLENGE
-- For each product category, find the customer
-- with the highest total completed purchase amount
-- for that category.
--
-- If tied, return all tied customers.
--
-- Return:
-- Product_Category
-- Customer_ID
-- Customer_Name
-- Total_Completed_Amount

SELECT Product_Category, Customer_ID, Customer_Name, Total_Completed_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Product_Category
           ORDER BY Total_Completed_Amount DESC) AS D_Rank
	FROM (
		SELECT P.Product_Category, C.Customer_ID, C.Customer_Name,
			   SUM(P.Purchase_Amount) AS Total_Completed_Amount
		FROM Customers C
		INNER JOIN Customer_Purchases P
			ON C.Customer_ID = P.Customer_ID
		WHERE P.Purchase_Status = 'Completed'
		GROUP BY P.Product_Category, C.Customer_ID, C.Customer_Name
	)D
)H
WHERE D_Rank = 1;