USE Daily_SQL;

-- DATASET : Movie Analytics

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    User_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Users
VALUES	(1, 'Connor', 'London', '2025-01-10'),
		(2, 'Ash', 'Toronto', '2025-01-15'),
		(3, 'Ethan', 'Berlin', '2025-02-05'),
		(4, 'Liam', 'Sydney', '2025-02-20'),
		(5, 'Noah', 'Paris', '2025-03-01'),
		(6, 'Oliver', 'Madrid', '2025-03-12'),
		(7, 'Lucas', 'London', '2025-04-08'),
		(8, 'Ryan', 'Toronto', '2025-04-18');


CREATE TABLE Movie_Watch_History (
    Watch_ID INT PRIMARY KEY,
    User_ID INT,
    Movie_Name VARCHAR(100),
    Genre VARCHAR(50),
    Watch_Date DATE,
    Minutes_Watched INT,
    Watch_Status VARCHAR(20),
    Rating DECIMAL(3,1)
);

INSERT INTO Movie_Watch_History
VALUES	(1, 1, 'Inception', 'Sci-Fi', '2025-01-11', 148, 'Completed', 9.0),
		(2, 1, 'Interstellar', 'Sci-Fi', '2025-01-12', 169, 'Completed', 9.5),
		(3, 1, 'Dune', 'Sci-Fi', '2025-01-14', 155, 'Completed', 8.5),
		(4, 1, 'The Batman', 'Action', '2025-01-20', 176, 'Completed', 8.0),
		(5, 2, 'The Matrix', 'Sci-Fi', '2025-01-16', 136, 'Completed', 9.0),
		(6, 2, 'Gladiator', 'Action', '2025-01-17', 155, 'Completed', 8.5),
		(7, 2, 'Avatar', 'Sci-Fi', '2025-01-18', 162, 'Completed', 8.0),
		(8, 2, 'Titanic', 'Drama', '2025-01-22', 194, 'Completed', 9.0),
		(9, 3, 'Joker', 'Drama', '2025-02-06', 122, 'Completed', 8.5),
		(10, 3, 'Parasite', 'Thriller', '2025-02-07', 132, 'Completed', 9.0),
		(11, 3, '1917', 'War', '2025-02-08', 119, 'Completed', 8.5),
		(12, 3, 'Tenet', 'Sci-Fi', '2025-02-11', 150, 'In Progress', NULL),
		(13, 4, 'The Prestige', 'Thriller', '2025-02-21', 130, 'Completed', 9.0),
		(14, 4, 'Arrival', 'Sci-Fi', '2025-02-22', 116, 'Completed', 8.5),
		(15, 4, 'Ford v Ferrari', 'Action', '2025-02-23', 152, 'Completed', 9.0),
		(16, 4, 'Whiplash', 'Drama', '2025-02-25', 106, 'Completed', 9.5),
		(17, 5, 'La La Land', 'Musical', '2025-03-02', 128, 'Completed', 8.5),
		(18, 5, 'The Godfather', 'Crime', '2025-03-03', 175, 'Completed', 9.5),
		(19, 5, 'Goodfellas', 'Crime', '2025-03-05', 146, 'Completed', 9.0),
		(20, 5, 'Heat', 'Crime', '2025-03-06', 170, 'Completed', 9.0),
		(21, 6, 'Rocky', 'Sports', '2025-03-13', 119, 'Completed', 8.0),
		(22, 6, 'Creed', 'Sports', '2025-03-14', 133, 'Completed', 8.5),
		(23, 6, 'Moneyball', 'Sports', '2025-03-15', 133, 'Completed', 8.0),
		(24, 6, 'Ford v Ferrari', 'Action', '2025-03-18', 152, 'Completed', 9.0),
		(25, 7, 'The Dark Knight', 'Action', '2025-04-09', 152, 'Completed', 9.5),
		(26, 7, 'Inception', 'Sci-Fi', '2025-04-10', 148, 'Completed', 9.0),
		(27, 7, 'Dune', 'Sci-Fi', '2025-04-11', 155, 'Completed', 8.5),
		(28, 7, 'Oppenheimer', 'Drama', '2025-04-13', 180, 'Completed', 9.0),
		(29, 8, 'The Shawshank Redemption', 'Drama', '2025-04-19', 142, 'Completed', 9.5),
		(30, 8, 'The Green Mile', 'Drama', '2025-04-20', 189, 'Completed', 9.0),
		(31, 8, 'Forrest Gump', 'Drama', '2025-04-21', 142, 'Completed', 9.5),
		(32, 8, 'The Departed', 'Crime', '2025-04-24', 151, 'Completed', 9.0);
 
 SELECT *
 FROM Users;
 
 SELECT *
 FROM Movie_Watch_History;
 

-- Q1
-- Show each user's:
-- total watch records
-- total minutes watched
-- average minutes watched
-- total completed movies.
--
-- Use both tables.
--
-- Return:
-- User_ID
-- User_Name
-- Total_Watch_Records
-- Total_Minutes_Watched
-- Average_Minutes_Watched
-- Total_Completed_Movies

