USE Daily_SQL;

-- DATASET: Online Delivery Analytics

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    City VARCHAR(50),
    Join_Date DATE
);

INSERT INTO Customers
VALUES	(1, 'Arun', 'Chennai', '2025-01-10'),
		(2, 'Bala', 'Chennai', '2025-02-15'),
		(3, 'Deepak', 'Bangalore', '2025-01-20'),
		(4, 'Kiran', 'Bangalore', '2025-03-05'),
		(5, 'Manoj', 'Chennai', '2025-02-25'),
		(6, 'Rahul', 'Hyderabad', '2025-01-12'),
		(7, 'Suresh', 'Hyderabad', '2025-03-18'),
		(8, 'Vijay', 'Bangalore', '2025-02-08');


CREATE TABLE Food_Deliveries (
    Delivery_ID INT PRIMARY KEY,
    Customer_ID INT,
    Restaurant_Name VARCHAR(100),
    Food_Category VARCHAR(50),
    Delivery_Date DATE,
    Delivery_Amount DECIMAL(10,2),
    Delivery_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Food_Deliveries
VALUES	(101, 1, 'Spice Hub', 'Indian', '2025-04-01', 450.00, 'Delivered'),
		(102, 1, 'Burger Point', 'Fast Food', '2025-04-02', 300.00, 'Delivered'),
		(103, 1, 'Spice Hub', 'Indian', '2025-04-04', 550.00, 'Delivered'),
		(104, 2, 'Pizza World', 'Italian', '2025-04-01', 700.00, 'Delivered'),
		(105, 2, 'Spice Hub', 'Indian', '2025-04-03', 400.00, 'Cancelled'),
		(106, 2, 'Pizza World', 'Italian', '2025-04-04', 650.00, 'Delivered'),
		(107, 3, 'Burger Point', 'Fast Food', '2025-04-02', 250.00, 'Delivered'),
		(108, 3, 'Curry House', 'Indian', '2025-04-03', 500.00, 'Delivered'),
		(109, 3, 'Burger Point', 'Fast Food', '2025-04-05', 350.00, 'Delivered'),
		(110, 4, 'Pizza World', 'Italian', '2025-04-01', 800.00, 'Delivered'),
		(111, 4, 'Curry House', 'Indian', '2025-04-02', 450.00, 'Delivered'),
		(112, 4, 'Pizza World', 'Italian', '2025-04-03', 900.00, 'Delivered'),
		(113, 5, 'Spice Hub', 'Indian', '2025-04-02', 350.00, 'Delivered'),
		(114, 5, 'Burger Point', 'Fast Food', '2025-04-03', 280.00, 'Delivered'),
		(115, 5, 'Spice Hub', 'Indian', '2025-04-05', 600.00, 'Delivered'),
		(116, 6, 'Curry House', 'Indian', '2025-04-01', 550.00, 'Delivered'),
		(117, 6, 'Pizza World', 'Italian', '2025-04-03', 750.00, 'Delivered'),
		(118, 6, 'Curry House', 'Indian', '2025-04-04', 650.00, 'Delivered'),
		(119, 7, 'Burger Point', 'Fast Food', '2025-04-02', 320.00, 'Delivered'),
		(120, 7, 'Pizza World', 'Italian', '2025-04-04', 680.00, 'Delivered'),
		(121, 7, 'Burger Point', 'Fast Food', '2025-04-05', 400.00, 'Delivered'),
		(122, 8, 'Pizza World', 'Italian', '2025-04-01', 600.00, 'Delivered'),
		(123, 8, 'Curry House', 'Indian', '2025-04-02', 500.00, 'Delivered'),
		(124, 8, 'Pizza World', 'Italian', '2025-04-05', 750.00, 'Delivered');
        
SELECT *
FROM Customers;

SELECT *
FROM Food_Deliveries;

-- Q1
-- Show each customer's:
-- total deliveries
-- total delivery amount
-- average delivery amount
-- total cancelled deliveries.
--
-- Use both tables.
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Total_Deliveries
-- Total_Delivery_Amount
-- Average_Delivery_Amount
-- Total_Cancelled_Deliveries

SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(F.Delivery_ID) AS Total_Deliveries,
       SUM(F.Delivery_Amount) AS Total_Delivery_Amount,
       ROUND(AVG(F.Delivery_Amount), 2) AS Average_Delivery_Amount,
       COUNT(CASE
				WHEN F.Delivery_Status = 'Cancelled' THEN 1
       END) AS Total_Cancelled_Deliveries
FROM Customers C
INNER JOIN Food_Deliveries F
	ON C.Customer_ID = F.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name;


-- Q2
-- For each food category, find:
-- total deliveries
-- total delivery revenue from Delivered orders
-- average delivery amount
-- unique customers.
--
-- Return:
-- Food_Category
-- Total_Deliveries
-- Total_Delivery_Revenue
-- Average_Delivery_Amount
-- Unique_Customers

SELECT Food_Category,
	   COUNT(Delivery_ID) AS Total_Deliveries,
       SUM(CASE 
			WHEN Delivery_Status = 'Delivered' 
            THEN Delivery_Amount
            ELSE 0
	   END) AS Total_Delivery_Revenue,
       ROUND(AVG(Delivery_Amount), 2) AS Average_Delivery_Amount,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Food_Deliveries
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
		INNER JOIN Food_Deliveries F
			ON C.Customer_ID = F.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)T
)D
WHERE D_Rank <= 3;


