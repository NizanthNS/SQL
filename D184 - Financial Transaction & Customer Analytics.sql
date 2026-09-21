USE Daily_SQL;

-- =========================================================
-- SESSION — Financial Transaction & Customer Analytics
-- =========================================================


-- =========================================================
-- TABLE 1 — Customers
-- =========================================================

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Daniel', 'London', '2024-01-15'),
		(2, 'Sophia', 'Toronto', '2024-02-10'),
		(3, 'Liam', 'Sydney', '2024-03-05'),
		(4, 'Emma', 'Berlin', '2024-03-20'),
		(5, 'Noah', 'Paris', '2024-04-12'),
		(6, 'Olivia', 'London', '2024-05-18'),
		(7, 'Ethan', 'Toronto', '2024-06-01'),
		(8, 'Ava', 'Sydney', '2024-06-25');


-- =========================================================
-- TABLE 2 — Accounts
-- =========================================================

CREATE TABLE Accounts (
    Account_ID INT PRIMARY KEY,
    Customer_ID INT,
    Account_Type VARCHAR(30),
    Open_Date DATE,
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Accounts
VALUES	(101, 1, 'Savings', '2024-01-20'),
		(102, 1, 'Current', '2024-03-01'),
		(103, 2, 'Savings', '2024-02-15'),
		(104, 3, 'Current', '2024-03-10'),
		(105, 3, 'Savings', '2024-04-05'),
		(106, 4, 'Savings', '2024-03-25'),
		(107, 5, 'Current', '2024-04-20'),
		(108, 6, 'Savings', '2024-05-25'),
		(109, 7, 'Current', '2024-06-10'),
		(110, 8, 'Savings', '2024-07-01');


-- =========================================================
-- TABLE 3 — Transactions
-- =========================================================

CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY,
    Account_ID INT,
    Transaction_Date DATE,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(10,2),
    Transaction_Status VARCHAR(20),
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID)
);

INSERT INTO Transactions
VALUES	(1001, 101, '2025-01-05', 'Credit', 2500, 'Completed'),
		(1002, 101, '2025-01-12', 'Debit', 800, 'Completed'),
		(1003, 101, '2025-02-05', 'Credit', 3000, 'Completed'),
		(1004, 101, '2025-02-18', 'Debit', 1200, 'Completed'),
		(1005, 101, '2025-03-10', 'Credit', 2800, 'Completed'),

		(1006, 102, '2025-03-05', 'Credit', 4000, 'Completed'),
		(1007, 102, '2025-03-18', 'Debit', 1500, 'Completed'),
		(1008, 102, '2025-04-05', 'Credit', 4500, 'Completed'),
		(1009, 102, '2025-04-20', 'Debit', 2000, 'Completed'),

		(1010, 103, '2025-01-08', 'Credit', 3200, 'Completed'),
		(1011, 103, '2025-02-14', 'Debit', 1000, 'Completed'),
		(1012, 103, '2025-03-12', 'Credit', 3600, 'Completed'),
		(1013, 103, '2025-03-25', 'Debit', 1400, 'Completed'),

		(1014, 104, '2025-02-05', 'Credit', 5000, 'Completed'),
		(1015, 104, '2025-02-20', 'Debit', 1800, 'Completed'),
		(1016, 104, '2025-03-15', 'Credit', 4200, 'Completed'),
		(1017, 104, '2025-04-10', 'Debit', 2200, 'Completed'),

		(1018, 105, '2025-03-05', 'Credit', 2800, 'Completed'),
		(1019, 105, '2025-03-20', 'Debit', 900, 'Completed'),
		(1020, 105, '2025-04-15', 'Credit', 3100, 'Completed'),
		(1021, 105, '2025-05-10', 'Debit', 1200, 'Completed'),

		(1022, 106, '2025-01-10', 'Credit', 2200, 'Completed'),
		(1023, 106, '2025-02-10', 'Credit', 2600, 'Completed'),
		(1024, 106, '2025-03-10', 'Debit', 700, 'Completed'),
		(1025, 106, '2025-04-10', 'Credit', 3000, 'Completed'),

		(1026, 107, '2025-02-15', 'Credit', 3500, 'Completed'),
		(1027, 107, '2025-03-15', 'Debit', 1000, 'Completed'),
		(1028, 107, '2025-04-15', 'Credit', 3900, 'Completed'),
		(1029, 107, '2025-05-15', 'Debit', 1300, 'Completed'),

		(1030, 108, '2025-03-05', 'Credit', 2700, 'Completed'),
		(1031, 108, '2025-03-20', 'Debit', 800, 'Completed'),
		(1032, 108, '2025-04-05', 'Credit', 3200, 'Completed'),
		(1033, 108, '2025-05-05', 'Credit', 3500, 'Completed'),

		(1034, 109, '2025-04-10', 'Credit', 4500, 'Completed'),
		(1035, 109, '2025-05-10', 'Debit', 1600, 'Completed'),
		(1036, 109, '2025-06-10', 'Credit', 4800, 'Completed'),

		(1037, 110, '2025-05-05', 'Credit', 3000, 'Completed'),
		(1038, 110, '2025-06-05', 'Debit', 1100, 'Completed'),
		(1039, 110, '2025-07-05', 'Credit', 3400, 'Completed');


