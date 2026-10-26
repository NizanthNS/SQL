-- =========================================================
-- SESSION — Hotel Booking Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — GUESTS
-- =========================================================

DROP TABLE IF EXISTS Booking_Audit;
DROP TABLE IF EXISTS Hotel_Bookings;
DROP TABLE IF EXISTS Guests;

CREATE TABLE Guests (
    Guest_ID INT PRIMARY KEY,
    Guest_Name VARCHAR(100),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Guests
VALUES	(1,'Alexander Reed','London','2025-01-05'),
		(2,'Charlotte Evans','Toronto','2025-01-10'),
		(3,'Benjamin Scott','Sydney','2025-01-15'),
		(4,'Emily Richardson','Berlin','2025-02-01'),
		(5,'Lucas Foster','Paris','2025-02-10'),
		(6,'Olivia Hughes','London','2025-02-20'),
		(7,'James Murphy','Toronto','2025-03-05'),
		(8,'Ava Peterson','Sydney','2025-03-15');
        

-- =========================================================
-- TABLE 2 — HOTEL BOOKINGS
-- =========================================================

CREATE TABLE Hotel_Bookings (
    Booking_ID INT PRIMARY KEY,
    Guest_ID INT,
    Booking_Date DATE,
    CheckIn_Date DATE,
    Room_Type VARCHAR(30),
    Booking_Amount DECIMAL(10,2),
    Booking_Status VARCHAR(20),
    FOREIGN KEY (Guest_ID) REFERENCES Guests(Guest_ID)
);

INSERT INTO Hotel_Bookings
VALUES	(1001,1,'2025-01-10','2025-01-20','Deluxe',450.00,'Completed'),
		(1002,1,'2025-01-12','2025-01-25','Suite',650.00,'Completed'),
		(1003,1,'2025-01-13','2025-01-28','Deluxe',500.00,'Completed'),
		(1004,1,'2025-02-15','2025-03-01','Standard',300.00,'Completed'),

		(1005,2,'2025-01-15','2025-01-25','Suite',700.00,'Completed'),
		(1006,2,'2025-02-18','2025-03-01','Deluxe',500.00,'Completed'),
		(1007,2,'2025-03-20','2025-04-01','Standard',250.00,'Cancelled'),

		(1008,3,'2025-01-05','2025-01-15','Suite',900.00,'Completed'),
		(1009,3,'2025-01-06','2025-01-18','Suite',850.00,'Completed'),
		(1010,3,'2025-01-07','2025-01-22','Deluxe',550.00,'Completed'),
		(1011,3,'2025-04-10','2025-04-20','Standard',280.00,'Completed'),

		(1012,4,'2025-02-10','2025-02-20','Standard',300.00,'Completed'),
		(1013,4,'2025-03-12','2025-03-20','Deluxe',450.00,'Completed'),

		(1014,5,'2025-02-15','2025-02-25','Suite',1000.00,'Completed'),
		(1015,5,'2025-03-16','2025-03-28','Suite',1100.00,'Completed'),

		(1016,6,'2025-03-01','2025-03-10','Deluxe',550.00,'Completed'),
		(1017,6,'2025-03-02','2025-03-11','Suite',850.00,'Completed'),
		(1018,6,'2025-03-03','2025-03-15','Standard',280.00,'Completed'),

		(1019,7,'2025-04-01','2025-04-15','Deluxe',600.00,'Completed'),
		(1020,7,'2025-05-01','2025-05-10','Suite',800.00,'Completed'),

		(1021,8,'2025-04-10','2025-04-20','Standard',350.00,'Completed'),
		(1022,8,'2025-06-01','2025-06-10','Suite',950.00,'Completed');
        

-- =========================================================
-- TABLE 3 — BOOKING AUDIT
-- =========================================================

CREATE TABLE Booking_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Booking_ID INT,
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

SELECT * FROM Guests;
SELECT * FROM Hotel_Bookings;


-- Q1
-- Find guests who made a booking within
-- 2 days of their previous booking.
--
-- Return:
-- Guest_ID
-- Guest_Name

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name, H.Booking_Date,
		   LAG(H.Booking_Date) OVER(PARTITION BY G.Guest_ID
           ORDER BY H.Booking_Date, H.Booking_ID) AS Previous_Booking
	FROM Guests G
    INNER JOIN Hotel_Bookings H
		ON G.Guest_ID = H.Guest_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Booking_Date, Previous_Booking) AS Days_Gap
	FROM CTE
)
SELECT Guest_ID, Guest_Name
FROM CTE2
WHERE Previous_Booking IS NOT NULL
AND Days_Gap <= 2;


