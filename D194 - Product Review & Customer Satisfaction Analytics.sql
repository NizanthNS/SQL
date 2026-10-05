-- =========================================================
-- SESSION — Product Review & Customer Satisfaction Analytics
-- =========================================================

-- =========================================================
-- TABLE 1 — CUSTOMERS
-- =========================================================

USE Daily_SQL;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Daniel Carter', 'London', '2024-01-10'),
		(2, 'Sophia Bennett', 'Toronto', '2024-01-18'),
		(3, 'Liam Walker', 'Sydney', '2024-02-05'),
		(4, 'Emma Collins', 'Berlin', '2024-02-22'),
		(5, 'Noah Mitchell', 'Paris', '2024-03-12'),
		(6, 'Olivia Parker', 'London', '2024-03-28'),
		(7, 'Ethan Cooper', 'Toronto', '2024-04-08'),
		(8, 'Ava Richardson', 'Sydney', '2024-04-21'),
		(9, 'Henry Morgan', 'Berlin', '2024-05-06'),
		(10, 'Charlotte Foster', 'Paris', '2024-05-19'),
		(11, 'James Anderson', 'London', '2024-06-03'),
		(12, 'Mia Thompson', 'Toronto', '2024-06-17');


-- =========================================================
-- TABLE 2 — PURCHASES
-- =========================================================

CREATE TABLE Purchases (
    Purchase_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Purchase_Date DATE,
    Purchase_Status VARCHAR(20),
    Purchase_Amount DECIMAL(10,2),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID)
);

INSERT INTO Purchases 
VALUES	(1001, 1, 'Wireless Headphones', 'Electronics', '2024-01-20', 'Completed', 120.00),
		(1002, 1, 'Running Shoes',       'Sports',      '2024-02-25', 'Completed', 95.00),
		(1003, 1, 'Smart Watch',        'Electronics', '2024-04-10', 'Completed', 180.00),

		(1004, 2, 'Laptop Stand',       'Electronics', '2024-02-02', 'Completed', 75.00),
		(1005, 2, 'Yoga Mat',           'Sports',      '2024-03-18', 'Completed', 45.00),
		(1006, 2, 'Coffee Maker',       'Home',        '2024-05-05', 'Cancelled', 110.00),

		(1007, 3, 'Running Shoes',      'Sports',      '2024-02-18', 'Completed', 105.00),
		(1008, 3, 'Coffee Maker',       'Home',        '2024-03-30', 'Completed', 130.00),
		(1009, 3, 'Bluetooth Speaker',  'Electronics', '2024-05-12', 'Completed', 85.00),

		(1010, 4, 'Desk Lamp',          'Home',        '2024-03-01', 'Completed', 55.00),
		(1011, 4, 'Laptop Stand',       'Electronics', '2024-04-15', 'Completed', 70.00),
		(1012, 4, 'Office Chair',       'Home',        '2024-06-01', 'Cancelled', 220.00),

		(1013, 5, 'Coffee Maker',       'Home',        '2024-03-20', 'Completed', 125.00),
		(1014, 5, 'Running Shoes',      'Sports',      '2024-04-28', 'Completed', 115.00),
		(1015, 5, 'Smart Watch',        'Electronics', '2024-06-10', 'Completed', 175.00),

		(1016, 6, 'Wireless Headphones','Electronics', '2024-04-02', 'Completed', 135.00),
		(1017, 6, 'Yoga Mat',           'Sports',      '2024-05-20', 'Completed', 50.00),
		(1018, 6, 'Desk Lamp',          'Home',        '2024-07-05', 'Completed', 60.00),

		(1019, 7, 'Bluetooth Speaker',  'Electronics', '2024-04-15', 'Completed', 90.00),
		(1020, 7, 'Running Shoes',      'Sports',      '2024-05-25', 'Completed', 100.00),
		(1021, 7, 'Coffee Maker',       'Home',        '2024-07-10', 'Completed', 140.00),

		(1022, 8, 'Yoga Mat',           'Sports',      '2024-05-01', 'Completed', 48.00),
		(1023, 8, 'Smart Watch',        'Electronics', '2024-06-15', 'Completed', 190.00),
		(1024, 8, 'Desk Lamp',          'Home',        '2024-08-01', 'Completed', 65.00),

		(1025, 9, 'Office Chair',       'Home',        '2024-05-15', 'Completed', 210.00),
		(1026, 9, 'Laptop Stand',       'Electronics', '2024-06-25', 'Completed', 80.00),

		(1027, 10, 'Coffee Maker',      'Home',        '2024-06-05', 'Completed', 135.00),
		(1028, 10, 'Running Shoes',     'Sports',      '2024-07-20', 'Completed', 110.00),

		(1029, 11, 'Smart Watch',       'Electronics', '2024-06-20', 'Completed', 185.00),
		(1030, 11, 'Yoga Mat',          'Sports',      '2024-08-05', 'Completed', 52.00);


