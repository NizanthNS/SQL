USE Daily_SQL;

-- =========================================================
-- SESSION — Inventory & Warehouse Analytics
-- =========================================================

-- =========================================================
-- TABLE 1 — Products
-- =========================================================


CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Warehouse VARCHAR(50),
    Unit_Cost DECIMAL(10,2)
);

INSERT INTO Products
VALUES	(1, 'Laptop Pro',       'Electronics', 'London',  900),
		(2, 'Wireless Mouse',   'Electronics', 'London',   25),
		(3, 'Mechanical KB',   'Electronics', 'Toronto',  70),
		(4, 'Office Chair',     'Furniture',   'Toronto', 180),
		(5, 'Standing Desk',    'Furniture',   'Sydney',  350),
		(6, 'Desk Lamp',        'Furniture',   'Berlin',   60),
		(7, 'Monitor 27',       'Electronics', 'Paris',   300),
		(8, 'USB-C Hub',        'Electronics', 'Sydney',   45);

-- =========================================================
-- TABLE 2 — Inventory Movements
-- =========================================================
CREATE TABLE Inventory_Movements (
    Movement_ID INT PRIMARY KEY,
    Product_ID INT,
    Movement_Date DATE,
    Movement_Type VARCHAR(20),
    Quantity INT,
    Movement_Status VARCHAR(20),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

INSERT INTO Inventory_Movements
VALUES	(101, 1, '2025-01-05', 'IN',  20, 'Completed'),
		(102, 1, '2025-01-15', 'OUT',  5, 'Completed'),
		(103, 1, '2025-02-05', 'IN',  15, 'Completed'),
		(104, 1, '2025-02-20', 'OUT',  8, 'Completed'),
		(105, 1, '2025-03-10', 'OUT',  4, 'Completed'),

		(106, 2, '2025-01-08', 'IN', 100, 'Completed'),
		(107, 2, '2025-01-18', 'OUT', 25, 'Completed'),
		(108, 2, '2025-02-10', 'OUT', 20, 'Completed'),
		(109, 2, '2025-03-05', 'IN',  60, 'Completed'),
		(110, 2, '2025-03-20', 'OUT', 30, 'Completed'),

		(111, 3, '2025-01-10', 'IN',  50, 'Completed'),
		(112, 3, '2025-01-25', 'OUT', 10, 'Completed'),
		(113, 3, '2025-02-15', 'IN',  30, 'Completed'),
		(114, 3, '2025-03-15', 'OUT', 20, 'Completed'),

		(115, 4, '2025-01-12', 'IN',  40, 'Completed'),
		(116, 4, '2025-01-28', 'OUT', 12, 'Completed'),
		(117, 4, '2025-02-18', 'OUT',  8, 'Completed'),
		(118, 4, '2025-03-10', 'IN',  20, 'Completed'),
		(119, 4, '2025-03-25', 'OUT', 10, 'Completed'),

		(120, 5, '2025-02-05', 'IN',  30, 'Completed'),
		(121, 5, '2025-02-20', 'OUT',  5, 'Completed'),
		(122, 5, '2025-03-15', 'IN',  20, 'Completed'),
		(123, 5, '2025-04-10', 'OUT', 12, 'Completed'),

		(124, 6, '2025-01-15', 'IN',  60, 'Completed'),
		(125, 6, '2025-02-15', 'OUT', 15, 'Completed'),
		(126, 6, '2025-03-15', 'OUT', 10, 'Completed'),
		(127, 6, '2025-04-15', 'IN',  25, 'Completed'),

		(128, 7, '2025-03-01', 'IN',  25, 'Completed'),
		(129, 7, '2025-03-18', 'OUT',  7, 'Completed'),
		(130, 7, '2025-04-05', 'OUT',  5, 'Completed'),
		(131, 7, '2025-05-01', 'IN',  15, 'Completed'),

		(132, 8, '2025-03-05', 'IN',  80, 'Completed'),
		(133, 8, '2025-03-20', 'OUT', 20, 'Completed'),
		(134, 8, '2025-04-05', 'OUT', 15, 'Completed'),
		(135, 8, '2025-05-05', 'IN', 40, 'Completed');
 
-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT *
FROM Products;

SELECT *
FROM Inventory_Movements;


-- =========================================================
-- Q1 — Product Inventory Summary
-- =========================================================
-- For every product, calculate:
-- total IN quantity,
-- total OUT quantity,
-- current stock,
-- inventory value based on Unit_Cost.
--
-- Only Completed movements count.
--
-- Return:
-- Product_ID
-- Product_Name
-- Category
-- Warehouse
-- Total_In
-- Total_Out
-- Current_Stock
-- Inventory_Value

WITH CTE AS (
	SELECT P.Product_ID, P.Product_Name, P.Category, P.Warehouse,
		   COALESCE(SUM(
		   CASE
				WHEN M.Movement_Type = 'IN'
				THEN M.Quantity
				ELSE 0
		   END), 0) AS Total_In,
		   COALESCE(SUM(
		   CASE
				WHEN M.Movement_Type = 'OUT'
				THEN M.Quantity
				ELSE 0
		   END), 0) AS Total_Out,
		   COALESCE(SUM(
		   CASE
				WHEN M.Movement_Type = 'IN'
				THEN M.Quantity
				ELSE 0
		   END) - SUM(
		   CASE
				WHEN M.Movement_Type = 'OUT'
				THEN M.Quantity
				ELSE 0
		   END), 0) AS Current_Stock
	FROM Products P
	LEFT JOIN Inventory_Movements M
		ON P.Product_ID = M.Product_ID
	AND M.Movement_Status = 'Completed'
	GROUP BY P.Product_ID, P.Product_Name, P.Category, P.Warehouse
)
SELECT C.Product_ID, C.Product_Name, C.Category, C.Warehouse, C.Total_In, C.Total_Out, C.Current_Stock,
	   COALESCE(P.Unit_Cost * (C.Total_In - C.Total_Out), 0) AS Inventory_Value
FROM CTE C
LEFT JOIN Products P
	ON C.Product_ID = P.Product_ID;


-- =========================================================
-- Q2 — Warehouse Performance
-- =========================================================
-- For each warehouse, calculate:
-- number of products,
-- total IN quantity,
-- total OUT quantity,
-- current stock,
-- total inventory value.
--
-- Only Completed movements count.
--
-- Return:
-- Warehouse
-- Product_Count
-- Total_In
-- Total_Out
-- Current_Stock
-- Inventory_Value

WITH CTE AS (
	SELECT P.Product_ID,
		   COALESCE(SUM(
		   CASE
				WHEN M.Movement_Type = 'IN'
				THEN M.Quantity
				ELSE 0
		   END), 0) AS Total_In,
		   COALESCE(SUM(
		   CASE
				WHEN M.Movement_Type = 'OUT'
				THEN M.Quantity
				ELSE 0
		   END), 0) AS Total_Out,
		   COALESCE(SUM(
		   CASE
				WHEN M.Movement_Type = 'IN'
				THEN M.Quantity
				ELSE 0
		   END) - SUM(
		   CASE
				WHEN M.Movement_Type = 'OUT'
				THEN M.Quantity
				ELSE 0
		   END), 0) AS Current_Stock
	FROM Products P
    LEFT JOIN Inventory_Movements M
		ON P.Product_ID = M.Product_ID
	AND M.Movement_Status = 'Completed'
    GROUP BY P.Product_ID
),
CTE2 AS (
	SELECT C.Product_ID, C.Total_In, C.Total_Out, C.Current_Stock,
		   P.Unit_Cost * C.Current_Stock AS Inventory_Value
	FROM CTE C
    LEFT JOIN Products P
		ON C.Product_ID = P.Product_ID
)
SELECT P.Warehouse, 
	   COALESCE(COUNT(DISTINCT P.Product_ID), 0) AS Product_Count,
	   COALESCE(SUM(C.Total_In), 0) AS Total_In,
       COALESCE(SUM(C.Total_Out), 0) AS Total_Out,
       COALESCE(SUM(C.Current_Stock), 0) AS Current_Stock,
       COALESCE(SUM(C.Inventory_Value), 0) AS Inventory_Value
FROM Products P
LEFT JOIN CTE2 C
	ON P.Product_ID = C.Product_ID
GROUP BY P.Warehouse;


-- =========================================================
-- Q3 — Top 2 Products Per Category
-- =========================================================
-- Find the top 2 products in each category
-- based on current stock.
--
-- Include ties.
--
-- Use DENSE_RANK().
--
-- Return:
-- Category
-- Product_ID
-- Product_Name
-- Current_Stock
-- Stock_Rank

SELECT Category, Product_ID, Product_Name, Current_Stock, Stock_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Category
           ORDER BY Current_Stock DESC) AS Stock_Rank
	FROM (
		SELECT P.Category, P.Product_ID, P.Product_Name,
			   SUM(
			   CASE
					WHEN M.Movement_Type = 'IN'
					THEN M.Quantity
					ELSE 0
			   END) - SUM(
			   CASE
					WHEN M.Movement_Type = 'OUT'
					THEN M.Quantity
					ELSE 0
			   END) AS Current_Stock
		FROM Products P
		INNER JOIN Inventory_Movements M
			ON P.Product_ID = M.Product_ID
		WHERE M.Movement_Status = 'Completed'
		GROUP BY P.Category, P.Product_ID, P.Product_Name
	)C
)S
WHERE Stock_Rank <= 2;


