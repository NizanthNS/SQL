USE Daily_SQL;

-- ============================================================
-- DAILY SQL — SESSION
-- DOMAIN: Subscription Retention & Churn Analytics
-- ============================================================

-- ============================================================
-- TABLE 1: Customers
-- ============================================================

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
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


-- ============================================================
-- TABLE 2: Subscription Activity
-- ============================================================

CREATE TABLE Subscription_Activity (
    Activity_ID INT PRIMARY KEY,
    Customer_ID INT,
    Activity_Date DATE,
    Plan VARCHAR(20),
    Monthly_Fee DECIMAL(10,2),
    Activity_Status VARCHAR(20),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID)
);


INSERT INTO Subscription_Activity
VALUES	-- Connor
		(101, 1, '2025-01-05', 'Basic', 10.00, 'Active'),
		(102, 1, '2025-02-05', 'Basic', 10.00, 'Active'),
		(103, 1, '2025-03-05', 'Premium', 20.00, 'Active'),
		(104, 1, '2025-03-20', 'Premium', 20.00, 'Cancelled'),
		(105, 1, '2025-05-05', 'Premium', 20.00, 'Active'),

		-- Ash
		(106, 2, '2025-01-10', 'Standard', 15.00, 'Active'),
		(107, 2, '2025-02-10', 'Standard', 15.00, 'Active'),
		(108, 2, '2025-03-10', 'Standard', 15.00, 'Cancelled'),
		(109, 2, '2025-04-10', 'Premium', 20.00, 'Active'),
		(110, 2, '2025-05-10', 'Premium', 20.00, 'Active'),

		-- Ethan
		(111, 3, '2025-02-01', 'Basic', 10.00, 'Active'),
		(112, 3, '2025-03-01', 'Basic', 10.00, 'Active'),
		(113, 3, '2025-04-01', 'Basic', 10.00, 'Active'),
		(114, 3, '2025-05-01', 'Basic', 10.00, 'Active'),

		-- Liam
		(115, 4, '2025-01-15', 'Premium', 20.00, 'Active'),
		(116, 4, '2025-02-15', 'Premium', 20.00, 'Cancelled'),
		(117, 4, '2025-04-15', 'Premium', 20.00, 'Active'),
		(118, 4, '2025-05-15', 'Premium', 20.00, 'Active'),

		-- Olivia
		(119, 5, '2025-01-20', 'Standard', 15.00, 'Active'),
		(120, 5, '2025-02-20', 'Standard', 15.00, 'Active'),
		(121, 5, '2025-03-20', 'Premium', 20.00, 'Active'),
		(122, 5, '2025-04-20', 'Premium', 20.00, 'Cancelled'),

		-- Mason
		(123, 6, '2025-02-05', 'Basic', 10.00, 'Active'),
		(124, 6, '2025-03-05', 'Basic', 10.00, 'Active'),
		(125, 6, '2025-04-05', 'Standard', 15.00, 'Active'),
		(126, 6, '2025-05-05', 'Standard', 15.00, 'Cancelled'),

		-- Sophia
		(127, 7, '2025-01-25', 'Basic', 10.00, 'Active'),
		(128, 7, '2025-02-25', 'Basic', 10.00, 'Active'),
		(129, 7, '2025-03-25', 'Basic', 10.00, 'Active'),
		(130, 7, '2025-04-25', 'Standard', 15.00, 'Active'),
		(131, 7, '2025-05-25', 'Standard', 15.00, 'Active'),

		-- Noah
		(132, 8, '2025-01-12', 'Standard', 15.00, 'Active'),
		(133, 8, '2025-02-12', 'Standard', 15.00, 'Active'),
		(134, 8, '2025-03-12', 'Standard', 15.00, 'Cancelled'),
		(135, 8, '2025-05-12', 'Premium', 20.00, 'Active');


-- ============================================================
-- CHECK DATA
-- ============================================================

SELECT *
FROM Customers;

SELECT *
FROM Subscription_Activity;


