USE Daily_SQL;


-- =========================================================
-- SESSION — Customer Support & Ticket Analytics
-- =========================================================


CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Connor', 'London', '2024-01-10'),
		(2, 'Ash', 'Toronto', '2024-02-15'),
		(3, 'Ethan', 'Sydney', '2024-03-05'),
		(4, 'Liam', 'Berlin', '2024-03-20'),
		(5, 'Olivia', 'Paris', '2024-04-02'),
		(6, 'Mason', 'Toronto', '2024-04-18'),
		(7, 'Sophia', 'London', '2024-05-06'),
		(8, 'Noah', 'Berlin', '2024-05-22');

CREATE TABLE Support_Tickets (
    Ticket_ID INT PRIMARY KEY,
    Customer_ID INT,
    Ticket_Date DATE,
    Issue_Category VARCHAR(50),
    Priority VARCHAR(20),
    Resolution_Date DATE,
    Ticket_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Support_Tickets
VALUES	(101, 1, '2025-01-05', 'Billing', 'High',   '2025-01-07', 'Resolved'),
		(102, 1, '2025-02-05', 'Technical', 'Medium', '2025-02-08', 'Resolved'),
		(103, 1, '2025-03-05', 'Billing', 'High',   NULL,         'Open'),
		(104, 1, '2025-04-05', 'Technical', 'Low',  '2025-04-06', 'Resolved'),
		(105, 1, '2025-05-05', 'Billing', 'High',   '2025-05-09', 'Resolved'),

		(106, 2, '2025-01-10', 'Technical', 'High',   '2025-01-12', 'Resolved'),
		(107, 2, '2025-02-10', 'Billing', 'Medium', '2025-02-13', 'Resolved'),
		(108, 2, '2025-03-10', 'Account', 'Low',    NULL,         'Open'),
		(109, 2, '2025-04-10', 'Technical', 'High',   '2025-04-14', 'Resolved'),
		(110, 2, '2025-05-10', 'Billing', 'Medium', '2025-05-12', 'Resolved'),

		(111, 3, '2025-02-01', 'Account', 'Low',    '2025-02-02', 'Resolved'),
		(112, 3, '2025-03-01', 'Technical', 'High',   '2025-03-04', 'Resolved'),
		(113, 3, '2025-04-01', 'Billing', 'Medium', '2025-04-05', 'Resolved'),
		(114, 3, '2025-05-01', 'Technical', 'High',   NULL,         'Open'),

		(115, 4, '2025-01-15', 'Billing', 'High',   '2025-01-18', 'Resolved'),
		(116, 4, '2025-02-15', 'Technical', 'Medium', '2025-02-17', 'Resolved'),
		(117, 4, '2025-03-15', 'Account', 'Low',    NULL,         'Open'),
		(118, 4, '2025-04-15', 'Billing', 'High',   '2025-04-19', 'Resolved'),
		(119, 4, '2025-05-15', 'Technical', 'Medium', '2025-05-18', 'Resolved'),

		(120, 5, '2025-01-20', 'Technical', 'High',   '2025-01-22', 'Resolved'),
		(121, 5, '2025-02-20', 'Billing', 'Medium', '2025-02-24', 'Resolved'),
		(122, 5, '2025-03-20', 'Account', 'Low',    '2025-03-22', 'Resolved'),
		(123, 5, '2025-04-20', 'Technical', 'High',   NULL,         'Open'),

		(124, 6, '2025-02-05', 'Billing', 'High',   '2025-02-08', 'Resolved'),
		(125, 6, '2025-03-05', 'Technical', 'Medium', '2025-03-08', 'Resolved'),
		(126, 6, '2025-04-05', 'Billing', 'High',   '2025-04-09', 'Resolved'),
		(127, 6, '2025-05-05', 'Account', 'Low',    NULL,         'Open'),

		(128, 7, '2025-01-12', 'Account', 'Low',    '2025-01-14', 'Resolved'),
		(129, 7, '2025-02-12', 'Technical', 'High',   '2025-02-15', 'Resolved'),
		(130, 7, '2025-03-12', 'Billing', 'Medium', '2025-03-16', 'Resolved'),
		(131, 7, '2025-04-12', 'Technical', 'High',   '2025-04-15', 'Resolved'),
		(132, 7, '2025-05-12', 'Billing', 'Medium', '2025-05-16', 'Resolved'),

		(133, 8, '2025-01-18', 'Technical', 'High',   '2025-01-21', 'Resolved'),
		(134, 8, '2025-02-18', 'Billing', 'Medium', '2025-02-21', 'Resolved'),
		(135, 8, '2025-03-18', 'Account', 'Low',    NULL,         'Open'),
		(136, 8, '2025-04-18', 'Technical', 'High',   '2025-04-22', 'Resolved'),
		(137, 8, '2025-05-18', 'Billing', 'Medium', '2025-05-21', 'Resolved');


SELECT *
FROM Customers;

SELECT *
FROM Support_Tickets;


-- =========================================================
-- Q1 — Customer Support Summary
-- =========================================================
-- For every customer, calculate:
-- total tickets, resolved tickets, open tickets,
-- total resolution days, average resolution days.
-- Include customers with no tickets.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Tickets
-- Resolved_Tickets
-- Open_Tickets
-- Total_Resolution_Days
-- Average_Resolution_Days


SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(S.Ticket_ID) AS Total_Tickets,
	   COUNT(
	   CASE 
			WHEN S.Ticket_Status = 'Resolved'
			THEN 1
	   END) AS Resolved_Tickets,
	   COUNT(
	   CASE 
			WHEN S.Ticket_Status = 'Open'
			THEN 1
	   END) AS Open_Tickets,
	   SUM(DATEDIFF(S.Resolution_Date, S.Ticket_Date)) AS Total_Resolution_Days,
	   ROUND(AVG(DATEDIFF(S.Resolution_Date, S.Ticket_Date)), 2) Average_Resolution_Days
FROM Customers C
LEFT JOIN Support_Tickets S
	ON C.Customer_ID = S.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- =========================================================
-- Q2 — Issue Category Performance
-- =========================================================
-- For each Issue_Category, calculate:
-- total tickets, resolved tickets, open tickets,
-- unique customers, average resolution days.
--
-- Average resolution days should consider ONLY resolved tickets.
--
-- Return:
-- Issue_Category
-- Total_Tickets
-- Resolved_Tickets
-- Open_Tickets
-- Unique_Customers
-- Average_Resolution_Days

SELECT Issue_Category,
	   COUNT(Ticket_ID) AS Total_Tickets,
	   COUNT(
	   CASE 
			WHEN Ticket_Status = 'Resolved'
			THEN 1
	   END) AS Resolved_Tickets,
	   COUNT(
	   CASE 
			WHEN Ticket_Status = 'Open'
			THEN 1
	   END) AS Open_Tickets,
	   COUNT(DISTINCT Customer_ID) AS Unique_Customers,
	   ROUND(AVG(DATEDIFF(Resolution_Date, Ticket_Date)), 2) Average_Resolution_Days
FROM Support_Tickets
GROUP BY Issue_Category;


-- =========================================================
-- Q3 — Top 2 Customers Per City
-- =========================================================
-- Find the top 2 customers in each city based on
-- total resolved tickets.
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Resolved_Tickets
-- Resolution_Rank

SELECT Customer_ID, Customer_Name, City, Total_Resolved_Tickets, Resolution_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Resolved_Tickets DESC) AS Resolution_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   COUNT(S.Ticket_ID) AS Total_Resolved_Tickets
		FROM Customers C
		INNER JOIN Support_Tickets S
			ON C.Customer_ID = S.Customer_ID
		WHERE S.Ticket_Status = 'Resolved'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)R
)D
WHERE Resolution_Rank <= 2;