-- =========================================================
-- Q4 — Inventory Movement Gap Analysis
-- =========================================================
-- For each product, find movements where the gap
-- from the previous completed movement is greater than 15 days.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Return:
-- Product_ID
-- Product_Name
-- Movement_Date
-- Previous_Movement_Date
-- Gap_Days

WITH CTE AS (
	SELECT P.Product_ID, P.Product_Name, M.Movement_Date,
		   LAG(M.Movement_Date) OVER(PARTITION BY P.Product_ID
           ORDER BY M.Movement_Date, M.Movement_ID) AS Previous_Movement_Date
	FROM Products P
	INNER JOIN Inventory_Movements M
		ON P.Product_ID = M.Product_ID
	WHERE M.Movement_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Movement_Date, Previous_Movement_Date) AS Gap_Days
	FROM CTE
)
SELECT  Product_ID, Product_Name, Movement_Date, Previous_Movement_Date, Gap_Days
FROM CTE2
WHERE Gap_Days > 15;


-- =========================================================
-- Q5 — Product Cohort Inventory Analysis
-- =========================================================
-- Group products by the month of their FIRST completed
-- inventory movement.
--
-- For each cohort month, calculate:
-- total products,
-- active products,
-- total IN quantity,
-- total OUT quantity,
-- total current stock,
-- average current stock per active product.
--
-- A product is active if it has at least one completed
-- inventory movement.
--
-- Return:
-- Cohort_Month
-- Total_Products
-- Active_Products
-- Total_In
-- Total_Out
-- Total_Current_Stock
-- Avg_Current_Stock_Per_Active_Product

