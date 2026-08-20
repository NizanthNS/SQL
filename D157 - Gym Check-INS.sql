USE Daily_SQL;

-- DATASET : GYM Check-INS

-- TABLE 1: Members

CREATE TABLE Members (
    Member_ID INT PRIMARY KEY,
    Member_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);


INSERT INTO Members
VALUES	(1, 'Arun', 'Chennai', '2024-01-15'),
		(2, 'Bala', 'Chennai', '2024-02-10'),
		(3, 'Charan', 'Chennai', '2024-02-25'),
		(4, 'Dinesh', 'Coimbatore', '2024-03-05'),
		(5, 'Eshan', 'Coimbatore', '2024-03-18'),
		(6, 'Fahad', 'Coimbatore', '2024-04-02'),
		(7, 'Gokul', 'Madurai', '2024-04-12'),
		(8, 'Hari', 'Madurai', '2024-05-08'),
		(9, 'Irfan', 'Madurai', '2024-05-20'),
		(10, 'Jeeva', 'Chennai', '2024-06-01');

-- TABLE 2: Gym_Checkins

CREATE TABLE Gym_Checkins (
    Checkin_ID INT PRIMARY KEY,
    Member_ID INT,
    Checkin_Date DATE,
    Workout_Type VARCHAR(50),
    Workout_Minutes INT,
    Calories_Burned INT,
    Checkin_Status VARCHAR(20),
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID)
);


INSERT INTO Gym_Checkins
VALUES	(101, 1, '2024-06-01', 'Cardio', 45, 400, 'Success'),
		(102, 1, '2024-06-02', 'Strength', 60, 500, 'Success'),
		(103, 1, '2024-06-03', 'Cardio', 50, 450, 'Success'),
		(104, 1, '2024-06-05', 'Strength', 70, 600, 'Success'),
		(105, 1, '2024-06-05', 'Cardio', 40, 350, 'Success'),

		(106, 2, '2024-06-01', 'Yoga', 40, 250, 'Success'),
		(107, 2, '2024-06-03', 'Cardio', 55, 480, 'Success'),
		(108, 2, '2024-06-04', 'Strength', 65, 550, 'Failed'),
		(109, 2, '2024-06-05', 'Cardio', 60, 520, 'Success'),

		(110, 3, '2024-06-02', 'Strength', 75, 650, 'Success'),
		(111, 3, '2024-06-03', 'Strength', 80, 700, 'Success'),
		(112, 3, '2024-06-04', 'Cardio', 50, 460, 'Success'),
		(113, 3, '2024-06-06', 'Yoga', 45, 280, 'Success'),

		(114, 4, '2024-06-01', 'Cardio', 60, 550, 'Success'),
		(115, 4, '2024-06-02', 'Cardio', 65, 600, 'Success'),
		(116, 4, '2024-06-03', 'Strength', 70, 620, 'Success'),
		(117, 4, '2024-06-04', 'Strength', 75, 680, 'Success'),

		(118, 5, '2024-06-01', 'Yoga', 45, 260, 'Success'),
		(119, 5, '2024-06-02', 'Cardio', 55, 500, 'Success'),
		(120, 5, '2024-06-04', 'Strength', 70, 640, 'Success'),
		(121, 5, '2024-06-05', 'Cardio', 60, 540, 'Success'),

		(122, 6, '2024-06-02', 'Strength', 80, 720, 'Success'),
		(123, 6, '2024-06-03', 'Cardio', 70, 650, 'Success'),
		(124, 6, '2024-06-04', 'Strength', 85, 780, 'Success'),

		(125, 7, '2024-06-01', 'Cardio', 50, 450, 'Success'),
		(126, 7, '2024-06-03', 'Yoga', 40, 240, 'Success'),
		(127, 7, '2024-06-04', 'Cardio', 55, 500, 'Success'),
		(128, 7, '2024-06-05', 'Strength', 65, 580, 'Success'),

		(129, 8, '2024-06-02', 'Yoga', 50, 300, 'Success'),
		(130, 8, '2024-06-03', 'Cardio', 60, 550, 'Success'),
		(131, 8, '2024-06-04', 'Strength', 75, 680, 'Success'),
		(132, 8, '2024-06-06', 'Cardio', 65, 600, 'Success'),

		(133, 9, '2024-06-01', 'Strength', 70, 620, 'Success'),
		(134, 9, '2024-06-02', 'Strength', 75, 680, 'Success'),
		(135, 9, '2024-06-03', 'Cardio', 65, 590, 'Success'),
		(136, 9, '2024-06-05', 'Cardio', 70, 640, 'Success'),

		(137, 10, '2024-06-01', 'Yoga', 35, 220, 'Success'),
		(138, 10, '2024-06-02', 'Cardio', 45, 400, 'Success'),
		(139, 10, '2024-06-04', 'Strength', 60, 550, 'Success'),
		(140, 10, '2024-06-05', 'Cardio', 55, 480, 'Success');


SELECT *
FROM Members;

SELECT *
FROM Gym_Checkins;


-- Q1
-- Show each member's:
-- total check-ins
-- total workout minutes
-- average workout minutes
-- total successful check-ins.
--
-- Use both tables.
--
-- Return:
-- Member_ID
-- Member_Name
-- Total_Checkins
-- Total_Workout_Minutes
-- Average_Workout_Minutes
-- Total_Successful_Checkins

SELECT M.Member_ID, M.Member_Name,
	   COUNT(G.Checkin_ID) AS Total_Checkins,
       SUM(G.Workout_Minutes) AS Total_Workout_Minutes,
       ROUND(AVG(G.Workout_Minutes), 2) AS Average_Workout_Minutes,
       COUNT(CASE
				WHEN Checkin_Status = 'Success'
                THEN 1
			  END) AS Total_Successful_Checkins
