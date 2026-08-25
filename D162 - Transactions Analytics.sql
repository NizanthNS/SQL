USE Daily_SQL;

-- =========================================================
-- DATASET : Transactions Analytics
-- =========================================================

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(100),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Connor', 'Chennai', '2025-01-10'),
		(2, 'Ashley', 'Chennai', '2025-01-15'),
		(3, 'Ethan', 'Bangalore', '2025-02-05'),
		(4, 'Daniel', 'Bangalore', '2025-02-20'),
		(5, 'Mason', 'Mumbai', '2025-03-01'),
		(6, 'Sophia', 'Mumbai', '2025-03-12'),
		(7, 'Ryan', 'Chennai', '2025-04-08'),
		(8, 'Emma', 'Bangalore', '2025-04-18');


CREATE TABLE Bank_Transactions (
    Transaction_ID INT PRIMARY KEY,
    Customer_ID INT,
    Transaction_Date DATE,
    Transaction_Type VARCHAR(50),
    Transaction_Amount DECIMAL(10,2),
    Transaction_Status VARCHAR(50),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Bank_Transactions
VALUES	(101, 1, '2025-05-01', 'Credit', 5000, 'Completed'),
		(102, 1, '2025-05-02', 'Debit', 1500, 'Completed'),
		(103, 1, '2025-05-03', 'Credit', 3000, 'Completed'),
		(104, 1, '2025-05-05', 'Debit', 1000, 'Completed'),

		(105, 2, '2025-05-01', 'Credit', 7000, 'Completed'),
		(106, 2, '2025-05-02', 'Debit', 2000, 'Completed'),
		(107, 2, '2025-05-04', 'Credit', 4000, 'Failed'),

		(108, 3, '2025-05-02', 'Credit', 6000, 'Completed'),
		(109, 3, '2025-05-03', 'Debit', 1200, 'Completed'),
		(110, 3, '2025-05-04', 'Credit', 3500, 'Completed'),
		(111, 3, '2025-05-06', 'Debit', 1800, 'Completed'),

		(112, 4, '2025-05-01', 'Credit', 8000, 'Completed'),
		(113, 4, '2025-05-02', 'Debit', 2500, 'Completed'),
		(114, 4, '2025-05-04', 'Credit', 4500, 'Failed'),

		(115, 5, '2025-05-01', 'Credit', 5500, 'Completed'),
		(116, 5, '2025-05-02', 'Debit', 1800, 'Completed'),
		(117, 5, '2025-05-03', 'Credit', 4200, 'Completed'),

		(118, 6, '2025-05-02', 'Credit', 9000, 'Completed'),
		(119, 6, '2025-05-03', 'Debit', 3000, 'Completed'),
		(120, 6, '2025-05-05', 'Credit', 5000, 'Completed'),

		(121, 7, '2025-05-01', 'Credit', 4500, 'Completed'),
		(122, 7, '2025-05-02', 'Debit', 1000, 'Completed'),
		(123, 7, '2025-05-03', 'Credit', 3500, 'Completed'),

		(124, 8, '2025-05-03', 'Credit', 7500, 'Completed'),
		(125, 8, '2025-05-04', 'Debit', 2200, 'Completed'),
		(126, 8, '2025-05-05', 'Credit', 4800, 'Completed');
    
    
SELECT *
FROM Customers;
        
SELECT *
FROM Bank_Transactions;


-- =========================================================
-- QUESTIONS
-- =========================================================

-- Q1
-- Show each customer's:
-- total transactions
-- total transaction amount
-- average transaction amount
-- total completed transactions.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Transactions
-- Total_Transaction_Amount
-- Average_Transaction_Amount
-- Total_Completed_Transactions

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(B.Transaction_ID) AS Total_Transactions,
       SUM(B.Transaction_Amount) AS Total_Transaction_Amount,
       ROUND(AVG(B.Transaction_Amount), 2) AS Average_Transaction_Amount,
       COUNT(
       CASE
			WHEN B.Transaction_Status = 'Completed'
            THEN 1
	   END) AS Total_Completed_Transactions
FROM Customers C
INNER JOIN Bank_Transactions B
	ON C.Customer_ID = B.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each transaction type, find:
-- total transactions
-- total transaction amount
-- average transaction amount
-- unique customers.
--
-- Return:
-- Transaction_Type
-- Total_Transactions
-- Total_Transaction_Amount
-- Average_Transaction_Amount
-- Unique_Customers

SELECT Transaction_Type,
	   COUNT(Transaction_ID) AS Total_Transactions,
       SUM(Transaction_Amount) AS Total_Transaction_Amount,
       ROUND(AVG(Transaction_Amount), 2) AS Average_Transaction_Amount,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Bank_Transactions
GROUP BY Transaction_Type;


-- Q3
-- Find the top 3 customers in each city
-- based on their total completed transaction amount.
--
-- If tied, return all tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Completed_Amount

SELECT City, Customer_ID, Customer_Name, Total_Completed_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Completed_Amount DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(
			   CASE
					WHEN B.Transaction_Status = 'Completed' 
					THEN B.Transaction_Amount
					ELSE 0
			   END) AS Total_Completed_Amount
		FROM Customers C
		INNER JOIN Bank_Transactions B
			ON C.Customer_ID = B.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)B
)D
WHERE D_Rank <= 3;


