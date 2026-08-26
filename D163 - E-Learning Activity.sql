USE Daily_SQL;

-- DATASET : E-Learning Activity

CREATE TABLE Students (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Students
VALUES	(1, 'Connor', 'London', '2025-01-10'),
		(2, 'Ash', 'Toronto', '2025-01-15'),
		(3, 'Ethan', 'Sydney', '2025-02-05'),
		(4, 'Liam', 'Vancouver', '2025-02-20'),
		(5, 'Noah', 'Berlin', '2025-03-01'),
		(6, 'Oliver', 'Melbourne', '2025-03-12'),
		(7, 'Mason', 'Chicago', '2025-04-08'),
		(8, 'Lucas', 'New York', '2025-04-18');


CREATE TABLE Learning_Activity (
    Activity_ID INT PRIMARY KEY,
    Student_ID INT,
    Course_Name VARCHAR(100),
    Activity_Date DATE,
    Minutes_Spent INT,
    Activity_Status VARCHAR(20),
    Score INT,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID)
);

INSERT INTO Learning_Activity
VALUES	(101, 1, 'Python', '2025-01-11', 60, 'Completed', 85),
		(102, 1, 'SQL', '2025-01-12', 75, 'Completed', 90),
		(103, 1, 'Python', '2025-01-15', 45, 'In Progress', 70),
		(104, 1, 'SQL', '2025-01-16', 90, 'Completed', 95),

		(105, 2, 'Python', '2025-01-16', 50, 'Completed', 82),
		(106, 2, 'SQL', '2025-01-17', 80, 'Completed', 88),
		(107, 2, 'Java', '2025-01-20', 65, 'In Progress', 72),

		(108, 3, 'Python', '2025-02-06', 90, 'Completed', 91),
		(109, 3, 'SQL', '2025-02-07', 70, 'Completed', 87),
		(110, 3, 'Python', '2025-02-08', 100, 'Completed', 94),
		(111, 3, 'Java', '2025-02-12', 55, 'In Progress', 68),

		(112, 4, 'SQL', '2025-02-21', 85, 'Completed', 89),
		(113, 4, 'Python', '2025-02-22', 95, 'Completed', 93),
		(114, 4, 'Java', '2025-02-25', 60, 'Completed', 78),

		(115, 5, 'Python', '2025-03-02', 70, 'Completed', 84),
		(116, 5, 'SQL', '2025-03-03', 80, 'Completed', 90),
		(117, 5, 'Java', '2025-03-05', 45, 'In Progress', 71),

		(118, 6, 'Python', '2025-03-13', 100, 'Completed', 96),
		(119, 6, 'SQL', '2025-03-14', 85, 'Completed', 91),
		(120, 6, 'Java', '2025-03-15', 75, 'Completed', 88),

		(121, 7, 'SQL', '2025-04-09', 90, 'Completed', 92),
		(122, 7, 'Python', '2025-04-10', 80, 'Completed', 89),
		(123, 7, 'SQL', '2025-04-11', 95, 'Completed', 94),

		(124, 8, 'Python', '2025-04-19', 65, 'Completed', 81),
		(125, 8, 'SQL', '2025-04-20', 75, 'Completed', 86),
		(126, 8, 'Java', '2025-04-23', 90, 'Completed', 93);
        
SELECT *
FROM Students;

SELECT *
FROM Learning_Activity;
        

-- Q1
-- Show each student's:
-- total learning activities
-- total minutes spent
-- average minutes spent
-- total completed activities.
--
-- Use both tables.
--
-- Return:
-- Student_ID
-- Student_Name
-- Total_Activities
-- Total_Minutes_Spent
-- Average_Minutes_Spent
-- Total_Completed_Activities

SELECT S.Student_ID, S.Student_Name,
       COUNT(L.Activity_ID) AS Total_Activities,
       SUM(L.Minutes_Spent) AS Total_Minutes_Spent,
       ROUND(AVG(L.Minutes_Spent), 2) AS Average_Minutes_Spent,
	   COUNT(CASE 
       WHEN	Activity_Status = 'Completed'
       THEN 1
       END) AS Total_Completed_Activities
FROM Students S
INNER JOIN Learning_Activity L
    ON S.Student_ID = L.Student_ID
GROUP BY S.Student_ID, S.Student_Name;


-- Q2
-- For each course, find:
-- total activities
-- total minutes spent
-- average score
-- unique students.
--
-- Return:
-- Course_Name
-- Total_Activities
-- Total_Minutes_Spent
-- Average_Score
-- Unique_Students

SELECT Course_Name,
       COUNT(Activity_ID) AS Total_Activities,
       SUM(Minutes_Spent) AS Total_Minutes_Spent,
	   ROUND(AVG(Score), 2) AS Average_Score,
       COUNT(DISTINCT Student_ID) AS Unique_Students