FROM Members M
INNER JOIN Gym_Checkins G
	ON M.Member_ID = G.Member_ID
GROUP BY M.Member_ID, M.Member_Name;


-- Q2
-- For each workout type, find:
-- total check-ins
-- total workout minutes
-- average workout minutes
-- unique members.
--
-- Return:
-- Workout_Type
-- Total_Checkins
-- Total_Workout_Minutes
-- Average_Workout_Minutes
-- Unique_Members

SELECT Workout_Type,
	   COUNT(Checkin_ID) AS Total_Checkins,
       SUM(Workout_Minutes) AS Total_Workout_Minutes,
       ROUND(AVG(Workout_Minutes), 2) AS Average_Workout_Minutes,
       COUNT(DISTINCT Member_ID) AS Unique_Members
FROM Gym_Checkins
GROUP BY Workout_Type;


-- Q3
-- Find the top 3 members in each city
-- based on total calories burned.
--
-- If tied, return all tied members.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Member_ID
-- Member_Name
-- Total_Calories_Burned

SELECT City, Member_ID, Member_Name, Total_Calories_Burned
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Calories_Burned DESC) AS D_Rank
	FROM (
		SELECT M.Member_ID, M.Member_Name, M.City,
			   SUM(G.Calories_Burned) AS Total_Calories_Burned
		FROM Members M
		INNER JOIN Gym_Checkins G
			ON M.Member_ID = G.Member_ID
		GROUP BY M.Member_ID, M.Member_Name, M.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find check-ins where the workout minutes
-- are greater than the member's previous check-in.
--
-- Use JOIN + LAG().
--
-- Return:
-- Member_ID
-- Member_Name
-- Checkin_Date
-- Workout_Minutes
-- Previous_Workout_Minutes

SELECT *
FROM (
	SELECT M.Member_ID, M.Member_Name, G.Checkin_Date, G.Workout_Minutes,
		   LAG(G.Workout_Minutes) OVER(PARTITION BY M.Member_ID
		   ORDER BY G.Checkin_Date, G.Checkin_ID) AS Previous_Workout_Minutes
	FROM Members M
	INNER JOIN Gym_Checkins G
		ON M.Member_ID = G.Member_ID
)P
WHERE Workout_Minutes > Previous_Workout_Minutes;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total members
-- total check-ins
-- total workout minutes
-- average workout minutes.
--
-- Definition:
-- Cohort Month = month in which the member joined.
--
-- Return:
-- Cohort_Month
-- Total_Members
-- Total_Checkins
-- Total_Workout_Minutes
-- Average_Workout_Minutes

WITH CTE AS (
    SELECT Member_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Members
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Member_ID) AS Total_Members,
	   COUNT(G.Checkin_ID) AS Total_Checkins,
       SUM(G.Workout_Minutes) AS Total_Workout_Minutes,
       ROUND(AVG(G.Workout_Minutes), 2) AS Average_Workout_Minutes
FROM CTE C
INNER JOIN Gym_Checkins G
	ON C.Member_ID = G.Member_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means checking in on consecutive dates.
--
-- Ignore duplicate check-in dates for the same member.
--
-- Find each member's longest check-in-date streak.
--
-- If multiple streaks have the same length,
-- return the most recent streak.
--
-- Return:
-- Member_ID
-- Member_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT M.Member_ID, M.Member_Name, G.Checkin_Date
	FROM Members M
	INNER JOIN Gym_Checkins G
		ON M.Member_ID = G.Member_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Member_ID
           ORDER BY Checkin_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Checkin_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Member_ID, Member_Name,
		   COUNT(*) AS Streak,
           MIN(Checkin_Date) AS Start_Date,
           MAX(Checkin_Date) AS End_Date
	FROM CTE3
    GROUP BY Member_ID, Member_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Member_ID
           ORDER BY Streak DESC, End_Date DESC) AS Row_Num
	FROM CTE4
)
SELECT Member_ID, Member_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find members whose total workout minutes
-- are greater than the average total workout minutes
-- of members in the same city.
--
-- Return:
-- Member_ID
-- Member_Name
-- City
-- Total_Workout_Minutes

SELECT Member_ID, Member_Name, City, Total_Workout_Minutes
FROM (
	SELECT *,
		   AVG(Total_Workout_Minutes) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT M.Member_ID, M.Member_Name, M.City,
			   SUM(G.Workout_Minutes) AS Total_Workout_Minutes
		FROM Members M
		INNER JOIN Gym_Checkins G
			ON M.Member_ID = G.Member_ID
		GROUP BY M.Member_ID, M.Member_Name, M.City
	)C
)A
WHERE Total_Workout_Minutes > Avg_City;


-- INTERVIEW CHALLENGE
-- For each workout type, find the member
-- with the highest total calories burned
-- for that workout type.
--
-- If tied, return all tied members.
--
-- Return:
-- Workout_Type
-- Member_ID
-- Member_Name
-- Total_Calories_Burned

SELECT Workout_Type, Member_ID, Member_Name, Total_Calories_Burned
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Workout_Type
           ORDER BY Total_Calories_Burned DESC) AS D_Rank
	FROM (
		SELECT G.Workout_Type, M.Member_ID, M.Member_Name,
			   SUM(G.Calories_Burned) AS Total_Calories_Burned
		FROM Members M
		INNER JOIN Gym_Checkins G
			ON M.Member_ID = G.Member_ID
		GROUP BY G.Workout_Type, M.Member_ID, M.Member_Name
	)W
)D
WHERE D_Rank = 1;