-- Q4
-- Find deliveries where the delivery amount
-- is greater than the customer's previous delivery amount.
--
-- Use LAG().
--
-- Return:
-- Customer_ID
-- Customer_Name
-- Delivery_Date
-- Delivery_Amount
-- Previous_Delivery_Amount

SELECT *
FROM (
	SELECT C.Customer_ID, C.Customer_Name, F.Delivery_Date, F.Delivery_Amount,
		   LAG(F.Delivery_Amount) OVER(PARTITION BY C.Customer_ID
		   ORDER BY F.Delivery_Date, F.Delivery_ID) AS Previous_Delivery_Amount
	FROM Customers C
	INNER JOIN Food_Deliveries F
		ON C.Customer_ID = F.Customer_ID
)P
WHERE Delivery_Amount > Previous_Delivery_Amount;


-- Q5 (COHORT ANALYSIS)
-- For each cohort month, find:
-- total customers
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
-- Total_Delivered_Revenue
-- Average_Delivered_Amount

WITH CTE AS (
    SELECT Customer_ID,
           DATE_FORMAT(Join_Date, '%Y-%m') AS Cohort_Month
    FROM Customers
)
SELECT Cohort_Month,
       COUNT(DISTINCT C.Customer_ID) AS Total_Customers,
       SUM(F.Delivery_Amount) AS Total_Delivered_Revenue,
       ROUND(AVG(F.Delivery_Amount), 2) AS Average_Delivered_Amount
FROM CTE C
INNER JOIN Food_Deliveries F
    ON C.Customer_ID = F.Customer_ID
WHERE F.Delivery_Status = 'Delivered'
GROUP BY Cohort_Month;


-- BONUS (GAP & ISLAND)
-- Find each customer's longest consecutive
-- delivery-date streak.
--
-- Only Delivered deliveries count.
-- Ignore duplicate delivery dates.
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
	SELECT DISTINCT C.Customer_ID, C.Customer_Name, F.Delivery_Date
	FROM Customers C
	INNER JOIN Food_Deliveries F
		ON C.Customer_ID = F.Customer_ID
	WHERE F.Delivery_Status = 'Delivered'
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
					WHEN F.Delivery_Status = 'Delivered' 
					THEN F.Delivery_Amount
					ELSE 0
			   END) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Food_Deliveries F
			ON C.Customer_ID = F.Customer_ID
		GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)A
WHERE Total_Delivered_Amount > Avg_City;


-- INTERVIEW CHALLENGE
-- For each restaurant, find the customer
-- who spent the highest total delivered amount
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
		SELECT F.Restaurant_Name, C.Customer_ID, C.Customer_Name,
			   SUM(CASE 
					WHEN F.Delivery_Status = 'Delivered' 
					THEN F.Delivery_Amount
					ELSE 0
			   END) AS Total_Delivered_Amount
		FROM Customers C
		INNER JOIN Food_Deliveries F
			ON C.Customer_ID = F.Customer_ID
		GROUP BY F.Restaurant_Name, C.Customer_ID, C.Customer_Name
	)D
)H
WHERE D_Rank = 1;