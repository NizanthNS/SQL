-- =========================================================
-- SESSION — Online Course & Learning Analytics
-- =========================================================

-- =========================================================
-- TABLE 1 — STUDENTS
-- =========================================================

USE Daily_SQL;

DROP TABLE IF EXISTS Course_Activity;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;

CREATE TABLE Students (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Students
VALUES	(1, 'Ethan Walker', 'London', '2024-01-10'),
		(2, 'Sophia Collins', 'Toronto', '2024-01-22'),
		(3, 'Noah Bennett', 'Sydney', '2024-02-05'),
		(4, 'Emma Richardson', 'Berlin', '2024-02-18'),
		(5, 'Liam Foster', 'Paris', '2024-03-03'),
		(6, 'Olivia Hughes', 'London', '2024-03-17'),
		(7, 'James Murphy', 'Toronto', '2024-04-02'),
		(8, 'Ava Peterson', 'Sydney', '2024-04-19'),
		(9, 'Lucas Morgan', 'Berlin', '2024-05-07'),
		(10, 'Mia Cooper', 'Paris', '2024-05-21'),
		(11, 'Benjamin Ward', 'London', '2024-06-04'),
		(12, 'Charlotte Hayes', 'Toronto', '2024-06-20');


-- =========================================================
-- TABLE 2 — ENROLLMENTS
-- =========================================================

CREATE TABLE Enrollments (
    Enrollment_ID INT PRIMARY KEY,
    Student_ID INT,
    Course_Name VARCHAR(100),
    Category VARCHAR(50),
    Enrollment_Date DATE,
    Enrollment_Status VARCHAR(20),
    Course_Fee DECIMAL(10,2),

    FOREIGN KEY (Student_ID)
        REFERENCES Students(Student_ID)
);

INSERT INTO Enrollments
VALUES	(1001, 1, 'Python Fundamentals', 'Programming',
		 '2024-01-15', 'Completed', 120.00),

		(1002, 1, 'SQL Analytics', 'Database',
		 '2024-02-20', 'Completed', 150.00),

		(1003, 1, 'Data Visualization', 'Analytics',
		 '2024-04-05', 'Completed', 100.00),

		(1004, 2, 'SQL Analytics', 'Database',
		 '2024-02-01', 'Completed', 150.00),

		(1005, 2, 'Python Fundamentals', 'Programming',
		 '2024-03-10', 'Completed', 120.00),

		(1006, 2, 'Cloud Basics', 'Cloud',
		 '2024-05-18', 'Cancelled', 180.00),

		(1007, 3, 'Python Fundamentals', 'Programming',
		 '2024-02-12', 'Completed', 120.00),

		(1008, 3, 'Data Visualization', 'Analytics',
		 '2024-03-25', 'Completed', 100.00),

		(1009, 3, 'Machine Learning', 'AI',
		 '2024-06-02', 'Completed', 220.00),

		(1010, 4, 'SQL Analytics', 'Database',
		 '2024-03-01', 'Completed', 150.00),

		(1011, 4, 'Cloud Basics', 'Cloud',
		 '2024-04-15', 'Completed', 180.00),

		(1012, 4, 'Machine Learning', 'AI',
		 '2024-07-20', 'Cancelled', 220.00),

		(1013, 5, 'Data Visualization', 'Analytics',
		 '2024-03-12', 'Completed', 100.00),

		(1014, 5, 'Machine Learning', 'AI',
		 '2024-05-05', 'Completed', 220.00),

		(1015, 5, 'SQL Analytics', 'Database',
		 '2024-08-01', 'Completed', 150.00),

		(1016, 6, 'Python Fundamentals', 'Programming',
		 '2024-03-22', 'Completed', 120.00),

		(1017, 6, 'SQL Analytics', 'Database',
		 '2024-05-10', 'Completed', 150.00),

		(1018, 6, 'Data Visualization', 'Analytics',
		 '2024-07-08', 'Completed', 100.00),

		(1019, 7, 'Cloud Basics', 'Cloud',
		 '2024-04-10', 'Completed', 180.00),

		(1020, 7, 'SQL Analytics', 'Database',
		 '2024-06-15', 'Completed', 150.00),

		(1021, 8, 'Python Fundamentals', 'Programming',
		 '2024-05-01', 'Completed', 120.00),

		(1022, 8, 'Data Visualization', 'Analytics',
		 '2024-06-20', 'Completed', 100.00),

		(1023, 9, 'Machine Learning', 'AI',
		 '2024-05-15', 'Completed', 220.00),

		(1024, 9, 'SQL Analytics', 'Database',
		 '2024-07-10', 'Completed', 150.00),

		(1025, 10, 'Data Visualization', 'Analytics',
		 '2024-06-01', 'Completed', 100.00),

		(1026, 10, 'Machine Learning', 'AI',
		 '2024-08-05', 'Completed', 220.00),

		(1027, 11, 'Python Fundamentals', 'Programming',
		 '2024-06-10', 'Completed', 120.00),

		(1028, 11, 'Cloud Basics', 'Cloud',
		 '2024-07-25', 'Completed', 180.00),

		(1029, 12, 'SQL Analytics', 'Database',
		 '2024-07-05', 'Completed', 150.00),

		(1030, 12, 'Cloud Basics', 'Cloud',
		 '2024-08-15', 'Completed', 180.00);


-- =========================================================
-- TABLE 3 — COURSE ACTIVITY
-- =========================================================

CREATE TABLE Course_Activity (
    Activity_ID INT PRIMARY KEY,
    Enrollment_ID INT,
    Activity_Date DATE,
    Activity_Type VARCHAR(30),
    Completion_Percent INT,

    FOREIGN KEY (Enrollment_ID)
        REFERENCES Enrollments(Enrollment_ID)
);

INSERT INTO Course_Activity
VALUES	(5001, 1001, '2024-01-16', 'Started', 10),
		(5002, 1001, '2024-01-20', 'Progress', 40),
		(5003, 1001, '2024-01-28', 'Completed', 100),

		(5004, 1002, '2024-02-21', 'Started', 15),
		(5005, 1002, '2024-03-02', 'Progress', 60),
		(5006, 1002, '2024-03-15', 'Completed', 100),

		(5007, 1003, '2024-04-06', 'Started', 20),
		(5008, 1003, '2024-04-15', 'Progress', 70),
		(5009, 1003, '2024-04-25', 'Completed', 100),

		(5010, 1004, '2024-02-02', 'Started', 20),
		(5011, 1004, '2024-02-12', 'Progress', 65),
		(5012, 1004, '2024-02-28', 'Completed', 100),

		(5013, 1005, '2024-03-11', 'Started', 10),
		(5014, 1005, '2024-03-20', 'Progress', 55),
		(5015, 1005, '2024-04-02', 'Completed', 100),

		(5016, 1006, '2024-05-19', 'Started', 10),

		(5017, 1007, '2024-02-13', 'Started', 15),
		(5018, 1007, '2024-02-22', 'Progress', 50),
		(5019, 1007, '2024-03-05', 'Completed', 100),

		(5020, 1008, '2024-03-26', 'Started', 20),
		(5021, 1008, '2024-04-05', 'Progress', 70),
		(5022, 1008, '2024-04-18', 'Completed', 100),

		(5023, 1009, '2024-06-03', 'Started', 10),
		(5024, 1009, '2024-06-20', 'Progress', 50),
		(5025, 1009, '2024-07-05', 'Completed', 100),

		(5026, 1010, '2024-03-02', 'Started', 20),
		(5027, 1010, '2024-03-15', 'Progress', 60),
		(5028, 1010, '2024-04-01', 'Completed', 100),

		(5029, 1011, '2024-04-16', 'Started', 15),
		(5030, 1011, '2024-04-28', 'Progress', 65),
		(5031, 1011, '2024-05-10', 'Completed', 100),

		(5032, 1012, '2024-07-21', 'Started', 10),

		(5033, 1013, '2024-03-13', 'Started', 20),
		(5034, 1013, '2024-03-25', 'Progress', 60),
		(5035, 1013, '2024-04-08', 'Completed', 100),

		(5036, 1014, '2024-05-06', 'Started', 15),
		(5037, 1014, '2024-05-18', 'Progress', 55),
		(5038, 1014, '2024-06-01', 'Completed', 100),

		(5039, 1015, '2024-08-02', 'Started', 20),
		(5040, 1015, '2024-08-15', 'Progress', 65),
		(5041, 1015, '2024-08-28', 'Completed', 100),

		(5042, 1016, '2024-03-23', 'Started', 10),
		(5043, 1016, '2024-04-01', 'Progress', 50),
		(5044, 1016, '2024-04-12', 'Completed', 100),

		(5045, 1017, '2024-05-11', 'Started', 15),
		(5046, 1017, '2024-05-25', 'Progress', 70),
		(5047, 1017, '2024-06-05', 'Completed', 100),

		(5048, 1018, '2024-07-09', 'Started', 20),
		(5049, 1018, '2024-07-20', 'Progress', 75),
		(5050, 1018, '2024-08-02', 'Completed', 100),

		(5051, 1019, '2024-04-11', 'Started', 10),
		(5052, 1019, '2024-04-25', 'Progress', 55),
		(5053, 1019, '2024-05-08', 'Completed', 100),

		(5054, 1020, '2024-06-16', 'Started', 15),
		(5055, 1020, '2024-06-30', 'Progress', 60),
		(5056, 1020, '2024-07-12', 'Completed', 100),

		(5057, 1021, '2024-05-02', 'Started', 20),
		(5058, 1021, '2024-05-15', 'Progress', 65),
		(5059, 1021, '2024-05-30', 'Completed', 100),

		(5060, 1022, '2024-06-21', 'Started', 10),
		(5061, 1022, '2024-07-01', 'Progress', 60),
		(5062, 1022, '2024-07-15', 'Completed', 100),

		(5063, 1023, '2024-05-16', 'Started', 15),
		(5064, 1023, '2024-05-28', 'Progress', 55),
		(5065, 1023, '2024-06-15', 'Completed', 100),

		(5066, 1024, '2024-07-11', 'Started', 20),
		(5067, 1024, '2024-07-25', 'Progress', 65),
		(5068, 1024, '2024-08-08', 'Completed', 100),

		(5069, 1025, '2024-06-02', 'Started', 10),
		(5070, 1025, '2024-06-15', 'Progress', 50),
		(5071, 1025, '2024-06-28', 'Completed', 100),

		(5072, 1026, '2024-08-06', 'Started', 15),
		(5073, 1026, '2024-08-20', 'Progress', 60),
		(5074, 1026, '2024-09-02', 'Completed', 100),

		(5075, 1027, '2024-06-11', 'Started', 20),
		(5076, 1027, '2024-06-25', 'Progress', 70),
		(5077, 1027, '2024-07-05', 'Completed', 100),

		(5078, 1028, '2024-07-26', 'Started', 10),
		(5079, 1028, '2024-08-05', 'Progress', 65),
		(5080, 1028, '2024-08-18', 'Completed', 100),

		(5081, 1029, '2024-07-06', 'Started', 15),
		(5082, 1029, '2024-07-20', 'Progress', 60),
		(5083, 1029, '2024-08-03', 'Completed', 100),

		(5084, 1030, '2024-08-16', 'Started', 20),
		(5085, 1030, '2024-08-28', 'Progress', 70),
		(5086, 1030, '2024-09-10', 'Completed', 100);


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT *
FROM Students;

SELECT *
FROM Enrollments;

SELECT *
FROM Course_Activity;


-- =========================================================
-- Q1 — STUDENT ENROLLMENT SUMMARY
-- =========================================================
-- For every student, calculate:
-- 1. Total completed enrollments
-- 2. Total completed course fees
-- 3. Average completed course fee
-- 4. Highest completed course fee
-- 5. Lowest completed course fee
-- 6. Total completed courses where the student reached 100%
--
-- Include students even if they have no completed enrollments.
--
-- Return:
-- Student_ID
-- Student_Name
-- City
-- Completed_Enrollments
-- Total_Fees
-- Avg_Fee
-- Highest_Fee
-- Lowest_Fee
-- Fully_Completed_Courses

WITH CTE AS (
	SELECT Enrollment_ID,
		   MAX(
           CASE
				WHEN Activity_Type = 'Completed' AND Completion_Percent = 100
                THEN 1
                ELSE 0
		   END) AS Fully_Completed
	FROM Course_Activity
    GROUP BY Enrollment_ID
)
SELECT S.Student_ID, S.Student_Name, S.City,
	   COUNT(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Enrollment_ID
	   END) AS Completed_Enrollments,
	   COALESCE(SUM(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Course_Fee
            ELSE 0
	   END), 0) AS Total_Fees,
       COALESCE(ROUND(AVG(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Course_Fee
	   END), 2), 0) AS Avg_Fee,
       MAX(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Course_Fee
	   END) AS Highest_Fee,
       MIN(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Course_Fee
	   END) AS Lowest_Fee,
       COUNT(
       CASE
			WHEN E.Enrollment_Status = 'Completed' AND C.Fully_Completed = 1
            THEN E.Enrollment_ID
	   END) AS Fully_Completed_Courses
FROM Students S
LEFT JOIN Enrollments E
	ON S.Student_ID = E.Student_ID
LEFT JOIN CTE C
	ON E.Enrollment_ID = C.Enrollment_ID
GROUP BY S.Student_ID, S.Student_Name, S.City;


-- =========================================================
-- Q2 — COURSE CATEGORY PERFORMANCE
-- =========================================================
-- For every category, calculate:
-- 1. Number of distinct courses
-- 2. Total completed enrollments
-- 3. Total completed revenue
-- 4. Average completed course fee
-- 5. Number of distinct students who completed courses
-- 6. Average final completion percentage
--
-- Use the latest activity record for each enrollment when
-- calculating the final completion percentage.
--
-- Return:
-- Category
-- Distinct_Courses
-- Completed_Enrollments
-- Total_Revenue
-- Avg_Course_Fee
-- Distinct_Students
-- Avg_Final_Completion

WITH CTE AS (
	SELECT Enrollment_ID, Completion_Percent,
		   ROW_NUMBER() OVER(PARTITION BY Enrollment_ID
           ORDER BY Activity_Date DESC) AS RN
	FROM Course_Activity
),
CTE2 AS (
	SELECT *
    FROM CTE
    WHERE RN = 1
)
SELECT E.Category,
	   COUNT(DISTINCT E.Course_Name) AS Distinct_Courses,
       COUNT(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Enrollment_ID
	   END) AS Completed_Enrollments,
	   COALESCE(SUM(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Course_Fee
            ELSE 0
	   END), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Course_Fee
	   END), 2), 0) AS Avg_Course_Fee,
       COUNT(DISTINCT
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Student_ID
	   END) AS Distinct_Students,
       COALESCE(ROUND(AVG(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN C.Completion_Percent
	   END), 2), 0) AS Avg_Final_Completion
