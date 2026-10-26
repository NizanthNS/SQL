-- =========================================================
-- SESSION — RETAIL SALES, CUSTOMER RETENTION & AUDITING
-- MySQL Daily SQL Practice
-- =========================================================

USE Daily_SQL;

-- =========================================================
-- TABLE 1 — CUSTOMERS
-- =========================================================

DROP TABLE IF EXISTS Sales_Audit;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Signup_Date DATE
);

INSERT INTO Customers
VALUES	(1,  'Alexander Reed',    'London',  '2025-01-05'),
		(2,  'Charlotte Evans',   'Toronto', '2025-01-18'),
		(3,  'Benjamin Scott',    'Sydney',  '2025-02-03'),
		(4,  'Emily Richardson',  'Berlin',  '2025-02-20'),
		(5,  'Lucas Foster',      'Paris',   '2025-03-02'),
		(6,  'Olivia Hughes',     'London',  '2025-03-15'),
		(7,  'James Murphy',      'Toronto', '2025-04-01'),
		(8,  'Ava Peterson',      'Sydney',  '2025-04-12'),
		(9,  'Lucas Morgan',      'Berlin',  '2025-05-07'),
		(10, 'Mia Cooper',        'Paris',   '2025-05-22'),
		(11, 'Benjamin Ward',     'London',  '2025-06-10'),
		(12, 'Charlotte Hayes',   'Toronto', '2025-06-25');

-- =========================================================
-- TABLE 2 — SALES
-- =========================================================

CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Customer_ID INT,
    Sale_Date DATE,
    Product_Category VARCHAR(50),
    Amount DECIMAL(10,2),
    Sale_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

INSERT INTO Sales
VALUES	(1001, 1,  '2025-01-10', 'Electronics',  800.00, 'Completed'),
		(1002, 1,  '2025-01-12', 'Accessories',  120.00, 'Completed'),
		(1003, 1,  '2025-01-13', 'Electronics',  250.00, 'Completed'),
		(1004, 1,  '2025-02-10', 'Furniture',    600.00, 'Completed'),
		(1005, 1,  '2025-03-10', 'Electronics',  400.00, 'Completed'),

		(1006, 2,  '2025-01-20', 'Furniture',    500.00, 'Cancelled'),
		(1007, 2,  '2025-02-05', 'Electronics',  700.00, 'Completed'),
		(1008, 2,  '2025-02-06', 'Accessories',  100.00, 'Completed'),
		(1009, 2,  '2025-03-15', 'Furniture',    900.00, 'Completed'),

		(1010, 3,  '2025-02-05', 'Electronics', 1200.00, 'Completed'),
		(1011, 3,  '2025-02-06', 'Accessories',  150.00, 'Completed'),
		(1012, 3,  '2025-02-08', 'Furniture',    350.00, 'Completed'),
		(1013, 3,  '2025-03-10', 'Electronics',  950.00, 'Completed'),
		(1014, 3,  '2025-04-12', 'Accessories',  200.00, 'Completed'),

		(1015, 4,  '2025-02-25', 'Furniture',    750.00, 'Completed'),
		(1016, 4,  '2025-03-25', 'Electronics',  650.00, 'Completed'),
		(1017, 4,  '2025-04-25', 'Accessories',  180.00, 'Completed'),

		(1018, 5,  '2025-03-05', 'Electronics',  500.00, 'Completed'),
		(1019, 5,  '2025-04-05', 'Furniture',    850.00, 'Completed'),
		(1020, 5,  '2025-05-05', 'Electronics',  450.00, 'Completed'),

		(1021, 6,  '2025-03-20', 'Accessories',  130.00, 'Completed'),
		(1022, 6,  '2025-04-20', 'Electronics',  900.00, 'Completed'),
		(1023, 6,  '2025-05-20', 'Furniture',    550.00, 'Completed'),

		(1024, 7,  '2025-04-05', 'Electronics',  700.00, 'Completed'),
		(1025, 7,  '2025-04-07', 'Accessories',  140.00, 'Completed'),
		(1026, 7,  '2025-05-10', 'Furniture',    620.00, 'Completed'),

		(1027, 8,  '2025-04-15', 'Electronics', 1100.00, 'Completed'),
		(1028, 8,  '2025-05-15', 'Furniture',    700.00, 'Completed'),

		(1029, 9,  '2025-05-10', 'Accessories',  160.00, 'Completed'),
		(1030, 9,  '2025-06-10', 'Electronics',  950.00, 'Completed');

-- =========================================================
-- TABLE 3 — SALES AUDIT
-- Create this table for Q5.
-- =========================================================