-- =========================================================
-- TABLE 3 — REVIEWS
-- =========================================================

CREATE TABLE Reviews (
    Review_ID INT PRIMARY KEY,
    Purchase_ID INT,
    Review_Date DATE,
    Rating INT,
    Review_Status VARCHAR(20),

    FOREIGN KEY (Purchase_ID)
        REFERENCES Purchases(Purchase_ID)
);

INSERT INTO Reviews
VALUES	(5001, 1001, '2024-01-23', 5, 'Published'),
		(5002, 1002, '2024-02-28', 4, 'Published'),
		(5003, 1003, '2024-04-14', 5, 'Published'),

		(5004, 1004, '2024-02-05', 4, 'Published'),
		(5005, 1005, '2024-03-22', 3, 'Published'),

		(5006, 1007, '2024-02-22', 5, 'Published'),
		(5007, 1008, '2024-04-03', 4, 'Published'),
		(5008, 1009, '2024-05-16', 2, 'Published'),

		(5009, 1010, '2024-03-05', 4, 'Published'),
		(5010, 1011, '2024-04-20', 5, 'Published'),

		(5011, 1013, '2024-03-25', 3, 'Published'),
		(5012, 1014, '2024-05-02', 4, 'Published'),
		(5013, 1015, '2024-06-14', 5, 'Published'),

		(5014, 1016, '2024-04-06', 5, 'Published'),
		(5015, 1017, '2024-05-25', 4, 'Published'),
		(5016, 1018, '2024-07-10', 3, 'Published'),

		(5017, 1019, '2024-04-18', 4, 'Published'),
		(5018, 1020, '2024-05-29', 5, 'Published'),
		(5019, 1021, '2024-07-14', 4, 'Published'),

		(5020, 1022, '2024-05-05', 5, 'Published'),
		(5021, 1023, '2024-06-20', 5, 'Published'),
		(5022, 1024, '2024-08-05', 4, 'Published'),

		(5023, 1025, '2024-05-20', 2, 'Published'),
		(5024, 1026, '2024-06-30', 4, 'Published'),

		(5025, 1027, '2024-06-10', 3, 'Published'),
		(5026, 1028, '2024-07-25', 5, 'Published'),

		(5027, 1029, '2024-06-25', 4, 'Published'),
		(5028, 1030, '2024-08-10', 5, 'Published');


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Customers;
SELECT * FROM Purchases;
SELECT * FROM Reviews;

-- =========================================================
-- Q1 — CUSTOMER PURCHASE & REVIEW SUMMARY
-- =========================================================

-- For every customer, calculate:
--
-- 1. Total completed purchases
-- 2. Total completed purchase amount
-- 3. Average completed purchase amount
-- 4. Highest completed purchase amount
-- 5. Number of published reviews
-- 6. Average published rating
--
-- Include customers even if they have no completed purchases.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Completed_Purchases
-- Total_Spent
-- Avg_Purchase_Amount
-- Highest_Purchase
-- Published_Reviews
-- Avg_Rating

SELECT C.Customer_ID, C.Customer_Name, C.City,
	   COUNT(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_ID
	   END) AS Completed_Purchases,
       COALESCE(SUM(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_Amount
            ELSE 0
	   END), 0) AS Total_Spent,
       COALESCE(ROUND(AVG(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_Amount
	   END), 2), 0) AS Avg_Purchase_Amount,
       COALESCE(MAX(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_Amount
	   END), 0) AS Highest_Purchase,
       COUNT(
       CASE
			WHEN R.Review_Status = 'Published'
            THEN R.Review_ID
	   END) AS Published_Reviews,
       COALESCE(ROUND(AVG(
       CASE
			WHEN R.Review_Status = 'Published'
            THEN R.Rating
	   END), 2), 0) AS Avg_Rating
