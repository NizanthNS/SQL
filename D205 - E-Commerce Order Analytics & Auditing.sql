-- =========================================================
-- SESSION — E-Commerce Order Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — CUSTOMERS
-- =========================================================

DROP TABLE IF EXISTS Order_Audit;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Customers
VALUES
(1,'Alexander Reed','London','2025-01-05'),
(2,'Charlotte Evans','Toronto','2025-01-10'),
(3,'Benjamin Scott','Sydney','2025-01-18'),
(4,'Emily Richardson','Berlin','2025-02-01'),
(5,'Lucas Foster','Paris','2025-02-12'),
(6,'Olivia Hughes','London','2025-02-20'),
(7,'James Murphy','Toronto','2025-03-05'),
(8,'Ava Peterson','Sydney','2025-03-10'),
(9,'Liam Cooper','Berlin','2025-03-18'),
(10,'Sophia Ward','Paris','2025-04-01');

-- =========================================================
-- TABLE 2 — ORDERS
-- =========================================================

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Product_Category VARCHAR(50),
    Order_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Orders
VALUES
(1001,1,'2025-01-10','Electronics',600,'Delivered'),
(1002,1,'2025-01-11','Accessories',300,'Delivered'),
(1003,1,'2025-01-12','Electronics',500,'Delivered'),
(1004,1,'2025-03-01','Furniture',900,'Delivered'),

(1005,2,'2025-01-20','Furniture',800,'Delivered'),
(1006,2,'2025-02-15','Electronics',700,'Delivered'),
(1007,2,'2025-04-01','Accessories',250,'Cancelled'),

(1008,3,'2025-01-25','Electronics',1200,'Delivered'),
(1009,3,'2025-01-26','Accessories',500,'Delivered'),
(1010,3,'2025-01-27','Furniture',400,'Delivered'),
(1011,3,'2025-05-01','Electronics',1000,'Delivered'),

(1012,4,'2025-02-05','Furniture',600,'Delivered'),
(1013,4,'2025-03-05','Electronics',800,'Delivered'),

(1014,5,'2025-02-20','Electronics',1800,'Delivered'),
(1015,5,'2025-03-20','Furniture',1500,'Delivered'),

(1016,6,'2025-03-01','Accessories',400,'Delivered'),
(1017,6,'2025-03-02','Electronics',450,'Delivered'),
(1018,6,'2025-03-03','Furniture',350,'Delivered'),

(1019,7,'2025-04-01','Electronics',800,'Delivered'),
(1020,7,'2025-05-01','Furniture',1000,'Delivered'),

(1021,8,'2025-04-10','Accessories',450,'Delivered'),
(1022,8,'2025-06-01','Electronics',650,'Delivered'),

(1023,9,'2025-04-15','Furniture',300,'Delivered'),
(1024,9,'2025-04-16','Electronics',400,'Delivered'),
(1025,9,'2025-04-17','Accessories',500,'Delivered'),

(1026,10,'2025-05-05','Electronics',1500,'Delivered'),
(1027,10,'2025-06-10','Furniture',1300,'Delivered');

-- =========================================================
-- TABLE 3 — ORDER AUDIT
-- =========================================================

CREATE TABLE Order_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID INT,
    Old_Amount DECIMAL(10,2),
    New_Amount DECIMAL(10,2),
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Action_Type VARCHAR(20),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Order_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find customers who placed another order
-- within 2 days of their previous order.
--
-- Return:
-- Customer_ID
-- Customer_Name

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, O.Order_Date,
		   LAG(O.Order_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY O.Order_Date, O.Order_ID) AS Previous
	FROM Customers C
    INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Order_Date, Previous) AS Gap_Days
	FROM CTE
)
SELECT DISTINCT Customer_ID, Customer_Name
FROM CTE2
WHERE Gap_Days <= 2;


-- =========================================================
-- Q2
-- COHORT ANALYSIS
-- =========================================================

-- For each cohort month, find:
-- Total_Customers
-- Total_Order_Revenue
--
-- Definition:
-- A customer's cohort month is the month
-- of their first order date.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Order_Revenue

WITH CTE AS (
	SELECT Customer_ID,
		   MIN(Order_Date) AS First_Order
	FROM Orders
    GROUP BY Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Order, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C2.Cohort_Month,
	   COUNT(DISTINCT O.Customer_ID) AS Total_Customers,
       COALESCE(SUM(O.Order_Amount), 0) AS Total_Order_Revenue
FROM CTE2 C2
LEFT JOIN Orders O
	ON C2.Customer_ID = O.Customer_ID
GROUP BY C2.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each customer's
-- current ordering streak.
--
-- Definition:
-- Current streak = streak containing the customer's
-- most recent order date.
--
-- Note:
-- Ignore duplicate order dates if a customer
-- has multiple orders on the same day.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only customers whose Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, O.Order_Date
    FROM Customers C
    INNER JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Customer_ID
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
		   DENSE_RANK() OVER(PARTITION BY Customer_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >=3
AND D_Rank = 1;


-- =========================================================
-- Q4
-- CASE STATEMENT
-- =========================================================

-- Categorize customers based on delivered
-- order revenue.
--
-- Platinum : Revenue >= 4000
-- Gold     : Revenue >= 2500
-- Silver   : Revenue >= 1000
-- Bronze   : Revenue < 1000
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Revenue
-- Customer_Category

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name,
		   COALESCE(SUM(O.Order_Amount), 0) AS Total_Revenue
	FROM Customers C
    LEFT JOIN Orders O
		ON C.Customer_ID = O.Customer_ID
		AND O.Order_Status = 'Delivered'
    GROUP BY C.Customer_ID, C.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 4000 THEN 'Platinum'
       
			WHEN Total_Revenue >= 2500 THEN 'Gold'
            
            WHEN Total_Revenue >= 1000 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Customer_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Orders.
--
-- Requirements:
--
-- 1. When Order_Amount OR Order_Status changes,
--    insert one record into Order_Audit.
--
-- 2. Record:
--    Order_ID
--    OLD.Order_Amount
--    NEW.Order_Amount
--    OLD.Order_Status
--    NEW.Order_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Order_Amount nor Order_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Orders
-- SET Order_Amount = 2500
-- WHERE Order_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Order_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.


DELIMITER //

CREATE TRIGGER Order_Update_Audit
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
	IF OLD.Order_Amount <> NEW.Order_Amount OR
	   OLD.Order_Status <> NEW.Order_Status
	THEN
		INSERT INTO Order_Audit(Order_ID, Old_Amount, New_Amount, Old_Status, New_Status, Action_Type)
        VALUES (
			OLD.Order_ID,
            OLD.Order_Amount,
            NEW.Order_Amount,
            OLD.Order_Status,
            NEW.Order_Status,
            'UPDATE'
		);
	END IF;
END //

DELIMITER ;


UPDATE Orders
SET Order_Amount = 2500
WHERE Order_ID = 1014;

SELECT * FROM Order_Audit;