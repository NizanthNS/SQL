USE Daily_SQL;

-- DATASET : Movie Watch History


CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    User_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);


INSERT INTO Users
VALUES	(1, 'Arun', 'Chennai', '2024-01-10'),
		(2, 'Bala', 'Chennai', '2024-02-15'),
		(3, 'Charan', 'Chennai', '2024-03-05'),
		(4, 'Dinesh', 'Coimbatore', '2024-03-20'),
		(5, 'Eshan', 'Coimbatore', '2024-04-12'),
		(6, 'Fahad', 'Coimbatore', '2024-05-01'),
		(7, 'Gokul', 'Madurai', '2024-05-18'),
		(8, 'Hari', 'Madurai', '2024-06-03'),
		(9, 'Irfan', 'Madurai', '2024-06-15'),
		(10, 'Jeeva', 'Chennai', '2024-07-01');


CREATE TABLE Movie_Watch_History (
    Watch_ID INT PRIMARY KEY,
    User_ID INT,
    Movie_Title VARCHAR(100),
    Genre VARCHAR(50),
    Watch_Date DATE,
    Watch_Minutes INT,
    Rating DECIMAL(3,1),
    Watch_Status VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);


INSERT INTO Movie_Watch_History
VALUES	(101, 1, 'Inception', 'Sci-Fi', '2024-06-01', 148, 9.0, 'Completed'),
		(102, 1, 'Interstellar', 'Sci-Fi', '2024-06-02', 169, 9.5, 'Completed'),
		(103, 1, 'The Dark Knight', 'Action', '2024-06-03', 152, 9.0, 'Completed'),
		(104, 1, 'Avatar', 'Sci-Fi', '2024-06-05', 162, 8.5, 'Completed'),
		(105, 1, 'Joker', 'Drama', '2024-06-05', 122, 8.5, 'Completed'),

		(106, 2, 'Titanic', 'Romance', '2024-06-01', 195, 9.0, 'Completed'),
		(107, 2, 'Gladiator', 'Action', '2024-06-03', 155, 8.5, 'Completed'),
		(108, 2, 'The Matrix', 'Sci-Fi', '2024-06-04', 136, 9.0, 'Dropped'),
		(109, 2, 'Avengers', 'Action', '2024-06-05', 143, 8.0, 'Completed'),

		(110, 3, 'The Godfather', 'Crime', '2024-06-02', 175, 9.5, 'Completed'),
		(111, 3, 'The Godfather Part II', 'Crime', '2024-06-03', 202, 9.5, 'Completed'),
		(112, 3, 'Fight Club', 'Drama', '2024-06-04', 139, 9.0, 'Completed'),
		(113, 3, 'Forrest Gump', 'Drama', '2024-06-06', 142, 8.5, 'Completed'),

		(114, 4, 'Avatar', 'Sci-Fi', '2024-06-01', 162, 8.5, 'Completed'),
		(115, 4, 'Avengers', 'Action', '2024-06-02', 143, 8.0, 'Completed'),
		(116, 4, 'Gladiator', 'Action', '2024-06-03', 155, 9.0, 'Completed'),
		(117, 4, 'Inception', 'Sci-Fi', '2024-06-04', 148, 9.5, 'Completed'),

		(118, 5, 'Titanic', 'Romance', '2024-06-01', 195, 9.0, 'Completed'),
		(119, 5, 'La La Land', 'Romance', '2024-06-02', 128, 8.5, 'Completed'),
		(120, 5, 'The Notebook', 'Romance', '2024-06-04', 123, 8.0, 'Completed'),
		(121, 5, 'Joker', 'Drama', '2024-06-05', 122, 9.0, 'Completed'),

		(122, 6, 'The Dark Knight', 'Action', '2024-06-02', 152, 9.5, 'Completed'),
		(123, 6, 'Gladiator', 'Action', '2024-06-03', 155, 9.0, 'Completed'),
		(124, 6, 'Inception', 'Sci-Fi', '2024-06-04', 148, 9.5, 'Completed'),

		(125, 7, 'Forrest Gump', 'Drama', '2024-06-01', 142, 9.0, 'Completed'),
		(126, 7, 'Joker', 'Drama', '2024-06-03', 122, 8.5, 'Completed'),
		(127, 7, 'Fight Club', 'Drama', '2024-06-04', 139, 9.0, 'Completed'),
		(128, 7, 'The Godfather', 'Crime', '2024-06-05', 175, 9.5, 'Completed'),

		(129, 8, 'Titanic', 'Romance', '2024-06-02', 195, 9.0, 'Completed'),
		(130, 8, 'La La Land', 'Romance', '2024-06-03', 128, 8.5, 'Completed'),
		(131, 8, 'Avatar', 'Sci-Fi', '2024-06-04', 162, 8.0, 'Completed'),
		(132, 8, 'Inception', 'Sci-Fi', '2024-06-06', 148, 9.0, 'Completed'),

		(133, 9, 'The Dark Knight', 'Action', '2024-06-01', 152, 9.5, 'Completed'),
		(134, 9, 'Gladiator', 'Action', '2024-06-02', 155, 9.0, 'Completed'),
		(135, 9, 'Avengers', 'Action', '2024-06-03', 143, 8.5, 'Completed'),
		(136, 9, 'Inception', 'Sci-Fi', '2024-06-05', 148, 9.5, 'Completed'),

		(137, 10, 'The Notebook', 'Romance', '2024-06-01', 123, 8.0, 'Completed'),
		(138, 10, 'Titanic', 'Romance', '2024-06-02', 195, 9.0, 'Completed'),
		(139, 10, 'Joker', 'Drama', '2024-06-04', 122, 8.5, 'Completed'),
		(140, 10, 'Forrest Gump', 'Drama', '2024-06-05', 142, 9.0, 'Completed');
        

