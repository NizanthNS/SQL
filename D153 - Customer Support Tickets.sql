USE Daily_SQL;

-- DATASET : Customer Support Tickets

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Support_Tickets (
    Ticket_ID INT PRIMARY KEY,
    Customer_ID INT,
    Ticket_Date DATE,
    Ticket_Category VARCHAR(50),
    Resolution_Status VARCHAR(30),
    Resolution_Hours DECIMAL(5,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Customers
VALUES	(1, 'Arun',   'Chennai',    '2025-01-10'),
		(2, 'Bala',   'Chennai',    '2025-02-15'),
		(3, 'Cathy',  'Bangalore',  '2025-01-20'),
		(4, 'Divya',  'Bangalore',  '2025-03-05'),
		(5, 'Eshan',  'Mumbai',     '2025-02-25'),
		(6, 'Farah',  'Mumbai',     '2025-04-10'),
		(7, 'Gokul',  'Chennai',    '2025-03-18'),
		(8, 'Hema',   'Bangalore',  '2025-04-22');

INSERT INTO Support_Tickets
VALUES	(101, 1, '2025-05-01', 'Payment',  'Resolved',  4.50),
		(102, 1, '2025-05-02', 'Technical','Resolved',  6.00),
		(103, 1, '2025-05-04', 'Payment',  'Pending',   8.00),
		(104, 2, '2025-05-01', 'Technical','Resolved',  3.00),
		(105, 2, '2025-05-03', 'Account',  'Resolved',  5.50),
		(106, 3, '2025-05-01', 'Payment',  'Resolved',  2.50),
		(107, 3, '2025-05-02', 'Payment',  'Resolved',  3.50),
		(108, 3, '2025-05-03', 'Technical','Resolved',  4.00),
		(109, 3, '2025-05-06', 'Account',  'Pending',   7.00),
		(110, 4, '2025-05-02', 'Technical','Resolved',  6.50),
		(111, 4, '2025-05-05', 'Payment',  'Resolved',  4.00),
		(112, 5, '2025-05-01', 'Account',  'Resolved',  5.00),
		(113, 5, '2025-05-02', 'Technical','Pending',   9.00),
		(114, 5, '2025-05-03', 'Payment',  'Resolved',  3.50),
		(115, 6, '2025-05-04', 'Payment',  'Resolved',  4.50),
		(116, 7, '2025-05-01', 'Technical','Resolved',  2.00),
		(117, 7, '2025-05-02', 'Technical','Resolved',  3.00),
		(118, 7, '2025-05-03', 'Account',  'Resolved',  4.00),
		(119, 7, '2025-05-05', 'Payment',  'Resolved',  5.00),
		(120, 8, '2025-05-01', 'Payment',  'Pending',   6.00);
        
SELECT *
FROM Customers;

SELECT *
FROM Support_Tickets;

-- Q1
-- Show each customer's:
-- total support tickets
-- total resolution hours
-- average resolution hours
-- total resolved tickets.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Tickets
-- Total_Resolution_Hours
-- Average_Resolution_Hours
-- Total_Resolved_Tickets

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(S.Ticket_ID) AS Total_Tickets,
       SUM(S.Resolution_Hours) AS Total_Resolution_Hours,
       ROUND(AVG(S.Resolution_Hours), 2) AS Average_Resolution_Hours,
       COUNT(CASE
				WHEN S.Resolution_Status = 'Resolved' THEN 1
       END) AS Total_Resolved_Tickets
FROM Customers C
INNER JOIN Support_Tickets S
	ON C.Customer_ID = S.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each ticket category, find:
-- total tickets
-- total resolution hours
-- average resolution hours
-- number of unique customers.
--
-- Return:
-- Ticket_Category
-- Total_Tickets
-- Total_Resolution_Hours
-- Average_Resolution_Hours
-- Unique_Customers

SELECT Ticket_Category,
	   COUNT(Ticket_ID) AS Total_Tickets,
       SUM(Resolution_Hours) AS Total_Resolution_Hours,
       ROUND(AVG(Resolution_Hours), 2) AS Average_Resolution_Hours,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Support_Tickets
GROUP BY Ticket_Category;


-- Q3
-- Find the top 3 customers in each city
-- based on total resolution hours.
--
-- If tied, return all tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Resolution_Hours

SELECT City, Customer_ID, Customer_Name, Total_Resolution_Hours
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Resolution_Hours DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(S.Resolution_Hours) AS Total_Resolution_Hours
		FROM Customers C
		INNER JOIN Support_Tickets S
			ON C.Customer_ID = S.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find tickets where the resolution hours
-- are greater than the customer's previous ticket.
--
-- Use LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Ticket_Date
-- Resolution_Hours
-- Previous_Resolution_Hours

SELECT *
FROM (
	SELECT C.Customer_ID, C.Customer_Name, S.Ticket_Date, S.Resolution_Hours,
		   LAG(S.Resolution_Hours) OVER(PARTITION BY C.Customer_ID
		   ORDER BY S.Ticket_Date, S.Ticket_ID) AS Previous_Resolution_Hours
	FROM Customers C
	INNER JOIN Support_Tickets S
		ON C.Customer_ID = S.Customer_ID
)P
WHERE Resolution_Hours > Previous_Resolution_Hours;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
-- total tickets
-- total resolution hours
-- average resolution hours.
--
-- Definition:
-- Cohort Month = month in which the customer joined.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Tickets
-- Total_Resolution_Hours
-- Average_Resolution_Hours

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(S.Ticket_ID) AS Total_Tickets,
       SUM(S.Resolution_Hours) AS Total_Resolution_Hours,
       ROUND(AVG(S.Resolution_Hours), 2) AS Average_Resolution_Hours
FROM CTE C
INNER JOIN Support_Tickets S
	ON C.Customer_ID = S.Customer_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each customer's longest consecutive
-- ticket-date streak.
--
-- Ignore duplicate ticket dates.
--
-- If multiple streaks have the same length,
-- return the most recent streak.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, S.Ticket_Date
	FROM Customers C
	INNER JOIN Support_Tickets S
		ON C.Customer_ID = S.Customer_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Ticket_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Ticket_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Ticket_Date) AS Start_Date,
           MAX(Ticket_Date) AS End_Date
	FROM CTE3
    GROUP BY Customer_ID, Customer_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Streak DESC, End_Date DESC) AS Row_Num
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find customers whose total resolution hours
-- are greater than the average total resolution hours
-- of customers in the same city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Resolution_Hours

