-- =========================================================
-- SESSION — Food Delivery Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — CUSTOMERS
-- =========================================================

DROP TABLE IF EXISTS Order_Audit;
DROP TABLE IF EXISTS Food_Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Customers
VALUES
(1,'Aarav Sharma','Mumbai','2025-01-05'),
(2,'Emma Wilson','London','2025-01-12'),
(3,'Noah Brown','Toronto','2025-01-18'),
(4,'Sophia Taylor','Sydney','2025-02-01'),
(5,'Liam Johnson','Berlin','2025-02-10'),
(6,'Olivia Martin','Paris','2025-02-20'),
(7,'Lucas Thomas','London','2025-03-01'),
(8,'Mia Anderson','Toronto','2025-03-12'),
(9,'Ethan White','Sydney','2025-03-20'),
(10,'Charlotte Harris','Berlin','2025-04-01');

-- =========================================================
-- TABLE 2 — FOOD ORDERS
-- =========================================================

CREATE TABLE Food_Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Restaurant_Name VARCHAR(100),
    Order_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Food_Orders
VALUES
(1001,1,'2025-01-10','Burger Hub',300,'Delivered'),
(1002,1,'2025-01-11','Pizza Point',450,'Delivered'),
(1003,1,'2025-01-12','Burger Hub',250,'Delivered'),
(1004,1,'2025-02-15','Taco Town',500,'Delivered'),

(1005,2,'2025-01-15','Pizza Point',600,'Delivered'),
(1006,2,'2025-02-01','Burger Hub',350,'Delivered'),
(1007,2,'2025-03-05','Taco Town',400,'Cancelled'),

(1008,3,'2025-01-20','Pizza Point',550,'Delivered'),
(1009,3,'2025-01-21','Burger Hub',300,'Delivered'),
(1010,3,'2025-01-22','Taco Town',450,'Delivered'),
(1011,3,'2025-05-01','Pizza Point',700,'Delivered'),

(1012,4,'2025-02-05','Burger Hub',250,'Delivered'),
(1013,4,'2025-03-05','Pizza Point',500,'Delivered'),

(1014,5,'2025-02-20','Taco Town',1200,'Delivered'),
(1015,5,'2025-03-20','Pizza Point',1000,'Delivered'),

(1016,6,'2025-03-01','Burger Hub',300,'Delivered'),
(1017,6,'2025-03-02','Pizza Point',500,'Delivered'),
(1018,6,'2025-03-03','Taco Town',400,'Delivered'),

(1019,7,'2025-04-01','Burger Hub',550,'Delivered'),
(1020,7,'2025-05-01','Pizza Point',850,'Delivered'),

(1021,8,'2025-04-10','Taco Town',300,'Delivered'),
(1022,8,'2025-06-01','Burger Hub',450,'Delivered'),

(1023,9,'2025-04-15','Pizza Point',350,'Delivered'),
(1024,9,'2025-04-16','Burger Hub',300,'Delivered'),
(1025,9,'2025-04-17','Taco Town',500,'Delivered'),

(1026,10,'2025-05-05','Pizza Point',900,'Delivered'),
(1027,10,'2025-06-10','Burger Hub',1100,'Delivered');

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
SELECT * FROM Food_Orders;
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
	SELECT C.Customer_ID, C.Customer_Name, F.Order_Date,
		   LAG(F.Order_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY F.Order_Date, F.Order_ID) AS Previous
	FROM Customers C
    INNER JOIN Food_Orders F
		ON C.Customer_ID = F.Customer_ID
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
	FROM Food_Orders
    GROUP BY Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Order, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C2.Cohort_Month,
	   COUNT(DISTINCT F.Customer_ID) AS Total_Customers,
       COALESCE(SUM(F.Order_Amount), 0) AS Total_Order_Revenue
FROM CTE2 C2
LEFT JOIN Food_Orders F
	ON C2.Customer_ID = F.Customer_ID
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, F.Order_Date
    FROM Customers C
    INNER JOIN Food_Orders F
		ON C.Customer_ID = F.Customer_ID
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
-- Platinum : Revenue >= 2000
-- Gold     : Revenue >= 1000
-- Silver   : Revenue >= 500
-- Bronze   : Revenue < 500
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Revenue
-- Customer_Category

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name,
		   COALESCE(SUM(F.Order_Amount), 0) AS Total_Revenue
	FROM Customers C
    LEFT JOIN Food_Orders F
		ON C.Customer_ID = F.Customer_ID
		AND F.Order_Status = 'Delivered'
    GROUP BY C.Customer_ID, C.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 2000 THEN 'Platinum'
       
			WHEN Total_Revenue >= 1000 THEN 'Gold'
            
            WHEN Total_Revenue >= 500 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Customer_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Food_Orders.
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
-- UPDATE Food_Orders
-- SET Order_Amount = 1500
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

CREATE TRIGGER Order_Update
AFTER UPDATE ON Food_Orders
FOR EACH ROW
BEGIN
	IF OLD.Order_Amount <> NEW.Order_Amount OR
	   OLD.Order_Status <> NEW.Order_Status
THEN
	INSERT INTO Order_Audit (Order_ID, Old_Amount, New_Amount, Old_Status, New_Status, Action_Type)
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


UPDATE Food_Orders
SET Order_Amount = 7500
WHERE Order_ID = 1014;


SELECT * FROM Order_Audit;