SELECT *
FROM Users;

SELECT *
FROM Movie_Watch_History;


-- Q1
-- Show each user's:
-- total movies watched
-- total watch minutes
-- average watch minutes
-- total completed watches.
--
-- Use both tables.
--
-- Return:
-- User_ID
-- User_Name
-- Total_Movies_Watched
-- Total_Watch_Minutes
-- Average_Watch_Minutes
-- Total_Completed_Watches

SELECT U.User_ID, U.User_Name,
	   COUNT(M.Watch_ID) AS Total_Movies_Watched,
       SUM(M.Watch_Minutes) AS Total_Watch_Minutes,
       ROUND(AVG(M.Watch_Minutes), 2) AS Average_Watch_Minutes,
       COUNT(CASE
				WHEN Watch_Status = 'Completed'
                THEN 1
			 END) AS Total_Completed_Watches
FROM Users U
INNER JOIN Movie_Watch_History M
	ON U.User_ID = M.User_ID
GROUP BY U.User_ID, U.User_Name;


-- Q2
-- For each genre, find:
-- total watches
-- total watch minutes
-- average rating
-- unique users.
--
-- Return:
-- Genre
-- Total_Watches
-- Total_Watch_Minutes
-- Average_Rating
-- Unique_Users

SELECT Genre,
	   COUNT(Watch_ID) AS Total_Watches,
       SUM(Watch_Minutes) AS Total_Watch_Minutes,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       COUNT(DISTINCT User_ID) AS Unique_Users
FROM Movie_Watch_History
GROUP BY Genre;


-- Q3
-- Find the top 3 users in each city
-- based on total watch minutes.
--
-- If tied, return all tied users.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- User_ID
-- User_Name
-- Total_Watch_Minutes

SELECT City, User_ID, User_Name, Total_Watch_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Watch_Minutes DESC) AS D_Rank
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(M.Watch_Minutes) AS Total_Watch_Minutes
		FROM Users U
		INNER JOIN Movie_Watch_History M
			ON U.User_ID = M.User_ID
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)M
WHERE D_Rank <= 3;


-- Q4
-- Find watches where the user's rating
-- is greater than their previous movie rating.
--
-- Use JOIN + LAG().
--
-- Return:
-- User_ID
-- User_Name
-- Watch_Date
-- Rating
-- Previous_Rating

SELECT *
FROM (
	SELECT U.User_ID, U.User_Name, M.Watch_Date, M.Rating,
		   LAG(M.Rating) OVER(PARTITION BY U.User_ID
		   ORDER BY M.Watch_Date, M.Watch_ID) AS Previous_Rating
	FROM Users U
	INNER JOIN Movie_Watch_History M
		ON U.User_ID = M.User_ID
)P
WHERE Rating > Previous_Rating;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total users
-- total watches
-- total watch minutes
-- average rating.
--
-- Definition:
-- Cohort Month = month in which the user joined.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Watches
-- Total_Watch_Minutes
-- Average_Rating

WITH CTE AS (
    SELECT User_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Users
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
       COUNT(M.Watch_ID) AS Total_Watches,
       SUM(M.Watch_Minutes) AS Total_Watch_Minutes,
       ROUND(AVG(M.Rating), 2) AS Average_Rating
FROM CTE C
INNER JOIN Movie_Watch_History M
	ON C.User_ID = M.User_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means watching at least one movie
-- on consecutive dates.
--
-- Ignore duplicate watch dates for the same user.
--
-- Find each user's longest watch-date streak.
--
-- If multiple streaks have the same length,
-- return the most recent streak.
--
-- Return:
-- User_ID
-- User_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT U.User_ID, U.User_Name, M.Watch_Date
	FROM Users U
	INNER JOIN Movie_Watch_History M
		ON U.User_ID = M.User_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Watch_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Watch_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT User_ID, User_Name,
		   COUNT(*) AS Streak,
           MIN(Watch_Date) AS Start_Date,
           MAX(Watch_Date) AS End_Date
	FROM CTE3
    GROUP BY User_ID, User_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Streak DESC, End_Date DESC) AS Row_Num
	FROM CTE4
)
SELECT User_ID, User_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find users whose total watch minutes
-- are greater than the average total watch minutes
-- of users in the same city.
--
-- Return:
-- User_ID
-- User_Name
-- City
-- Total_Watch_Minutes

SELECT User_ID, User_Name, City, Total_Watch_Minutes
FROM (
	SELECT *,
		   AVG(Total_Watch_Minutes) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(M.Watch_Minutes) AS Total_Watch_Minutes
		FROM Users U
		INNER JOIN Movie_Watch_History M
			ON U.User_ID = M.User_ID
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)A
WHERE Total_Watch_Minutes > Avg_City;


-- INTERVIEW CHALLENGE
-- For each genre, find the user
-- with the highest total watch minutes
-- for that genre.
--
-- If tied, return all tied users.
--
-- Return:
-- Genre
-- User_ID
-- User_Name
-- Total_Watch_Minutes

SELECT Genre, User_ID, User_Name, Total_Watch_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Genre
           ORDER BY Total_Watch_Minutes DESC) AS D_Rank
	FROM (
		SELECT M.Genre, U.User_ID, U.User_Name,
			   SUM(M.Watch_Minutes) AS Total_Watch_Minutes
		FROM Users U
		INNER JOIN Movie_Watch_History M
			ON U.User_ID = M.User_ID
		GROUP BY M.Genre, U.User_ID, U.User_Name
	)D
)G
WHERE D_Rank = 1;