-- =========================================================
-- Q4 — Repeat Support Tickets Within 30 Days
-- =========================================================
-- Find customers who created another ticket within
-- 30 days of their previous ticket.
--
-- Consider ALL tickets regardless of status.
-- Use LAG() + DATEDIFF().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Ticket_Date
-- Previous_Ticket_Date
-- Days_Between_Tickets

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, S.Ticket_Date,
		   LAG(S.Ticket_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY S.Ticket_Date, S.Ticket_ID) AS Previous_Ticket_Date
	FROM Customers C
	INNER JOIN Support_Tickets S
		ON C.Customer_ID = S.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Ticket_Date, Previous_Ticket_Date) AS Days_Between_Tickets
	FROM CTE
)
SELECT Customer_ID, Customer_Name, Ticket_Date, Previous_Ticket_Date, Days_Between_Tickets
FROM CTE2
WHERE Previous_Ticket_Date IS NOT NULL
AND Days_Between_Tickets <= 30;


-- =========================================================
-- Q5 — Customer Cohort Support Analysis
-- =========================================================
-- Group customers by Signup Month.
--
-- Calculate:
-- total customers,
-- customers who created at least one ticket,
-- total tickets,
-- resolved tickets,
-- total resolution days,
-- average resolution days among resolved tickets.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Ticketing_Customers
-- Total_Tickets
-- Resolved_Tickets
-- Total_Resolution_Days
-- Average_Resolution_Days

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(DISTINCT
       CASE
			WHEN S.Ticket_ID IS NOT NULL
            THEN C.Customer_ID
       END) AS Ticketing_Customers,
       COUNT(S.Ticket_ID) AS Total_Tickets,
       COUNT(
       CASE
			WHEN S.Ticket_Status = 'Resolved'
            THEN 1
       END) AS Resolved_Tickets,
       SUM(DATEDIFF(S.Resolution_Date, S.Ticket_Date)) AS Total_Resolution_Days,
	   ROUND(AVG(DATEDIFF(S.Resolution_Date, S.Ticket_Date)), 2) Average_Resolution_Days
