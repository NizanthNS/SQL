USE Daily_SQL;

-- Domain: Library Borrowing Activity

-- ============================================================
-- MEMBERS TABLE
-- ============================================================

CREATE TABLE Members (
    Member_ID INT PRIMARY KEY,
    Member_Name VARCHAR(50),
    City VARCHAR(50),
    Signup_Date DATE
);


INSERT INTO Members
VALUES	(1, 'Ethan', 'London', '2025-01-05'),
		(2, 'Olivia', 'Paris', '2025-01-12'),
		(3, 'Liam', 'New York', '2025-02-03'),
		(4, 'Sophia', 'Toronto', '2025-02-10'),
		(5, 'Noah', 'London', '2025-02-18'),
		(6, 'Emma', 'Paris', '2025-03-02'),
		(7, 'Lucas', 'New York', '2025-03-08'),
		(8, 'Mia', 'Toronto', '2025-03-15'),
		(9, 'James', 'London', '2025-03-20'),
		(10, 'Ava', 'Paris', '2025-04-01');


-- ============================================================
-- BOOK BORROWING TABLE
-- ============================================================

CREATE TABLE Book_Borrowing (
    Borrow_ID INT PRIMARY KEY,
    Member_ID INT,
    Book_Title VARCHAR(100),
    Book_Category VARCHAR(50),
    Borrow_Date DATE,
    Days_Borrowed INT,
    Rating DECIMAL(3,1),
    Borrow_Status VARCHAR(20),
    
    FOREIGN KEY (Member_ID)
        REFERENCES Members(Member_ID)
);


INSERT INTO Book_Borrowing
VALUES	(1, 1, 'The Silent River', 'Fiction', '2025-04-01', 5, 4.5, 'Returned'),
		(2, 1, 'Hidden Worlds', 'Science', '2025-04-02', 7, 4.8, 'Returned'),
		(3, 1, 'The Last Kingdom', 'History', '2025-04-03', 6, 4.2, 'Returned'),
		(4, 1, 'Lost Signals', 'Science', '2025-04-10', 8, 4.7, 'Returned'),
		(5, 1, 'Dream Walker', 'Fiction', '2025-04-11', 4, 4.1, 'Cancelled'),

		(6, 2, 'Ocean Secrets', 'Fiction', '2025-04-02', 6, 4.6, 'Returned'),
		(7, 2, 'Ancient Empires', 'History', '2025-04-03', 8, 4.9, 'Returned'),
		(8, 2, 'Future Tech', 'Science', '2025-04-04', 10, 4.5, 'Returned'),
		(9, 2, 'Dark Forest', 'Fiction', '2025-04-12', 5, 4.0, 'Cancelled'),

		(10, 3, 'Space Beyond', 'Science', '2025-04-01', 4, 4.3, 'Returned'),
		(11, 3, 'World Wars', 'History', '2025-04-02', 7, 4.7, 'Returned'),
		(12, 3, 'Silent Night', 'Fiction', '2025-04-05', 9, 4.8, 'Returned'),
		(13, 3, 'Deep Ocean', 'Science', '2025-04-06', 11, 4.6, 'Returned'),
		(14, 3, 'Lost City', 'History', '2025-04-07', 6, 4.4, 'Returned'),

		(15, 4, 'Digital Future', 'Science', '2025-04-03', 5, 4.2, 'Returned'),
		(16, 4, 'Hidden Truth', 'Fiction', '2025-04-04', 7, 4.5, 'Returned'),
		(17, 4, 'Roman Empire', 'History', '2025-04-08', 9, 4.7, 'Cancelled'),
		(18, 4, 'Machine World', 'Science', '2025-04-09', 12, 4.9, 'Returned'),

		(19, 5, 'Northern Lights', 'Fiction', '2025-04-01', 6, 4.4, 'Returned'),
		(20, 5, 'AI Revolution', 'Science', '2025-04-02', 8, 4.8, 'Returned'),
		(21, 5, 'Ancient Rome', 'History', '2025-04-03', 7, 4.6, 'Returned'),
		(22, 5, 'Galaxy Wars', 'Science', '2025-04-04', 10, 4.9, 'Returned'),
		(23, 5, 'Shadow Land', 'Fiction', '2025-04-15', 5, 4.1, 'Cancelled'),

		(24, 6, 'Future Earth', 'Science', '2025-04-05', 7, 4.5, 'Returned'),
		(25, 6, 'Lost Kingdom', 'History', '2025-04-06', 9, 4.8, 'Returned'),
		(26, 6, 'Silent Forest', 'Fiction', '2025-04-07', 6, 4.3, 'Returned'),
		(27, 6, 'Quantum World', 'Science', '2025-04-20', 11, 4.7, 'Returned'),

		(28, 7, 'Dark Matter', 'Science', '2025-04-02', 5, 4.4, 'Returned'),
		(29, 7, 'Hidden Empire', 'History', '2025-04-03', 7, 4.6, 'Returned'),
		(30, 7, 'Moonlight', 'Fiction', '2025-04-04', 8, 4.9, 'Returned'),
		(31, 7, 'Future Machines', 'Science', '2025-04-05', 10, 4.5, 'Returned'),

		(32, 8, 'Ocean Life', 'Science', '2025-04-01', 6, 4.3, 'Returned'),
		(33, 8, 'Lost Civilizations', 'History', '2025-04-02', 8, 4.7, 'Returned'),
		(34, 8, 'Dream World', 'Fiction', '2025-04-03', 7, 4.6, 'Returned'),
		(35, 8, 'Deep Space', 'Science', '2025-04-04', 9, 4.8, 'Returned'),

		(36, 9, 'The Unknown', 'Fiction', '2025-04-10', 5, 4.2, 'Returned'),
		(37, 9, 'Tech Tomorrow', 'Science', '2025-04-11', 7, 4.6, 'Returned'),
		(38, 9, 'Ancient World', 'History', '2025-04-12', 9, 4.9, 'Returned'),

		(39, 10, 'Final Journey', 'Fiction', '2025-04-01', 6, 4.5, 'Returned'),
		(40, 10, 'Modern Science', 'Science', '2025-04-02', 8, 4.7, 'Returned'),
		(41, 10, 'Empire Rising', 'History', '2025-04-03', 10, 4.8, 'Returned');
        