-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT *
FROM Customers;

SELECT *
FROM Accounts;

SELECT *
FROM Transactions;


-- =========================================================
-- Q1 — Customer Transaction Summary
-- =========================================================
-- For every customer, calculate:
-- total transactions,
-- total credits,
-- total debits,
-- total credit amount,
-- total debit amount,
-- net transaction amount.
--
-- Net_Transaction_Amount =
-- total credit amount - total debit amount
--
-- Include customers with no transactions.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Transactions
-- Total_Credits
-- Total_Debits
-- Total_Credit_Amount
-- Total_Debit_Amount
-- Net_Transaction_Amount

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(T.Transaction_ID) AS Total_Transactions,
       COUNT(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN 1
	   END) AS Total_Credits,
       COUNT(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN 1
	   END) AS Total_Debits,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN T.Amount
            ELSE 0
	   END) AS Total_Credit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Amount
            ELSE 0
	   END) AS Total_Debit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN T.Amount
            ELSE 0
	   END) - SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Amount
            ELSE 0
	   END) AS Net_Transaction_Amount
FROM Customers C
LEFT JOIN AccountS A
	ON C.Customer_ID = A.Customer_ID
LEFT JOIN Transactions T
	ON A.Account_ID = T.Account_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- =========================================================
-- Q2 — Account Performance
-- =========================================================
-- For each account, calculate:
-- total completed transactions,
-- total credit amount,
-- total debit amount,
-- net amount,
-- average transaction amount.
--
-- Only Completed transactions count.
--
-- Return:
-- Account_ID
-- Customer_ID
-- Account_Type
-- Total_Transactions
-- Total_Credit_Amount
-- Total_Debit_Amount
-- Net_Amount
-- Average_Transaction_Amount

SELECT A.Account_ID, A.Customer_ID, A.Account_Type,
	   COUNT(T.Transaction_ID) AS Total_Transactions,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN T.Amount
            ELSE 0
	   END) AS Total_Credit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Amount
            ELSE 0
	   END) AS Total_Debit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN T.Amount
            ELSE 0
	   END) - SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Amount
            ELSE 0
	   END) AS Net_Amount,
       ROUND(AVG(T.Amount), 2) AS Average_Transaction_Amount
FROM AccountS A
LEFT JOIN Transactions T
	ON A.Account_ID = T.Account_ID
	AND T.Transaction_Status = 'Completed'
GROUP BY A.Account_ID, A.Customer_ID, A.Account_Type;


-- =========================================================
-- Q3 — Top 2 Customers Per City
-- =========================================================
-- Find the top 2 customers in each city based on
-- their total completed transaction net amount.
--
-- Net_Amount =
-- total credits - total debits
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Net_Amount
-- Net_Rank

SELECT City, Customer_ID, Customer_Name, Net_Amount, Net_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Net_Amount DESC) AS Net_Rank
	FROM (
		SELECT C.City, C.Customer_ID, C.Customer_Name,
			   SUM(
			   CASE
					WHEN T.Transaction_Type = 'Credit'
					THEN T.Amount
					ELSE 0
			   END) - SUM(
			   CASE
					WHEN T.Transaction_Type = 'Debit'
					THEN T.Amount
					ELSE 0
			   END) AS Net_Amount
		FROM Customers C
		INNER JOIN AccountS A
			ON C.Customer_ID = A.Customer_ID
		INNER JOIN Transactions T
			ON A.Account_ID = T.Account_ID
		WHERE T.Transaction_Status = 'Completed'
		GROUP BY C.City, C.Customer_ID, C.Customer_Name
	)C
)N
WHERE Net_Rank <= 2;


-- =========================================================
-- Q4 — Transaction Gap Analysis
-- =========================================================
-- For every account, find transactions where the gap
-- from the previous completed transaction is more than
-- 15 days.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Only Completed transactions count.
--
-- Return:
-- Account_ID
-- Transaction_ID
-- Transaction_Date
-- Previous_Transaction_Date
-- Days_Since_Previous

WITH CTE AS (
	SELECT A.Account_ID, T.Transaction_ID, T.Transaction_Date,
		   LAG(T.Transaction_Date) OVER(PARTITION BY A.Account_ID
           ORDER BY T.Transaction_Date, T.Transaction_ID) AS Previous_Transaction_Date
	FROM AccountS A
	INNER JOIN Transactions T
		ON A.Account_ID = T.Account_ID
	WHERE T.Transaction_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Transaction_Date, Previous_Transaction_Date) AS Days_Since_Previous
	FROM CTE
)
SELECT  Account_ID, Transaction_ID, Transaction_Date, Previous_Transaction_Date, Days_Since_Previous
FROM CTE2
WHERE Days_Since_Previous > 15;


