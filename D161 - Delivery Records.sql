USE Daily_SQL;

-- =========================================================
-- DATASET : Delivery Records
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


CREATE TABLE Delivery_Records (
    Delivery_ID INT PRIMARY KEY,
    Customer_ID INT,
    Delivery_Date DATE,
    Restaurant_Name VARCHAR(100),
    Food_Category VARCHAR(50),
    Delivery_Amount DECIMAL(10,2),
    Delivery_Status VARCHAR(50),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Delivery_Records
VALUES	(101, 1, '2025-05-01', 'Burger House', 'Fast Food', 450, 'Delivered'),
		(102, 1, '2025-05-02', 'Pizza World', 'Pizza', 650, 'Delivered'),
		(103, 1, '2025-05-03', 'Sushi Hub', 'Japanese', 900, 'Delivered'),
		(104, 1, '2025-05-05', 'Burger House', 'Fast Food', 500, 'Delivered'),

		(105, 2, '2025-05-01', 'Pizza World', 'Pizza', 700, 'Delivered'),
		(106, 2, '2025-05-03', 'Burger House', 'Fast Food', 400, 'Delivered'),
		(107, 2, '2025-05-04', 'Sushi Hub', 'Japanese', 850, 'Cancelled'),

		(108, 3, '2025-05-02', 'Sushi Hub', 'Japanese', 1000, 'Delivered'),
		(109, 3, '2025-05-03', 'Pizza World', 'Pizza', 750, 'Delivered'),
		(110, 3, '2025-05-04', 'Burger House', 'Fast Food', 550, 'Delivered'),
		(111, 3, '2025-05-06', 'Pizza World', 'Pizza', 800, 'Delivered'),

		(112, 4, '2025-05-01', 'Pizza World', 'Pizza', 900, 'Delivered'),
		(113, 4, '2025-05-02', 'Pizza World', 'Pizza', 850, 'Delivered'),
		(114, 4, '2025-05-04', 'Burger House', 'Fast Food', 600, 'Cancelled'),

		(115, 5, '2025-05-01', 'Burger House', 'Fast Food', 500, 'Delivered'),
		(116, 5, '2025-05-02', 'Sushi Hub', 'Japanese', 800, 'Delivered'),
		(117, 5, '2025-05-03', 'Pizza World', 'Pizza', 700, 'Delivered'),

		(118, 6, '2025-05-02', 'Pizza World', 'Pizza', 950, 'Delivered'),
		(119, 6, '2025-05-03', 'Sushi Hub', 'Japanese', 1100, 'Delivered'),
		(120, 6, '2025-05-05', 'Burger House', 'Fast Food', 550, 'Delivered'),

		(121, 7, '2025-05-01', 'Sushi Hub', 'Japanese', 900, 'Delivered'),
		(122, 7, '2025-05-02', 'Pizza World', 'Pizza', 750, 'Delivered'),
		(123, 7, '2025-05-03', 'Burger House', 'Fast Food', 600, 'Delivered'),

		(124, 8, '2025-05-03', 'Pizza World', 'Pizza', 800, 'Delivered'),
		(125, 8, '2025-05-04', 'Sushi Hub', 'Japanese', 950, 'Delivered'),
		(126, 8, '2025-05-05', 'Pizza World', 'Pizza', 1000, 'Delivered');
        
SELECT *
FROM Customers;

SELECT *
FROM Delivery_Records;

-- =========================================================
-- QUESTIONS
-- =========================================================

-- Q1
-- Show each customer's:
-- total deliveries
-- total delivery amount
-- average delivery amount
-- total delivered deliveries.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Deliveries
-- Total_Delivery_Amount
-- Average_Delivery_Amount
-- Total_Delivered_Deliveries

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(D.Delivery_ID) AS Total_Deliveries,
       SUM(D.Delivery_Amount) AS Total_Delivery_Amount,
       ROUND(AVG(D.Delivery_Amount), 2) AS Average_Delivery_Amount,
       COUNT(CASE
				WHEN D.Delivery_Status = 'Delivered' THEN 1
       END) AS Total_Delivered_Deliveries
FROM Customers C
INNER JOIN Delivery_Records D
	ON C.Customer_ID = D.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each food category, find:
-- total deliveries
-- total delivered revenue
-- total cancelled deliveries
-- unique customers.
--
-- Return:
-- Food_Category
-- Total_Deliveries
-- Total_Delivered_Revenue
-- Total_Cancelled_Deliveries
-- Unique_Customers

SELECT Food_Category,
	   COUNT(Delivery_ID) AS Total_Deliveries,
       SUM(CASE
		   WHEN Delivery_Status = 'Delivered'
		   THEN Delivery_Amount
           ELSE 0
	   END) AS Total_Delivered_Revenue,
       COUNT(CASE
			WHEN Delivery_Status = 'Cancelled' THEN 1
       END) AS Total_Cancelled_Deliveries,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Delivery_Records
GROUP BY Food_Category;


-- Q3
-- Find the top 3 customers in each city
-- based on total delivered amount.
--
-- If tied, return all tied customers.
--
-- Use DENSE_RANK().
--
-- Return:
-- City
-- Customer_ID
-- Customer_Name
-- Total_Delivered_Amount

SELECT City, Customer_ID, Customer_Name, Total_Delivered_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Delivered_Amount DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
		       SUM(CASE
				   WHEN Delivery_Status = 'Delivered'
				   THEN Delivery_Amount
				   ELSE 0
			   END) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Delivery_Records D
			ON C.Customer_ID = D.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)D
