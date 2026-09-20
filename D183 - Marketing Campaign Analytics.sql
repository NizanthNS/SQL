USE Daily_SQL;

-- =========================================================
-- SESSION — Marketing Campaign Analytics
-- =========================================================

-- =========================================================
-- TABLE 1 — Campaigns
-- =========================================================

CREATE TABLE Campaigns (
    Campaign_ID INT PRIMARY KEY,
    Campaign_Name VARCHAR(100),
    Channel VARCHAR(50),
    City VARCHAR(50),
    Launch_Date DATE,
    Budget DECIMAL(10,2)
);

INSERT INTO Campaigns
VALUES	(1, 'Spring Launch',      'Email',        'London',  '2025-01-10', 5000),
		(2, 'Winter Sale',        'Social Media', 'Toronto', '2025-01-15', 7000),
		(3, 'Product Boost',      'Search',       'Sydney',  '2025-02-05', 6500),
		(4, 'Brand Awareness',    'Email',        'Berlin',  '2025-02-18', 4500),
		(5, 'Summer Preview',     'Social Media', 'Paris',   '2025-03-01', 8000),
		(6, 'Customer Rewards',   'Search',       'London',  '2025-03-12', 5500),
		(7, 'Flash Promotion',   'Email',        'Toronto', '2025-04-02', 6000),
		(8, 'Growth Campaign',    'Social Media', 'Sydney',  '2025-04-15', 7500);


-- =========================================================
-- TABLE 2 — Campaign Events
-- =========================================================

CREATE TABLE Campaign_Events (
    Event_ID INT PRIMARY KEY,
    Campaign_ID INT,
    Event_Date DATE,
    Event_Type VARCHAR(30),
    Leads_Generated INT,
    Conversions INT,
    Revenue DECIMAL(10,2),
    Event_Status VARCHAR(20),
    FOREIGN KEY (Campaign_ID) REFERENCES Campaigns(Campaign_ID)
);

INSERT INTO Campaign_Events
VALUES	(101, 1, '2025-01-12', 'Email', 120, 20, 1800, 'Completed'),
		(102, 1, '2025-01-20', 'Email', 150, 28, 2400, 'Completed'),
		(103, 1, '2025-02-05', 'Email', 130, 25, 2100, 'Completed'),
		(104, 1, '2025-03-03', 'Email', 160, 32, 2900, 'Completed'),

		(105, 2, '2025-01-18', 'Ad', 180, 35, 3200, 'Completed'),
		(106, 2, '2025-01-25', 'Ad', 200, 42, 3900, 'Completed'),
		(107, 2, '2025-02-10', 'Ad', 170, 31, 2800, 'Completed'),
		(108, 2, '2025-03-08', 'Ad', 210, 45, 4200, 'Completed'),

		(109, 3, '2025-02-08', 'Search', 140, 30, 2700, 'Completed'),
		(110, 3, '2025-02-20', 'Search', 155, 34, 3100, 'Completed'),
		(111, 3, '2025-03-15', 'Search', 165, 37, 3400, 'Completed'),
		(112, 3, '2025-04-10', 'Search', 180, 41, 3800, 'Completed'),

		(113, 4, '2025-02-20', 'Email', 100, 18, 1500, 'Completed'),
		(114, 4, '2025-03-05', 'Email', 115, 21, 1800, 'Completed'),
		(115, 4, '2025-04-01', 'Email', 125, 25, 2200, 'Completed'),

		(116, 5, '2025-03-04', 'Ad', 220, 48, 4500, 'Completed'),
		(117, 5, '2025-03-18', 'Ad', 240, 52, 4900, 'Completed'),
		(118, 5, '2025-04-12', 'Ad', 230, 50, 4700, 'Completed'),
		(119, 5, '2025-05-05', 'Ad', 250, 56, 5300, 'Completed'),

		(120, 6, '2025-03-15', 'Search', 130, 27, 2500, 'Completed'),
		(121, 6, '2025-04-05', 'Search', 145, 31, 2900, 'Completed'),
		(122, 6, '2025-05-01', 'Search', 155, 35, 3300, 'Completed'),

		(123, 7, '2025-04-05', 'Email', 135, 26, 2300, 'Completed'),
		(124, 7, '2025-04-18', 'Email', 150, 30, 2700, 'Completed'),
		(125, 7, '2025-05-10', 'Email', 160, 34, 3100, 'Completed'),

		(126, 8, '2025-04-18', 'Ad', 190, 40, 3600, 'Completed'),
		(127, 8, '2025-05-02', 'Ad', 205, 44, 4100, 'Completed'),
		(128, 8, '2025-06-01', 'Ad', 220, 49, 4600, 'Completed');


SELECT *
FROM Campaigns;

SELECT *
FROM Campaign_Events;