SELECT *
FROM Members;

SELECT *
FROM Book_Borrowing;


-- ============================================================
-- Q1
-- ============================================================

-- Show each member's:
-- total borrowing records
-- total days borrowed
-- average days borrowed
-- total returned books.
--
-- Use both tables.
--
-- Return:
-- Member_ID
-- Member_Name
-- Total_Borrowing_Records
-- Total_Days_Borrowed
-- Average_Days_Borrowed
-- Total_Returned_Books

SELECT M.Member_ID, M.Member_Name,
	   COUNT(B.Borrow_ID) AS Total_Borrowing_Records,
       SUM(B.Days_Borrowed) AS Total_Days_Borrowed,
       ROUND(AVG(B.Days_Borrowed), 2) AS Average_Days_Borrowed,
       COUNT(
       CASE
			WHEN B.Borrow_Status = 'Returned'
			THEN 1
	   END) AS Total_Returned_Books
FROM Members M
INNER JOIN Book_Borrowing B
	ON M.Member_ID = B.Member_ID
GROUP BY M.Member_ID, M.Member_Name;


-- ============================================================
-- Q2
-- ============================================================

-- For each book category, find only Returned books:
-- total borrowing records
-- total days borrowed
-- average rating
-- unique members.
--
-- Return:
-- Book_Category
-- Total_Borrowing_Records
-- Total_Days_Borrowed
-- Average_Rating
-- Unique_Members

SELECT Book_Category,
	   COUNT(Borrow_ID) AS Total_Borrowing_Records,
       SUM(Days_Borrowed) AS Total_Days_Borrowed,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       COUNT(DISTINCT Member_ID) AS Unique_Members
FROM Book_Borrowing
WHERE Borrow_Status = 'Returned'
GROUP BY Book_Category;


-- ============================================================
-- Q3
-- ============================================================

-- Find the top 3 members in each city
-- based on total returned days borrowed.
--
-- If tied, return all tied members.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Member_ID
-- Member_Name
-- Total_Returned_Days

SELECT City, Member_ID, Member_Name, Total_Returned_Days
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Returned_Days DESC) AS D_Rank
	FROM (
		SELECT M.Member_ID, M.Member_Name, M.City,
			   SUM(B.Days_Borrowed) AS Total_Returned_Days
		FROM Members M
		INNER JOIN Book_Borrowing B
			ON M.Member_ID = B.Member_ID
		WHERE B.Borrow_Status = 'Returned'
		GROUP BY M.Member_ID, M.Member_Name, M.City
	)B
)D
WHERE D_Rank <= 3;


-- ============================================================
-- Q4
-- ============================================================

-- Find Returned borrowing records where
-- the days borrowed are greater than the member's
-- previous Returned borrowing record.
--
-- Only Returned records should be compared.
--
-- Use JOIN + LAG().
--
-- Return:
-- Member_ID
-- Member_Name
-- Borrow_ID
-- Borrow_Date
-- Days_Borrowed
-- Previous_Days_Borrowed

