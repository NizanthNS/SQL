USE Daily_SQL;

-- ============================================================
-- SESSION — Product Sales & Inventory Analytics
-- ============================================================

-- ============================================================
-- TABLE 1 — PRODUCTS
-- ============================================================

CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Warehouse_City VARCHAR(50),
    Launch_Date DATE
);

INSERT INTO Products
VALUES	(1, 'Laptop Pro 14', 'Electronics', 'London', '2024-01-10'),
		(2, 'Wireless Mouse', 'Electronics', 'Toronto', '2024-02-15'),
		(3, 'Mechanical Keyboard', 'Electronics', 'Berlin', '2024-03-05'),
		(4, 'Noise Cancelling Headphones', 'Electronics', 'Sydney', '2024-03-20'),
		(5, 'Smart Watch', 'Wearables', 'Paris', '2024-04-02'),
		(6, 'Fitness Tracker', 'Wearables', 'Toronto', '2024-04-18'),
		(7, 'Running Shoes', 'Sports', 'London', '2024-05-06'),
		(8, 'Yoga Mat', 'Sports', 'Berlin', '2024-05-22');


-- ============================================================
-- TABLE 2 — SALES
-- ============================================================

CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Product_ID INT,
    Sale_Date DATE,
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Sale_Status VARCHAR(20),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

INSERT INTO Sales
VALUES	(101, 1, '2025-01-05', 2, 1200, 'Completed'),
		(102, 1, '2025-02-05', 1, 1200, 'Completed'),
		(103, 1, '2025-03-05', 3, 1150, 'Completed'),
		(104, 1, '2025-03-20', 1, 1150, 'Cancelled'),
		(105, 1, '2025-05-05', 2, 1100, 'Completed'),

		(106, 2, '2025-01-10', 5, 30, 'Completed'),
		(107, 2, '2025-02-10', 3, 30, 'Completed'),
		(108, 2, '2025-03-10', 4, 28, 'Cancelled'),
		(109, 2, '2025-04-10', 6, 28, 'Completed'),
		(110, 2, '2025-05-10', 2, 28, 'Completed'),

		(111, 3, '2025-01-15', 4, 80, 'Completed'),
		(112, 3, '2025-02-15', 5, 80, 'Completed'),
		(113, 3, '2025-03-15', 2, 75, 'Completed'),
		(114, 3, '2025-04-15', 6, 75, 'Completed'),
		(115, 3, '2025-05-15', 3, 75, 'Completed'),

		(116, 4, '2025-01-20', 2, 150, 'Completed'),
		(117, 4, '2025-02-20', 3, 150, 'Completed'),
		(118, 4, '2025-03-20', 1, 145, 'Cancelled'),
		(119, 4, '2025-04-20', 4, 145, 'Completed'),
		(120, 4, '2025-05-20', 2, 140, 'Completed'),

		(121, 5, '2025-01-25', 3, 200, 'Completed'),
		(122, 5, '2025-02-25', 2, 200, 'Completed'),
		(123, 5, '2025-03-25', 5, 190, 'Completed'),
		(124, 5, '2025-04-25', 2, 190, 'Cancelled'),
		(125, 5, '2025-05-25', 4, 185, 'Completed'),

		(126, 6, '2025-02-05', 4, 100, 'Completed'),
		(127, 6, '2025-03-05', 3, 100, 'Completed'),
		(128, 6, '2025-04-05', 5, 95, 'Completed'),
		(129, 6, '2025-05-05', 2, 95, 'Cancelled'),

		(130, 7, '2025-01-12', 3, 90, 'Completed'),
		(131, 7, '2025-02-12', 2, 90, 'Completed'),
		(132, 7, '2025-03-12', 4, 85, 'Completed'),
		(133, 7, '2025-04-12', 5, 85, 'Completed'),
		(134, 7, '2025-05-12', 2, 80, 'Completed'),

		(135, 8, '2025-01-18', 5, 25, 'Completed'),
		(136, 8, '2025-02-18', 4, 25, 'Completed'),
		(137, 8, '2025-03-18', 6, 25, 'Cancelled'),
		(138, 8, '2025-04-18', 3, 22, 'Completed'),
		(139, 8, '2025-05-18', 7, 22, 'Completed');