CREATE TABLE Sales_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Sale_ID INT,
    Old_Amount DECIMAL(10,2),
    New_Amount DECIMAL(10,2),
    Old_Status VARCHAR(20),
    New_Status VARCHAR(20),
    Action_Type VARCHAR(20),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- VIEW THE DATA
-- =========================================================

SELECT * FROM Customers;
SELECT * FROM Sales;
SELECT * FROM Sales_Audit;

-- =========================================================
-- Q1 — GAP & ISLAND: LONGEST CONSECUTIVE MONTHLY
--      COMPLETED-SALES STREAK
-- =========================================================
-- For each customer, find their longest streak of consecutive
-- calendar months containing at least one Completed sale.
--
-- Requirements:
-- 1. Count each customer-month only once, even if they made
--    multiple completed sales in that month.
-- 2. Return only each customer's longest streak.
-- 3. If multiple streaks have the same length, choose the
--    most recent streak.
-- 4. Ignore customers with no Completed sales.
--
-- Return:
-- Customer_ID, Customer_Name, Streak_Start_Month,
-- Streak_End_Month, Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Customer_ID, C.Customer_Name,
		   CAST(DATE_FORMAT(S.Sale_Date, '%Y-%m-01') AS DATE) AS Sale_Month
    FROM Customers C
    INNER JOIN Sales S
		ON C.Customer_ID = S.Customer_ID
	WHERE S.Sale_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Customer_ID
           ORDER BY Sale_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Sale_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Customer_ID, Customer_Name,
		   MIN(Sale_Month) AS Streak_Start_Month,
           MAX(Sale_Month) AS Streak_End_Month,
           COUNT(*) AS Streak_Months
	FROM CTE3
    GROUP BY Customer_ID, Customer_Name, GK
),
CTE5 AS (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Customer_ID
           ORDER BY Streak_Months DESC, Streak_End_Month DESC) AS D_Rank
	FROM CTE4
)
SELECT Customer_ID, Customer_Name, Streak_Start_Month, Streak_End_Month, Streak_Months
FROM CTE5
WHERE D_Rank = 1;


-- =========================================================
-- Q2 — COHORT MONTH ANALYSIS
-- =========================================================
-- Build customer cohorts using each customer's FIRST
-- Completed sale month.
--
-- For every cohort month, calculate:
-- 1. Number of customers in the cohort.
-- 2. Number of those customers who made at least one
--    Completed sale in each activity month.
-- 3. Number of Completed sales in each activity month.
-- 4. Total Completed revenue in each activity month.
-- 5. Average Completed revenue per active customer.
--
-- Include activity months from the cohort month onward.
-- A customer is active in a month if they made at least one
-- Completed sale during that month.
--
-- Return:
-- Cohort_Month, Activity_Month, Cohort_Customers,
-- Active_Customers, Completed_Sales, Completed_Revenue,
-- Revenue_Per_Active_Customer

WITH CTE AS (
    SELECT Customer_ID,
           MIN(Sale_Date) AS First_Sale_Date
    FROM Sales
    WHERE Sale_Status = 'Completed'
    GROUP BY Customer_ID
),
CTE2 AS (
    SELECT Customer_ID,
           DATE_FORMAT(First_Sale_Date, '%Y-%m') AS Cohort_Month
    FROM CTE
),
CTE3 AS (
    SELECT Cohort_Month,
           COUNT(DISTINCT Customer_ID) AS Cohort_Customers
    FROM CTE2
    GROUP BY Cohort_Month
),
CTE4 AS (
    SELECT C.Customer_ID,
           C.Cohort_Month,
           DATE_FORMAT(S.Sale_Date, '%Y-%m') AS Activity_Month,
           S.Sale_ID,
           S.Amount
    FROM CTE2 C
    INNER JOIN Sales S
        ON C.Customer_ID = S.Customer_ID
    WHERE S.Sale_Status = 'Completed'
),
CTE5 AS (
    SELECT Cohort_Month,
           Activity_Month,
           COUNT(DISTINCT Customer_ID) AS Active_Customers,
           COUNT(Sale_ID) AS Completed_Sales,
           SUM(Amount) AS Completed_Revenue
    FROM CTE4
    GROUP BY Cohort_Month, Activity_Month
)
SELECT C.Cohort_Month,
       A.Activity_Month,
       C.Cohort_Customers,
       A.Active_Customers,
       A.Completed_Sales,
       A.Completed_Revenue,
       ROUND(A.Completed_Revenue /
	   NULLIF(A.Active_Customers, 0), 2) AS Revenue_Per_Active_Customer
FROM CTE5 A
INNER JOIN CTE3 C
    ON A.Cohort_Month = C.Cohort_Month
