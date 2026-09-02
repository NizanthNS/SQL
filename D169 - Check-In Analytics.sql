USE Daily_SQL;

-- DATASET : Check-In Analytics

CREATE TABLE Members (
    Member_ID INT PRIMARY KEY,
    Member_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Gym_Checkins (
    Checkin_ID INT PRIMARY KEY,
    Member_ID INT,
    Checkin_Date DATE,
    Workout_Type VARCHAR(50),
    Minutes_Worked INT,
    Calories_Burned INT,
    Checkin_Status VARCHAR(20)
);


INSERT INTO Members
VALUES	(1, 'Connor', 'London', '2025-01-10'),
		(2, 'Olivia', 'Toronto', '2025-02-15'),
		(3, 'Ethan', 'Sydney', '2025-03-05'),
		(4, 'Sophia', 'Berlin', '2025-03-20'),
		(5, 'Liam', 'Paris', '2025-04-12'),
		(6, 'Emma', 'Madrid', '2025-04-25'),
		(7, 'Noah', 'Amsterdam', '2025-05-08'),
		(8, 'Ava', 'Dublin', '2025-05-18'),
		(9, 'Lucas', 'Vienna', '2025-06-02'),
		(10, 'Mia', 'Copenhagen', '2025-06-15');

INSERT INTO Gym_Checkins
VALUES	(101, 1, '2025-06-01', 'Cardio', 45, 420, 'Completed'),
		(102, 1, '2025-06-02', 'Strength', 60, 500, 'Completed'),
		(103, 1, '2025-06-03', 'Cardio', 50, 460, 'Completed'),
		(104, 1, '2025-06-05', 'Yoga', 40, 250, 'Completed'),
		(105, 2, '2025-06-01', 'Strength', 70, 580, 'Completed'),
		(106, 2, '2025-06-02', 'Cardio', 55, 510, 'Completed'),
		(107, 2, '2025-06-04', 'Strength', 65, 550, 'Cancelled'),
		(108, 2, '2025-06-05', 'Cardio', 60, 530, 'Completed'),
		(109, 3, '2025-06-02', 'Yoga', 45, 280, 'Completed'),
		(110, 3, '2025-06-03', 'Cardio', 50, 470, 'Completed'),
		(111, 3, '2025-06-04', 'Strength', 75, 620, 'Completed'),
		(112, 3, '2025-06-07', 'Cardio', 60, 540, 'Completed'),
		(113, 4, '2025-06-01', 'Strength', 80, 650, 'Completed'),
		(114, 4, '2025-06-03', 'Cardio', 40, 390, 'Completed'),
		(115, 4, '2025-06-04', 'Yoga', 50, 300, 'Completed'),
		(116, 4, '2025-06-05', 'Strength', 70, 600, 'Completed'),
		(117, 5, '2025-06-02', 'Cardio', 55, 500, 'Completed'),
		(118, 5, '2025-06-03', 'Cardio', 65, 570, 'Completed'),
		(119, 5, '2025-06-05', 'Strength', 75, 630, 'Completed'),
		(120, 5, '2025-06-06', 'Yoga', 45, 270, 'Completed'),
		(121, 6, '2025-06-01', 'Yoga', 50, 310, 'Completed'),
		(122, 6, '2025-06-02', 'Cardio', 60, 550, 'Completed'),
		(123, 6, '2025-06-03', 'Strength', 70, 610, 'Completed'),
		(124, 6, '2025-06-06', 'Cardio', 65, 580, 'Completed'),
		(125, 7, '2025-06-03', 'Strength', 75, 640, 'Completed'),
		(126, 7, '2025-06-04', 'Cardio', 55, 500, 'Completed'),
		(127, 7, '2025-06-05', 'Strength', 80, 690, 'Completed'),
		(128, 7, '2025-06-08', 'Yoga', 45, 280, 'Completed'),
		(129, 8, '2025-06-01', 'Cardio', 40, 380, 'Completed'),
		(130, 8, '2025-06-02', 'Yoga', 50, 300, 'Completed'),
		(131, 8, '2025-06-03', 'Cardio', 60, 540, 'Completed'),
		(132, 8, '2025-06-05', 'Strength', 70, 620, 'Completed'),
		(133, 9, '2025-06-04', 'Strength', 65, 560, 'Completed'),
		(134, 9, '2025-06-05', 'Cardio', 55, 490, 'Completed'),
		(135, 9, '2025-06-06', 'Strength', 75, 650, 'Completed'),
		(136, 9, '2025-06-08', 'Cardio', 60, 530, 'Completed'),
		(137, 10, '2025-06-01', 'Yoga', 45, 270, 'Completed'),
		(138, 10, '2025-06-02', 'Cardio', 55, 500, 'Completed'),
		(139, 10, '2025-06-04', 'Strength', 70, 610, 'Completed'),
		(140, 10, '2025-06-05', 'Cardio', 60, 540, 'Completed');
        

SELECT *
FROM Members;

SELECT *
FROM Gym_Checkins;


-- Q1
-- Show each member's:
-- total check-ins
-- total minutes worked
-- average minutes worked
-- total completed check-ins.
--
-- Use both tables.
--
-- Return:
-- Member_ID
-- Member_Name
-- Total_Checkins
-- Total_Minutes_Worked
-- Average_Minutes_Worked
-- Total_Completed_Checkins

SELECT M.Member_ID, M.Member_Name,
	   COUNT(G.Checkin_ID) AS Total_Checkins,
       SUM(G.Minutes_Worked) AS Total_Minutes_Worked,
       ROUND(AVG(G.Minutes_Worked), 2) AS Average_Minutes_Worked,
       COUNT(
       CASE
			WHEN Checkin_Status = 'Completed'
			THEN 1
	   END) AS Total_Completed_Checkins
FROM Members M
INNER JOIN Gym_Checkins G
	ON M.Member_ID = G.Member_ID
GROUP BY M.Member_ID, M.Member_Name;


-- Q2
-- For each workout type, find:
-- total check-ins
-- total completed minutes
-- average calories burned
-- unique members.
--
-- Only Completed check-ins should be considered.
--
-- Return:
-- Workout_Type
-- Total_Checkins
-- Total_Completed_Minutes
-- Average_Calories_Burned
-- Unique_Members

SELECT Workout_Type,
	   COUNT(Checkin_ID) AS Total_Checkins,
       SUM(Minutes_Worked) AS Total_Completed_Minutes,
       ROUND(AVG(Calories_Burned), 2) AS Average_Calories_Burned,
       COUNT(DISTINCT Member_ID) AS Unique_Members
FROM Gym_Checkins
WHERE Checkin_Status = 'Completed'
GROUP BY Workout_Type;


-- Q3
-- Find the top 3 members in each city
-- based on total completed calories burned.
--
-- If tied, return all tied members.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Member_ID
-- Member_Name
-- Total_Completed_Calories

SELECT City, Member_ID, Member_Name, Total_Completed_Calories
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Completed_Calories DESC) AS D_Rank
	FROM (
		SELECT M.Member_ID, M.Member_Name, M.City,
			   SUM(G.Calories_Burned) AS Total_Completed_Calories
		FROM Members M
		INNER JOIN Gym_Checkins G
			ON M.Member_ID = G.Member_ID
		WHERE Checkin_Status = 'Completed'
		GROUP BY M.Member_ID, M.Member_Name, M.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find check-ins where the member's
-- minutes worked are greater than their previous
-- completed check-in.
--
-- Only Completed check-ins should be compared.
--
-- Use JOIN + LAG().
--
-- Return:
-- Member_ID
-- Member_Name
-- Checkin_Date
-- Minutes_Worked
-- Previous_Minutes_Worked

SELECT *
FROM (
	SELECT M.Member_ID, M.Member_Name, G.Checkin_Date, G.Minutes_Worked,
		   LAG(G.Minutes_Worked) OVER(PARTITION BY M.Member_ID
		   ORDER BY G.Checkin_Date, G.Checkin_ID) AS Previous_Minutes_Worked
	FROM Members M
	INNER JOIN Gym_Checkins G
		ON M.Member_ID = G.Member_ID
	WHERE Checkin_Status = 'Completed'
)P
WHERE Minutes_Worked > Previous_Minutes_Worked;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total members
-- total completed check-ins
-- total completed minutes
-- average completed minutes.
--
-- Definition:
-- Cohort Month = month in which the member joined.
--
-- Only Completed check-ins should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Members
-- Total_Completed_Checkins
-- Total_Completed_Minutes
-- Average_Completed_Minutes

WITH CTE AS (
    SELECT Member_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Members
),
CTE2 AS (
	SELECT *
    FROM Gym_Checkins
    WHERE Checkin_Status = 'Completed'
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Member_ID) AS Total_Members,
	   COUNT(G.Checkin_ID) AS Total_Completed_Checkins,
       SUM(G.Minutes_Worked) AS Total_Completed_Minutes,
       ROUND(AVG(G.Minutes_Worked), 2) AS Average_Completed_Minutes
FROM CTE C
LEFT JOIN CTE2 G
	ON C.Member_ID = G.Member_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means having a Completed check-in
-- on consecutive dates.
--
-- Ignore duplicate check-in dates for the same member.
-- Only Completed check-ins count.
--
-- Find each member's longest completed-check-in
-- date streak.
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
	WHERE Checkin_Status = 'Completed'
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
-- Find members whose total completed minutes
-- are greater than the average total completed minutes
-- of members in the same city.
--
-- Return:
-- Member_ID
-- Member_Name
-- City
-- Total_Completed_Minutes

SELECT Member_ID, Member_Name, City, Total_Completed_Minutes
FROM (
	SELECT *,
		   AVG(Total_Completed_Minutes) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT M.Member_ID, M.Member_Name, M.City,
			   SUM(G.Minutes_Worked) AS Total_Completed_Minutes
		FROM Members M
		INNER JOIN Gym_Checkins G
			ON M.Member_ID = G.Member_ID
		WHERE Checkin_Status = 'Completed'
		GROUP BY M.Member_ID, M.Member_Name, M.City
	)C
)A
WHERE Total_Completed_Minutes > Avg_City;


-- INTERVIEW CHALLENGE
-- For each workout type, find the member
-- with the highest total completed calories burned
-- for that workout type.
--
-- Only Completed check-ins should be considered.
--
-- If tied, return all tied members.
--
-- Return:
-- Workout_Type
-- Member_ID
-- Member_Name
-- Total_Completed_Calories

SELECT Workout_Type, Member_ID, Member_Name, Total_Completed_Calories
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Workout_Type
           ORDER BY Total_Completed_Calories DESC) AS D_Rank
	FROM (
		SELECT G.Workout_Type, M.Member_ID, M.Member_Name,
			   SUM(G.Calories_Burned) AS Total_Completed_Calories
		FROM Members M
		INNER JOIN Gym_Checkins G
			ON M.Member_ID = G.Member_ID
		WHERE Checkin_Status = 'Completed'
		GROUP BY G.Workout_Type, M.Member_ID, M.Member_Name
	)W
)D
WHERE D_Rank = 1;