SELECT *
FROM Products;

SELECT *
FROM Sales;


-- ============================================================
-- Q1 — PRODUCT SALES SUMMARY
-- ============================================================
-- For every product, calculate:
--
-- 1. Total sales records
-- 2. Completed sales records
-- 3. Total completed quantity
-- 4. Total completed revenue
-- 5. Average completed sale value
--
-- Include products with no sales.
--
-- Return:
-- Product_ID
-- Product_Name
-- Category
-- Total_Sales_Records
-- Completed_Sales_Records
-- Total_Completed_Quantity
-- Total_Completed_Revenue
-- Average_Completed_Sale_Value

SELECT P.Product_ID, P.Product_Name, P.Category,
	   COUNT(S.Sale_ID) AS Total_Sales_Records,
       COUNT(
       CASE
			WHEN S.Sale_Status = 'Completed'
            THEN 1
       END) AS Completed_Sales_Records,
       SUM(
       CASE
			WHEN S.Sale_Status = 'Completed'
            THEN S.Quantity
            ELSE 0
       END) AS Total_Completed_Quantity,
       SUM(
       CASE
			WHEN S.Sale_Status = 'Completed'
            THEN S.Unit_Price * S.Quantity
            ELSE 0
       END) AS Total_Completed_Revenue,
       ROUND(AVG(
       CASE
			WHEN S.Sale_Status = 'Completed'
            THEN S.Unit_Price * S.Quantity
       END), 2) AS Average_Completed_Sale_Value
FROM Products P
LEFT JOIN Sales S
	ON P.Product_ID = S.Product_ID
GROUP BY P.Product_ID, P.Product_Name, P.Category;



-- ============================================================
-- Q2 — CATEGORY PERFORMANCE
-- ============================================================
-- For each category calculate:
--
-- 1. Total completed quantity
-- 2. Total completed revenue
-- 3. Average selling price
-- 4. Unique products sold
-- 5. Revenue contribution percentage within
--    the entire dataset
--
-- Revenue contribution =
-- Category Completed Revenue / Overall Completed Revenue * 100
--
-- Return:
-- Category
-- Total_Completed_Quantity
-- Total_Completed_Revenue
-- Average_Selling_Price
-- Unique_Products
-- Revenue_Contribution_Percentage

WITH CTE AS (
	SELECT P.Category,
		   SUM(
		   CASE
				WHEN S.Sale_Status = 'Completed'
				THEN S.Quantity
				ELSE 0
		   END) AS Total_Completed_Quantity,
		   SUM(
		   CASE
				WHEN S.Sale_Status = 'Completed'
				THEN S.Unit_Price * S.Quantity
				ELSE 0
		   END) AS Total_Completed_Revenue,
		   ROUND(AVG(
           CASE
				WHEN S.Sale_Status = 'Completed'
				THEN S.Unit_Price
		   END), 2) AS Average_Selling_Price,
		   COUNT(DISTINCT S.Product_ID) AS Unique_Products
	FROM Products P
	LEFT JOIN Sales S
		ON P.Product_ID = S.Product_ID
	GROUP BY P.Category
)
SELECT *,
	   ROUND(Total_Completed_Revenue / SUM(Total_Completed_Revenue) OVER() * 100, 2) AS Revenue_Contribution_Percentage
FROM CTE;


-- ============================================================
-- Q3 — TOP 2 PRODUCTS PER WAREHOUSE CITY
-- ============================================================
-- Find the top 2 products in each warehouse city
-- based on Total Completed Revenue.
--
-- Ties must be included.
--
-- Requirements:
-- 1. Calculate product-level completed revenue.
-- 2. Rank products within each city.
-- 3. Use DENSE_RANK().
-- 4. Return ranks 1 and 2.
--
-- Return:
-- Product_ID
-- Product_Name
-- Warehouse_City
-- Total_Completed_Revenue
-- Revenue_Rank

