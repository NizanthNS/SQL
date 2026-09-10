USE Daily_SQL;

-- Dataset: Subscription_Activity

CREATE TABLE Subscription_Activity (
    Activity_ID INT PRIMARY KEY,
    User_ID INT,
    User_Name VARCHAR(50),
    City VARCHAR(50),
    Plan_Name VARCHAR(30),
    Activity_Date DATE,
    Activity_Type VARCHAR(20),
    Amount DECIMAL(10,2)
);

INSERT INTO Subscription_Activity
VALUES	(1, 101, 'Connor', 'London', 'Basic', '2026-01-05', 'Payment', 20.00),
		(2, 101, 'Connor', 'London', 'Basic', '2026-01-15', 'Payment', 20.00),
		(3, 101, 'Connor', 'London', 'Basic', '2026-01-25', 'Refund', 10.00),
		(4, 101, 'Connor', 'London', 'Basic', '2026-02-05', 'Payment', 20.00),
		(5, 102, 'Ash', 'Toronto', 'Premium', '2026-01-03', 'Payment', 50.00),
		(6, 102, 'Ash', 'Toronto', 'Premium', '2026-01-13', 'Payment', 50.00),
		(7, 102, 'Ash', 'Toronto', 'Premium', '2026-01-23', 'Payment', 50.00),
		(8, 102, 'Ash', 'Toronto', 'Premium', '2026-02-02', 'Refund', 20.00),
		(9, 103, 'Mia', 'Sydney', 'Basic', '2026-01-08', 'Payment', 20.00),
		(10, 103, 'Mia', 'Sydney', 'Basic', '2026-01-18', 'Payment', 20.00),
		(11, 103, 'Mia', 'Sydney', 'Basic', '2026-01-28', 'Payment', 20.00),
		(12, 104, 'Liam', 'Berlin', 'Premium', '2026-02-01', 'Payment', 50.00),
		(13, 104, 'Liam', 'Berlin', 'Premium', '2026-02-11', 'Payment', 50.00),
		(14, 105, 'Sophie', 'Paris', 'Basic', '2026-01-10', 'Payment', 20.00),
		(15, 105, 'Sophie', 'Paris', 'Basic', '2026-01-20', 'Refund', 5.00),
		(16, 105, 'Sophie', 'Paris', 'Basic', '2026-01-30', 'Payment', 20.00),
		(17, 106, 'Ethan', 'New York', 'Premium', '2026-01-04', 'Payment', 50.00),
		(18, 106, 'Ethan', 'New York', 'Premium', '2026-01-14', 'Payment', 50.00),
		(19, 106, 'Ethan', 'New York', 'Premium', '2026-01-24', 'Payment', 50.00),
		(20, 107, 'Olivia', 'Madrid', 'Basic', '2026-02-03', 'Payment', 20.00),
		(21, 107, 'Olivia', 'Madrid', 'Basic', '2026-02-13', 'Payment', 20.00);
        

SELECT *
FROM Subscription_Activity;

-- Q1
-- For each user, calculate:
-- Total Activities
-- Total Payments
-- Total Refunds
-- Net Revenue = Payments - Refunds
--
-- Return:
-- User_ID
-- User_Name
-- Total_Activities
-- Total_Payments
-- Total_Refunds
-- Net_Revenue

WITH CTE AS (
	SELECT User_ID, User_Name,
		   COUNT(Activity_ID) AS Total_Activities,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Payment'
				THEN Amount
				ELSE 0
		   END) AS Total_Payments,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Refund'
				THEN Amount
				ELSE 0
		   END) AS Total_Refunds
	FROM Subscription_Activity
	GROUP BY User_ID, User_Name
)
SELECT User_ID, User_Name, Total_Activities, Total_Payments, Total_Refunds,
	   Total_Payments - Total_Refunds AS Net_Revenue
FROM CTE;


-- Q2
-- For each Plan_Name, calculate:
-- Total Payments
-- Total Refunds
-- Net Revenue
-- Average Payment Amount
--
-- Only Payment/Refund records are relevant.
--
-- Return:
-- Plan_Name
-- Total_Payments
-- Total_Refunds
-- Net_Revenue
-- Average_Payment_Amount

WITH CTE AS (
	SELECT Plan_Name,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Payment'
				THEN Amount
				ELSE 0
		   END) AS Total_Payments,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Refund'
				THEN Amount
				ELSE 0
		   END) AS Total_Refunds,
           ROUND(AVG(
		   CASE 
				WHEN Activity_Type = 'Payment'
				THEN Amount
		   END), 2) AS Average_Payment_Amount
	FROM Subscription_Activity
	GROUP BY Plan_Name
)
SELECT Plan_Name, Total_Payments, Total_Refunds,
	   Total_Payments - Total_Refunds AS Net_Revenue, Average_Payment_Amount
FROM CTE;


-- Q3
-- Find the TOP 2 users in each City based on Net Revenue.
-- Include ties.
--
-- Return:
-- City
-- User_ID
-- User_Name
-- Net_Revenue
-- Revenue_Rank

WITH CTE AS (
	SELECT City, User_ID, User_Name,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Payment'
				THEN Amount
				ELSE 0
		   END) AS Total_Payments,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Refund'
				THEN Amount
				ELSE 0
		   END) AS Total_Refunds
	FROM Subscription_Activity
	GROUP BY City, User_ID, User_Name
),
CTE2 AS (
	SELECT *,
		   Total_Payments - Total_Refunds AS Net_Revenue
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
		   ORDER BY Net_Revenue DESC) AS Revenue_Rank
	FROM CTE2
)
SELECT City, User_ID, User_Name, Net_Revenue, Revenue_Rank
FROM CTE3
WHERE Revenue_Rank <= 2;