ORDER BY C.Cohort_Month, A.Activity_Month;
    
       
-- =========================================================
-- Q3 — CASE STATEMENT: CUSTOMER VALUE SEGMENTATION
-- =========================================================
-- Classify every customer based on their total Completed
-- sales revenue:
--
-- Platinum: revenue >= 2000
-- Gold:     revenue >= 1000 and < 2000
-- Silver:   revenue >= 500 and < 1000
-- Bronze:   revenue < 500, including customers with no
--           Completed sales.
--
-- Requirements:
-- 1. Include every customer.
-- 2. Cancelled sales must not contribute to revenue.
-- 3. Use CASE to assign the segment.
-- 4. Return the total revenue and segment for each customer.
--
-- Return:
-- Customer_ID, Customer_Name, Total_Revenue, Customer_Segment

-- =========================================================
-- Q3 — CASE STATEMENT: CUSTOMER VALUE SEGMENTATION
-- =========================================================

SELECT C.Customer_ID, C.Customer_Name,
       COALESCE(SUM(S.Amount), 0) AS Total_Revenue,
       CASE
		   WHEN COALESCE(SUM(S.Amount), 0) >= 2000
		   THEN 'Platinum'

		   WHEN COALESCE(SUM(S.Amount), 0) >= 1000
		   THEN 'Gold'

		   WHEN COALESCE(SUM(S.Amount), 0) >= 500
		   THEN 'Silver'
		   ELSE 'Bronze'
       END AS Customer_Segment
FROM Customers C
LEFT JOIN Sales S
    ON C.Customer_ID = S.Customer_ID
    AND S.Sale_Status = 'Completed'
GROUP BY C.Customer_ID, C.Customer_Name;
            

-- =========================================================
-- Q4 — DATE LOGIC USING LAG
-- =========================================================
-- Find each customer's Completed sale that occurred more
-- than 20 days after their previous Completed sale.
--
-- Requirements:
-- 1. Compare only Completed sales.
-- 2. Use LAG() partitioned by Customer_ID.
-- 3. Order chronologically by Sale_Date, then Sale_ID.
-- 4. Calculate the number of days since the previous sale.
-- 5. Exclude each customer's first Completed sale.
--
-- Return:
-- Customer_ID, Customer_Name, Sale_ID, Sale_Date,
-- Previous_Sale_Date, Gap_Days

WITH CTE AS (
	SELECT C.Customer_ID, C.Customer_Name, S.Sale_ID, S.Sale_Date,
		   LAG(S.Sale_Date) OVER(PARTITION BY C.Customer_ID
           ORDER BY S.Sale_Date, S.Sale_ID) AS Previous_Sale_Date
	FROM Customers C
    INNER JOIN Sales S
		ON C.Customer_ID = S.Customer_ID
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Sale_Date, Previous_Sale_Date) AS Gap_Days
	FROM CTE
)
SELECT Customer_ID, Customer_Name, Sale_ID, Sale_Date, Previous_Sale_Date, Gap_Days
FROM CTE2
WHERE Gap_Days > 20;


-- =========================================================
-- Q5 — TRIGGER: SALES AUDIT LOG
-- =========================================================
-- Create a MySQL AFTER UPDATE trigger on the Sales table.
--
-- Requirements:
-- 1. When a sale's Amount or Sale_Status changes, insert
--    one record into Sales_Audit.
-- 2. Record Sale_ID, OLD.Amount, NEW.Amount,
--    OLD.Sale_Status, NEW.Sale_Status.
-- 3. Set Action_Type to 'UPDATE'.
-- 4. Do not insert an audit record if neither Amount nor
--    Sale_Status changed.
-- 5. Use MySQL trigger syntax and the OLD/NEW references.
--
-- After creating the trigger, test it by updating a sale.
-- Example test (run only after creating your trigger):
--
-- UPDATE Sales
-- SET Amount = 850.00
-- WHERE Sale_ID = 1001;
--
-- Then verify:
-- SELECT * FROM Sales_Audit;
--
-- Return:
-- The CREATE TRIGGER statement and your test results.
-- =========================================================

DELIMITER $$

CREATE TRIGGER Trg_Sales_Audit
AFTER UPDATE ON Sales
FOR EACH ROW
BEGIN
    IF OLD.Amount <> NEW.Amount
       OR OLD.Sale_Status <> NEW.Sale_Status
    THEN
        INSERT INTO Sales_Audit
        (
            Sale_ID,
            Old_Amount,
            New_Amount,
            Old_Status,
            New_Status,
            Action_Type
        )
        VALUES
        (
            OLD.Sale_ID,
            OLD.Amount,
            NEW.Amount,
            OLD.Sale_Status,
            NEW.Sale_Status,
            'UPDATE'
        );

    END IF;

END$$

DELIMITER ;

UPDATE Sales
SET Amount = 850.00
WHERE Sale_ID = 1001;