============================================================
                 SQL WINDOW FUNCTIONS
                     COMPLETE NOTES
============================================================


1. WHAT IS A WINDOW FUNCTION?
-----------------------------

A Window Function performs a calculation across related rows
without combining those rows into a single row.

GROUP BY:
    Combines rows into groups.

WINDOW FUNCTION:
    Keeps the original rows and adds a calculated value.


Example:

SELECT City,
       SUM(Sales) OVER(PARTITION BY City) AS City_Total_Sales
FROM Orders;


Remember:

    GROUP BY          → Collapses rows
    Window Function   → Keeps rows


============================================================
2. BASIC SYNTAX
============================================================

FUNCTION() OVER(
    PARTITION BY column
    ORDER BY column
)


Example:

SUM(Sales) OVER(
    PARTITION BY City
) AS City_Total_Sales


The main parts are:

    FUNCTION()
        ↓
    OVER()
        ↓
    PARTITION BY
        ↓
    ORDER BY


PARTITION BY and ORDER BY are optional depending on the
function and requirement.


============================================================
3. PARTITION BY
============================================================

PARTITION BY divides rows into separate windows/groups.

Example:

SELECT Employee_ID,
       City,
       Salary,
       AVG(Salary) OVER(
           PARTITION BY City
       ) AS City_Average_Salary
FROM Employees;


Meaning:

    London employees → London average
    Paris employees  → Paris average
    Berlin employees → Berlin average


IMPORTANT:

PARTITION BY does NOT remove rows.

It only tells the window function:

"Perform this calculation separately for each group."


============================================================
4. ORDER BY
============================================================

ORDER BY determines the order in which the window function
processes the rows.

Example:

ROW_NUMBER() OVER(
    ORDER BY Salary DESC
)


Highest salary:

    1

Second highest:

    2

Third highest:

    3


============================================================
5. PARTITION BY + ORDER BY
============================================================

This is one of the most important patterns.

ROW_NUMBER() OVER(
    PARTITION BY City
    ORDER BY Salary DESC
)


Meaning:

    Rank employees separately inside each city
    according to salary.


Example:

Employee    City       Salary    Rank

Chloe       London     7000       1
Ethan       London     5000       2

Emma        Paris      6000       1
Lucas       Paris      4000       2


The ranking starts again for every city.


============================================================
6. MAIN TYPES OF WINDOW FUNCTIONS
============================================================

A. RANKING FUNCTIONS

    ROW_NUMBER()
    RANK()
    DENSE_RANK()


B. NAVIGATION / VALUE FUNCTIONS

    LAG()
    LEAD()
    FIRST_VALUE()
    LAST_VALUE()


C. AGGREGATE WINDOW FUNCTIONS

    SUM()
    AVG()
    COUNT()
    MIN()
    MAX()


============================================================
7. ROW_NUMBER()
============================================================

ROW_NUMBER() assigns a unique sequential number to every row.

Syntax:

ROW_NUMBER() OVER(
    ORDER BY column
)


Example:

SELECT Employee_ID,
       Salary,
       ROW_NUMBER() OVER(
           ORDER BY Salary DESC
       ) AS Row_Num
FROM Employees;


Result:

Salary    Row_Num

7000         1
6000         2
6000         3
5000         4


Even when values are tied, ROW_NUMBER() gives different
numbers.


------------------------------------------------------------
ROW_NUMBER() WITH PARTITION
------------------------------------------------------------

ROW_NUMBER() OVER(
    PARTITION BY City
    ORDER BY Salary DESC
)


This restarts the numbering for every city.


USE ROW_NUMBER() WHEN:

    You need a unique sequential position.

Common example:

    Find the latest order for each customer.


============================================================
8. RANK()
============================================================

RANK() gives the same rank to tied values.

However, it skips ranks after a tie.


Example:

Salary    Rank

7000       1
6000       2
6000       2
5000       4


Notice:

    1
    2
    2
    4

Rank 3 is skipped.


============================================================
9. DENSE_RANK()
============================================================

DENSE_RANK() also gives the same rank to tied values.

But it does NOT skip ranks.


Example:

Salary    Dense_Rank

7000          1
6000          2
6000          2
5000          3


Result:

    1
    2
    2
    3


============================================================
10. ROW_NUMBER vs RANK vs DENSE_RANK
============================================================

Values:

    7000
    6000
    6000
    5000


ROW_NUMBER():

    1
    2
    3
    4


RANK():

    1
    2
    2
    4


DENSE_RANK():

    1
    2
    2
    3


MEMORY:

ROW_NUMBER()
    → Every row gets a unique number.

RANK()
    → Ties share rank + gaps appear.

DENSE_RANK()
    → Ties share rank + no gaps.


============================================================
11. WHEN TO USE EACH RANKING FUNCTION?
============================================================

