# SQL INTERVIEW CHEAT SHEET

## Views → Temporary Tables → Stored Procedures → Indexes

---

# 1. VIEWS

## What is a View?

A **View is a saved SQL query** that behaves like a virtual table.

Think:

> "I have a query I use again and again. Save that query with a name."

### Basic syntax

```sql
CREATE VIEW view_name AS
SELECT ...
FROM ...
WHERE ...;
```

Then:

```sql
SELECT *
FROM view_name;
```

---

## Example

Suppose we have:

```sql
CREATE TABLE Orders (
    Order_ID INT,
    Customer_ID INT,
    Order_Date DATE,
    Amount DECIMAL(10,2),
    Status VARCHAR(20)
);
```

We frequently need completed orders.

Instead of writing:

```sql
SELECT *
FROM Orders
WHERE Status = 'Completed';
```

every time, create a View:

```sql
CREATE VIEW Completed_Orders AS
SELECT Order_ID,
       Customer_ID,
       Order_Date,
       Amount
FROM Orders
WHERE Status = 'Completed';
```

Now:

```sql
SELECT *
FROM Completed_Orders;
```

---

## View with aggregation

```sql
CREATE VIEW Customer_Revenue AS
SELECT Customer_ID,
       COUNT(*) AS Total_Orders,
       SUM(Amount) AS Total_Revenue,
       AVG(Amount) AS Avg_Order_Value
FROM Orders
WHERE Status = 'Completed'
GROUP BY Customer_ID;
```

Then:

```sql
SELECT *
FROM Customer_Revenue
WHERE Total_Revenue > 5000;
```

---

## Modify a View

```sql
CREATE OR REPLACE VIEW Completed_Orders AS
SELECT Order_ID,
       Customer_ID,
       Order_Date,
       Amount
FROM Orders
WHERE Status = 'Completed'
  AND Amount > 100;
```

---

## Delete a View

```sql
DROP VIEW Completed_Orders;
```

---

## Important Interview Point

A normal View **does not normally store the query result as a separate table**.

It stores the **query definition**.

So:

```text
Orders table changes
       ↓
View query runs against updated data
       ↓
View reflects the current data
```

### View vs CTE

```text
CTE
 ↓
Exists only for one SQL statement

VIEW
 ↓
Saved in the database
 ↓
Can be reused by many queries
```

### When to use a View?

Use a View when:

* You repeatedly use the same query
* You want to hide query complexity
* You want a consistent business definition
* You want users/analysts to query a simpler interface

Example:

```text
Complex revenue calculation
        ↓
CREATE VIEW Monthly_Revenue
        ↓
SELECT * FROM Monthly_Revenue
```

---

# 2. TEMPORARY TABLES

## What is a Temporary Table?

A Temporary Table is a **real temporary table created during your session**.

Think:

> "I need to physically store intermediate results while I work."

### Basic syntax

```sql
CREATE TEMPORARY TABLE temp_table_name AS
SELECT ...
FROM ...
WHERE ...;
```

Example:

```sql
CREATE TEMPORARY TABLE Completed_Orders AS
SELECT *
FROM Orders
WHERE Status = 'Completed';
```

Now:

```sql
SELECT *
FROM Completed_Orders;
```

---

## Insert into a Temporary Table

You can also create the structure first:

```sql
CREATE TEMPORARY TABLE Customer_Summary (
    Customer_ID INT,
    Total_Orders INT,
    Total_Revenue DECIMAL(10,2)
);
```

Then:

```sql
INSERT INTO Customer_Summary
SELECT Customer_ID,
       COUNT(*),
       SUM(Amount)
FROM Orders
WHERE Status = 'Completed'
GROUP BY Customer_ID;
```

Then:

```sql
SELECT *
FROM Customer_Summary;
```

---

## Drop Temporary Table

```sql
DROP TEMPORARY TABLE Customer_Summary;
```

Usually you don't even need to manually drop it because a temporary table is automatically removed when the session ends.

---

## Why use Temporary Tables?