SELECT U.User_ID, U.User_Name,
	   COUNT(M.Watch_ID) AS Total_Watch_Records,
       SUM(M.Minutes_Watched) AS Total_Minutes_Watched,
       ROUND(AVG(M.Minutes_Watched), 2) AS Average_Minutes_Watched,
       COUNT(
	   CASE
			WHEN Watch_Status = 'Completed'
			THEN 1
	   END) AS Total_Completed_Movies
FROM Users U
INNER JOIN Movie_Watch_History M
	ON U.User_ID = M.User_ID
GROUP BY U.User_ID, U.User_Name;


-- Q2
-- For each genre, find:
-- total watch records
-- total completed minutes
-- average rating
-- unique users.
--
-- Only Completed movies should be considered.
--
-- Return:
-- Genre
-- Total_Watch_Records
-- Total_Completed_Minutes
-- Average_Rating
-- Unique_Users

SELECT Genre,
	   COUNT(Watch_ID) AS Total_Watch_Records,
       SUM(Minutes_Watched) AS Total_Completed_Minutes,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       COUNT(DISTINCT User_ID) AS Unique_Users
FROM Movie_Watch_History
WHERE Watch_Status = 'Completed'
GROUP BY Genre;


-- Q3
-- Find the top 3 users in each city
-- based on total completed minutes watched.
--
-- If tied, return all tied users.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- User_ID
-- User_Name
-- Total_Completed_Minutes

SELECT City, User_ID, User_Name, Total_Completed_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Completed_Minutes DESC) AS D_Rank
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(M.Minutes_Watched) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Movie_Watch_History M
			ON U.User_ID = M.User_ID
		WHERE M.Watch_Status = 'Completed'
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find movie watches where the minutes watched
-- are greater than the user's previous
-- completed movie.
--
-- Only Completed movies should be compared.
--
-- Use JOIN + LAG().
--
-- Return:
-- User_ID
-- User_Name
-- Watch_Date
-- Movie_Name
-- Minutes_Watched
-- Previous_Minutes_Watched

SELECT *
FROM (
	SELECT U.User_ID, U.User_Name, M.Watch_Date, M.Movie_Name, M.Minutes_Watched,
		   LAG(M.Minutes_Watched) OVER(PARTITION BY U.User_ID
		   ORDER BY M.Watch_Date, M.Watch_ID) AS Previous_Minutes_Watched
	FROM Users U
	INNER JOIN Movie_Watch_History M
		ON U.User_ID = M.User_ID
	WHERE M.Watch_Status = 'Completed'
)P
WHERE Minutes_Watched > Previous_Minutes_Watched;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total users
-- total completed movies
-- total completed minutes
-- average completed minutes.
--
-- Definition:
-- Cohort Month = month in which the user joined.
--
-- Only Completed movies should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Completed_Movies
-- Total_Completed_Minutes
-- Average_Completed_Minutes

WITH CTE AS (
    SELECT User_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Users
),
CTE2 AS (
	SELECT *
    FROM Movie_Watch_History
    WHERE Watch_Status = 'Completed'
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
       COUNT(M.Watch_ID) AS Total_Completed_Movies,
       SUM(M.Minutes_Watched) AS Total_Completed_Minutes,
       ROUND(AVG(M.Minutes_Watched), 2) AS Average_Completed_Minutes
FROM CTE C
INNER JOIN CTE2 M
	ON C.User_ID = M.User_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means watching a Completed movie
-- on consecutive dates.
--
-- Ignore duplicate watch dates for the same user.
-- Only Completed movies count.
--
-- Find each user's longest completed-movie
-- watch-date streak.
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
	WHERE M.Watch_Status = 'Completed'
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
-- Find users whose total completed minutes
-- are greater than the average total completed minutes
-- of users in the same city.
--
-- Return:
-- User_ID
-- User_Name
-- City
-- Total_Completed_Minutes

SELECT User_ID, User_Name, City, Total_Completed_Minutes
FROM (
	SELECT *,
		   AVG(Total_Completed_Minutes) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT U.User_ID, U.User_Name, U.City,
			   SUM(M.Minutes_Watched) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Movie_Watch_History M
			ON U.User_ID = M.User_ID
		WHERE M.Watch_Status = 'Completed'
		GROUP BY U.User_ID, U.User_Name, U.City
	)C
)A
WHERE Total_Completed_Minutes > Avg_City;


-- INTERVIEW CHALLENGE
-- For each genre, find the user
-- with the highest total completed minutes
-- watched for that genre.
--
-- Only Completed movies should be considered.
--
-- If tied, return all tied users.
--
-- Return:
-- Genre
-- User_ID
-- User_Name
-- Total_Completed_Minutes

SELECT Genre, User_ID, User_Name, Total_Completed_Minutes
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Genre
           ORDER BY Total_Completed_Minutes DESC) AS D_Rank
	FROM (
		SELECT M.Genre, U.User_ID, U.User_Name,
			   SUM(M.Minutes_Watched) AS Total_Completed_Minutes
		FROM Users U
		INNER JOIN Movie_Watch_History M
			ON U.User_ID = M.User_ID
		WHERE M.Watch_Status = 'Completed'
		GROUP BY M.Genre, U.User_ID, U.User_Name
	)D
)T
WHERE D_Rank = 1;