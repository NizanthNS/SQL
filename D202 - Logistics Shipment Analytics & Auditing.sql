-- =========================================================
-- SESSION 05 — Logistics Shipment Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — CLIENTS
-- =========================================================

DROP TABLE IF EXISTS Shipment_Audit;
DROP TABLE IF EXISTS Shipments;
DROP TABLE IF EXISTS Clients;

CREATE TABLE Clients (
    Client_ID INT PRIMARY KEY,
    Client_Name VARCHAR(100),
    City VARCHAR(50),
    Registration_Date DATE
);

INSERT INTO Clients
VALUES
(1,'Aarav Exports','Mumbai','2025-01-05'),
(2,'Global Traders','London','2025-01-10'),
(3,'North Star Retail','Toronto','2025-01-18'),
(4,'Premium Goods','Sydney','2025-02-01'),
(5,'Berlin Imports','Berlin','2025-02-12'),
(6,'Paris Distributors','Paris','2025-02-20'),
(7,'Metro Supplies','London','2025-03-05'),
(8,'Rapid Commerce','Toronto','2025-03-10'),
(9,'Skyline Mart','Sydney','2025-03-18'),
(10,'Capital Wholesale','Berlin','2025-04-01');

-- =========================================================
-- TABLE 2 — SHIPMENTS
-- =========================================================

CREATE TABLE Shipments (
    Shipment_ID INT PRIMARY KEY,
    Client_ID INT,
    Shipment_Date DATE,
    Destination_Country VARCHAR(50),
    Shipment_Value DECIMAL(10,2),
    Shipment_Status VARCHAR(20),
    FOREIGN KEY (Client_ID) REFERENCES Clients(Client_ID)
);

INSERT INTO Shipments
VALUES
(1001,1,'2025-01-10','UAE',500,'Delivered'),
(1002,1,'2025-01-11','Singapore',300,'Delivered'),
(1003,1,'2025-01-12','Germany',400,'Delivered'),
(1004,1,'2025-03-01','Canada',900,'Delivered'),

(1005,2,'2025-01-20','France',700,'Delivered'),
(1006,2,'2025-02-15','Italy',500,'Delivered'),
(1007,2,'2025-04-01','Japan',300,'Cancelled'),

(1008,3,'2025-01-25','USA',1200,'Delivered'),
(1009,3,'2025-01-26','UK',500,'Delivered'),
(1010,3,'2025-01-27','Australia',400,'Delivered'),
(1011,3,'2025-05-01','Germany',800,'Delivered'),

(1012,4,'2025-02-05','Canada',600,'Delivered'),
(1013,4,'2025-03-05','France',700,'Delivered'),

(1014,5,'2025-02-20','Japan',1500,'Delivered'),
(1015,5,'2025-03-20','USA',1300,'Delivered'),

(1016,6,'2025-03-01','UK',400,'Delivered'),
(1017,6,'2025-03-02','Germany',450,'Delivered'),
(1018,6,'2025-03-03','France',350,'Delivered'),

(1019,7,'2025-04-01','Italy',800,'Delivered'),
(1020,7,'2025-05-01','Canada',900,'Delivered'),

(1021,8,'2025-04-10','USA',450,'Delivered'),
(1022,8,'2025-06-01','Japan',550,'Delivered'),

(1023,9,'2025-04-15','Singapore',300,'Delivered'),
(1024,9,'2025-04-16','UAE',400,'Delivered'),
(1025,9,'2025-04-17','Australia',500,'Delivered'),

(1026,10,'2025-05-05','Germany',1400,'Delivered'),
(1027,10,'2025-06-10','USA',1200,'Delivered');

-- =========================================================
-- TABLE 3 — SHIPMENT AUDIT
-- =========================================================

CREATE TABLE Shipment_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Shipment_ID INT,
    Old_Value DECIMAL(10,2),
    New_Value DECIMAL(10,2),
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Action_Type VARCHAR(20),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Clients;
SELECT * FROM Shipments;
SELECT * FROM Shipment_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find clients who created a shipment within
-- 2 days of their previous shipment.
--
-- Return:
-- Client_ID
-- Client_Name

