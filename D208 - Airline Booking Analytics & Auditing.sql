-- =========================================================
-- SESSION 11 — Airline Booking Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — PASSENGERS
-- =========================================================

DROP TABLE IF EXISTS Booking_Audit;
DROP TABLE IF EXISTS Flight_Bookings;
DROP TABLE IF EXISTS Passengers;

CREATE TABLE Passengers (
    Passenger_ID INT PRIMARY KEY,
    Passenger_Name VARCHAR(100),
    City VARCHAR(50),
    Registration_Date DATE
);

INSERT INTO Passengers
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
-- TABLE 2 — FLIGHT BOOKINGS
-- =========================================================

CREATE TABLE Flight_Bookings (
    Booking_ID INT PRIMARY KEY,
    Passenger_ID INT,
    Booking_Date DATE,
    Destination VARCHAR(50),
    Ticket_Amount DECIMAL(10,2),
    Booking_Status VARCHAR(20),
    FOREIGN KEY (Passenger_ID)
        REFERENCES Passengers(Passenger_ID)
);

INSERT INTO Flight_Bookings
VALUES
(1001,1,'2025-01-10','Dubai',700,'Confirmed'),
(1002,1,'2025-01-11','Singapore',300,'Confirmed'),
(1003,1,'2025-01-12','Paris',600,'Confirmed'),
(1004,1,'2025-03-01','Toronto',1000,'Confirmed'),

(1005,2,'2025-01-20','Berlin',900,'Confirmed'),
(1006,2,'2025-02-15','Tokyo',700,'Confirmed'),
(1007,2,'2025-04-01','Sydney',300,'Cancelled'),

(1008,3,'2025-01-25','New York',1600,'Confirmed'),
(1009,3,'2025-01-26','Dubai',500,'Confirmed'),
(1010,3,'2025-01-27','Paris',600,'Confirmed'),
(1011,3,'2025-05-01','Singapore',1100,'Confirmed'),

(1012,4,'2025-02-05','Toronto',800,'Confirmed'),
(1013,4,'2025-03-05','Dubai',1000,'Confirmed'),

(1014,5,'2025-02-20','Tokyo',2200,'Confirmed'),
(1015,5,'2025-03-20','New York',1800,'Confirmed'),

(1016,6,'2025-03-01','Paris',500,'Confirmed'),
(1017,6,'2025-03-02','Dubai',600,'Confirmed'),
(1018,6,'2025-03-03','Singapore',700,'Confirmed'),

(1019,7,'2025-04-01','Berlin',1000,'Confirmed'),
(1020,7,'2025-05-01','Tokyo',1200,'Confirmed'),

(1021,8,'2025-04-10','Sydney',600,'Confirmed'),
(1022,8,'2025-06-01','Dubai',800,'Confirmed'),

(1023,9,'2025-04-15','Paris',400,'Confirmed'),
(1024,9,'2025-04-16','Berlin',500,'Confirmed'),
(1025,9,'2025-04-17','Tokyo',700,'Confirmed'),

(1026,10,'2025-05-05','New York',1800,'Confirmed'),
(1027,10,'2025-06-10','Singapore',1600,'Confirmed');

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

SELECT * FROM Passengers;
SELECT * FROM Flight_Bookings;
SELECT * FROM Booking_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find passengers who made another booking
-- within 2 days of their previous booking.
--
-- Return:
-- Passenger_ID
-- Passenger_Name

WITH CTE AS (
	SELECT P.Passenger_ID, P.Passenger_Name, F.Booking_Date,
		   LAG(F.Booking_Date) OVER(PARTITION BY P.Passenger_ID
           ORDER BY F.Booking_Date, F.Booking_ID) AS Previous
	FROM Passengers P
    INNER JOIN Flight_Bookings F
		ON P.Passenger_ID = F.Passenger_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Booking_Date, Previous) AS Gap_Days
	FROM CTE
)
SELECT DISTINCT Passenger_ID, Passenger_Name
FROM CTE2
WHERE Previous IS NOT NULL
AND	Gap_Days <= 2;


-- =========================================================
-- Q2
-- COHORT ANALYSIS
-- =========================================================

