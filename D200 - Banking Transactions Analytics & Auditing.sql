-- =========================================================
-- SESSION — Banking Transactions Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — CUSTOMERS
-- =========================================================

DROP TABLE IF EXISTS Transaction_Audit;
DROP TABLE IF EXISTS Bank_Transactions;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Account_Open_Date DATE
);

INSERT INTO Customers
VALUES
(1,'Aarav Sharma','Mumbai','2025-01-05'),
(2,'Emma Wilson','London','2025-01-10'),
(3,'Noah Brown','Toronto','2025-01-15'),
(4,'Sophia Taylor','Sydney','2025-02-01'),
(5,'Liam Johnson','Berlin','2025-02-10'),
(6,'Olivia Martin','Paris','2025-02-18'),
(7,'Lucas Thomas','London','2025-03-01'),
(8,'Mia Anderson','Toronto','2025-03-12'),
(9,'Ethan White','Sydney','2025-03-20'),
(10,'Charlotte Harris','Berlin','2025-04-01');

-- =========================================================
-- TABLE 2 — BANK TRANSACTIONS
-- =========================================================

CREATE TABLE Bank_Transactions (
    Transaction_ID INT PRIMARY KEY,
    Customer_ID INT,
    Transaction_Date DATE,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(10,2),
    Transaction_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Bank_Transactions
VALUES
(1001,1,'2025-01-10','Deposit',500,'Completed'),
(1002,1,'2025-01-11','Transfer',300,'Completed'),
(1003,1,'2025-01-12','Withdrawal',200,'Completed'),
(1004,1,'2025-03-01','Deposit',800,'Completed'),

(1005,2,'2025-01-20','Deposit',700,'Completed'),
(1006,2,'2025-02-15','Transfer',400,'Completed'),
(1007,2,'2025-04-01','Withdrawal',250,'Failed'),

(1008,3,'2025-01-25','Deposit',1000,'Completed'),
(1009,3,'2025-01-26','Transfer',500,'Completed'),
(1010,3,'2025-01-27','Withdrawal',350,'Completed'),
(1011,3,'2025-05-01','Deposit',900,'Completed'),

(1012,4,'2025-02-05','Deposit',450,'Completed'),
(1013,4,'2025-03-05','Transfer',550,'Completed'),

(1014,5,'2025-02-20','Deposit',1500,'Completed'),
(1015,5,'2025-03-20','Transfer',1200,'Completed'),

(1016,6,'2025-03-01','Deposit',300,'Completed'),
(1017,6,'2025-03-02','Transfer',350,'Completed'),
(1018,6,'2025-03-03','Withdrawal',250,'Completed'),

(1019,7,'2025-04-01','Deposit',700,'Completed'),
(1020,7,'2025-05-01','Transfer',900,'Completed'),

(1021,8,'2025-04-10','Deposit',400,'Completed'),
(1022,8,'2025-06-01','Withdrawal',500,'Completed'),

(1023,9,'2025-04-15','Deposit',300,'Completed'),
(1024,9,'2025-04-16','Transfer',450,'Completed'),
(1025,9,'2025-04-17','Withdrawal',350,'Completed'),

(1026,10,'2025-05-05','Deposit',1100,'Completed'),
(1027,10,'2025-06-10','Transfer',1300,'Completed');

-- =========================================================
-- TABLE 3 — TRANSACTION AUDIT
-- =========================================================

CREATE TABLE Transaction_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Transaction_ID INT,
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
SELECT * FROM Bank_Transactions;
SELECT * FROM Transaction_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find customers who made a transaction within
-- 2 days of their previous transaction.
--
-- Return:
-- Customer_ID
-- Customer_Name

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, B.Transaction_Date,
		   LAG(B.Transaction_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY B.Transaction_Date, B.Transaction_ID) AS Previous
	FROM Customers C
    INNER JOIN Bank_Transactions B
		ON C.Customer_ID = B.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Transaction_Date, Previous) AS Gap_Days
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
-- Total_Transaction_Amount
--
-- Definition:
-- A customer's cohort month is the month of
-- their first transaction date.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Transaction_Amount

WITH CTE AS (
	SELECT Customer_ID,
		   MIN(Transaction_Date) AS First_
	FROM Bank_Transactions
    GROUP BY Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT B.Customer_ID) AS Total_Customers,
       COALESCE(SUM(B.Amount), 0) AS Total_Transaction_Amount
FROM CTE2 C
LEFT JOIN Bank_Transactions B
	ON C.Customer_ID = B.Customer_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each customer's
-- current transaction streak.
--
-- Definition:
-- Current streak = streak containing the customer's
-- most recent transaction date.
--
-- Additional Rule:
-- Ignore duplicate transaction dates if a customer
-- has multiple transactions on the same date.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, B.Transaction_Date
    FROM Customers C
    INNER JOIN Bank_Transactions B
		ON C.Customer_ID = B.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Customer_ID
           ORDER BY Transaction_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Transaction_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Transaction_Date) AS Start_Date,
           MAX(Transaction_Date) AS End_Date
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

-- Categorize customers based on completed
-- transaction amount.
--
-- Platinum : Amount >= 2500
-- Gold     : Amount >= 1500
-- Silver   : Amount >= 500
-- Bronze   : Amount < 500
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Amount
-- Customer_Category

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name,
		   COALESCE(SUM(B.Amount), 0) AS Total_Amount
	FROM Customers C
    LEFT JOIN Bank_Transactions B
		ON C.Customer_ID = B.Customer_ID
		AND B.Transaction_Status = 'Completed'
    GROUP BY C.Customer_ID, C.Customer_Name
)
SELECT Customer_ID, Customer_Name, Total_Amount,

	   CASE 
			WHEN Total_Amount >= 2500 THEN 'Platinum'
       
			WHEN Total_Amount >= 1500 THEN 'Gold'
            
            WHEN Total_Amount >= 500 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Customer_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Bank_Transactions.
--
-- Requirements:
--
-- 1. When Amount OR Transaction_Status changes,
--    insert one record into Transaction_Audit.
--
-- 2. Record:
--    Transaction_ID
--    OLD.Amount
--    NEW.Amount
--    OLD.Transaction_Status
--    NEW.Transaction_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Amount nor Transaction_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Bank_Transactions
-- SET Amount = 2000
-- WHERE Transaction_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Transaction_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.


DELIMITER //

CREATE TRIGGER Transaction_Update
AFTER UPDATE ON Bank_Transactions
FOR EACH ROW
BEGIN
	IF OLD.Amount <> NEW.Amount OR
	   OLD.Transaction_Status <> NEW.Transaction_Status
THEN
	INSERT INTO Transaction_Audit (Transaction_ID, Old_Amount, New_Amount, Old_Status, New_Status, Action_Type)
    VALUES (
		OLD.Transaction_ID,
        OLD.Amount,
        NEW.Amount,
        OLD.Transaction_Status,
        NEW.Transaction_Status,
        'UPDATE'
		);
	END IF;
    
END //

DELIMITER ;


UPDATE Bank_Transactions
SET Amount = 2000
WHERE Transaction_ID = 1014;


SELECT * FROM Transaction_Audit;