FROM CTE C
LEFT JOIN Support_Tickets S
	ON C.Customer_ID = S.Customer_ID
GROUP BY Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- Find each customer's longest consecutive MONTHLY
-- ticket-creation streak.
--
-- Rules:
-- 1. Multiple tickets in the same month count ONCE.
-- 2. Consecutive months form a streak.
-- 3. Find the longest streak per customer.
-- 4. If tied, choose the most recent streak.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, S.Ticket_Date,
		   DATE_FORMAT(S.Ticket_Date, '%Y-%m-01') AS Ticket_Month
	FROM Customers C
	INNER JOIN Support_Tickets S
		ON C.Customer_ID = S.Customer_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Ticket_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Ticket_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Ticket_Month) AS Streak_Start_Month,
           MAX(Ticket_Month) AS Streak_End_Month
	FROM CTE3
    GROUP BY Customer_ID, Customer_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Streak DESC, Streak_End_Month DESC) AS Row_Num
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak_Start_Month, Streak_End_Month, Streak AS Streak_Months
FROM CTE5
WHERE Row_Num = 1;


-- =========================================================
-- BONUS+ — Above-City-Average Ticket Volume
-- =========================================================
-- Find customers whose total ticket count is greater
-- than the average ticket count of customers in their city.
--
-- Use a window function.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Tickets
-- City_Average_Tickets

SELECT Customer_ID, Customer_Name, City, Total_Tickets, City_Average_Tickets
FROM (
	SELECT *,
		   ROUND(AVG(Total_Tickets) OVER(PARTITION BY City), 2) AS City_Average_Tickets
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   COUNT(S.Ticket_ID) AS Total_Tickets
		FROM Customers C
		INNER JOIN Support_Tickets S
			ON C.Customer_ID = S.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Tickets > City_Average_Tickets;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each Issue_Category, find the customer(s) with
-- the highest number of resolved tickets.
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- Issue_Category
-- Customer_ID
-- Customer_Name
-- Total_Resolved_Tickets
-- Resolution_Rank

SELECT Issue_Category, Customer_ID, Customer_Name, Total_Resolved_Tickets, Resolution_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Issue_Category
           ORDER BY Total_Resolved_Tickets DESC) AS Resolution_Rank
	FROM (
		SELECT Issue_Category, C.Customer_ID, C.Customer_Name,
			   COUNT(S.Ticket_ID) AS Total_Resolved_Tickets
		FROM Customers C
		INNER JOIN Support_Tickets S
			ON C.Customer_ID = S.Customer_ID
		WHERE S.Ticket_Status = 'Resolved'
		GROUP BY Issue_Category, C.Customer_ID, C.Customer_Name
	)I
)D
WHERE Resolution_Rank = 1;