SELECT Customer_ID, Customer_Name, City, Total_Resolution_Hours
FROM (
	SELECT *,
		   AVG(Total_Resolution_Hours) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(S.Resolution_Hours) AS Total_Resolution_Hours
		FROM Customers C
		INNER JOIN Support_Tickets S
			ON C.Customer_ID = S.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Resolution_Hours > Avg_City;


-- INTERVIEW CHALLENGE
-- For each ticket category, find the customer
-- with the highest total resolution hours
-- in that category.
--
-- If tied, return all tied customers.
--
-- Return:
-- Ticket_Category
-- Customer_ID
-- Customer_Name
-- Total_Resolution_Hours

SELECT Ticket_Category, Customer_ID, Customer_Name, Total_Resolution_Hours
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Ticket_Category
           ORDER BY Total_Resolution_Hours DESC) AS D_Rank
	FROM (
		SELECT S.Ticket_Category, C.Customer_ID, C.Customer_Name,
			   SUM(S.Resolution_Hours) AS Total_Resolution_Hours
		FROM Customers C
		INNER JOIN Support_Tickets S
			ON C.Customer_ID = S.Customer_ID
		GROUP BY S.Ticket_Category, C.Customer_ID, C.Customer_Name
	)D
)H
WHERE D_Rank = 1;