FROM Learning_Activity
GROUP BY Course_Name;


-- Q3
-- Find the top 3 students in each city
-- based on total minutes spent.
--
-- If tied, return all tied students.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Student_ID
-- Student_Name
-- Total_Minutes_Spent

SELECT City, Student_ID, Student_Name, Total_Minutes_Spent
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Minutes_Spent DESC) AS D_Rank
	FROM (
		SELECT S.City, S.Student_ID, S.Student_Name,
			   SUM(L.Minutes_Spent) AS Total_Minutes_Spent
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		GROUP BY S.City, S.Student_ID, S.Student_Name
	)D
)C
WHERE D_Rank <= 3;


-- Q4
-- Find learning activities where the student's
-- minutes spent are greater than their previous activity.
--
-- Only compare activities from the same student.
--
-- Use JOIN + LAG().
--
-- Return:
-- Student_ID
-- Student_Name
-- Activity_Date
-- Minutes_Spent
-- Previous_Minutes_Spent

SELECT *
FROM (
	SELECT S.Student_ID, S.Student_Name, L.Activity_Date, L.Minutes_Spent,
		   LAG(L.Minutes_Spent) OVER(PARTITION BY S.Student_ID
		   ORDER BY L.Activity_Date, L.Activity_ID) AS Previous_Minutes_Spent
	FROM Students S
	INNER JOIN Learning_Activity L
		ON S.Student_ID = L.Student_ID
)S
WHERE Minutes_Spent > Previous_Minutes_Spent;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total students
-- total completed activities
-- total completed minutes
-- average completed minutes.
--
-- Definition:
-- Cohort Month = month in which the student joined.
--
-- Only Completed activities should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Students
-- Total_Completed_Activities
-- Total_Completed_Minutes
-- Average_Completed_Minutes

WITH CTE AS (
    SELECT Student_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Students
),
CTE2 AS (
    SELECT *
    FROM Learning_Activity
    WHERE Activity_Status = 'Completed'
)
SELECT C.Cohort_Month,
       COUNT(DISTINCT C.Student_ID) AS Total_Students,
       COUNT(L.Activity_ID) AS Total_Completed_Activities,
       SUM(L.Minutes_Spent) AS Total_Completed_Minutes,
       ROUND(AVG(L.Minutes_Spent), 2) AS Average_Completed_Minutes
FROM CTE C
LEFT JOIN CTE2 L
    ON C.Student_ID = L.Student_ID
GROUP BY C.Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means having learning activity
-- on consecutive dates.
--
-- Ignore duplicate activity dates for the same student.
--
-- Find each student's longest activity-date streak.
--
-- If multiple streaks have the same length,
-- return the most recent streak.
--
-- Return:
-- Student_ID
-- Student_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT S.Student_ID, S.Student_Name, L.Activity_Date
	FROM Students S
	INNER JOIN Learning_Activity L
		ON S.Student_ID = L.Student_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Student_ID
		   ORDER BY Activity_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Activity_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Student_ID, Student_Name,
		   COUNT(*) AS Streak,
		   MIN(Activity_Date) AS Start_Date,
           MAX(Activity_Date) AS End_Date
	FROM CTE3
    GROUP BY Student_ID, Student_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Student_ID
           ORDER BY Streak DESC, End_Date DESC) AS  Row_Num
	FROM CTE4
)
SELECT Student_ID, Student_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;



-- BONUS+
-- Find students whose total completed minutes
-- are greater than the average total completed minutes
-- of students in the same city.
--
-- Return:
-- Student_ID
-- Student_Name
-- City
-- Total_Completed_Minutes

SELECT Student_ID, Student_Name, City, Total_Completed_Minutes
FROM (
	SELECT *,
		   AVG(Total_Completed_Minutes) OVER(PARTITION BY City) AS Avg_Minutes
	FROM (
		SELECT S.Student_ID, S.Student_Name, S.City,
			   SUM(L.Minutes_Spent) AS Total_Completed_Minutes
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		WHERE Activity_Status = 'Completed'
		GROUP BY S.Student_ID, S.Student_Name, S.City
	)A
)T
WHERE Total_Completed_Minutes > Avg_Minutes;


-- INTERVIEW CHALLENGE
-- For each course, find the student
-- with the highest total score.
--
-- If tied, return all tied students.
--
-- Return:
-- Course_Name
-- Student_ID
-- Student_Name
-- Total_Score

SELECT Course_Name, Student_ID, Student_Name, Total_Score
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Course_Name
           ORDER BY Total_Score DESC) AS D_Rank
	FROM (
		SELECT L.Course_Name, S.Student_ID, S.Student_Name,
			   SUM(L.Score) AS Total_Score
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		GROUP BY L.Course_Name, S.Student_ID, S.Student_Name
	)H
)S
WHERE D_Rank = 1;