-- ============================================================
-- Q1 — Customer Subscription Summary
-- ============================================================
-- For every customer, return:
--
-- Customer_ID
-- Customer_Name
-- Total_Activity_Records
-- Active_Records
-- Cancelled_Records
-- Total_Subscription_Fees
-- Average_Monthly_Fee
--
-- Include ALL customers.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Activity_Records
-- Active_Records
-- Cancelled_Records
-- Total_Subscription_Fees
-- Average_Monthly_Fee

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(S.Activity_ID) AS Total_Activity_Records,
       COUNT(
       CASE
			WHEN S.Activity_Status = 'Active'
            THEN 1
       END) AS Active_Records,
       COUNT(
       CASE
			WHEN S.Activity_Status = 'Cancelled'
            THEN 1
       END) AS Cancelled_Records,
       SUM(S.Monthly_Fee) AS Total_Subscription_Fees,
       ROUND(AVG(S.Monthly_Fee), 2) AS Average_Monthly_Fee
FROM Customers C
LEFT JOIN Subscription_Activity S
	ON C.Customer_ID = S.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- ============================================================
-- Q2 — Plan Performance
-- ============================================================
-- For every plan, calculate:
--
-- Total_Records
-- Active_Records
-- Cancelled_Records
-- Unique_Customers
-- Total_Fees
-- Average_Fee
--
-- Include all plans.
--
-- Return:
-- Plan
-- Total_Records
-- Active_Records
-- Cancelled_Records
-- Unique_Customers
-- Total_Fees
-- Average_Fee

SELECT Plan,
	   COUNT(Activity_ID) AS Total_Records,
       COUNT(
       CASE
			WHEN Activity_Status = 'Active'
            THEN 1
       END) AS Active_Records,
       COUNT(
       CASE
			WHEN Activity_Status = 'Cancelled'
            THEN 1
       END) AS Cancelled_Records,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers,
       SUM(Monthly_Fee) AS Total_Fees,
       ROUND(AVG(Monthly_Fee), 2) AS Average_Fee
FROM Subscription_Activity 
GROUP BY Plan;


-- ============================================================
-- Q3 — Top 2 Customers Per City
-- ============================================================
-- Find the top 2 customers in each city based on:
--
-- Total Active Subscription Fees
--
-- Ties must be included.
--
-- Requirements:
-- 1. Calculate total active fees per customer.
-- 2. Rank customers within each city.
-- 3. Use DENSE_RANK().
-- 4. Return only ranks 1 and 2.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Active_Fees
-- Revenue_Rank

SELECT Customer_ID, Customer_Name, City, Total_Active_Fees, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Active_Fees DESC) AS Revenue_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(S.Monthly_Fee) AS Total_Active_Fees
		FROM Customers C
		INNER JOIN Subscription_Activity S
			ON C.Customer_ID = S.Customer_ID 
		WHERE S.Activity_Status = 'Active'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)R
)D
WHERE Revenue_Rank <= 2;


-- ============================================================
-- Q4 — Subscription Reactivation Within 30 Days
-- ============================================================
-- Find customers who became Active within 30 days
-- after their previous Cancelled activity.
--
-- Rules:
-- 1. Consider each customer's activities chronologically.
-- 2. Look at the previous activity using LAG().
-- 3. Previous activity must be Cancelled.
-- 4. Current activity must be Active.
-- 5. Difference between dates must be <= 30 days.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Activity_Date
-- Previous_Activity_Date
-- Days_Since_Cancellation

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, S.Activity_Date, S.Activity_Status,
		   LAG(S.Activity_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY S.Activity_Date, Activity_ID) AS Previous_Activity_Date,
           LAG(Activity_Status) OVER(PARTITION BY C.Customer_ID
           ORDER BY S.Activity_Date, Activity_ID) AS Previous_status
	FROM Customers C
	INNER JOIN Subscription_Activity S
		ON C.Customer_ID = S.Customer_ID 
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Activity_Date, Previous_Activity_Date) AS Days_Since_Cancellation
	FROM CTE
)
SELECT Customer_ID, Customer_Name, Activity_Date, Previous_Activity_Date, Days_Since_Cancellation
FROM CTE2
WHERE Activity_Status = 'Active'
AND Previous_status = 'Cancelled'
AND Days_Since_Cancellation <= 60;


