USE Daily_SQL;

-- DATASET: Online Learning Activity

CREATE TABLE Students (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(100),
    Department VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Students
VALUES	(1,'Arun','Computer Science','Chennai','2024-01-10'),
		(2,'Divya','Commerce','Bangalore','2024-02-15'),
		(3,'Karthik','Computer Science','Chennai','2024-03-20'),
		(4,'Sneha','Science','Hyderabad','2024-01-25'),
		(5,'Rahul','Commerce','Bangalore','2024-04-12'),
		(6,'Priya','Science','Hyderabad','2024-02-28'),
		(7,'Vijay','Computer Science','Chennai','2024-05-05'),
		(8,'Anitha','Commerce','Bangalore','2024-03-18');

CREATE TABLE Learning_Activity (
    Activity_ID INT PRIMARY KEY,
    Student_ID INT,
    Activity_Date DATE,
    Course_Category VARCHAR(50),
    Minutes_Studied INT,
    Score INT,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID)
);

INSERT INTO Learning_Activity
VALUES	(101,1,'2024-06-01','Programming',90,85),
		(102,1,'2024-06-02','Database',75,88),
		(103,1,'2024-06-03','Programming',100,92),
		(104,1,'2024-06-10','Database',60,79),

		(105,2,'2024-06-01','Accounting',80,82),
		(106,2,'2024-06-02','Finance',70,76),
		(107,2,'2024-06-03','Accounting',90,89),
		(108,2,'2024-06-08','Finance',65,84),

		(109,3,'2024-06-01','Programming',120,95),
		(110,3,'2024-06-02','Database',100,93),
		(111,3,'2024-06-03','Programming',110,97),
		(112,3,'2024-06-04','Database',90,91),

		(113,4,'2024-06-01','Physics',75,78),
		(114,4,'2024-06-02','Chemistry',80,81),
		(115,4,'2024-06-05','Physics',90,86),
		(116,4,'2024-06-10','Chemistry',70,74),

		(117,5,'2024-06-01','Accounting',100,91),
		(118,5,'2024-06-02','Finance',85,87),
		(119,5,'2024-06-03','Accounting',95,94),
		(120,5,'2024-06-04','Finance',90,90),

		(121,6,'2024-06-01','Physics',110,92),
		(122,6,'2024-06-02','Chemistry',100,89),
		(123,6,'2024-06-03','Physics',105,95),
		(124,6,'2024-06-04','Chemistry',95,91),

		(125,7,'2024-06-01','Programming',70,80),
		(126,7,'2024-06-02','Database',85,84),
		(127,7,'2024-06-03','Programming',90,88),
		(128,7,'2024-06-07','Database',75,86),

		(129,8,'2024-06-01','Accounting',60,75),
		(130,8,'2024-06-02','Finance',80,83),
		(131,8,'2024-06-03','Accounting',85,88),
		(132,8,'2024-06-06','Finance',90,91);
        
SELECT *
FROM Students;

SELECT *
FROM Learning_Activity;

-- Q1
-- Show each student's:
-- total learning activities,
-- total minutes studied,
-- average study minutes,
-- average score.
--
-- Use both tables.
--
-- Return:
-- Student_ID
-- Student_Name
-- Total_Activities
-- Total_Minutes_Studied
-- Average_Study_Minutes
-- Average_Score

SELECT S.Student_ID, S.Student_Name,
       COUNT(L.Activity_ID) AS Total_Activities,
       SUM(L.Minutes_Studied) AS Total_Minutes_Studied,
       ROUND(AVG(L.Minutes_Studied), 2) AS Average_Study_Minutes,
	   ROUND(AVG(L.Score), 2) AS Average_Score
FROM Students S
INNER JOIN Learning_Activity L
    ON S.Student_ID = L.Student_ID
GROUP BY S.Student_ID, S.Student_Name;


-- Q2
-- For each course category, find:
-- total activities,
-- total minutes studied,
-- average score.
--
-- Return:
-- Course_Category
-- Total_Activities
-- Total_Minutes_Studied
-- Average_Score