FROM Enrollments E
LEFT JOIN CTE2 C
	ON E.Enrollment_ID = C.Enrollment_ID
GROUP BY E.Category;


-- =========================================================
-- Q3 — TOP 2 STUDENTS PER CITY
-- =========================================================
-- Find the top 2 students in each city based on their
-- total completed course fees.
--
-- Requirements:
-- - Completed enrollments only
-- - Calculate student-level revenue first
-- - Use DENSE_RANK()
-- - Include ties
--
-- Return:
-- City
-- Student_ID
-- Student_Name
-- Total_Revenue
-- Revenue_Rank

SELECT City, Student_ID, Student_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT S.City, S.Student_ID, S.Student_Name,
			   COALESCE(SUM(E.Course_Fee), 0) AS Total_Revenue
		FROM Students S
        INNER JOIN Enrollments E
			ON S.Student_ID = E.Student_ID
		WHERE E.Enrollment_Status = 'Completed'
		GROUP BY S.City, S.Student_ID, S.Student_Name
	)C
)R
WHERE Revenue_Rank BETWEEN 1 AND 2;


-- =========================================================
-- Q4 — STUDENT ENROLLMENT GAP ANALYSIS
-- =========================================================
-- For every student, calculate the number of days between
-- their current completed enrollment and previous completed
-- enrollment.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Return ONLY enrollments where the gap is greater than
-- 45 days.
--
-- Return:
-- Student_ID
-- Student_Name
-- Enrollment_ID
-- Enrollment_Date
-- Previous_Enrollment_Date
-- Gap_Days

