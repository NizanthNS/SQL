-- =========================================================
-- SESSION — Hospital Appointment Analytics & Auditing
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — PATIENTS
-- =========================================================

DROP TABLE IF EXISTS Appointment_Audit;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;

CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100),
    City VARCHAR(50),
    Registration_Date DATE
);

INSERT INTO Patients
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
-- TABLE 2 — APPOINTMENTS
-- =========================================================

CREATE TABLE Appointments (
    Appointment_ID INT PRIMARY KEY,
    Patient_ID INT,
    Appointment_Date DATE,
    Department VARCHAR(50),
    Consultation_Fee DECIMAL(10,2),
    Appointment_Status VARCHAR(20),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

INSERT INTO Appointments
VALUES
(1001,1,'2025-01-10','Cardiology',500,'Completed'),
(1002,1,'2025-01-11','Neurology',700,'Completed'),
(1003,1,'2025-01-12','Orthopedics',400,'Completed'),
(1004,1,'2025-03-01','Dermatology',600,'Completed'),

(1005,2,'2025-01-20','Cardiology',800,'Completed'),
(1006,2,'2025-02-15','Neurology',600,'Completed'),
(1007,2,'2025-04-01','Orthopedics',300,'Cancelled'),

(1008,3,'2025-01-25','Dermatology',1200,'Completed'),
(1009,3,'2025-01-26','Cardiology',500,'Completed'),
(1010,3,'2025-01-27','Neurology',400,'Completed'),
(1011,3,'2025-05-01','Orthopedics',900,'Completed'),

(1012,4,'2025-02-05','Cardiology',600,'Completed'),
(1013,4,'2025-03-05','Dermatology',700,'Completed'),

(1014,5,'2025-02-20','Neurology',1500,'Completed'),
(1015,5,'2025-03-20','Cardiology',1300,'Completed'),

(1016,6,'2025-03-01','Orthopedics',400,'Completed'),
(1017,6,'2025-03-02','Dermatology',450,'Completed'),
(1018,6,'2025-03-03','Cardiology',350,'Completed'),

(1019,7,'2025-04-01','Neurology',800,'Completed'),
(1020,7,'2025-05-01','Dermatology',900,'Completed'),

(1021,8,'2025-04-10','Orthopedics',450,'Completed'),
(1022,8,'2025-06-01','Cardiology',550,'Completed'),

(1023,9,'2025-04-15','Dermatology',300,'Completed'),
(1024,9,'2025-04-16','Cardiology',400,'Completed'),
(1025,9,'2025-04-17','Neurology',500,'Completed'),

(1026,10,'2025-05-05','Cardiology',1400,'Completed'),
(1027,10,'2025-06-10','Dermatology',1200,'Completed');

-- =========================================================
-- TABLE 3 — APPOINTMENT AUDIT
-- =========================================================

CREATE TABLE Appointment_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Appointment_ID INT,
    Old_Fee DECIMAL(10,2),
    New_Fee DECIMAL(10,2),
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Action_Type VARCHAR(20),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Patients;
SELECT * FROM Appointments;
SELECT * FROM Appointment_Audit;

-- =========================================================
-- Q1
-- DATE LOGIC
-- =========================================================

-- Find patients who booked another appointment
-- within 2 days of their previous appointment.
--
-- Return:
-- Patient_ID
-- Patient_Name

WITH CTE AS (
	SELECT P.Patient_ID, P.Patient_Name, A.Appointment_Date,
		   LAG(A.Appointment_Date) OVER(PARTITION BY P.Patient_ID
           ORDER BY A.Appointment_Date, A.Appointment_ID) AS Previous
	FROM Patients P
    INNER JOIN Appointments A
		ON P.Patient_ID = A.Patient_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Appointment_Date, Previous) AS Gap_Days
	FROM CTE
)
SELECT DISTINCT Patient_ID, Patient_Name
FROM CTE2
WHERE Gap_Days <= 2;


-- =========================================================
-- Q2
-- COHORT ANALYSIS
-- =========================================================

-- For each cohort month, find:
-- Total_Patients
-- Total_Consultation_Revenue
--
-- Definition:
-- A patient's cohort month is the month
-- of their first appointment date.
--
-- Return:
-- Cohort_Month
-- Total_Patients
-- Total_Consultation_Revenue

WITH CTE AS (
	SELECT Patient_ID,
		   MIN(Appointment_Date) AS First_
	FROM Appointments
    GROUP BY Patient_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT A.Patient_ID) AS Total_Patients,
       COALESCE(SUM(A.Consultation_Fee), 0) AS Total_Consultation_Revenue