WITH CTE AS ( 
	SELECT Product_ID, 
		   MIN(Movement_Date) AS First_Movement 
	FROM Inventory_Movements 
    WHERE Movement_Status = 'Completed' 
    GROUP BY Product_ID 
),
CTE2 AS ( 
	SELECT Product_ID, 
		   DATE_FORMAT(First_Movement, '%Y-%m') AS Cohort_Month 
	FROM CTE 
), 
CTE3 AS ( 
	SELECT Product_ID, 
		   COALESCE(SUM(
           CASE 
				WHEN Movement_Type = 'IN' 
                THEN Quantity 
                ELSE 0 
		   END ), 0) AS Total_In, 
           COALESCE(SUM(
           CASE 
				WHEN Movement_Type = 'OUT'
                THEN Quantity 
                ELSE 0
		   END ), 0) AS Total_Out 
	FROM Inventory_Movements 
    WHERE Movement_Status = 'Completed'
    GROUP BY Product_ID
),
CTE4 AS (
	SELECT C2.Cohort_Month,
		   C2.Product_ID, 
           C3.Total_In, 
           C3.Total_Out, 
           C3.Total_In - C3.Total_Out AS Current_Stock 
	FROM CTE2 C2 
    INNER JOIN CTE3 C3 
    ON C2.Product_ID = C3.Product_ID 
) 
SELECT Cohort_Month, 
	   COUNT(Product_ID) AS Total_Products, 
       COUNT(Product_ID) AS Active_Products,
       SUM(Total_In) AS Total_In,
       SUM(Total_Out) AS Total_Out,
       SUM(Current_Stock) AS Total_Current_Stock,
       ROUND( SUM(Current_Stock) / NULLIF(COUNT(Product_ID), 0), 2 ) AS Avg_Current_Stock_Per_Active_Product