WITH CTE AS (
	SELECT S.Student_ID, S.Student_Name, E.Enrollment_ID, E.Enrollment_Date,
		   LAG(E.Enrollment_Date) OVER(PARTITION BY S.Student_ID
           ORDER BY E.Enrollment_Date, E.Enrollment_ID) AS Previous_Enrollment_Date
	FROM Students S
	INNER JOIN Enrollments E
		ON S.Student_ID = E.Student_ID
	WHERE E.Enrollment_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Enrollment_Date, Previous_Enrollment_Date) AS Gap_Days
	FROM CTE
)
SELECT Student_ID, Student_Name, Enrollment_ID, Enrollment_Date, Previous_Enrollment_Date, Gap_Days
FROM CTE2
WHERE Previous_Enrollment_Date IS NOT NULL
AND Gap_Days > 45;
	

-- =========================================================
-- Q5 — STUDENT COHORT ANALYSIS
-- =========================================================
-- Define each student's cohort month as the month of their
-- FIRST completed enrollment.
--
-- For each cohort month, calculate:
-- 1. Total students in the cohort
-- 2. Active students who completed at least one course
-- 3. Total completed enrollments
-- 4. Total completed revenue
-- 5. Total fully completed courses
-- 6. Average completed revenue per active student
--
-- Important:
-- Cohort membership must be based ONLY on the first
-- completed enrollment.
--
-- Return:
-- Cohort_Month
-- Cohort_Students
-- Active_Students
-- Completed_Enrollments
-- Total_Revenue
-- Fully_Completed_Courses
-- Avg_Revenue_Per_Active_Student