Useful when:

* Intermediate data is large
* You need to reuse intermediate results multiple times
* You want to break a complicated process into stages
* You need to manipulate intermediate data
* You want to index the intermediate result

Example:

```text
Orders
   ↓
Temporary Table
   ↓
Clean/filter data
   ↓
Aggregate
   ↓
Final analysis
```

---

# 3. CTE vs TEMPORARY TABLE

This is an important interview comparison.

### CTE

```sql
WITH Customer_Summary AS (
    SELECT Customer_ID,
           SUM(Amount) AS Revenue
    FROM Orders
    GROUP BY Customer_ID
)
SELECT *
FROM Customer_Summary;
```

The CTE exists for **that statement**.

### Temporary Table

```sql
CREATE TEMPORARY TABLE Customer_Summary AS
SELECT Customer_ID,
       SUM(Amount) AS Revenue
FROM Orders
GROUP BY Customer_ID;
```

Now you can use it in multiple statements:

```sql
SELECT *
FROM Customer_Summary;

SELECT AVG(Revenue)
FROM Customer_Summary;

SELECT *
FROM Customer_Summary
WHERE Revenue > 5000;
```

### Simple rule

```text
One query
    ↓
CTE

Multiple queries during the session
    ↓
Temporary Table
```

---

# 4. STORED PROCEDURES

## What is a Stored Procedure?

A Stored Procedure is **saved SQL logic that you can execute later**.

Think:

> "Save this whole SQL operation as a reusable program."

### Basic syntax

```sql
DELIMITER //

CREATE PROCEDURE Get_Completed_Orders()
BEGIN

    SELECT *
    FROM Orders
    WHERE Status = 'Completed';

END //

DELIMITER ;
```

Run it:

```sql
CALL Get_Completed_Orders();
```

---

# Stored Procedure with Parameters

This is more useful.

```sql
DELIMITER //

CREATE PROCEDURE Get_Customer_Orders(
    IN p_customer_id INT
)
BEGIN

    SELECT *
    FROM Orders
    WHERE Customer_ID = p_customer_id;

END //

DELIMITER ;
```

Call:

```sql
CALL Get_Customer_Orders(101);
```

Another customer:

```sql
CALL Get_Customer_Orders(205);
```

Same procedure, different input.

---

# Multiple Parameters

```sql
DELIMITER //

CREATE PROCEDURE Get_Orders_By_Status(
    IN p_status VARCHAR(20),
    IN p_min_amount DECIMAL(10,2)
)
BEGIN

    SELECT *
    FROM Orders
    WHERE Status = p_status
      AND Amount >= p_min_amount;

END //

DELIMITER ;
```

Call:

```sql
CALL Get_Orders_By_Status('Completed', 500);
```

---

# Stored Procedure with UPDATE

Procedures don't have to only SELECT.

```sql
DELIMITER //

CREATE PROCEDURE Update_Order_Status(
    IN p_order_id INT,
    IN p_status VARCHAR(20)
)
BEGIN

    UPDATE Orders
    SET Status = p_status
    WHERE Order_ID = p_order_id;

END //

DELIMITER ;
```

Run:

```sql
CALL Update_Order_Status(1001, 'Completed');
```

---

# Delete a Procedure

```sql
DROP PROCEDURE Get_Customer_Orders;
```

---

# 5. VIEW vs TEMPORARY TABLE vs STORED PROCEDURE

This comparison is VERY interview-friendly.

```text
VIEW
 ↓
Saved SELECT query
 ↓
Used like a table
 ↓
Reusable

TEMPORARY TABLE
 ↓
Temporary stored data
 ↓
Exists during session
 ↓
Can be queried multiple times

STORED PROCEDURE
 ↓
Saved SQL program/logic
 ↓
Can accept parameters
 ↓
Can SELECT / INSERT / UPDATE / DELETE
```

### Quick comparison