FROM CTE4 GROUP BY Cohort_Month
ORDER BY Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- For each product, find its longest consecutive
-- monthly inventory-activity streak.
--
-- A month counts once even if the product has multiple
-- movements in that month.
--
-- If there is a tie, return the most recent streak.
--
-- Return:
-- Product_ID
-- Product_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT P.Product_ID, P.Product_Name,
		   DATE_FORMAT(M.Movement_Date, '%Y-%m-01') AS Movement_Month
	FROM Products P
	INNER JOIN Inventory_Movements M
		ON P.Product_ID = M.Product_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Product_ID
           ORDER BY Movement_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Movement_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Product_ID, Product_Name,
		   COUNT(*) AS Streak,
           MIN(Movement_Month) AS Streak_Start_Month,
           MAX(Movement_Month) AS Streak_End_Month
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


-- =========================================================
-- BONUS+ — Warehouse Above-Average Inventory
-- =========================================================
-- Find products whose current stock is greater than
-- the average current stock of their warehouse.
--
-- Use a window function.
--
-- Return:
-- Product_ID
-- Product_Name
-- Warehouse
-- Current_Stock
-- Warehouse_Average_Stock

SELECT Product_ID, Product_Name, Warehouse, Current_Stock, Warehouse_Average_Stock
FROM (
	SELECT *,
		   ROUND(AVG(Current_Stock) OVER(PARTITION BY Warehouse), 2) AS Warehouse_Average_Stock
	FROM (
		SELECT P.Product_ID, P.Product_Name, P.Warehouse,
			   SUM(
			   CASE
					WHEN M.Movement_Type = 'IN'
					THEN M.Quantity
					ELSE 0
			   END) - SUM(
			   CASE
					WHEN M.Movement_Type = 'OUT'
					THEN M.Quantity
					ELSE 0
			   END) AS Current_Stock
		FROM Products P
		INNER JOIN Inventory_Movements M
			ON P.Product_ID = M.Product_ID
		GROUP BY P.Product_ID, P.Product_Name, P.Warehouse
	)A
)P
WHERE Current_Stock > Warehouse_Average_Stock;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each warehouse, find the product(s) with the
-- highest inventory value.
--
-- Include ties.
--
-- Use DENSE_RANK().
--
-- Return:
-- Warehouse
-- Product_ID
-- Product_Name
-- Inventory_Value
-- Value_Rank

WITH CTE AS (
	SELECT P.Warehouse, P.Product_ID, Product_Name,
		   SUM(
		   CASE
				WHEN M.Movement_Type = 'IN'
				THEN M.Quantity
				ELSE 0
		   END) - SUM(
		   CASE
				WHEN M.Movement_Type = 'OUT'
				THEN M.Quantity
				ELSE 0
		   END) AS Current_Stock
	FROM Products P
    LEFT JOIN Inventory_Movements M
		ON P.Product_ID = M.Product_ID
    GROUP BY P.Warehouse, P.Product_ID, Product_Name
),
CTE2 AS (
	SELECT P.Warehouse, P.Product_ID, P.Product_Name,
		   P.Unit_Cost * C.Current_Stock AS Inventory_Value
	FROM CTE C
    INNER JOIN Products P
		ON C.Product_ID = P.Product_ID
),
CTE3 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Warehouse
           ORDER BY Inventory_Value DESC) AS Value_Rank
	FROM CTE2
)
SELECT Warehouse, Product_ID, Product_Name, Inventory_Value, Value_Rank
FROM CTE3
WHERE Value_Rank = 1;