WHERE D_Rank <= 3;


-- Q4
-- Find deliveries where the delivery amount
-- is greater than the customer's previous
-- delivered delivery amount.
--
-- Only Delivered deliveries should be compared.
--
-- Use JOIN + LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Delivery_Date
-- Delivery_Amount
-- Previous_Delivery_Amount

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, D.Delivery_Date, D.Delivery_Amount,
		   LAG(D.Delivery_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY D.Delivery_Date, D.Delivery_ID) AS Previous_Delivery_Amount
	FROM Customers C
	INNER JOIN Delivery_Records D
		ON C.Customer_ID = D.Customer_ID
	WHERE Delivery_Status = 'Delivered'
)
SELECT *
FROM CTE
WHERE Delivery_Amount > Previous_Delivery_Amount;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
-- total delivered deliveries
-- total delivered revenue
-- average delivered amount.
--
-- Definition:
-- Cohort Month = month in which the customer joined.
--
-- Only Delivered deliveries should be considered.
--
-- Return:
-- Cohort_Month
-- Total_Customers
-- Total_Delivered_Deliveries
-- Total_Delivered_Revenue
-- Average_Delivered_Amount

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(D.Delivery_ID) AS Total_Delivered_Deliveries,
       SUM(D.Delivery_Amount) AS Total_Delivered_Revenue,
       ROUND(AVG(D.Delivery_Amount), 2) AS Average_Delivered_Amount
FROM CTE C
INNER JOIN Delivery_Records D
	ON C.Customer_ID = D.Customer_ID
WHERE Delivery_Status = 'Delivered'
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- A streak means having a Delivered delivery
-- on consecutive dates.
--
-- Ignore duplicate delivery dates for the same customer.
-- Only Delivered deliveries count.
--
-- Find each customer's longest delivered-delivery
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, D.Delivery_Date
	FROM Customers C
	INNER JOIN Delivery_Records D
		ON C.Customer_ID = D.Customer_ID
	WHERE Delivery_Status = 'Delivered'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Delivery_Date) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Delivery_Date, INTERVAL RN DAY) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   COUNT(*) AS Streak,
           MIN(Delivery_Date) AS Start_Date,
           MAX(Delivery_Date) AS End_Date
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
-- Find customers whose total delivered amount
-- is greater than the average total delivered amount
-- of customers in the same city.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- City
-- Total_Delivered_Amount

SELECT Customer_ID, Customer_Name, City, Total_Delivered_Amount
FROM (
	SELECT *,
		   AVG(Total_Delivered_Amount) OVER(PARTITION BY City) AS Avg_City
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   SUM(CASE
				   WHEN Delivery_Status = 'Delivered'
				   THEN Delivery_Amount
				   ELSE 0
			   END) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Delivery_Records D
			ON C.Customer_ID = D.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Delivered_Amount > Avg_City;


-- INTERVIEW CHALLENGE
-- For each restaurant, find the customer
-- with the highest total delivered amount
-- at that restaurant.
--
-- If tied, return all tied customers.
--
-- Return:
-- Restaurant_Name
-- Customer_ID
-- Customer_Name
-- Total_Delivered_Amount

SELECT Restaurant_Name, Customer_ID, Customer_Name, Total_Delivered_Amount
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Restaurant_Name
           ORDER BY Total_Delivered_Amount DESC) AS D_Rank
	FROM (
		SELECT D.Restaurant_Name, C.Customer_ID, C.Customer_Name,
			   SUM(CASE
				   WHEN Delivery_Status = 'Delivered'
				   THEN Delivery_Amount
				   ELSE 0
			   END) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Delivery_Records D
			ON C.Customer_ID = D.Customer_ID
		GROUP BY D.Restaurant_Name, C.Customer_ID, C.Customer_Name
	)D
)H
WHERE D_Rank = 1;