SELECT Product_ID, Product_Name, Warehouse_City, Total_Completed_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Warehouse_City
           ORDER BY Total_Completed_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT P.Product_ID, P.Product_Name, P.Warehouse_City,
			   SUM(S.Unit_Price * S.Quantity) AS Total_Completed_Revenue
		FROM Products P
		INNER JOIN Sales S
			ON P.Product_ID = S.Product_ID
		WHERE S.Sale_Status = 'Completed'
		GROUP BY P.Product_ID, P.Product_Name, P.Warehouse_City
	)W
)D
WHERE Revenue_Rank <= 2;


-- ============================================================
-- Q4 — SALES REPEAT DATE LOGIC
-- ============================================================
-- Find products that had another COMPLETED sale
-- within 30 days of their previous COMPLETED sale.
--
-- Rules:
-- 1. Ignore Cancelled sales.
-- 2. Compare each sale with the previous completed
--    sale for the same product.
-- 3. Use LAG().
-- 4. Calculate the number of days between sales.
-- 5. Return only differences <= 30 days.
--
-- Return:
-- Product_ID
-- Product_Name
-- Sale_Date
-- Previous_Sale_Date
-- Days_Between_Sales

WITH CTE AS (
	SELECT P.Product_ID, P.Product_Name, S.Sale_Date,
		   LAG(S.Sale_Date) OVER(PARTITION BY Product_ID
           ORDER BY S.Sale_Date, S.Sale_ID) AS Previous_Sale_Date
	FROM Products P
	INNER JOIN Sales S
		ON P.Product_ID = S.Product_ID
	WHERE S.Sale_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Sale_Date, Previous_Sale_Date) AS Days_Between_Sales
	FROM CTE
)
SELECT Product_ID, Product_Name, Sale_Date, Previous_Sale_Date, Days_Between_Sales
FROM CTE2
WHERE Days_Between_Sales <= 30;


-- ============================================================
-- Q5 — PRODUCT COHORT ANALYSIS 🔥
-- ============================================================
-- Group products by their Launch Month.
--
-- For each cohort calculate:
--
-- 1. Total products
-- 2. Products with completed sales
-- 3. Total completed quantity
-- 4. Total completed revenue
-- 5. Average completed revenue per selling product
--
-- Average completed revenue =
-- Total Completed Revenue /
-- Number of products with completed sales
--
-- Return:
-- Cohort_Month
-- Total_Products
-- Selling_Products
-- Total_Completed_Quantity
-- Total_Completed_Revenue
-- Average_Completed_Revenue_Per_Selling_Product

WITH CTE AS (
    SELECT Product_ID,
           DATE_FORMAT(Launch_Date, '%Y-%m') AS Cohort_Month
    FROM Products
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Product_ID) AS Total_Products,
       COUNT(DISTINCT
       CASE
			WHEN S.Sale_Status = 'Completed'
            THEN C.Product_ID
       END) AS Selling_Products,
       SUM(
		   CASE
				WHEN S.Sale_Status = 'Completed'
				THEN S.Quantity
				ELSE 0
		   END) AS Total_Completed_Quantity,
	   SUM(
	   CASE
			WHEN S.Sale_Status = 'Completed'
			THEN S.Unit_Price * S.Quantity
			ELSE 0
	   END) AS Total_Completed_Revenue,
       ROUND(
       SUM(
	   CASE
			WHEN S.Sale_Status = 'Completed'
			THEN S.Unit_Price * S.Quantity
			ELSE 0
	   END) / COUNT(DISTINCT
       CASE
			WHEN S.Sale_Status = 'Completed'
            THEN C.Product_ID
       END), 2) AS Average_Completed_Revenue_Per_Selling_Product