ROW_NUMBER():

    Use when you need exactly one row per position.


RANK():

    Use when ties should share a rank and gaps are required.


DENSE_RANK():

    Use when ties should share a rank without gaps.


Very common interview question:

"Find the top 3 customers in each city, including ties."


Use:

DENSE_RANK() OVER(
    PARTITION BY City
    ORDER BY Total_Sales DESC
)


============================================================
12. LAG()
============================================================

LAG() looks at a previous row.


Syntax:

LAG(Value) OVER(
    PARTITION BY ID
    ORDER BY Date
)


Example:

SELECT Customer_ID,
       Purchase_Date,
       Purchase_Amount,
       LAG(Purchase_Amount) OVER(
           PARTITION BY Customer_ID
           ORDER BY Purchase_Date
       ) AS Previous_Amount
FROM Purchases;


Example result:

Date       Amount    Previous_Amount

Jan 1       100          NULL
Jan 5       150           100
Jan 10      120           150


The first row has no previous row, so it returns NULL.


USE LAG() FOR:

    Previous purchase
    Previous transaction
    Previous salary
    Previous login
    Previous order
    Current vs previous comparison


MEMORY:

    LAG  → Look backward


============================================================
13. LEAD()
============================================================

LEAD() looks at the next row.


Syntax:

LEAD(Value) OVER(
    PARTITION BY ID
    ORDER BY Date
)


Example:

Date       Amount    Next_Amount

Jan 1       100          150
Jan 5       150          120
Jan 10      120          NULL


MEMORY:

    LAG  → Previous
    LEAD → Next


============================================================
14. LAG() — COMMON INTERVIEW PATTERN
============================================================

Question:

Find records where the current amount is greater than
the previous amount.


Query:

WITH CTE AS (
    SELECT Customer_ID,
           Purchase_Date,
           Purchase_Amount,

           LAG(Purchase_Amount) OVER(
               PARTITION BY Customer_ID
               ORDER BY Purchase_Date, Purchase_ID
           ) AS Previous_Amount

    FROM Purchases
)
SELECT *
FROM CTE
WHERE Purchase_Amount > Previous_Amount;


IMPORTANT:

Calculate LAG() first.

Then filter the result in the outer query.


============================================================
15. SUM() AS A WINDOW FUNCTION
============================================================

SUM() can be used with OVER().


Example:

SELECT Customer_ID,
       Purchase_ID,
       Amount,

       SUM(Amount) OVER(
           PARTITION BY Customer_ID
       ) AS Customer_Total

FROM Purchases;


Example:

Customer    Amount    Customer_Total

1             200          500
1             300          500
2             700          700


Every original row remains.


============================================================
16. AVG() AS A WINDOW FUNCTION
============================================================

Example:

AVG(Sales) OVER(
    PARTITION BY City
) AS City_Average_Sales


This calculates the average separately for each city
while keeping every row.


Very useful for:

    Compare employee salary with department average
    Compare customer spending with city average
    Compare user activity with city average


Example:

SELECT *,
       AVG(Total_Sales) OVER(
           PARTITION BY City
       ) AS Avg_City_Sales
FROM Customer_Total;


Then:

WHERE Total_Sales > Avg_City_Sales


This finds customers above their city's average.


============================================================
17. COUNT() AS A WINDOW FUNCTION
============================================================

Example:

COUNT(*) OVER(
    PARTITION BY City
) AS City_Customer_Count


This gives the number of rows in each city while preserving
the original rows.


============================================================
18. MIN() AND MAX() AS WINDOW FUNCTIONS
============================================================

MIN():

MIN(Salary) OVER(
    PARTITION BY Department
) AS Department_Min_Salary


MAX():

MAX(Salary) OVER(
    PARTITION BY Department
) AS Department_Max_Salary


Useful for comparing each row with the minimum or maximum
value within its group.


============================================================
19. RUNNING TOTAL
============================================================

A running total continuously adds values as rows move
forward in time/order.


Syntax:

SUM(Value) OVER(
    PARTITION BY ID
    ORDER BY Date
)


Example:

SELECT Sale_Date,
       Sales,

       SUM(Sales) OVER(
           PARTITION BY Customer_ID
           ORDER BY Sale_Date
       ) AS Running_Total

FROM Sales;


Example:

Date       Sales    Running_Total

Jan 1       100          100
Jan 2        50          150
Jan 5        80          230
Jan 7       120          350


IMPORTANT:

    SUM() + ORDER BY
        → Running calculation


============================================================
20. RUNNING AVERAGE
============================================================

AVG() can also create a running average.


Example:

AVG(Sales) OVER(
    PARTITION BY Customer_ID
    ORDER BY Sale_Date
) AS Running_Average


The average changes as new rows are added.


============================================================
21. GROUP BY vs WINDOW FUNCTION
============================================================