FROM Customers C
LEFT JOIN Purchases P
	ON C.Customer_ID = P.Customer_ID
LEFT JOIN Reviews R
	ON P.Purchase_ID = R.Purchase_ID
GROUP BY C.Customer_ID, C.Customer_Name, C.City;


-- =========================================================
-- Q2 — CATEGORY PERFORMANCE & CUSTOMER SATISFACTION
-- =========================================================

-- For every product category, calculate:
--
-- 1. Number of distinct products purchased
-- 2. Total completed purchases
-- 3. Total completed revenue
-- 4. Average completed purchase amount
-- 5. Number of distinct customers with completed purchases
-- 6. Average published rating
--
-- IMPORTANT:
-- Only reviews belonging to completed purchases should
-- contribute to the category rating.
--
-- Return:
-- Category
-- Distinct_Products
-- Completed_Purchases
-- Total_Revenue
-- Avg_Purchase_Amount
-- Distinct_Customers
-- Avg_Rating

SELECT P.Category,
	   COUNT(DISTINCT
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Product_Name
	   END) AS Distinct_Products,
       COUNT(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_ID
	   END) AS Completed_Purchases,
       COALESCE(SUM(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_Amount
            ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_Amount
	   END), 2), 0) AS Avg_Purchase_Amount,
       COUNT(DISTINCT
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Customer_ID
	   END) AS Distinct_Customers,
       COALESCE(ROUND(AVG(
       CASE
			WHEN P.Purchase_Status = 'Completed' AND R.Review_Status = 'Published'
            THEN R.Rating
	   END), 2), 0) AS Avg_Rating
FROM Purchases P
LEFT JOIN Reviews R
	ON P.Purchase_ID = R.Purchase_ID
GROUP BY P.Category;


-- =========================================================
-- Q3 — TOP 2 CUSTOMERS PER CITY BY SPENDING
-- =========================================================

-- Find the top 2 customers in each city based on
-- total completed purchase amount.
--
-- Requirements:
-- - Completed purchases only
-- - Calculate customer-level revenue first
-- - Use DENSE_RANK()
-- - Include ties
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Spent
-- Spending_Rank

SELECT City, Customer_ID, Customer_Name, Total_Spent, Spending_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Spent DESC) AS Spending_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   COALESCE(SUM(P.Purchase_Amount), 0) AS Total_Spent
		FROM Customers C
		INNER JOIN Purchases P
			ON C.Customer_ID = P.Customer_ID
		WHERE P.Purchase_Status = 'Completed'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE Spending_Rank <= 2;
-- WHERE Spending_Rank BETWEEN 1 AND 2;


-- =========================================================
-- Q4 — CUSTOMER PURCHASE GAP ANALYSIS
-- =========================================================

-- For every customer, calculate the number of days between
-- their current completed purchase and previous completed
-- purchase.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Return ONLY purchases where the gap is greater than
-- 45 days.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Purchase_ID
-- Purchase_Date
-- Previous_Purchase_Date
-- Gap_Days

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, P.Purchase_ID, P.Purchase_Date, 
		   LAG(P.Purchase_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY P.Purchase_Date, P.Purchase_ID) AS Previous_Purchase_Date
	FROM Customers C
	INNER JOIN Purchases P
		ON C.Customer_ID = P.Customer_ID
	WHERE P.Purchase_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Purchase_Date, Previous_Purchase_Date) AS Gap_Days
    FROM CTE
)
SELECT Customer_ID, Customer_Name, Purchase_ID, Purchase_Date, Previous_Purchase_Date, Gap_Days
FROM CTE2
WHERE Previous_Purchase_Date IS NOT NULL
AND Gap_Days > 45;


-- =========================================================
-- Q5 — CUSTOMER COHORT ANALYSIS
-- =========================================================

-- Define each customer's cohort month as the month of their
-- FIRST completed purchase.
--
-- For each cohort month, calculate:
--
-- 1. Total customers in the cohort
-- 2. Active customers who completed at least one purchase
-- 3. Total completed purchases
-- 4. Total completed revenue
-- 5. Total published reviews
-- 6. Average completed revenue per active customer
--
-- Important:
-- Cohort membership must be based ONLY on the first
-- completed purchase.
--
-- Return:
-- Cohort_Month
-- Cohort_Customers
-- Active_Customers
-- Completed_Purchases
-- Total_Revenue
-- Published_Reviews
-- Avg_Revenue_Per_Active_Customer