| Feature                         | View             | Temporary Table   | Stored Procedure    |
| ------------------------------- | ---------------- | ----------------- | ------------------- |
| Saved in database               | Yes              | No                | Yes                 |
| Stores query definition         | Yes              | No                | Yes                 |
| Stores intermediate data        | No               | Yes               | Can create/use      |
| Reusable                        | Yes              | During session    | Yes                 |
| Parameters                      | No               | No                | Yes                 |
| Can contain multiple statements | No               | N/A               | Yes                 |
| Mainly used for                 | Reusable queries | Intermediate data | Reusable operations |

---

# 6. INDEXES

Now we get into **database performance**.

## What is an Index?

An Index helps the database **find rows faster**.

Think about a book.

Without an index:

```text
Search for "SQL"
        ↓
Read every page
        ↓
Slow
```

With an index:

```text
Index
 ↓
Find location
 ↓
Jump directly there
 ↓
Faster
```

---

# Creating an Index

Suppose:

```sql
SELECT *
FROM Orders
WHERE Customer_ID = 101;
```

If this query runs frequently, an index can help:

```sql
CREATE INDEX idx_orders_customer
ON Orders(Customer_ID);
```

Now the database has an index on:

```text
Customer_ID
```

---

# Index on a Date Column

If you frequently run:

```sql
SELECT *
FROM Orders
WHERE Order_Date >= '2026-01-01';
```

You might create:

```sql
CREATE INDEX idx_orders_date
ON Orders(Order_Date);
```

---

# Composite Index

You can index multiple columns:

```sql
CREATE INDEX idx_orders_customer_status
ON Orders(Customer_ID, Status);
```

This is called a **composite index**.

Useful for queries such as:

```sql
SELECT *
FROM Orders
WHERE Customer_ID = 101
  AND Status = 'Completed';
```

---

# IMPORTANT: Column Order Matters

Suppose:

```sql
CREATE INDEX idx_customer_status
ON Orders(Customer_ID, Status);
```

The index is ordered approximately like:

```text
Customer_ID
    ↓
Status
```

This can help with:

```sql
WHERE Customer_ID = 101
```

and:

```sql
WHERE Customer_ID = 101
  AND Status = 'Completed'
```

But it generally isn't equivalent to having an index starting with `Status` for:

```sql
WHERE Status = 'Completed'
```

This is related to the **leftmost-prefix principle**.

---

# Remove an Index

```sql
DROP INDEX idx_orders_customer
ON Orders;
```

---

# PRIMARY KEY and Indexes

When you define:

```sql
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100)
);
```

The primary key is indexed automatically in MySQL.

So you generally don't need:

```sql
CREATE INDEX idx_customer_id
ON Customers(Customer_ID);
```

again.

---

# UNIQUE INDEX

You can also create a unique index:

```sql
CREATE UNIQUE INDEX idx_customer_email
ON Customers(Email);
```

This means duplicate emails are not allowed.

Example:

```text
abc@email.com  ✅
xyz@email.com  ✅
abc@email.com  ❌
```

---

# Why not create indexes on EVERYTHING?

Because indexes aren't free.

Indexes can:

### Speed up

```text
SELECT
WHERE
JOIN
ORDER BY
```

in appropriate situations.

But they also:

### Slow down

```text
INSERT
UPDATE
DELETE
```

because the database may need to update the indexes too.

They also consume storage.

So:

```text
More indexes
     ↓
Faster reads
     +
More storage
     +
Potentially slower writes
```

---

# 7. WHEN SHOULD YOU CONSIDER AN INDEX?

Common candidates:

```text
WHERE columns
JOIN columns
ORDER BY columns
GROUP BY columns
```

Example:

```sql
SELECT *
FROM Orders O
JOIN Customers C
    ON O.Customer_ID = C.Customer_ID
WHERE O.Status = 'Completed';
```

Potentially useful indexes could include:

```sql
CREATE INDEX idx_orders_customer
ON Orders(Customer_ID);

CREATE INDEX idx_orders_status
ON Orders(Status);
```

But don't blindly create both.

You should consider:

* How often the query runs
* Table size
* Number of distinct values
* Existing indexes
* Query execution plan
* Read vs write workload

---

# 8. EXPLAIN — VERY IMPORTANT FOR INTERVIEWS

When discussing indexes, interviewers may ask:

> "How do you know whether your index is actually helping?"

Use:

```sql
EXPLAIN
SELECT *
FROM Orders
WHERE Customer_ID = 101;
```

`EXPLAIN` shows how MySQL plans to execute the query.

It can help you understand:

```text
Which table is accessed
Which indexes are considered
Which index is selected
How many rows may be examined
How tables are joined
```

---

# 9. THE BIG PICTURE

Think of these four topics like this:

```text
                    SQL DATABASE
                         |
        +----------------+----------------+
        |                |                |
      VIEW         TEMP TABLE       STORED PROCEDURE
        |                |                |
  Saved query      Temporary data     Saved SQL logic
        |                |                |
   Reuse query      Reuse data        Reuse operation
                         |
                         |
                      INDEX
                         |
                   Faster access
```

---

# 10. SUPER-SHORT INTERVIEW CHEAT SHEET

### VIEW

```sql
CREATE VIEW view_name AS
SELECT ...
FROM ...;
```

**Purpose:**

> Save and reuse a query.

---

### TEMPORARY TABLE

```sql
CREATE TEMPORARY TABLE temp_name AS
SELECT ...;
```

**Purpose:**

> Store intermediate data temporarily.

---

### STORED PROCEDURE

```sql
DELIMITER //

CREATE PROCEDURE procedure_name(IN p_id INT)
BEGIN

    SELECT *
    FROM Orders
    WHERE Customer_ID = p_id;

END //

DELIMITER ;
```

Run:

```sql
CALL procedure_name(101);
```

**Purpose:**

> Save reusable SQL logic, optionally accepting parameters.

---

### INDEX

```sql
CREATE INDEX idx_name
ON table_name(column_name);
```

**Purpose:**

> Improve lookup/query performance when the index is useful.

---

# 11. ONE-LINE MEMORY TRICK

```text
VIEW
= Save the QUERY

TEMPORARY TABLE
= Save the DATA temporarily

STORED PROCEDURE
= Save the SQL LOGIC

INDEX
= Speed up DATA ACCESS
```

---

# 12. INTERVIEW QUESTIONS YOU SHOULD BE ABLE TO ANSWER

### Q1

What is a View?

**Answer:**

> A View is a stored SQL query that can be queried like a virtual table.

### Q2

Does a normal View store the result data?

**Answer:**

> Normally, no. It stores the query definition and retrieves the underlying data when queried.

### Q3

View vs CTE?

**Answer:**

> A CTE exists for one SQL statement, while a View is saved in the database and can be reused across queries.

### Q4

View vs Temporary Table?

**Answer:**

> A View stores a reusable query definition, while a Temporary Table stores intermediate data for the current session.

### Q5

What is a Stored Procedure?

**Answer:**

> A Stored Procedure is saved SQL logic that can be executed later and can accept parameters.

### Q6

What is an Index?

**Answer:**

> An Index is a database structure that can improve query performance by allowing the database to locate rows more efficiently.

### Q7

Why not create an index on every column?

**Answer:**

> Indexes consume storage and can make INSERT, UPDATE, and DELETE operations more expensive.

### Q8

How do you check whether an index may be used?

```sql
EXPLAIN
SELECT ...
FROM ...
WHERE ...;
```

---

# 13. YOUR LEARNING ORDER

For your current SQL level, I'd learn them in this order:

```text
CTE
 ↓
VIEW
 ↓
TEMPORARY TABLE
 ↓
STORED PROCEDURE
 ↓
INDEX
 ↓
EXPLAIN / QUERY PLANS
 ↓
TRANSACTIONS
 ↓
ISOLATION LEVELS
 ↓
NORMALIZATION
```

You already have the **CTE + analytical SQL** part pretty solid.

The next big jump for you is understanding **how SQL works as a database system**, not just how to write analytical queries.
