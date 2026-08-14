USE Daily_SQL;

-- DATASET : Bank Transactions

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY,
    Customer_ID INT,
    Transaction_Date DATE,
    Transaction_Type VARCHAR(20),
    Transaction_Amount DECIMAL(10,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Customers
VALUES	(1, 'Arun', 'Chennai', '2025-01-10'),
		(2, 'Bala', 'Chennai', '2025-02-15'),
		(3, 'Kiran', 'Madurai', '2025-01-20'),
		(4, 'Vijay', 'Madurai', '2025-03-05'),
		(5, 'Rahul', 'Coimbatore', '2025-02-25'),
		(6, 'Suresh', 'Coimbatore', '2025-01-15');

INSERT INTO Transactions
VALUES	(101, 1, '2025-03-01', 'Credit', 5000),
		(102, 1, '2025-03-02', 'Debit', 2000),
		(103, 1, '2025-03-03', 'Credit', 3000),
		(104, 1, '2025-03-10', 'Debit', 1500),

		(105, 2, '2025-03-01', 'Credit', 4000),
		(106, 2, '2025-03-04', 'Debit', 1000),
		(107, 2, '2025-03-05', 'Credit', 2500),

		(108, 3, '2025-03-01', 'Credit', 6000),
		(109, 3, '2025-03-02', 'Debit', 2000),
		(110, 3, '2025-03-05', 'Credit', 3500),

		(111, 4, '2025-03-10', 'Debit', 1200),
		(112, 4, '2025-03-11', 'Credit', 1800),
		(113, 4, '2025-03-12', 'Credit', 5000),

		(114, 5, '2025-03-02', 'Credit', 3000),
		(115, 5, '2025-03-08', 'Debit', 1500),
		(116, 5, '2025-03-09', 'Credit', 2000),

		(117, 6, '2025-03-01', 'Credit', 1000),
		(118, 6, '2025-03-02', 'Credit', 1500),
		(119, 6, '2025-03-03', 'Debit', 500),
		(120, 6, '2025-03-04', 'Credit', 4000);
        
SELECT *
FROM Customers;

SELECT *
FROM Transactions;

-- Q1
-- Show each customer's:
-- total transactions
-- total transaction amount
-- average transaction amount
-- total credit amount
-- total debit amount.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Transactions
-- Total_Transaction_Amount
-- Average_Transaction_Amount
-- Total_Credit_Amount
-- Total_Debit_Amount

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(T.Transaction_ID) AS Total_Transactions,
       SUM(T.Transaction_Amount) AS Total_Transaction_Amount,
       ROUND(AVG(T.Transaction_Amount), 2) AS Average_Transaction_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit' 
            THEN T.Transaction_Amount
            ELSE 0
	   END) AS Total_Credit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Transaction_Amount
            ELSE 0
	   END) AS Total_Debit_Amount
FROM Customers C
INNER JOIN Transactions T
	ON C.Customer_ID = T.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;
	   

-- Q2
-- For each city, find:
-- total transaction amount
-- total credit amount
-- total debit amount
-- number of unique customers.
--
-- Return:
-- City
-- Total_Transaction_Amount
-- Total_Credit_Amount
-- Total_Debit_Amount
-- Unique_Customers

SELECT C.City,
	   SUM(T.Transaction_Amount) AS Total_Transaction_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Credit' 
            THEN T.Transaction_Amount
            ELSE 0
	   END) AS Total_Credit_Amount,
       SUM(
       CASE
			WHEN T.Transaction_Type = 'Debit'
            THEN T.Transaction_Amount
            ELSE 0
	   END) AS Total_Debit_Amount,
       COUNT(DISTINCT C.Customer_ID) AS Unique_Customers
FROM Customers C
INNER JOIN Transactions T
	ON C.Customer_ID = T.Customer_ID
GROUP BY C.City;


-- Q3
-- Find the top 3 customers in each city
-- based on their total credit amount.
--
-- If tied, return all tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Credit_Amount

SELECT City, Customer_ID, Customer_Name, Total_Credit_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Credit_Amount DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(
			   CASE
					WHEN T.Transaction_Type = 'Credit' 
					THEN T.Transaction_Amount
					ELSE 0
			   END) AS Total_Credit_Amount
		FROM Customers C
		INNER JOIN Transactions T
			ON C.Customer_ID = T.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)T
)D
WHERE D_Rank <= 3;


-- Q4
-- Find transactions where the transaction amount
-- is greater than the customer's previous transaction amount.
--
-- Use LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Transaction_Date
-- Transaction_Amount
-- Previous_Transaction_Amount

SELECT *
FROM (
	SELECT C.Customer_ID, C.Customer_Name, T.Transaction_Date, T.Transaction_Amount,
		   LAG(T.Transaction_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY T.Transaction_Date, T.Transaction_ID) AS Previous_Transaction_Amount
	FROM Customers C
	INNER JOIN Transactions T
		ON C.Customer_ID = T.Customer_ID
)P
WHERE Transaction_Amount > Previous_Transaction_Amount;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
-- total transaction amount
-- total credit amount
-- average transaction amount.
--
-- Definition:
-- Cohort Month = month in which the customer joined.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Transaction_Amount
-- Total_Credit_Amount
-- Average_Transaction_Amount

WITH CTE AS (
	SELECT Customer_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Customers
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       SUM(T.Transaction_Amount) AS Total_Transaction_Amount,
       SUM(CASE
				WHEN T.Transaction_Type = 'Credit'
                THEN T.Transaction_Amount
                ELSE 0
	   END) AS Total_Credit_Amount,
       ROUND(AVG(T.Transaction_Amount), 2) AS Average_Transaction_Amount
FROM CTE C
INNER JOIN Transactions T
	ON C.Customer_ID = T.Customer_ID
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each customer's longest consecutive
-- transaction-date streak.
--
-- Ignore duplicate transaction dates.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, T.Transaction_Date
	FROM Customers C
	INNER JOIN Transactions T
		ON C.Customer_ID = T.Customer_ID
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Transaction_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Transaction_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Transaction_Date) AS Start_Date,
           MAX(Transaction_Date) AS End_Date
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
-- Find customers whose total credit amount
-- is greater than the average total credit amount
-- of customers in the same city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Credit_Amount

SELECT Customer_ID, Customer_Name, City, Total_Credit_Amount
FROM (
	SELECT *,
		   AVG(Total_Credit_Amount) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(CASE
						WHEN T.Transaction_Type = 'Credit'
						THEN T.Transaction_Amount
						ELSE 0
			   END) AS Total_Credit_Amount
		FROM Customers C
		INNER JOIN Transactions T
			ON C.Customer_ID = T.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Credit_Amount > Avg_City;


-- INTERVIEW CHALLENGE
-- For each transaction type, find the customer
-- with the highest total transaction amount.
--
-- If tied, return all tied customers.
--
-- Return:
-- Transaction_Type
-- Customer_ID
-- Customer_Name
-- Total_Transaction_Amount

SELECT Transaction_Type, Customer_ID, Customer_Name, Total_Transaction_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Transaction_Type
           ORDER BY Total_Transaction_Amount DESC) AS D_Rank
	FROM (
		SELECT T.Transaction_Type, C.Customer_ID, C.Customer_Name,
			   SUM(T.Transaction_Amount) AS Total_Transaction_Amount
		FROM Customers C
		INNER JOIN Transactions T
			ON C.Customer_ID = T.Customer_ID
		GROUP BY T.Transaction_Type, C.Customer_ID, C.Customer_Name
	)D
)T
WHERE D_Rank = 1;