GROUP BY:

SELECT Customer_ID,
       SUM(Amount) AS Total_Amount
FROM Purchases
GROUP BY Customer_ID;


Result:

Customer 1 → 500
Customer 2 → 700
Customer 3 → 300


One row per customer.


WINDOW FUNCTION:

SELECT Customer_ID,
       Purchase_ID,
       Amount,

       SUM(Amount) OVER(
           PARTITION BY Customer_ID
       ) AS Customer_Total

FROM Purchases;


Result:

Customer    Purchase    Amount    Customer_Total

1           P1           200          500
1           P2           300          500
2           P3           700          700


Original rows remain.


MEMORY:

    GROUP BY
        → Reduces rows

    WINDOW FUNCTION
        → Keeps rows


============================================================
22. WINDOW FUNCTION + CTE
============================================================

This combination is extremely common.


Example:

WITH Customer_Total AS (

    SELECT City,
           Customer_ID,
           SUM(Sales) AS Total_Sales

    FROM Purchases

    GROUP BY City, Customer_ID

),

Ranked AS (

    SELECT *,
           DENSE_RANK() OVER(
               PARTITION BY City
               ORDER BY Total_Sales DESC
           ) AS D_Rank

    FROM Customer_Total

)

SELECT *
FROM Ranked
WHERE D_Rank <= 3;


MENTAL FLOW:

Raw Data
   ↓
GROUP BY
   ↓
Customer Totals
   ↓
DENSE_RANK()
   ↓
Filter Rank
   ↓
Top 3


============================================================
23. WHY USE A CTE WITH WINDOW FUNCTIONS?
============================================================

You generally cannot directly filter a window-function result
in WHERE.


This is NOT valid:

SELECT *,
       DENSE_RANK() OVER(
           ORDER BY Sales DESC
       ) AS Rnk
FROM Sales
WHERE Rnk <= 3;


Instead:


WITH CTE AS (

    SELECT *,
           DENSE_RANK() OVER(
               ORDER BY Sales DESC
           ) AS Rnk

    FROM Sales

)

SELECT *
FROM CTE
WHERE Rnk <= 3;


MEMORY:

    Calculate first
         ↓
    Filter later


============================================================
24. SQL EXECUTION ORDER — SIMPLE VERSION
============================================================

FROM
  ↓
JOIN
  ↓
WHERE
  ↓
GROUP BY
  ↓
HAVING
  ↓
WINDOW FUNCTIONS
  ↓
SELECT
  ↓
ORDER BY


This explains why window-function results cannot normally
be used directly in WHERE.


============================================================
25. MULTIPLE WINDOW FUNCTIONS
============================================================

You can use multiple window functions in one query.


Example:

SELECT Employee_ID,
       Salary,

       ROW_NUMBER() OVER(
           ORDER BY Salary DESC
       ) AS Row_Num,

       RANK() OVER(
           ORDER BY Salary DESC
       ) AS Salary_Rank,

       AVG(Salary) OVER() AS Company_Average

FROM Employees;


One query can calculate:

    Row number
    Rank
    Company average


============================================================
26. DIFFERENT PARTITIONS IN ONE QUERY
============================================================

You can calculate different group-level values at the same
time.


Example:

SELECT Employee_ID,
       City,
       Department,
       Salary,

       AVG(Salary) OVER(
           PARTITION BY City
       ) AS City_Average,

       AVG(Salary) OVER(
           PARTITION BY Department
       ) AS Department_Average,

       AVG(Salary) OVER() AS Company_Average

FROM Employees;


Each employee row can now contain:

    Employee Salary
    City Average
    Department Average
    Company Average


============================================================
27. DUPLICATE DATES + ORDER BY
============================================================

When using:

    LAG()
    LEAD()
    ROW_NUMBER()

make sure the ordering is deterministic when duplicate dates
are possible.


Instead of:

ORDER BY Purchase_Date


Prefer:

ORDER BY Purchase_Date, Purchase_ID


Example:

ORDER BY A.Usage_Date,
         A.Usage_ID


Why?

Suppose:

Purchase_ID    Purchase_Date

101             2026-03-01
102             2026-03-01


Both have the same date.

Purchase_ID gives SQL a clear order between them.


============================================================
28. COMMON WINDOW FUNCTION PATTERNS
============================================================


PATTERN 1 — RANKING
-------------------

DENSE_RANK() OVER(
    PARTITION BY Category
    ORDER BY Total DESC
)


PATTERN 2 — PREVIOUS VALUE
--------------------------

LAG(Value) OVER(
    PARTITION BY ID
    ORDER BY Date, ID
)


PATTERN 3 — NEXT VALUE
----------------------

LEAD(Value) OVER(
    PARTITION BY ID
    ORDER BY Date, ID
)


PATTERN 4 — GROUP AVERAGE
-------------------------