FROM CTE C
LEFT JOIN Sales S
	ON C.Product_ID = S.Product_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND 🔥
-- ============================================================
-- Find each product's longest consecutive MONTHLY
-- completed-sales streak.
--
-- Rules:
-- 1. Only Completed sales.
-- 2. Multiple sales in the same month count once.
-- 3. Consecutive months form a streak.
-- 4. Find the longest streak per product.
-- 5. If tied, choose the most recent streak.
--
-- Return:
-- Product_ID
-- Product_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT P.Product_ID, P.Product_Name, S.Sale_Date,
		   DATE_FORMAT(S.Sale_Date, '%Y-%m-01') AS Sale_Month
	FROM Products P
	INNER JOIN Sales S
		ON P.Product_ID = S.Product_ID
	WHERE S.Sale_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Product_ID
           ORDER BY Sale_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Sale_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Product_ID, Product_Name,
		   COUNT(*) AS Streak,
           MIN(Sale_Month) AS Streak_Start_Month,
           MAX(Sale_Month) AS Streak_End_Month
	FROM CTE3
    GROUP BY Product_ID, Product_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Product_ID
           ORDER BY Streak DESC, Streak_End_Month DESC) AS Row_Num
	FROM CTE4
)
SELECT Product_ID, Product_Name, Streak_Start_Month, Streak_End_Month, Streak AS Streak_Months
FROM CTE5
WHERE Row_Num = 1;


-- ============================================================
-- BONUS+ — ABOVE-CATEGORY-AVERAGE REVENUE
-- ============================================================
-- Calculate each product's total completed revenue.
--
-- Then calculate the average completed revenue
-- for its category using a window function.
--
-- Return only products whose:
--
-- Total_Completed_Revenue >
-- Category_Average_Completed_Revenue
--
-- Return:
-- Product_ID
-- Product_Name
-- Category
-- Total_Completed_Revenue
-- Category_Average_Completed_Revenue

SELECT Product_ID, Product_Name, Category, Total_Completed_Revenue, Category_Average_Completed_Revenue
FROM (
	SELECT *,
		   ROUND(AVG(Total_Completed_Revenue) OVER(PARTITION BY Category), 2) AS Category_Average_Completed_Revenue
	FROM (
		SELECT P.Product_ID, P.Product_Name, P.Category,
			   SUM(S.Unit_Price * S.Quantity) AS Total_Completed_Revenue
		FROM Products P
		INNER JOIN Sales S
			ON P.Product_ID = S.Product_ID
		WHERE S.Sale_Status = 'Completed'
		GROUP BY P.Product_ID, P.Product_Name, P.Category
	)C
)A
WHERE Total_Completed_Revenue > Category_Average_Completed_Revenue;


-- ============================================================
-- INTERVIEW CHALLENGE 🔥🔥
-- ============================================================
-- Find the product(s) with the highest TOTAL
-- COMPLETED QUANTITY in each category.
--
-- Ties must be included.
--
-- Requirements:
-- 1. Calculate completed quantity per product.
-- 2. Rank products within each category.
-- 3. Use DENSE_RANK().
-- 4. Return only rank 1.
--
-- Return:
-- Product_ID
-- Product_Name
-- Category
-- Total_Completed_Quantity
-- Quantity_Rank

SELECT Product_ID, Product_Name, Category, Total_Completed_Quantity, Quantity_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Category
           ORDER BY Total_Completed_Quantity DESC) AS Quantity_Rank
	FROM (
		SELECT P.Product_ID, P.Product_Name, P.Category,
			   SUM(S.Quantity) AS Total_Completed_Quantity
		FROM Products P
		INNER JOIN Sales S
			ON P.Product_ID = S.Product_ID
		WHERE S.Sale_Status = 'Completed'
		GROUP BY P.Product_ID, P.Product_Name, P.Category
	)C
)A
WHERE Quantity_Rank = 1;