-- Q2​‌
-- For each cohort month, find:
-- Total_Guests
-- Total_Booking_Revenue
--
-- Definition:
-- A guest's cohort month is the month of
-- their first booking date.
--
-- Return:
-- Cohort_Month
-- Total_Guests
-- Total_Booking_Revenue​‌

WITH CTE AS (
	SELECT Guest_ID,
		   MIN(Booking_Date) AS First_Booking
	FROM Hotel_Bookings
    GROUP BY Guest_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Booking, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT H.Guest_ID) AS Total_Guests,
       COALESCE(SUM(H.Booking_Amount), 0) AS Total_Booking_Revenue​‌
FROM CTE2 C
LEFT JOIN Hotel_Bookings H
	ON C.Guest_ID = H.Guest_ID
    AND Booking_Status = 'Completed'
GROUP BY C.Cohort_Month;


-- Q3​‌
-- Find the start date and end date of each guest's
-- current booking streak.
--
-- Definition:
-- Current streak = streak containing the guest's
-- most recent booking date.
--
-- Note:
-- Ignore duplicate booking dates if a guest
-- has multiple bookings on the same day.
--
-- Return:
-- Guest_ID
-- Guest_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only guests whose Current_Streak >= 3.​‌

WITH CTE AS (
	SELECT DISTINCT G.Guest_ID, G.Guest_Name, H.Booking_Date
    FROM Guests G
    INNER JOIN Hotel_Bookings H
		ON G.Guest_ID = H.Guest_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Guest_ID
           ORDER BY Booking_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Booking_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Guest_ID, Guest_Name,
		   COUNT(*) AS Streak,
           MIN(Booking_Date) AS Start_Date,
           MAX(Booking_Date) AS End_Date
	FROM CTE3
    GROUP BY Guest_ID, Guest_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Guest_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Guest_ID, Guest_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >=3
AND D_Rank = 1;


-- Q4​‌
-- Categorize guests based on completed booking revenue.
--
-- Platinum : Revenue >= 2000
-- Gold     : Revenue >= 1000
-- Silver   : Revenue >= 500
-- Bronze   : Revenue < 500
--
-- Return:
-- Guest_ID
-- Guest_Name
-- Total_Revenue
-- Guest_Category​‌

WITH CTE AS (
	SELECT G.Guest_ID, G.Guest_Name,
		   COALESCE(SUM(H.Booking_Amount), 0) AS Total_Revenue
	FROM Guests G
    LEFT JOIN Hotel_Bookings H
		ON G.Guest_ID = H.Guest_ID
	WHERE H.Booking_Status = 'Completed'
    GROUP BY G.Guest_ID, G.Guest_Name
)
SELECT Guest_ID, Guest_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 2000 THEN 'Platinum'
       
			WHEN Total_Revenue >= 1000 THEN 'Gold'
            
            WHEN Total_Revenue >= 500 THEN 'Silver'
            
            WHEN Total_Revenue < 500 THEN 'Bronze'
	   END AS Guest_Category​‌
FROM CTE;


-- Q5​‌
-- Create a MySQL AFTER UPDATE trigger
-- on Hotel_Bookings.
--
-- Requirements:
--
-- 1. When Booking_Amount OR Booking_Status changes,
-- insert one record into Booking_Audit.
--
-- 2. Record:
-- Booking_ID
-- OLD.Booking_Amount
-- NEW.Booking_Amount
-- OLD.Booking_Status
-- NEW.Booking_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
-- Booking_Amount nor Booking_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Hotel_Bookings
-- SET Booking_Amount = 1200
-- WHERE Booking_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Booking_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.​‌

DELIMITER //

CREATE TRIGGER Guest_Update
AFTER UPDATE ON Hotel_Bookings
FOR EACH ROW
BEGIN
	IF OLD.Booking_Amount <> NEW.Booking_Amount OR
	   OLD.Booking_Status <> NEW.Booking_Status
	THEN
		INSERT INTO Booking_Audit (Booking_ID, Old_Amount, New_Amount, Old_Status, New_Status, Action_Type)
        VALUES (
			OLD.Booking_ID,
            OLD.Booking_Amount,
            NEW.Booking_Amount,
            OLD.Booking_Status,
            NEW.Booking_Status,
            'UPDATE'
		);
	END IF;
    
END //

DELIMITER ;

UPDATE Hotel_Bookings
SET Booking_Amount = 1200
WHERE Booking_ID = 1014;

SELECT * FROM Booking_Audit;