WITH CTE AS (
	SELECT C.Client_ID, C.Client_Name, S.Shipment_Date,
		   LAG(S.Shipment_Date) OVER(PARTITION BY C.Client_ID
           ORDER BY S.Shipment_Date, S.Shipment_ID) AS Previous
	FROM Clients C
    INNER JOIN Shipments S
		ON C.Client_ID = S.Client_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Shipment_Date, Previous) AS Gap_Days
	FROM CTE
)
SELECT DISTINCT Client_ID, Client_Name
FROM CTE2
WHERE Gap_Days <= 2;


-- =========================================================
-- Q2
-- COHORT ANALYSIS
-- =========================================================

-- For each cohort month, find:
-- Total_Clients
-- Total_Shipment_Value
--
-- Definition:
-- A client's cohort month is the month
-- of their first shipment date.
--
-- Return:
-- Cohort_Month
-- Total_Clients
-- Total_Shipment_Value

WITH CTE AS (
	SELECT Client_ID,
		   MIN(Shipment_Date) AS First_
	FROM Shipments
    GROUP BY Client_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT S.Client_ID) AS Total_Clients,
       COALESCE(SUM(S.Shipment_Value), 0) AS Total_Shipment_Value
FROM CTE2 C
LEFT JOIN Shipments S
	ON C.Client_ID = S.Client_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each client's
-- current shipment streak.
--
-- Definition:
-- Current streak = streak containing the client's
-- most recent shipment date.
--
-- Note:
-- Ignore duplicate shipment dates if a client
-- has multiple shipments on the same day.
--
-- Return:
-- Client_ID
-- Client_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only clients whose Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT C.Client_ID, C.Client_Name, S.Shipment_Date
    FROM Clients C
    INNER JOIN Shipments S
		ON C.Client_ID = S.Client_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Client_ID
           ORDER BY Shipment_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Shipment_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Client_ID, Client_Name,
		   COUNT(*) AS Streak,
           MIN(Shipment_Date) AS Start_Date,
           MAX(Shipment_Date) AS End_Date
	FROM CTE3
    GROUP BY Client_ID, Client_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Client_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Client_ID, Client_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >=3
AND D_Rank = 1;


-- =========================================================
-- Q4
-- CASE STATEMENT
-- =========================================================

-- Categorize clients based on delivered
-- shipment value.
--
-- Platinum : Value >= 3000
-- Gold     : Value >= 2000
-- Silver   : Value >= 1000
-- Bronze   : Value < 1000
--
-- Return:
-- Client_ID
-- Client_Name
-- Total_Value
-- Client_Category

WITH CTE AS (
	SELECT C.Client_ID, C.Client_Name,
		   COALESCE(SUM(S.Shipment_Value), 0) AS Total_Value
	FROM Clients C
    LEFT JOIN Shipments S
		ON C.Client_ID = S.Client_ID
		AND S.Shipment_Status = 'Delivered'
    GROUP BY C.Client_ID, C.Client_Name
)
SELECT Client_ID, Client_Name, Total_Value,

	   CASE 
			WHEN Total_Value >= 3000 THEN 'Platinum'
       
			WHEN Total_Value >= 2000 THEN 'Gold'
            
            WHEN Total_Value >= 1000 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Client_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Shipments.
--
-- Requirements:
--
-- 1. When Shipment_Value OR Shipment_Status changes,
--    insert one record into Shipment_Audit.
--
-- 2. Record:
--    Shipment_ID
--    OLD.Shipment_Value
--    NEW.Shipment_Value
--    OLD.Shipment_Status
--    NEW.Shipment_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Shipment_Value nor Shipment_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Shipments
-- SET Shipment_Value = 2000
-- WHERE Shipment_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Shipment_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.

DELIMITER //

CREATE TRIGGER Shipment_Update
AFTER UPDATE ON Shipments
FOR EACH ROW
BEGIN
	IF OLD.Shipment_Status <> NEW.Shipment_Status OR
	   OLD.Shipment_Value <> NEW.Shipment_Value
	THEN
		INSERT INTO Shipment_Audit ( Shipment_ID, Old_Value, New_Value, Old_Status, New_Status, Action_Type)
        VALUES (
        OLD.Shipment_ID,
        OLD.Shipment_Value,
        NEW.Shipment_Value,
        OLD.Shipment_Status,
        NEW.Shipment_Status,
        'UPDATE'
		);
	END IF;
    END //
    
DELIMITER ;

UPDATE Shipments
SET Shipment_Status = 'Cancelled'
WHERE Shipment_ID = 1011;

        
SELECT * FROM Shipment_Audit;