-- =========================================================
-- Q5 — Customer Cohort Transaction Analysis
-- =========================================================
-- Group customers by their Join Month.
--
-- Calculate:
-- total customers,
-- active customers,
-- total transactions,
-- total credit amount,
-- total debit amount,
-- total net amount,
-- average net amount per active customer.
--
-- An Active Customer is a customer with at least one
-- Completed transaction.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Active_Customers
-- Total_Transactions
-- Total_Credit_Amount
-- Total_Debit_Amount
-- Total_Net_Amount
-- Average_Net_Per_Active_Customer

WITH CTE AS (
	SELECT Customer_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Customers
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(DISTINCT
       CASE
			WHEN T.Transaction_ID IS NOT NULL AND T.Transaction_Status = 'Completed'
            THEN C.Customer_ID
	   END) AS Active_Customers,
	   COUNT(T.Transaction_ID) AS Total_Transactions,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN T.Amount
            ELSE 0
	   END) AS Total_Credit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Amount
            ELSE 0
	   END) AS Total_Debit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN T.Amount
            ELSE 0
	   END) - SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Amount
            ELSE 0
	   END) AS Total_Net_Amount,
       ROUND((SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit'
            THEN T.Amount
            ELSE 0
	   END) - SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Amount
            ELSE 0
	   END)) / COUNT(DISTINCT
       CASE
			WHEN T.Transaction_ID IS NOT NULL AND T.Transaction_Status = 'Completed'
            THEN C.Customer_ID
	   END), 2) AS Average_Net_Per_Active_Customer
FROM CTE C
LEFT JOIN AccountS A
	ON C.Customer_ID = A.Customer_ID
LEFT JOIN Transactions T
	ON A.Account_ID = T.Account_ID
GROUP BY Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- Find each customer's longest consecutive MONTHLY
-- transaction-activity streak.
--
-- Rules:
-- 1. Multiple transactions in the same month count ONCE.
-- 2. Only Completed transactions count.
-- 3. Consecutive months form a streak.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name,
		   DATE_FORMAT(T.Transaction_Date, '%Y-%m-01') AS Transaction_Month
	FROM Customers C
	INNER JOIN AccountS A
		ON C.Customer_ID = A.Customer_ID
	INNER JOIN Transactions T
		ON A.Account_ID = T.Account_ID
	WHERE T.Transaction_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Transaction_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Transaction_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Transaction_Month) AS Streak_Start_Month,
           MAX(Transaction_Month) AS Streak_End_Month
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
-- BONUS+ — Above-City-Average Customer
-- =========================================================
-- Find customers whose net transaction amount is greater
-- than the average customer net amount in their city.
--
-- Use a window function.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Net_Amount
-- City_Average_Net_Amount

SELECT Customer_ID, Customer_Name, City, Net_Amount, City_Average_Net_Amount
FROM (
	SELECT *,
		   AVG(Net_Amount) OVER(PARTITION BY City) AS City_Average_Net_Amount
	FROM (
			SELECT C.City, C.Customer_ID, C.Customer_Name,
				   SUM(
				   CASE
						WHEN T.Transaction_Type = 'Credit'
						THEN T.Amount
						ELSE 0
				   END) - SUM(
				   CASE
						WHEN T.Transaction_Type = 'Debit'
						THEN T.Amount
						ELSE 0
				   END) AS Net_Amount
			FROM Customers C
			INNER JOIN AccountS A
				ON C.Customer_ID = A.Customer_ID
			INNER JOIN Transactions T
				ON A.Account_ID = T.Account_ID
			AND T.Transaction_Status = 'Completed'
			GROUP BY C.City, C.Customer_ID, C.Customer_Name
	)N
)A
WHERE Net_Amount > City_Average_Net_Amount;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each account type, find the account(s) with the
-- highest net transaction amount.
--
-- Only Completed transactions count.
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- Account_Type
-- Account_ID
-- Customer_ID
-- Net_Amount
-- Net_Rank

SELECT Account_Type, Account_ID, Customer_ID, Net_Amount, Net_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Account_Type
           ORDER BY Net_Amount DESC) AS Net_Rank
	FROM (
		SELECT A.Account_Type, A.Account_ID, A.Customer_ID,
			   SUM(
			   CASE
					WHEN T.Transaction_Type = 'Credit'
					THEN T.Amount
					ELSE 0
			   END) - SUM(
			   CASE
					WHEN T.Transaction_Type = 'Debit'
					THEN T.Amount
					ELSE 0
			   END) AS Net_Amount
		FROM Customers C
		INNER JOIN AccountS A
			ON C.Customer_ID = A.Customer_ID
		INNER JOIN Transactions T
			ON A.Account_ID = T.Account_ID
		WHERE T.Transaction_Status = 'Completed'
		GROUP BY A.Account_Type, A.Account_ID, A.Customer_ID
	)D
)N
WHERE Net_Rank = 1;