-- Q4
-- Find transactions where the transaction amount
-- is greater than the customer's previous
-- completed transaction amount.
--
-- Only Completed transactions should be compared.
--
-- Use JOIN + LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Transaction_Date
-- Transaction_Amount
-- Previous_Transaction_Amount

SELECT *
FROM (
	SELECT C.Customer_ID, C.Customer_Name, B.Transaction_Date, B.Transaction_Amount,
		   LAG(B.Transaction_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY B.Transaction_Date, B.Transaction_ID) AS Previous_Transaction_Amount
	FROM Customers C
	INNER JOIN Bank_Transactions B
		ON C.Customer_ID = B.Customer_ID
	WHERE B.Transaction_Status = 'Completed'
)P
WHERE Transaction_Amount > Previous_Transaction_Amount;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
-- total completed transactions
-- total completed transaction amount
-- average completed transaction amount.
--
-- Definition:
-- Cohort Month = month in which the customer joined.
--
-- Only Completed transactions should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Completed_Transactions
-- Total_Completed_Amount
-- Average_Completed_Amount

WITH CTE AS (
	SELECT Customer_ID,
		   DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
	FROM Customers
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
	   COUNT(B.Transaction_ID) AS Total_Completed_Transactions,
       SUM(B.Transaction_Amount) AS Total_Completed_Amount,
       ROUND(AVG(B.Transaction_Amount), 2) AS Average_Completed_Amount
FROM CTE C
INNER JOIN Bank_Transactions B
	ON C.Customer_ID = B.Customer_ID
WHERE B.Transaction_Status = 'Completed'
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means having a Completed transaction
-- on consecutive dates.
--
-- Ignore duplicate transaction dates for the same customer.
-- Only Completed transactions count.
--
-- Find each customer's longest completed-transaction
-- date streak.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, B.Transaction_Date
	FROM Customers C
	INNER JOIN Bank_Transactions B
		ON C.Customer_ID = B.Customer_ID
	WHERE B.Transaction_Status = 'Completed'
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
-- Find customers whose total completed transaction amount
-- is greater than the average total completed transaction
-- amount of customers in the same city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Completed_Amount

SELECT Customer_ID, Customer_Name, City, Total_Completed_Amount
FROM (
	SELECT *,
		   AVG(Total_Completed_Amount) OVER(PARTITION BY City) AS Avg_Completed_Amount
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(
			   CASE
					WHEN B.Transaction_Status = 'Completed' 
					THEN B.Transaction_Amount
					ELSE 0
			   END) AS Total_Completed_Amount
		FROM Customers C
		INNER JOIN Bank_Transactions B
			ON C.Customer_ID = B.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)B
)A
WHERE Total_Completed_Amount > Avg_Completed_Amount;


-- INTERVIEW CHALLENGE
-- For each transaction type, find the customer
-- with the highest total completed transaction amount
-- for that transaction type.
--
-- If tied, return all tied customers.
--
-- Return:
-- Transaction_Type
-- Customer_ID
-- Customer_Name
-- Total_Completed_Amount

SELECT Transaction_Type, Customer_ID, Customer_Name, Total_Completed_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Transaction_Type
           ORDER BY Total_Completed_Amount DESC) AS D_Rank
	FROM (
		SELECT B.Transaction_Type, C.Customer_ID, C.Customer_Name,
			   SUM(
			   CASE
					WHEN B.Transaction_Status = 'Completed' 
					THEN B.Transaction_Amount
					ELSE 0
			   END) AS Total_Completed_Amount
		FROM Customers C
		INNER JOIN Bank_Transactions B
			ON C.Customer_ID = B.Customer_ID
		GROUP BY B.Transaction_Type, C.Customer_ID, C.Customer_Name
	)D
)T
WHERE D_Rank = 1;