-- =========================================================
-- Q1 — Campaign Performance Summary
-- =========================================================
-- For each campaign, calculate:
-- total events,
-- total leads,
-- total conversions,
-- total revenue,
-- average conversion count,
-- conversion rate.
--
-- Conversion_Rate =
-- total conversions / total leads * 100
--
-- Include campaigns with no events.
--
-- Return:
-- Campaign_ID
-- Campaign_Name
-- Channel
-- Total_Events
-- Total_Leads
-- Total_Conversions
-- Total_Revenue
-- Average_Conversions
-- Conversion_Rate

SELECT C.Campaign_ID, C.Campaign_Name, C.Channel,
	   COUNT(E.Event_ID) AS Total_Events,
       COALESCE(SUM(E.Leads_Generated), 0) AS Total_Leads,
       COALESCE(SUM(E.Conversions), 0) AS Total_Conversions,
       COALESCE(SUM(E.Revenue), 0) AS Total_Revenue,
       COALESCE(ROUND(AVG(E.Conversions), 2), 0) AS Average_Conversions,
       COALESCE(SUM(E.Conversions) / NULLIF(SUM(E.Leads_Generated), 0) * 100, 0) AS Conversion_Rate
FROM Campaigns C
LEFT JOIN Campaign_Events E
	ON C.Campaign_ID = E.Campaign_ID
GROUP BY C.Campaign_ID, C.Campaign_Name, C.Channel;


-- =========================================================
-- Q2 — Channel Performance
-- =========================================================
-- For each channel, calculate:
-- total campaigns,
-- total events,
-- total leads,
-- total conversions,
-- total revenue,
-- average revenue per campaign.
--
-- Return:
-- Channel
-- Total_Campaigns
-- Total_Events
-- Total_Leads
-- Total_Conversions
-- Total_Revenue
-- Average_Revenue_Per_Campaign

SELECT C.Channel,
	   COUNT(DISTINCT C.Campaign_ID) AS Total_Campaigns,
       COUNT(E.Event_ID) AS Total_Events,
       SUM(E.Leads_Generated) AS Total_Leads,
       SUM(E.Conversions) AS Total_Conversions,
       SUM(E.Revenue) AS Total_Revenue,
       ROUND(SUM(E.Revenue) / COUNT(DISTINCT C.Campaign_ID), 2) AS Average_Revenue_Per_Campaign
FROM Campaigns C
LEFT JOIN Campaign_Events E
	ON C.Campaign_ID = E.Campaign_ID
GROUP BY C.Channel;


-- =========================================================
-- Q3 — Top 2 Campaigns Per City
-- =========================================================
-- Find the top 2 campaigns in each city based on
-- total completed revenue.
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- Campaign_ID
-- Campaign_Name
-- City
-- Total_Revenue
-- Revenue_Rank

SELECT Campaign_ID, Campaign_Name, City, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT C.Campaign_ID, C.Campaign_Name, C.City,
			   SUM(E.Revenue) AS Total_Revenue
		FROM Campaigns C
		INNER JOIN Campaign_Events E
			ON C.Campaign_ID = E.Campaign_ID
		WHERE E.Event_Status = 'Completed'
		GROUP BY C.Campaign_ID, C.Campaign_Name
	)C
)D
WHERE Revenue_Rank <= 2;


-- =========================================================
-- Q4 — Repeat Campaign Activity Within 7 Days
-- =========================================================
-- Find campaign events where the current event happened
-- within 7 days of the previous event for the same campaign.
--
-- Use:
-- LAG()
-- DATEDIFF()
--
-- Only consider Completed events.
--
-- Return:
-- Campaign_ID
-- Campaign_Name
-- Event_Date
-- Previous_Event_Date
-- Days_Between_Events

WITH CTE AS (
	SELECT C.Campaign_ID, C.Campaign_Name, E.Event_Date,
		   LAG(E.Event_Date) OVER(PARTITION BY C.Campaign_ID
           ORDER BY E.Event_Date, E.Event_ID) AS Previous_Event_Date
	FROM Campaigns C
	INNER JOIN Campaign_Events E
		ON C.Campaign_ID = E.Campaign_ID
	WHERE E.Event_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   DATEDIFF(Event_Date, Previous_Event_Date) AS Days_Between_Events
	FROM CTE
)
SELECT  Campaign_ID, Campaign_Name, Event_Date, Previous_Event_Date, Days_Between_Events
FROM CTE2
WHERE Days_Between_Events <= 7;


-- =========================================================
-- Q5 — Campaign Cohort Revenue Analysis
-- =========================================================
-- Group campaigns by Launch Month.
--
-- Calculate:
-- total campaigns,
-- active campaigns,
-- total events,
-- total conversions,
-- total revenue,
-- average revenue per active campaign.
--
-- An Active Campaign is a campaign with at least one
-- Completed event.
--
-- Return:
-- Cohort_Month
-- Total_Campaigns
-- Active_Campaigns
-- Total_Events
-- Total_Conversions
-- Total_Revenue
-- Average_Revenue_Per_Active_Campaign