WITH CTE AS (
	SELECT Customer_ID,
		   MIN(Purchase_Date) AS First_Purchase
	FROM Purchases
	WHERE Purchase_Status = 'Completed'
    GROUP BY Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Purchase, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Cohort_Customers,
       COUNT(DISTINCT
       CASE
			WHEN P.Purchase_ID IS NOT NULL AND P.Purchase_Status = 'Completed'
            THEN C.Customer_ID
	   END) AS Active_Customers,
	   COUNT(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_ID
	   END) AS Completed_Purchases,
       COALESCE(SUM(
       CASE
			WHEN P.Purchase_Status = 'Completed'
            THEN P.Purchase_Amount
            ELSE 0
	   END), 0) AS Total_Revenue,
       COUNT(
       CASE
			WHEN R.Review_Status = 'Published'
            THEN R.Review_ID
	   END) AS Published_Reviews,
       COALESCE(ROUND(SUM(
       CASE
		    WHEN P.Purchase_Status = 'Completed'
			THEN P.Purchase_Amount
			ELSE 0
	   END) / NULLIF(COUNT(DISTINCT
       CASE
			WHEN P.Purchase_ID IS NOT NULL AND P.Purchase_Status = 'Completed'
            THEN C.Customer_ID
	   END), 0), 2), 0) AS Avg_Revenue_Per_Active_Customer
FROM CTE2 C
LEFT JOIN Purchases P
	ON C.Customer_ID = P.Customer_ID
LEFT JOIN Reviews R
	ON P.Purchase_ID = R.Purchase_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- BONUS — GAP & ISLAND
-- =========================================================

-- Find each customer's longest consecutive monthly
-- completed-purchase streak.
--
-- Requirements:
-- - Completed purchases only
-- - A customer must have at least one completed purchase
--   in each consecutive month
-- - Use the classic:
--     DISTINCT entity/month
--     ROW_NUMBER()
--     DATE_SUB()
--     GROUP BY
--     ranking
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name,
		   CAST(DATE_FORMAT(P.Purchase_Date, '%Y-%m-01') AS DATE) AS Purchase_Month
	FROM Customers C
	INNER JOIN Purchases P
		ON C.Customer_ID = P.Customer_ID
	WHERE P.Purchase_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Purchase_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Purchase_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Purchase_Month) AS Streak_Start_Month,
           MAX(Purchase_Month) AS Streak_End_Month
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
-- BONUS+ — ABOVE CITY AVERAGE
-- =========================================================

-- Find customers whose total completed spending is greater
-- than the average customer spending in their city.
--
-- Requirements:
-- - Completed purchases only
-- - Calculate spending per customer first
-- - Use a window function for the city average
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Spent
-- City_Avg_Spent

SELECT City, Customer_ID, Customer_Name, Total_Spent, City_Avg_Spent
FROM (
	SELECT *,
		   ROUND(Exact_Avg, 2) AS City_Avg_Spent
    FROM (
		SELECT *,
			   AVG(Total_Spent) OVER(PARTITION BY City) AS Exact_Avg
		FROM (
			SELECT C.Customer_ID, C.Customer_Name, C.City,
				   COALESCE(SUM(P.Purchase_Amount), 0) AS Total_Spent
			FROM Customers C
			INNER JOIN Purchases P
				ON C.Customer_ID = P.Customer_ID
			WHERE P.Purchase_Status = 'Completed'
			GROUP BY C.Customer_ID, C.Customer_Name, C.City
		)C
	)A
)E
WHERE Total_Spent > Exact_Avg;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================

-- For each category, find the product(s) with the highest
-- total completed purchase revenue.
--
-- Requirements:
-- - Completed purchases only
-- - Calculate product-level revenue first
-- - Use DENSE_RANK()
-- - Include ties
--
-- Return:
-- Category
-- Product_Name
-- Total_Revenue
-- Revenue_Rank

SELECT Category, Product_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Category
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT Category, Product_Name,
			   COALESCE(SUM(Purchase_Amount), 0) AS Total_Revenue
		FROM Purchases 
		WHERE Purchase_Status = 'Completed'
		GROUP BY Category, Product_Name
	)C
)P
WHERE Revenue_Rank = 1;