SELECT *
FROM (
	SELECT M.Member_ID, M.Member_Name, B.Borrow_ID, B.Borrow_Date, B.Days_Borrowed,
		   LAG(B.Days_Borrowed) OVER(PARTITION BY M.Member_ID
		   ORDER BY B.Borrow_Date, B.Borrow_ID) AS Previous_Days_Borrowed
	FROM Members M
	INNER JOIN Book_Borrowing B
		ON M.Member_ID = B.Member_ID
	WHERE B.Borrow_Status = 'Returned'
)P
WHERE Days_Borrowed > Previous_Days_Borrowed;


-- ============================================================
-- Q5 — COHORT ANALYSIS
-- ============================================================

-- Group members by Signup Month.
--
-- For each cohort, calculate:
-- total members
-- total returned books
-- total returned days borrowed
-- average returned days borrowed.
--
-- IMPORTANT:
-- Total_Members must include every member
-- in the cohort, even if they have no Returned books.
--
-- Only Returned records should be considered
-- for borrowing metrics.
--
-- Return:
-- Cohort_Month
-- Total_Members
-- Total_Returned_Books
-- Total_Returned_Days
-- Average_Returned_Days

WITH CTE AS (
    SELECT Member_ID,
           DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
    FROM Members
),
CTE2 AS (
	SELECT *
    FROM Book_Borrowing
    WHERE Borrow_Status = 'Returned'
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Member_ID) AS Total_Members,
	   COUNT(B.Borrow_ID) AS Total_Returned_Books,
       SUM(B.Days_Borrowed) AS Total_Returned_Days,
       ROUND(AVG(B.Days_Borrowed), 2) AS Average_Returned_Days
FROM CTE C
LEFT JOIN CTE2 B
	ON C.Member_ID = B.Member_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================

-- For each member, find their longest streak of
-- consecutive dates on which they had a Returned borrowing record.
--
-- Ignore duplicate borrow dates for the same member.
--
-- Only Returned records count.
--
-- If two streaks have the same length,
-- return the most recent streak.
--
-- Return:
-- Member_ID
-- Member_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT M.Member_ID, M.Member_Name, B.Borrow_Date
	FROM Members M
	INNER JOIN Book_Borrowing B
		ON M.Member_ID = B.Member_ID
	WHERE B.Borrow_Status = 'Returned'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Member_ID
           ORDER BY Borrow_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Borrow_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Member_ID, Member_Name,
		   COUNT(*) AS Streak,
           MIN(Borrow_Date) AS Start_Date,
           MAX(Borrow_Date) AS End_Date
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


-- ============================================================
-- BONUS+
-- ============================================================

-- Find members whose total returned days borrowed
-- are greater than the average total returned days
-- borrowed by members in the same city.
--
-- Return:
-- Member_ID
-- Member_Name
-- City
-- Total_Returned_Days
-- City_Average_Returned_Days

SELECT Member_ID, Member_Name, City, Total_Returned_Days, City_Average_Returned_Days
FROM (
	SELECT *,
		   ROUND(AVG(Total_Returned_Days) OVER(PARTITION BY City), 2) AS City_Average_Returned_Days
	FROM (
		SELECT M.Member_ID, M.Member_Name, M.City,
			   SUM(B.Days_Borrowed) AS Total_Returned_Days
		FROM Members M
		INNER JOIN Book_Borrowing B
			ON M.Member_ID = B.Member_ID
		WHERE B.Borrow_Status = 'Returned'
		GROUP BY M.Member_ID, M.Member_Name, M.City
	)C
)A
WHERE Total_Returned_Days > City_Average_Returned_Days;


-- ============================================================
-- INTERVIEW CHALLENGE
-- ============================================================

-- For each book category, find the member
-- with the highest total returned days borrowed
-- in that category.
--
-- Only Returned records should be considered.
--
-- If tied, return all tied members.
--
-- Return:
-- Book_Category
-- Member_ID
-- Member_Name
-- Total_Returned_Days
-- 

SELECT Book_Category, Member_ID, Member_Name, Total_Returned_Days, D_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Book_Category
           ORDER BY Total_Returned_Days DESC) AS D_Rank
	FROM (
		SELECT B.Book_Category, M.Member_ID, M.Member_Name,
			   SUM(B.Days_Borrowed) AS Total_Returned_Days
		FROM Members M
		INNER JOIN Book_Borrowing B
			ON M.Member_ID = B.Member_ID
		WHERE B.Borrow_Status = 'Returned'
		GROUP BY B.Book_Category, M.Member_ID, M.Member_Name
	)B
)D
WHERE D_Rank = 1;