FROM CTE2 C
LEFT JOIN Appointments A
	ON C.Patient_ID = A.Patient_ID
GROUP BY C.Cohort_Month;


-- =========================================================
-- Q3
-- GAP & ISLAND
-- =========================================================

-- Find the start date and end date of each patient's
-- current appointment streak.
--
-- Definition:
-- Current streak = streak containing the patient's
-- most recent appointment date.
--
-- Note:
-- Ignore duplicate appointment dates if a patient
-- has multiple appointments on the same day.
--
-- Return:
-- Patient_ID
-- Patient_Name
-- Current_Streak
-- Start_Date
-- End_Date
--
-- Return only patients whose Current_Streak >= 3.

WITH CTE AS (
	SELECT DISTINCT P.Patient_ID, P.Patient_Name, A.Appointment_Date
    FROM Patients P
    INNER JOIN Appointments A
		ON P.Patient_ID = A.Patient_ID
),
CTE2 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Patient_ID
           ORDER BY Appointment_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Appointment_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Patient_ID, Patient_Name,
		   COUNT(*) AS Streak,
           MIN(Appointment_Date) AS Start_Date,
           MAX(Appointment_Date) AS End_Date
	FROM CTE3
    GROUP BY Patient_ID, Patient_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Patient_ID
           ORDER BY End_Date DESC) AS D_Rank
	FROM CTE4
)
SELECT Patient_ID, Patient_Name, Streak AS Current_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Streak >=3
AND D_Rank = 1;


-- =========================================================
-- Q4
-- CASE STATEMENT
-- =========================================================

-- Categorize patients based on completed
-- consultation revenue.
--
-- Platinum : Revenue >= 3500
-- Gold     : Revenue >= 2500
-- Silver   : Revenue >= 1000
-- Bronze   : Revenue < 1000
--
-- Return:
-- Patient_ID
-- Patient_Name
-- Total_Revenue
-- Patient_Category

WITH CTE AS (
	SELECT P.Patient_ID, P.Patient_Name,
		   COALESCE(SUM(A.Consultation_Fee), 0) AS Total_Revenue
	FROM Patients P
    LEFT JOIN Appointments A
		ON P.Patient_ID = A.Patient_ID
		AND A.Appointment_Status = 'Completed'
    GROUP BY P.Patient_ID, P.Patient_Name
)
SELECT Patient_ID, Patient_Name, Total_Revenue,

	   CASE 
			WHEN Total_Revenue >= 3500 THEN 'Platinum'
       
			WHEN Total_Revenue >= 2500 THEN 'Gold'
            
            WHEN Total_Revenue >= 1000 THEN 'Silver'
            
            ELSE 'Bronze'
	   END AS Patient_Category
FROM CTE;


-- =========================================================
-- Q5
-- TRIGGER
-- =========================================================

-- Create a MySQL AFTER UPDATE trigger
-- on Appointments.
--
-- Requirements:
--
-- 1. When Consultation_Fee OR Appointment_Status changes,
--    insert one record into Appointment_Audit.
--
-- 2. Record:
--    Appointment_ID
--    OLD.Consultation_Fee
--    NEW.Consultation_Fee
--    OLD.Appointment_Status
--    NEW.Appointment_Status
--
-- 3. Set Action_Type = 'UPDATE'
--
-- 4. Do NOT insert an audit row if neither
--    Consultation_Fee nor Appointment_Status changed.
--
-- 5. Use OLD and NEW references.
--
-- Test your trigger:
--
-- UPDATE Appointments
-- SET Consultation_Fee = 2000
-- WHERE Appointment_ID = 1014;
--
-- Verify:
--
-- SELECT * FROM Appointment_Audit;
--
-- Return:
-- CREATE TRIGGER statement
-- and test results.

DELIMITER //

CREATE TRIGGER Appointment_update
AFTER UPDATE ON Appointments
FOR EACH ROW
BEGIN
	IF OLD.Appointment_Status <> NEW.Appointment_Status OR
	   OLD.Consultation_Fee <> NEW.Consultation_Fee
	THEN 
		INSERT INTO Appointment_Audit (Appointment_ID, Old_Fee, New_Fee, Old_Status, New_Status, Action_Type)
        VALUES (
			OLD.Appointment_ID,
            OLD.Consultation_Fee,
            NEW.Consultation_Fee,
            OLD.Appointment_Status,
            NEW.Appointment_Status,
            'UPDATE'
		);
	END IF;
END //

DELIMITER ;

UPDATE Appointments
SET Consultation_Fee = 2000
WHERE Appointment_ID = 1014;

SELECT * FROM Appointment_Audit;