-- For each cohort month, find:
-- Total_Passengers
-- Total_Ticket_Revenue
--
-- Definition:
-- A passenger's cohort month is the month
-- of their first booking date.
--
-- Return:
-- Cohort_Month
-- Total_Passengers
-- Total_Ticket_Revenue

WITH CTE AS (
	SELECT Passenger_ID,
		   MIN(Booking_Date) AS First_
	FROM Flight_Bookings
    GROUP BY Passenger_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C2.Cohort_Month,
	   COUNT(DISTINCT F.Passenger_ID) AS Total_Passengers,
       COALESCE(SUM(F.Ticket_Amount), 0) AS Total_Ticket_Revenue
FROM CTE2 C2
LEFT JOIN Flight_Bookings F
	ON C2.Passenger_ID = F.Passenger_ID
GROUP BY C2.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each
-- passenger's current booking streak.
--
-- Definition:
-- Current streak = streak containing the
-- passenger's most recent booking date.
--
-- Note:
-- Ignore duplicate booking dates if a passenger
-- has multiple bookings on the same day.
--
-- Return:
-- Passenger_ID
-- Passenger_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only passengers whose
-- Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT P.Passenger_ID, P.Passenger_Name, F.Booking_Date
    FROM Passengers P
    INNER JOIN Flight_Bookings F
		ON P.Passenger_ID = F.Passenger_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Passenger_ID
           ORDER BY Booking_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Booking_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Passenger_ID, Passenger_Name,
		   COUNT(*) AS Streak,
           MIN(Booking_Date) AS Start_Date,
           MAX(Booking_Date) AS End_Date
	FROM CTE3
    GROUP BY Passenger_ID, Passenger_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Passenger_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Passenger_ID, Passenger_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >= 3
AND D_Rank = 1;


-- =========================================================
-- Q4
-- CASE STATEMENT
-- =========================================================

-- Categorize passengers based on confirmed
-- ticket revenue.
--
-- Platinum : Revenue >= 5500
-- Gold     : Revenue >= 3500
-- Silver   : Revenue >= 1500
-- Bronze   : Revenue < 1500
--
-- Return:
-- Passenger_ID
-- Passenger_Name
-- Total_Revenue
-- Passenger_Category

WITH CTE AS (
	SELECT P.Passenger_ID, P.Passenger_Name,
		   COALESCE(SUM(F.Ticket_Amount), 0) AS Total_Revenue
	FROM Passengers P
    LEFT JOIN Flight_Bookings F
		ON P.Passenger_ID = F.Passenger_ID
		AND F.Booking_Status = 'Confirmed'
    GROUP BY P.Passenger_ID, P.Passenger_Name
)
SELECT Passenger_ID, Passenger_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 5500 THEN 'Platinum'
       
			WHEN Total_Revenue >= 3500 THEN 'Gold'
            
            WHEN Total_Revenue >= 1500 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Passenger_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Flight_Bookings.
--
-- Requirements:
--
-- 1. When Ticket_Amount OR Booking_Status changes,
--    insert one record into Booking_Audit.
--
-- 2. Record:
--    Booking_ID
--    OLD.Ticket_Amount
--    NEW.Ticket_Amount
--    OLD.Booking_Status
--    NEW.Booking_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Ticket_Amount nor Booking_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Flight_Bookings
-- SET Ticket_Amount = 3500
-- WHERE Booking_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Booking_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.

DELIMITER //

CREATE TRIGGER Booking_Audit_Update
AFTER UPDATE ON Flight_Bookings
FOR EACH ROW
BEGIN
	IF OLD.Ticket_Amount <> NEW.Ticket_Amount
    OR OLD.Booking_Status <> NEW.Booking_Status
    THEN INSERT INTO Booking_Audit (Booking_ID, Old_Amount, New_Amount, Old_Status, New_Status, Action_Type)
		 VALUES	(
				OLD.Booking_ID,
                OLD.Ticket_Amount,
                NEW.Ticket_Amount,
                OLD.Booking_Status,
                NEW.Booking_Status,
                'UPDATE'
			);
	END IF;
END //

DELIMITER ;


UPDATE Flight_Bookings
SET Ticket_Amount = 3500
WHERE Booking_ID = 1014;

SELECT * FROM Booking_Audit;