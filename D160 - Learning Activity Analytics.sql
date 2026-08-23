USE Daily_SQL;

-- Learning Activity Analytics

CREATE TABLE Students (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(100),
    City VARCHAR(100),
    Join_Date DATE
);

INSERT INTO Students
VALUES	(1, 'Connor', 'Chennai', '2025-01-10'),
		(2, 'Ashley', 'Chennai', '2025-01-15'),
		(3, 'Ethan', 'Bangalore', '2025-02-05'),
		(4, 'Daniel', 'Bangalore', '2025-02-20'),
		(5, 'Mason', 'Mumbai', '2025-03-01'),
		(6, 'Sophia', 'Mumbai', '2025-03-12'),
		(7, 'Ryan', 'Chennai', '2025-04-08'),
		(8, 'Emma', 'Bangalore', '2025-04-18');

CREATE TABLE Learning_Activity (
    Activity_ID INT PRIMARY KEY,
    Student_ID INT,
    Activity_Date DATE,
    Course_Name VARCHAR(100),
    Activity_Type VARCHAR(50),
    Minutes_Spent INT,
    Activity_Status VARCHAR(50),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID)
);

INSERT INTO Learning_Activity
VALUES	(101, 1, '2025-05-01', 'Python', 'Video', 60, 'Completed'),
		(102, 1, '2025-05-02', 'Python', 'Quiz', 30, 'Completed'),
		(103, 1, '2025-05-03', 'SQL', 'Practice', 90, 'Completed'),
		(104, 1, '2025-05-05', 'SQL', 'Video', 45, 'Completed'),

		(105, 2, '2025-05-01', 'SQL', 'Practice', 70, 'Completed'),
		(106, 2, '2025-05-03', 'Python', 'Video', 50, 'Completed'),
		(107, 2, '2025-05-04', 'Python', 'Quiz', 40, 'Pending'),

		(108, 3, '2025-05-02', 'Python', 'Video', 80, 'Completed'),
		(109, 3, '2025-05-03', 'SQL', 'Practice', 100, 'Completed'),
		(110, 3, '2025-05-04', 'SQL', 'Quiz', 60, 'Completed'),
		(111, 3, '2025-05-06', 'Python', 'Video', 90, 'Completed'),

		(112, 4, '2025-05-01', 'SQL', 'Practice', 120, 'Completed'),
		(113, 4, '2025-05-02', 'SQL', 'Video', 80, 'Completed'),
		(114, 4, '2025-05-04', 'Python', 'Quiz', 50, 'Pending'),

		(115, 5, '2025-05-01', 'Python', 'Video', 40, 'Completed'),
		(116, 5, '2025-05-02', 'Python', 'Practice', 60, 'Completed'),
		(117, 5, '2025-05-03', 'SQL', 'Quiz', 70, 'Completed'),

		(118, 6, '2025-05-02', 'SQL', 'Video', 90, 'Completed'),
		(119, 6, '2025-05-03', 'SQL', 'Practice', 110, 'Completed'),
		(120, 6, '2025-05-05', 'Python', 'Video', 50, 'Completed'),

		(121, 7, '2025-05-01', 'Python', 'Practice', 100, 'Completed'),
		(122, 7, '2025-05-02', 'SQL', 'Video', 80, 'Completed'),
		(123, 7, '2025-05-03', 'SQL', 'Quiz', 60, 'Completed'),

		(124, 8, '2025-05-03', 'Python', 'Video', 70, 'Completed'),
		(125, 8, '2025-05-04', 'Python', 'Practice', 90, 'Completed'),
		(126, 8, '2025-05-05', 'SQL', 'Quiz', 100, 'Completed');

        
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
-- average minutes spent
-- unique students.
--
-- Return:
-- Course_Name
-- Total_Activities
-- Total_Minutes_Spent
-- Average_Minutes_Spent
-- Unique_Students

SELECT Course_Name,
       COUNT(Activity_ID) AS Total_Activities,
       SUM(Minutes_Spent) AS Total_Minutes_Spent,
	   ROUND(AVG(Minutes_Spent), 2) AS Average_Minutes_Spent,
       COUNT(DISTINCT Student_ID) AS Unique_Students
FROM Learning_Activity
GROUP BY Course_Name;


-- Q3
-- Find the top 3 students in each city
-- based on total learning minutes.
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
-- Find learning activities where the minutes spent
-- are greater than the student's previous activity.
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
-- total activities
-- total minutes spent
-- average minutes spent.
--
-- Definition:
-- Cohort Month = month in which the student joined.
--
-- Return:
-- Cohort_Month
-- Total_Students
-- Total_Activities
-- Total_Minutes_Spent
-- Average_Minutes_Spent

WITH CTE AS (
	SELECT Student_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Students
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Student_ID) AS Total_Students,
       COUNT(L.Activity_ID) AS Total_Activities,
       SUM(L.Minutes_Spent) AS Total_Minutes_Spent,
	   ROUND(AVG(L.Minutes_Spent), 2) AS Average_Minutes_Spent
FROM CTE C
INNER JOIN Learning_Activity L
	ON C.Student_ID = L.Student_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means learning activity occurring
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
-- Find students whose total learning minutes
-- are greater than the average total learning minutes
-- of students in the same city.
--
-- Return:
-- Student_ID
-- Student_Name
-- City
-- Total_Minutes_Spent

SELECT Student_ID, Student_Name, City, Total_Minutes_Spent
FROM (
	SELECT *,
		   AVG(Total_Minutes_Spent) OVER(PARTITION BY City) AS Avg_Minutes
	FROM (
		SELECT S.Student_ID, S.Student_Name, S.City,
			   SUM(L.Minutes_Spent) AS Total_Minutes_Spent
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		GROUP BY S.Student_ID, S.Student_Name, S.City
	)A
)C
WHERE Total_Minutes_Spent > Avg_Minutes;


-- INTERVIEW CHALLENGE
-- For each course, find the student
-- with the highest total minutes spent
-- for that course.
--
-- If tied, return all tied students.
--
-- Return:
-- Course_Name
-- Student_ID
-- Student_Name
-- Total_Minutes_Spent

SELECT Course_Name, Student_ID, Student_Name, Total_Minutes_Spent
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Course_Name
           ORDER BY Total_Minutes_Spent DESC) AS D_Rank
	FROM (
		SELECT L.Course_Name, S.Student_ID, S.Student_Name,
			   SUM(L.Minutes_Spent) AS Total_Minutes_Spent
		FROM Students S
		INNER JOIN Learning_Activity L
			ON S.Student_ID = L.Student_ID
		GROUP BY L.Course_Name, S.Student_ID, S.Student_Name
	)H
)S
WHERE D_Rank = 1;