AVG(Value) OVER(
    PARTITION BY Category
)


PATTERN 5 — GROUP TOTAL
-----------------------

SUM(Value) OVER(
    PARTITION BY Category
)


PATTERN 6 — RUNNING TOTAL
-------------------------

SUM(Value) OVER(
    PARTITION BY ID
    ORDER BY Date
)


PATTERN 7 — SEQUENTIAL NUMBER
-----------------------------

ROW_NUMBER() OVER(
    PARTITION BY ID
    ORDER BY Date
)


============================================================
29. GAP & ISLAND + WINDOW FUNCTIONS
============================================================

Gap & Island uses ROW_NUMBER() to identify consecutive
date groups.


Basic pattern:

WITH CTE AS (

    SELECT DISTINCT
           User_ID,
           Usage_Date

    FROM App_Usage

),

CTE2 AS (

    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY User_ID
               ORDER BY Usage_Date
           ) AS RN

    FROM CTE

),

CTE3 AS (

    SELECT *,
           DATE_SUB(
               Usage_Date,
               INTERVAL RN DAY
           ) AS Group_Key

    FROM CTE2

)


The same Group_Key is created for consecutive dates.


Mental model:

Consecutive dates
       ↓
ROW_NUMBER()
       ↓
DATE_SUB()
       ↓
Same Group_Key
       ↓
GROUP BY
       ↓
Streak


============================================================
30. WINDOW FUNCTIONS — INTERVIEW KEYWORDS
============================================================

When you see these words in a SQL question,
think about Window Functions:


    previous
    next
    rank
    ranking
    top N
    bottom N
    running total
    running average
    highest per group
    lowest per group
    compare with average
    compare with previous
    consecutive
    streak
    latest record
    first record
    nth highest


============================================================
31. WHICH FUNCTION SHOULD I THINK OF?
============================================================

previous
    → LAG()


next
    → LEAD()


unique sequential number
    → ROW_NUMBER()


ranking with gaps
    → RANK()


ranking without gaps
    → DENSE_RANK()


group total while keeping rows
    → SUM() OVER()


group average while keeping rows
    → AVG() OVER()


group count while keeping rows
    → COUNT() OVER()


running total
    → SUM() OVER(ORDER BY ...)


running average
    → AVG() OVER(ORDER BY ...)


consecutive-date streak
    → ROW_NUMBER() + DATE_SUB()


============================================================
32. MOST IMPORTANT FUNCTIONS TO MASTER
============================================================

Priority for your current SQL level:


⭐⭐⭐⭐⭐  ROW_NUMBER()

⭐⭐⭐⭐⭐  DENSE_RANK()

⭐⭐⭐⭐⭐  LAG()

⭐⭐⭐⭐⭐  SUM() OVER()

⭐⭐⭐⭐⭐  AVG() OVER()

⭐⭐⭐⭐   LEAD()

⭐⭐⭐⭐   COUNT() OVER()

⭐⭐⭐     RANK()

⭐⭐⭐     MIN() OVER()

⭐⭐⭐     MAX() OVER()

⭐⭐       FIRST_VALUE()

⭐⭐       LAST_VALUE()


============================================================
33. QUICK REVISION CHEAT SHEET
============================================================

ROW_NUMBER()
    → Unique numbering


RANK()
    → Ranking + gaps


DENSE_RANK()
    → Ranking + no gaps


LAG()
    → Previous row


LEAD()
    → Next row


SUM() OVER()
    → Total while keeping rows


AVG() OVER()
    → Average while keeping rows


COUNT() OVER()
    → Count while keeping rows


SUM() OVER(ORDER BY ...)
    → Running total


AVG() OVER(ORDER BY ...)
    → Running average


PARTITION BY
    → Separate calculation for each group


ORDER BY
    → Controls row order inside the window


============================================================
34. GOLDEN RULE
============================================================

GROUP BY:

    "Give me one result for each group."


WINDOW FUNCTION:

    "Give me the group calculation while keeping
     every individual row."


If a question says:

    Previous
    Next
    Rank
    Top N per group
    Running total
    Running average
    Compare with group average
    Compare with previous
    Consecutive dates
    Streak

THINK:

    WINDOW FUNCTION


============================================================
35. FINAL MEMORY MAP
============================================================

                 WINDOW FUNCTIONS
                        |
        +---------------+---------------+
        |               |               |
     RANKING        NAVIGATION       AGGREGATE
        |               |               |
   ROW_NUMBER()       LAG()          SUM()
   RANK()              LEAD()         AVG()
   DENSE_RANK()                       COUNT()
                                      MIN()
                                      MAX()
        |
        +-------------------------------+
        |
     PARTITION BY
        |
     "Separate groups"
        |
     ORDER BY
        |
     "Control order"


============================================================
                    END OF NOTES
============================================================