-- ============================================================
-- Q5 — Customer Cohort Subscription Analysis
-- ============================================================
-- Group customers by their Signup Month.
--
-- For each cohort return:
--
-- Cohort_Month
-- Total_Customers
-- Active_Customers
-- Cancelled_Customers
-- Total_Active_Fees
-- Average_Active_Fees_Per_Customer
--
-- Important:
-- Total_Active_Fees should count only Active activities.
--
-- Average_Active_Fees_Per_Customer =
--
-- Total Active Fees / Number of customers
-- in that cohort with Active activity.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Active_Customers
-- Cancelled_Customers
-- Total_Active_Fees
-- Average_Active_Fees_Per_Customer

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Signup_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(DISTINCT
       CASE
			WHEN S.Activity_Status = 'Active'
            THEN C.Customer_ID
       END) AS Active_Customers,
       COUNT(DISTINCT
       CASE
			WHEN S.Activity_Status = 'Cancelled'
            THEN C.Customer_ID
       END) AS Cancelled_Customers,
       SUM(
       CASE
			WHEN S.Activity_Status = 'Active'
            THEN S.Monthly_Fee
            ELSE 0
       END) AS Total_Active_Fees,
       ROUND(SUM(
       CASE
			WHEN S.Activity_Status = 'Active'
            THEN S.Monthly_Fee
            ELSE 0
       END) / COUNT(DISTINCT
       CASE
			WHEN S.Activity_Status = 'Active'
            THEN C.Customer_ID
       END), 2) AS Average_Active_Fees_Per_Customer
FROM CTE C
LEFT JOIN Subscription_Activity S
	ON C.Customer_ID = S.Customer_ID
GROUP BY Cohort_Month;


-- ============================================================
-- BONUS — GAP & ISLAND
-- ============================================================
-- Find each customer's longest consecutive monthly
-- Active subscription streak.
--
-- Rules:
-- 1. Consider only Active activities.
-- 2. If a customer has multiple Active records in
--    the same month, count that month only once.
-- 3. Consecutive months form one streak.
-- 4. Find the longest streak per customer.
-- 5. If tied, choose the most recent streak.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, S.Activity_Date
	FROM Customers C
	INNER JOIN Subscription_Activity S
		ON C.Customer_ID = S.Customer_ID
	WHERE S.Activity_Status = 'Active'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Activity_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Activity_Date, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Activity_Date) AS Streak_Start_Month,
           MAX(Activity_Date) AS Streak_End_Month
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


-- ============================================================
-- BONUS+ — ABOVE-CITY-AVERAGE ACTIVE REVENUE
-- ============================================================
-- Calculate each customer's total Active subscription fees.
--
-- Then calculate the average active revenue for
-- each city using a window function.
--
-- Return only customers whose:
--
-- Total_Active_Fees > City_Average_Active_Revenue
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Active_Fees
-- City_Average_Active_Revenue

SELECT Customer_ID, Customer_Name, City, Total_Active_Fees, City_Average_Active_Revenue
FROM (
	SELECT *,
		   ROUND(AVG(Total_Active_Fees) OVER(PARTITION BY City), 2) AS City_Average_Active_Revenue
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(S.Monthly_Fee) AS Total_Active_Fees
		FROM Customers C
		INNER JOIN Subscription_Activity S
			ON C.Customer_ID = S.Customer_ID
		WHERE S.Activity_Status = 'Active'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Active_Fees > City_Average_Active_Revenue;


-- ============================================================
-- INTERVIEW CHALLENGE 🔥
-- ============================================================
-- Find the customer(s) with the highest number of
-- Active subscription records in each city.
--
-- Ties must be included.
--
-- Requirements:
-- 1. Count Active records per customer.
-- 2. Rank customers within each city.
-- 3. Use DENSE_RANK().
-- 4. Return only rank 1.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Active_Records
-- Activity_Rank

SELECT Customer_ID, Customer_Name, City, Active_Records, Activity_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Active_Records DESC) AS Activity_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   COUNT(S.Activity_ID) AS Active_Records
		FROM Customers C
		INNER JOIN Subscription_Activity S
			ON C.Customer_ID = S.Customer_ID
		WHERE S.Activity_Status = 'Active'
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)R
)D
WHERE Activity_Rank = 1;