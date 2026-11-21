-- =========================================================
-- SESSION 10 — Insurance Policy Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — POLICYHOLDERS
-- =========================================================

DROP TABLE IF EXISTS Policy_Audit;
DROP TABLE IF EXISTS Policy_Purchases;
DROP TABLE IF EXISTS Policyholders;

CREATE TABLE Policyholders (
    Policyholder_ID INT PRIMARY KEY,
    Policyholder_Name VARCHAR(100),
    City VARCHAR(50),
    Registration_Date DATE
);

INSERT INTO Policyholders
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
-- TABLE 2 — POLICY PURCHASES
-- =========================================================

CREATE TABLE Policy_Purchases (
    Policy_ID INT PRIMARY KEY,
    Policyholder_ID INT,
    Purchase_Date DATE,
    Policy_Type VARCHAR(50),
    Premium_Amount DECIMAL(10,2),
    Policy_Status VARCHAR(20),
    FOREIGN KEY (Policyholder_ID)
        REFERENCES Policyholders(Policyholder_ID)
);

INSERT INTO Policy_Purchases
VALUES
(1001,1,'2025-01-10','Health',600,'Active'),
(1002,1,'2025-01-11','Travel',300,'Active'),
(1003,1,'2025-01-12','Life',700,'Active'),
(1004,1,'2025-03-01','Vehicle',900,'Active'),

(1005,2,'2025-01-20','Health',800,'Active'),
(1006,2,'2025-02-15','Life',600,'Active'),
(1007,2,'2025-04-01','Travel',250,'Cancelled'),

(1008,3,'2025-01-25','Life',1500,'Active'),
(1009,3,'2025-01-26','Health',500,'Active'),
(1010,3,'2025-01-27','Travel',400,'Active'),
(1011,3,'2025-05-01','Vehicle',1000,'Active'),

(1012,4,'2025-02-05','Health',700,'Active'),
(1013,4,'2025-03-05','Vehicle',900,'Active'),

(1014,5,'2025-02-20','Life',2000,'Active'),
(1015,5,'2025-03-20','Health',1800,'Active'),

(1016,6,'2025-03-01','Travel',400,'Active'),
(1017,6,'2025-03-02','Health',500,'Active'),
(1018,6,'2025-03-03','Vehicle',600,'Active'),

(1019,7,'2025-04-01','Life',900,'Active'),
(1020,7,'2025-05-01','Vehicle',1100,'Active'),

(1021,8,'2025-04-10','Travel',450,'Active'),
(1022,8,'2025-06-01','Health',750,'Active'),

(1023,9,'2025-04-15','Travel',300,'Active'),
(1024,9,'2025-04-16','Health',450,'Active'),
(1025,9,'2025-04-17','Life',650,'Active'),

(1026,10,'2025-05-05','Life',1700,'Active'),
(1027,10,'2025-06-10','Vehicle',1500,'Active');

-- =========================================================
-- TABLE 3 — POLICY AUDIT
-- =========================================================

CREATE TABLE Policy_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Policy_ID INT,
    Old_Premium DECIMAL(10,2),
    New_Premium DECIMAL(10,2),
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Action_Type VARCHAR(20),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Policyholders;
SELECT * FROM Policy_Purchases;
SELECT * FROM Policy_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find policyholders who purchased another policy
-- within 2 days of their previous policy purchase.
--
-- Return:
-- Policyholder_ID
-- Policyholder_Name

WITH CTE AS (
	SELECT H.Policyholder_ID, H.Policyholder_Name, P.Purchase_Date,
		   LAG(P.Purchase_Date) OVER(PARTITION BY H.Policyholder_ID
           ORDER BY P.Purchase_Date, P.Policy_ID) AS Previous
	FROM Policyholders H
    INNER JOIN Policy_Purchases P
		ON H.Policyholder_ID = P.Policyholder_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Purchase_Date, Previous) AS Gap_Days
	FROM CTE
)
SELECT DISTINCT Policyholder_ID, Policyholder_Name
FROM CTE2
WHERE Gap_Days <= 2;


-- =========================================================
-- Q2
-- COHORT ANALYSIS
-- =========================================================