WITH CTE AS (
	SELECT S.Student_ID,
		   MIN(E.Enrollment_Date) AS First_Enrollment_Date
	FROM Students S
	INNER JOIN Enrollments E
		ON S.Student_ID = E.Student_ID
	WHERE E.Enrollment_Status = 'Completed'
    GROUP BY S.Student_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Enrollment_Date, '%Y-%m') AS Cohort_Month
	FROM CTE
),
CTE3 AS (
	SELECT Enrollment_ID,
		   MAX(
           CASE
				WHEN Activity_Type = 'Completed' AND Completion_Percent = 100
                THEN 1
                ELSE 0
		   END) AS Fully_Completed
	FROM Course_Activity
    GROUP BY Enrollment_ID
)
SELECT T.Cohort_Month,
	   COUNT(DISTINCT T.Student_ID)AS Cohort_Students,
       COUNT(DISTINCT
       CASE
			WHEN T.Student_ID IS NOT NULL AND E.Enrollment_Status = 'Completed'
            THEN T.Student_ID
	   END) AS Active_Students,
	   COUNT(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Enrollment_ID
	   END) AS Completed_Enrollments,
       COALESCE(SUM(
       CASE
			WHEN E.Enrollment_Status = 'Completed'
            THEN E.Course_Fee
            ELSE 0
	   END), 0) AS Total_Revenue,
       COUNT(
       CASE
			WHEN E.Enrollment_Status = 'Completed' AND C.Fully_Completed = 1
            THEN E.Enrollment_ID
	   END) AS Fully_Completed_Courses,
       COALESCE(ROUND(SUM(
       CASE
		   WHEN E.Enrollment_Status = 'Completed'
		   THEN E.Course_Fee
		   ELSE 0
	   END) / NULLIF(COUNT(DISTINCT
       CASE
			WHEN T.Student_ID IS NOT NULL AND E.Enrollment_Status = 'Completed'
            THEN T.Student_ID
	   END), 0), 2), 0) AS Avg_Revenue_Per_Active_Student