WITH CTE AS (
	SELECT Campaign_ID,
		   DATE_FORMAT(Launch_Date, '%Y-%m') AS Cohort_Month
	FROM Campaigns
)
SELECT Cohort_Month,
	   COUNT(DISTINCT C.Campaign_ID) AS Total_Campaigns,
       COUNT(DISTINCT
       CASE
			WHEN E.Event_ID IS NOT NULL AND E.Event_Status = 'Completed'
            THEN C.Campaign_ID
	   END) AS Active_Campaigns,
	   COUNT(E.Event_ID) AS Total_Events,
       SUM(E.Conversions) AS Total_Conversions,
       SUM(E.Revenue) AS Total_Revenue,
       ROUND(SUM(E.Revenue) / COUNT(DISTINCT
       CASE
			WHEN E.Event_ID IS NOT NULL AND E.Event_Status = 'Completed'
            THEN C.Campaign_ID
	   END), 2) AS Average_Revenue_Per_Active_Campaign
FROM CTE C
LEFT JOIN Campaign_Events E
	ON C.Campaign_ID = E.Campaign_ID
GROUP BY Cohort_Month;


-- =========================================================
-- BONUS — Gap & Island
-- =========================================================
-- Find each campaign's longest consecutive MONTHLY
-- event-activity streak.
--
-- Rules:
-- 1. Multiple events in the same month count ONCE.
-- 2. Only Completed events count.
-- 3. Consecutive months form a streak.
-- 4. Find the longest streak per campaign.
-- 5. If tied, choose the most recent streak.
--
-- Return:
-- Campaign_ID
-- Campaign_Name
-- Streak_Start_Month
-- Streak_End_Month
-- Streak_Months

WITH CTE AS (
	SELECT DISTINCT C.Campaign_ID, C.Campaign_Name,
		   DATE_FORMAT(E.Event_Date, '%Y-%m-01') AS Campaign_Month
	FROM Campaigns C
	INNER JOIN Campaign_Events E
		ON C.Campaign_ID = E.Campaign_ID
	WHERE E.Event_Status = 'Completed'
),
CTE2 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Campaign_ID
           ORDER BY Campaign_Month) AS RN
	FROM CTE
),
CTE3 AS (
	SELECT *,
		   DATE_SUB(Campaign_Month, INTERVAL RN MONTH) AS GK
	FROM CTE2
),
CTE4 AS (
	SELECT Campaign_ID, Campaign_Name,
		   COUNT(*) AS Streak,
           MIN(Campaign_Month) AS Streak_Start_Month,
           MAX(Campaign_Month) AS Streak_End_Month
	FROM CTE3
    GROUP BY Campaign_ID, Campaign_Name, GK
),
CTE5 AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY Campaign_ID
           ORDER BY Streak DESC, Streak_End_Month DESC) AS Row_Num
	FROM CTE4
)
SELECT Campaign_ID, Campaign_Name, Streak_Start_Month, Streak_End_Month, Streak AS Streak_Months
FROM CTE5
WHERE Row_Num = 1;


-- =========================================================
-- BONUS+ — Above-Channel-Average Conversion Rate
-- =========================================================
-- Find campaigns whose conversion rate is greater than
-- the average campaign conversion rate in their channel.
--
-- Use a window function.
--
-- Conversion_Rate =
-- total conversions / total leads * 100
--
-- Return:
-- Campaign_ID
-- Campaign_Name
-- Channel
-- Conversion_Rate
-- Channel_Average_Conversion_Rate

SELECT Campaign_ID, Campaign_Name, Channel, Conversion_Rate, Channel_Average_Conversion_Rate
FROM (
	SELECT *,
		   ROUND(AVG(Conversion_Rate) OVER(PARTITION BY Channel), 2) AS Channel_Average_Conversion_Rate
	FROM (
		SELECT C.Campaign_ID, C.Campaign_Name, C.Channel,
			   SUM(E.Conversions) / NULLIF(SUM(E.Leads_Generated), 0) * 100 AS Conversion_Rate
		FROM Campaigns C
		INNER JOIN Campaign_Events E
			ON C.Campaign_ID = E.Campaign_ID
		GROUP BY C.Campaign_ID, C.Campaign_Name, C.Channel
	)C
)A
WHERE Conversion_Rate > Channel_Average_Conversion_Rate;


-- =========================================================
-- INTERVIEW CHALLENGE
-- =========================================================
-- For each channel, find the campaign(s) with the highest
-- total revenue.
--
-- Ties must be included.
-- Use DENSE_RANK().
--
-- Return:
-- Channel
-- Campaign_ID
-- Campaign_Name
-- Total_Revenue
-- Revenue_Rank

SELECT Channel, Campaign_ID, Campaign_Name, Total_Revenue, Revenue_Rank
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Channel
           ORDER BY Total_Revenue DESC) AS Revenue_Rank
	FROM (
		SELECT C.Campaign_ID, C.Campaign_Name, C.Channel,
			   SUM(E.Revenue) AS Total_Revenue
		FROM Campaigns C
		INNER JOIN Campaign_Events E
			ON C.Campaign_ID = E.Campaign_ID
		GROUP BY C.Campaign_ID, C.Campaign_Name, C.Channel
	)D
)R
WHERE Revenue_Rank = 1;