SELECT Course_Category,
       COUNT(Activity_ID) AS Total_Activities,
       SUM(Minutes_Studied) AS Total_Minutes_Studied,
	   ROUND(AVG(Score), 2) AS Average_Score
FROM Learning_Activity
GROUP BY Course_Category;


-- Q3
-- Find the top 3 students by total minutes studied.
--
-- Use DENSE_RANK().
--
-- Return:
-- Student_ID
-- Student_Name
-- Department
-- Total_Minutes_Studied

SELECT Student_ID, Student_Name, Department, Total_Minutes_Studied
FROM (
	SELECT *,
		   DENSE_RANK() OVER(ORDER BY Total_Minutes_Studied DESC) AS D_Rank
	FROM (
		SELECT S.Student_ID, S.Student_Name, Department,
			   SUM(L.Minutes_Studied) AS Total_Minutes_Studied
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		GROUP BY S.Student_ID, S.Student_Name, Department
	)D
)T
WHERE D_Rank <= 3;


-- Q4
-- Find students whose score improved compared
-- with their previous learning activity.
--
-- The previous activity must be determined
-- by Activity_Date.
--
-- Use LAG().
--
-- Return:
-- Student_ID
-- Student_Name
-- Activity_Date
-- Score
-- Previous_Score

SELECT *
FROM (
	SELECT S.Student_ID, S.Student_Name, L.Activity_Date, L.Score,
		   LAG(L.Score) OVER(PARTITION BY S.Student_ID
		   ORDER BY L.Activity_Date, L.Activity_ID) AS Previous_Score
	FROM Students S
	INNER JOIN Learning_Activity L
		ON S.Student_ID = L.Student_ID
)S
WHERE Score > Previous_Score;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total students,
-- total minutes studied,
-- average score.
--
-- Definition:
-- Cohort Month = month in which the student joined.
--
-- Use both tables.
--
-- Return:
-- Cohort_Month
-- Total_Students
-- Total_Minutes_Studied
-- Average_Score

WITH CTE AS (
	SELECT Student_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Students
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Student_ID) AS Total_Students,
       SUM(L.Minutes_Studied) AS Total_Minutes_Studied,
	   ROUND(AVG(L.Score), 2) AS Average_Score
FROM CTE C
INNER JOIN Learning_Activity L
	ON C.Student_ID = L.Student_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each student's longest streak of learning
-- activities on consecutive days.
--
-- A streak means activity dates occurring
-- on consecutive calendar days.
--
-- Ignore duplicate activity dates for the same student.
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
-- Find students whose average score is greater
-- than the average score of students
-- in the same department.
--
-- Return:
-- Student_ID
-- Student_Name
-- Department
-- Average_Score

SELECT Student_ID, Student_Name, Department, Average_Score
FROM (
	SELECT *,
		   AVG(Average_Score) OVER(PARTITION BY Department) AS Avg_Score
	FROM (
		SELECT S.Student_ID, S.Student_Name, S.Department,
			   ROUND(AVG(L.Score), 2) AS Average_Score
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		GROUP BY S.Student_ID, S.Student_Name, S.Department
	)A
)S
WHERE Average_Score > Avg_Score;


-- INTERVIEW CHALLENGE
-- For each course category, find the student who
-- spent the greatest total number of minutes
-- studying that category.
--
-- If tied, return all tied students.
--
-- Return:
-- Course_Category
-- Student_ID
-- Student_Name
-- Total_Minutes_Studied

SELECT Course_Category, Student_ID, Student_Name, Total_Minutes_Studied
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Course_Category
           ORDER BY Total_Minutes_Studied DESC) AS D_Rank
	FROM (
		SELECT S.Student_ID, S.Student_Name, L.Course_Category,
			   SUM(L.Minutes_Studied) AS Total_Minutes_Studied
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		GROUP BY S.Student_ID, S.Student_Name, L.Course_Category
	)H
)S
WHERE D_Rank = 1;