FROM CTE2 T
LEFT JOIN Enrollments E
	ON T.Student_ID = E.Student_ID
LEFT JOIN CTE3 C
	ON E.Enrollment_ID = C.Enrollment_ID
GROUP BY T.Cohort_Month;


-- =========================================================
-- BONUS — GAP & ISLAND
-- =========================================================
-- Find each student's longest consecutive monthly
-- enrollment streak.
--
-- Requirements:
-- - Completed enrollments only
-- - A student must have at least one completed enrollment
--   in each consecutive month
-- - Use the classic:
--     DISTINCT entity/month
--     ROW_NUMBER()
--     DATE_SUB()
--     GROUP BY
--     ranking
--
-- Return:
-- Student_ID
-- Student_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT S.Student_ID, S.Student_Name,
		   CAST(DATE_FORMAT(E.Enrollment_Date, '%Y-%m-01') AS DATE) AS Enroll_Month
	FROM Students S
	INNER JOIN Enrollments E
		ON S.Student_ID = E.Student_ID
	WHERE E.Enrollment_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Student_ID
           ORDER BY Enroll_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Enroll_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Student_ID, Student_Name,
		   COUNT(*) AS Streak,
           MIN(Enroll_Month) AS Streak_Start_Month,
           MAX(Enroll_Month) AS Streak_End_Month
	FROM CTE3
    GROUP BY Student_ID, Student_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Student_ID
           ORDER BY Streak DESC, Streak_End_Month DESC) AS Row_Num
	FROM CTE4
)
SELECT Student_ID, Student_Name, Streak_Start_Month, Streak_End_Month, Streak AS Streak_Months
FROM CTE5
WHERE Row_Num = 1;


