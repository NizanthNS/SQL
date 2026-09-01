USE Daily_SQL;

-- DATASET : Records Analytics

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Connor', 'London', '2025-01-15'),
		(2, 'Emma', 'Toronto', '2025-02-10'),
		(3, 'Liam', 'Sydney', '2025-02-18'),
		(4, 'Olivia', 'Berlin', '2025-03-05'),
		(5, 'Noah', 'Paris', '2025-03-22'),
		(6, 'Sophia', 'London', '2025-04-12'),
		(7, 'James', 'Toronto', '2025-04-25'),
		(8, 'Ava', 'Sydney', '2025-05-08'),
		(9, 'William', 'Berlin', '2025-05-19'),
		(10, 'Mia', 'Paris', '2025-06-03');
        

CREATE TABLE Delivery_Records (
    Delivery_ID INT PRIMARY KEY,
    Customer_ID INT,
    Restaurant_Name VARCHAR(100),
    Food_Category VARCHAR(50),
    Delivery_Date DATE,
    Delivery_Amount DECIMAL(10,2),
    Delivery_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Delivery_Records
VALUES	(101, 1, 'Urban Bites', 'Italian', '2025-05-01', 28.50, 'Delivered'),
		(102, 1, 'Green Garden', 'Healthy', '2025-05-02', 35.00, 'Delivered'),
		(103, 1, 'Spice House', 'Indian', '2025-05-04', 42.00, 'Cancelled'),
		(104, 1, 'Urban Bites', 'Italian', '2025-05-05', 31.50, 'Delivered'),
		(105, 1, 'Taco Corner', 'Mexican', '2025-05-06', 24.00, 'Delivered'),

		(106, 2, 'Sushi World', 'Japanese', '2025-05-02', 45.00, 'Delivered'),
		(107, 2, 'Urban Bites', 'Italian', '2025-05-03', 32.00, 'Delivered'),
		(108, 2, 'Burger Point', 'Fast Food', '2025-05-05', 21.50, 'Cancelled'),
		(109, 2, 'Sushi World', 'Japanese', '2025-05-06', 48.00, 'Delivered'),

		(110, 3, 'Taco Corner', 'Mexican', '2025-05-01', 26.00, 'Delivered'),
		(111, 3, 'Green Garden', 'Healthy', '2025-05-02', 34.50, 'Delivered'),
		(112, 3, 'Taco Corner', 'Mexican', '2025-05-03', 29.00, 'Delivered'),
		(113, 3, 'Spice House', 'Indian', '2025-05-05', 41.00, 'Delivered'),

		(114, 4, 'Urban Bites', 'Italian', '2025-05-03', 37.00, 'Delivered'),
		(115, 4, 'Sushi World', 'Japanese', '2025-05-04', 44.00, 'Delivered'),
		(116, 4, 'Burger Point', 'Fast Food', '2025-05-06', 19.50, 'Cancelled'),
		(117, 4, 'Urban Bites', 'Italian', '2025-05-07', 39.00, 'Delivered'),

		(118, 5, 'Spice House', 'Indian', '2025-05-01', 40.00, 'Delivered'),
		(119, 5, 'Taco Corner', 'Mexican', '2025-05-02', 27.50, 'Delivered'),
		(120, 5, 'Green Garden', 'Healthy', '2025-05-04', 36.00, 'Delivered'),

		(121, 6, 'Sushi World', 'Japanese', '2025-05-02', 46.00, 'Delivered'),
		(122, 6, 'Urban Bites', 'Italian', '2025-05-03', 33.00, 'Delivered'),
		(123, 6, 'Spice House', 'Indian', '2025-05-04', 43.00, 'Delivered'),
		(124, 6, 'Burger Point', 'Fast Food', '2025-05-06', 22.00, 'Cancelled'),

		(125, 7, 'Taco Corner', 'Mexican', '2025-05-01', 25.00, 'Delivered'),
		(126, 7, 'Green Garden', 'Healthy', '2025-05-02', 38.00, 'Delivered'),
		(127, 7, 'Taco Corner', 'Mexican', '2025-05-03', 30.00, 'Delivered'),
		(128, 7, 'Urban Bites', 'Italian', '2025-05-05', 34.00, 'Delivered'),

		(129, 8, 'Sushi World', 'Japanese', '2025-05-03', 49.00, 'Delivered'),
		(130, 8, 'Spice House', 'Indian', '2025-05-04', 42.50, 'Delivered'),
		(131, 8, 'Green Garden', 'Healthy', '2025-05-05', 35.00, 'Delivered'),

		(132, 9, 'Urban Bites', 'Italian', '2025-05-01', 29.00, 'Delivered'),
		(133, 9, 'Burger Point', 'Fast Food', '2025-05-02', 20.00, 'Delivered'),
		(134, 9, 'Urban Bites', 'Italian', '2025-05-03', 36.00, 'Delivered'),
		(135, 9, 'Sushi World', 'Japanese', '2025-05-05', 47.00, 'Delivered'),

		(136, 10, 'Spice House', 'Indian', '2025-05-02', 39.00, 'Delivered'),
		(137, 10, 'Taco Corner', 'Mexican', '2025-05-03', 28.00, 'Delivered'),
		(138, 10, 'Green Garden', 'Healthy', '2025-05-04', 37.50, 'Delivered'),
		(139, 10, 'Spice House', 'Indian', '2025-05-05', 45.00, 'Delivered');
        

SELECT *
FROM Customers;

SELECT *
FROM Delivery_Records;


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
       COUNT(
       CASE
			WHEN D.Delivery_Status = 'Delivered' 
            THEN 1
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
       SUM(
       CASE
		   WHEN Delivery_Status = 'Delivered'
		   THEN Delivery_Amount
           ELSE 0
	   END) AS Total_Delivered_Revenue,
       COUNT(
       CASE
			WHEN Delivery_Status = 'Cancelled' 
            THEN 1
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
		       SUM(D.Delivery_Amount) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Delivery_Records D
			ON C.Customer_ID = D.Customer_ID
		WHERE Delivery_Status = 'Delivered'
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
),
CTE2 AS (
	SELECT *
    FROM Delivery_Records
    WHERE Delivery_Status = 'Delivered'
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       COUNT(D.Delivery_ID) AS Total_Delivered_Deliveries,
       SUM(D.Delivery_Amount) AS Total_Delivered_Revenue,
       ROUND(AVG(D.Delivery_Amount), 2) AS Average_Delivered_Amount
FROM CTE C
INNER JOIN CTE2 D
	ON C.Customer_ID = D.Customer_ID
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
			   SUM(D.Delivery_Amount) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Delivery_Records D
			ON C.Customer_ID = D.Customer_ID
		WHERE Delivery_Status = 'Delivered'
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
			   SUM(D.Delivery_Amount) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Delivery_Records D
			ON C.Customer_ID = D.Customer_ID
		WHERE Delivery_Status = 'Delivered'
		GROUP BY D.Restaurant_Name, C.Customer_ID, C.Customer_Name
	)D
)H
WHERE D_Rank = 1;