-- For each cohort month, find:
-- Total_Policyholders
-- Total_Premium_Revenue
--
-- Definition:
-- A policyholder's cohort month is the month
-- of their first policy purchase date.
--
-- Return:
-- Cohort_Month
-- Total_Policyholders
-- Total_Premium_Revenue

WITH CTE AS (
	SELECT Policyholder_ID,
		   MIN(Purchase_Date) AS First_Purchase
	FROM Policy_Purchases
    GROUP BY Policyholder_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Purchase, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C2.Cohort_Month,
	   COUNT(DISTINCT P.Policyholder_ID) AS Total_Policyholders,
       COALESCE(SUM(P.Premium_Amount), 0) AS Total_Premium_Revenue
FROM CTE2 C2
LEFT JOIN Policy_Purchases P
	ON C2.Policyholder_ID = P.Policyholder_ID
GROUP BY C2.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each
-- policyholder's current purchase streak.
--
-- Definition:
-- Current streak = streak containing the
-- policyholder's most recent purchase date.
--
-- Note:
-- Ignore duplicate purchase dates if a
-- policyholder has multiple purchases on
-- the same day.
--
-- Return:
-- Policyholder_ID
-- Policyholder_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only policyholders whose
-- Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT H.Policyholder_ID, H.Policyholder_Name, P.Purchase_Date
    FROM Policyholders H
    INNER JOIN Policy_Purchases P
		ON H.Policyholder_ID = P.Policyholder_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Policyholder_ID
           ORDER BY Purchase_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Purchase_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Policyholder_ID, Policyholder_Name,
		   COUNT(*) AS Streak,
           MIN(Purchase_Date) AS Start_Date,
           MAX(Purchase_Date) AS End_Date
	FROM CTE3
    GROUP BY Policyholder_ID, Policyholder_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Policyholder_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Policyholder_ID, Policyholder_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >= 3
AND D_Rank = 1;


-- =========================================================
-- Q4
-- CASE STATEMENT
-- =========================================================

-- Categorize policyholders based on active
-- premium revenue.
--
-- Platinum : Revenue >= 5000
-- Gold     : Revenue >= 3500
-- Silver   : Revenue >= 1500
-- Bronze   : Revenue < 1500
--
-- Return:
-- Policyholder_ID
-- Policyholder_Name
-- Total_Revenue
-- Policyholder_Category

WITH CTE AS (
	SELECT H.Policyholder_ID, H.Policyholder_Name,
		   COALESCE(SUM(P.Premium_Amount), 0) AS Total_Revenue
	FROM Policyholders H
    LEFT JOIN Policy_Purchases P
		ON H.Policyholder_ID = P.Policyholder_ID
		AND P.Policy_Status = 'Active'
    GROUP BY H.Policyholder_ID, H.Policyholder_Name
)
SELECT Policyholder_ID, Policyholder_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 5000 THEN 'Platinum'
       
			WHEN Total_Revenue >= 3500 THEN 'Gold'
            
            WHEN Total_Revenue >= 1500 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Policyholder_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Policy_Purchases.
--
-- Requirements:
--
-- 1. When Premium_Amount OR Policy_Status changes,
--    insert one record into Policy_Audit.
--
-- 2. Record:
--    Policy_ID
--    OLD.Premium_Amount
--    NEW.Premium_Amount
--    OLD.Policy_Status
--    NEW.Policy_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Premium_Amount nor Policy_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Policy_Purchases
-- SET Premium_Amount = 3000
-- WHERE Policy_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Policy_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.

DELIMITER //

CREATE TRIGGER Policy_Update_Audit
AFTER UPDATE ON Policy_Purchases
FOR EACH ROW
BEGIN
	IF OLD.Premium_Amount <> NEW.Premium_Amount OR
	   OLD.Policy_Status <> NEW.Policy_Status
	THEN
		INSERT INTO Policy_Audit(Policy_ID, Old_Premium, New_Premium, Old_Status, New_Status, Action_Type)
        VALUES (
			OLD.Policy_ID,
            OLD.Premium_Amount,
            NEW.Premium_Amount,
            OLD.Policy_Status,
            NEW.Policy_Status,
            'UPDATE'
		);
	END IF;
END //

DELIMITER ;


UPDATE Policy_Purchases
SET Premium_Amount = 3000
WHERE Policy_ID = 1014;

SELECT * FROM Policy_Audit;