-- =========================================================
-- BONUS+ — ABOVE CITY AVERAGE
-- =========================================================
-- Find students whose total completed course revenue is
-- greater than the average student revenue in their city.
--
-- Requirements:
-- - Completed enrollments only
-- - Calculate revenue per student first
-- - Use a window function for the city average
--
-- Return:
-- City
-- Student_ID
-- Student_Name
-- Total_Revenue
-- City_Avg_Revenue

SELECT City, Student_ID, Student_Name, Total_Revenue, City_Avg_Revenue
FROM (
	SELECT *,
		   ROUND(Exact_Avg, 2) AS City_Avg_Revenue
	FROM (
		SELECT *,
			   AVG(Total_Revenue) OVER(PARTITION BY City) AS Exact_Avg
		FROM (
			SELECT S.City, S.Student_ID, S.Student_Name,
				   COALESCE(SUM(E.Course_Fee), 0) AS Total_Revenue
			FROM Students S
			INNER JOIN Enrollments E
				ON S.Student_ID = E.Student_ID
			WHERE E.Enrollment_Status = 'Completed'
			GROUP BY S.City, S.Student_ID, S.Student_Name
		)C
	)A
)E
WHERE Total_Revenue > Exact_Avg;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each category, find the course(s) with the highest
-- total completed revenue.
--
-- Requirements:
-- - Completed enrollments only
-- - Calculate course-level revenue first
-- - Use DENSE_RANK()
-- - Include ties
--
-- Return:
-- Category
-- Course_Name
-- Total_Revenue
-- Revenue_Rank

SELECT * FROM Enrollments;

SELECT Category, Course_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Category
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT Category, Course_Name,
			   COALESCE(SUM(Course_Fee), 0) AS Total_Revenue
		FROM Enrollments 
		WHERE Enrollment_Status = 'Completed'
		GROUP BY Category, Course_Name
	)D
)R
WHERE Revenue_Rank = 1;