-- Q4
-- For every Payment made by a user, compare it with
-- their PREVIOUS Payment.
--
-- Return only payments where the current payment
-- amount is greater than the previous payment amount.
--
-- Return:
-- User_ID
-- User_Name
-- Activity_Date
-- Amount
-- Previous_Payment_Amount
--
-- Important:
-- "Previous Payment" means previous chronologically.
-- If dates can be duplicated, use Activity_ID as a tie-breaker.

SELECT *
FROM (
	SELECT User_ID, User_Name, Activity_Date, Amount,
		   LAG(Amount) OVER(PARTITION BY User_ID
           ORDER BY Activity_Date, Activity_ID) AS Previous_Payment_Amount
	FROM Subscription_Activity
    WHERE Activity_Type = 'Payment'
)P
WHERE Amount > Previous_Payment_Amount;


-- Q5 — COHORT ANALYSIS
-- Treat each user's first Payment month as their Cohort_Month.
--
-- For each cohort month, calculate:
-- Total_Users
-- Total_Payments
-- Total_Revenue
-- Average_Payment_Amount
--
-- Total_Users must include users even if they made
-- no additional payments after their first payment.
--
-- Return:
-- Cohort_Month
-- Total_Users
-- Total_Payments
-- Total_Revenue
-- Average_Payment_Amount

WITH CTE AS (
	SELECT User_ID,
		   MIN(Activity_Date) AS First_Payment_Date
	FROM Subscription_Activity
    WHERE Activity_Type = 'Payment'
    GROUP BY User_ID
),
CTE2 AS (
	SELECT *,
		   DATE_FORMAT(First_Payment_Date, '%Y-%m') AS Cohort_Month
	FROM CTE
)
SELECT C.Cohort_Month,
	   COUNT(DISTINCT C.User_ID) AS Total_Users,
       COUNT(S.Activity_ID) AS Total_Payments,
       SUM(S.Amount) AS Total_Revenue,
       ROUND(AVG(S.Amount), 2) AS Average_Payment_Amount
FROM CTE2 C
LEFT JOIN Subscription_Activity S
	ON C.User_ID = S.User_ID
AND S.Activity_Type = 'Payment'
GROUP BY C.Cohort_Month;


-- BONUS — GAP & ISLAND
-- Find each user's longest streak of Payment activity
-- on consecutive calendar days.
--
-- Return:
-- User_ID
-- User_Name
-- Longest_Streak
-- Start_Date
-- End_Date

WITH CTE AS (
	SELECT DISTINCT User_ID, User_Name, Activity_Date
	FROM Subscription_Activity
	WHERE Activity_Type = 'Payment'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Activity_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Activity_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT User_ID, User_Name,
		   COUNT(*) AS Streak,
		   MIN(Activity_Date) AS Start_Date,
           MAX(Activity_Date) AS End_Date
	FROM CTE3
    GROUP BY User_ID, User_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY User_ID
           ORDER BY Streak DESC, End_Date DESC) AS  Row_Num
	FROM CTE4
)
SELECT User_ID, User_Name, Streak AS Longest_Streak,
	   Start_Date, End_Date
FROM CTE5
WHERE Row_Num = 1;


-- BONUS+
-- Find users whose Net Revenue is greater than
-- the average Net Revenue of their City.
--
-- Return:
-- User_ID
-- User_Name
-- City
-- Net_Revenue
-- City_Average_Net_Revenue

WITH CTE AS (
	SELECT City, User_ID, User_Name,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Payment'
				THEN Amount
				ELSE 0
		   END) AS Total_Payments,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Refund'
				THEN Amount
				ELSE 0
		   END) AS Total_Refunds
	FROM Subscription_Activity
	GROUP BY City, User_ID, User_Name
),
CTE2 AS (
	SELECT *,
		   Total_Payments - Total_Refunds AS Net_Revenue
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   ROUND(AVG(Net_Revenue) OVER(PARTITION BY City), 2) AS City_Average_Net_Revenue
	FROM CTE2
)
SELECT User_ID, User_Name, City, Net_Revenue, City_Average_Net_Revenue
FROM CTE3
WHERE Net_Revenue > City_Average_Net_Revenue;


-- INTERVIEW CHALLENGE
-- Find the top user in each Plan_Name based on Net Revenue.
-- Include ties.
--
-- Return:
-- Plan_Name
-- User_ID
-- User_Name
-- Net_Revenue
-- Revenue_Rank

WITH CTE AS (
	SELECT Plan_Name, User_ID, User_Name,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Payment'
				THEN Amount
				ELSE 0
		   END) AS Total_Payments,
		   SUM(
		   CASE 
				WHEN Activity_Type = 'Refund'
				THEN Amount
				ELSE 0
		   END) AS Total_Refunds
	FROM Subscription_Activity
	GROUP BY Plan_Name, User_ID, User_Name
),
CTE2 AS (
	SELECT *,
		   Total_Payments - Total_Refunds AS Net_Revenue
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Plan_Name
           ORDER BY Net_Revenue DESC) AS Revenue_Rank
	FROM CTE2
)
SELECT Plan_Name, User_ID, User_Name, Net_Revenue, Revenue_Rank
FROM CTE3
WHERE Revenue_Rank = 1;