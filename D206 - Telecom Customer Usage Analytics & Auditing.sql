-- =========================================================
-- SESSION 09 — Telecom Customer Usage Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — CUSTOMERS
-- =========================================================

DROP TABLE IF EXISTS Recharge_Audit;
DROP TABLE IF EXISTS Mobile_Recharges;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Activation_Date DATE
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
-- TABLE 2 — MOBILE RECHARGES
-- =========================================================

CREATE TABLE Mobile_Recharges (
    Recharge_ID INT PRIMARY KEY,
    Customer_ID INT,
    Recharge_Date DATE,
    Plan_Name VARCHAR(50),
    Recharge_Amount DECIMAL(10,2),
    Recharge_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Mobile_Recharges
VALUES
(1001,1,'2025-01-10','Unlimited 30D',500,'Successful'),
(1002,1,'2025-01-11','Data Booster',200,'Successful'),
(1003,1,'2025-01-12','Unlimited 30D',500,'Successful'),
(1004,1,'2025-03-01','Unlimited 60D',900,'Successful'),

(1005,2,'2025-01-20','Unlimited 30D',600,'Successful'),
(1006,2,'2025-02-15','Data Booster',300,'Successful'),
(1007,2,'2025-04-01','Unlimited 30D',250,'Failed'),

(1008,3,'2025-01-25','Unlimited 90D',1200,'Successful'),
(1009,3,'2025-01-26','Data Booster',400,'Successful'),
(1010,3,'2025-01-27','Unlimited 30D',450,'Successful'),
(1011,3,'2025-05-01','Unlimited 60D',1000,'Successful'),

(1012,4,'2025-02-05','Unlimited 30D',500,'Successful'),
(1013,4,'2025-03-05','Unlimited 60D',700,'Successful'),

(1014,5,'2025-02-20','Unlimited 90D',1800,'Successful'),
(1015,5,'2025-03-20','Unlimited 60D',1400,'Successful'),

(1016,6,'2025-03-01','Data Booster',250,'Successful'),
(1017,6,'2025-03-02','Unlimited 30D',450,'Successful'),
(1018,6,'2025-03-03','Unlimited 60D',350,'Successful'),

(1019,7,'2025-04-01','Unlimited 30D',800,'Successful'),
(1020,7,'2025-05-01','Unlimited 60D',900,'Successful'),

(1021,8,'2025-04-10','Data Booster',400,'Successful'),
(1022,8,'2025-06-01','Unlimited 30D',650,'Successful'),

(1023,9,'2025-04-15','Unlimited 30D',300,'Successful'),
(1024,9,'2025-04-16','Data Booster',350,'Successful'),
(1025,9,'2025-04-17','Unlimited 60D',500,'Successful'),

(1026,10,'2025-05-05','Unlimited 90D',1500,'Successful'),
(1027,10,'2025-06-10','Unlimited 60D',1300,'Successful');

-- =========================================================
-- TABLE 3 — RECHARGE AUDIT
-- =========================================================

CREATE TABLE Recharge_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Recharge_ID INT,
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
SELECT * FROM Mobile_Recharges;
SELECT * FROM Recharge_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find customers who made another recharge
-- within 2 days of their previous recharge.
--
-- Return:
-- Customer_ID
-- Customer_Name

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, M.Recharge_Date,
		   LAG(M.Recharge_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY M.Recharge_Date, M.Recharge_ID) AS Previous
	FROM Customers C
    INNER JOIN Mobile_Recharges M
		ON C.Customer_ID = M.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Recharge_Date, Previous) AS Gap_Days
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
-- Total_Recharge_Revenue
--
-- Definition:
-- A customer's cohort month is the month
-- of their first recharge date.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Recharge_Revenue

WITH CTE AS (
	SELECT Customer_ID,
		   MIN(Recharge_Date) AS First_
	FROM Mobile_Recharges
    GROUP BY Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C2.Cohort_Month,
	   COUNT(DISTINCT M.Customer_ID) AS Total_Customers,
       COALESCE(SUM(M.Recharge_Amount), 0) AS Total_Recharge_Revenue
FROM CTE2 C2
LEFT JOIN Mobile_Recharges M
	ON C2.Customer_ID = M.Customer_ID
GROUP BY C2.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each customer's
-- current recharge streak.
--
-- Definition:
-- Current streak = streak containing the customer's
-- most recent recharge date.
--
-- Note:
-- Ignore duplicate recharge dates if a customer
-- has multiple recharges on the same day.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, M.Recharge_Date
    FROM Customers C
    INNER JOIN Mobile_Recharges M
		ON C.Customer_ID = M.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Customer_ID
           ORDER BY Recharge_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Recharge_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Recharge_Date) AS Start_Date,
           MAX(Recharge_Date) AS End_Date
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

-- Categorize customers based on successful
-- recharge revenue.
--
-- Platinum : Revenue >= 4500
-- Gold     : Revenue >= 3000
-- Silver   : Revenue >= 1200
-- Bronze   : Revenue < 1200
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Revenue
-- Customer_Category

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name,
		   COALESCE(SUM(M.Recharge_Amount), 0) AS Total_Revenue
	FROM Customers C
    LEFT JOIN Mobile_Recharges M
		ON C.Customer_ID = M.Customer_ID
		AND M.Recharge_Status = 'Successful'
    GROUP BY C.Customer_ID, C.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 4500 THEN 'Platinum'
       
			WHEN Total_Revenue >= 3000 THEN 'Gold'
            
            WHEN Total_Revenue >= 1200 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Customer_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Mobile_Recharges.
--
-- Requirements:
--
-- 1. When Recharge_Amount OR Recharge_Status changes,
--    insert one record into Recharge_Audit.
--
-- 2. Record:
--    Recharge_ID
--    OLD.Recharge_Amount
--    NEW.Recharge_Amount
--    OLD.Recharge_Status
--    NEW.Recharge_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Recharge_Amount nor Recharge_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Mobile_Recharges
-- SET Recharge_Amount = 2500
-- WHERE Recharge_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Recharge_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.

SELECT * FROM Recharge_Audit;

DELIMITER //

CREATE TRIGGER Recharge_Update_Audit
AFTER UPDATE ON Mobile_Recharges
FOR EACH ROW
BEGIN
	IF OLD.Recharge_Amount <> NEW.Recharge_Amount OR
       OLD.Recharge_Status <> NEW.Recharge_Status
	THEN
		INSERT INTO Recharge_Audit (Recharge_ID, Old_Amount, New_Amount, Old_Status, New_Status, Action_Type)
        VALUES (
			OLD.Recharge_ID,
            OLD.Recharge_Amount,
            NEW.Recharge_Amount,
            OLD.Recharge_Status,
            NEW.Recharge_Status,
            'UPDATE'
		);
	END IF;
END //

DELIMITER ;


UPDATE Mobile_Recharges
SET Recharge_Amount = 2500
WHERE Recharge_ID = 1014;