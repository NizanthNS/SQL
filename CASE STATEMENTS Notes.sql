SQL CASE STATEMENT — SUM vs COUNT vs AVG
==========================================

🧠 EASY MEMORY RULE

SUM   → Give the MONEY 💰
COUNT → Give a 1 🔢
AVG   → Give the MONEY, unwanted rows = NULL 🚫


1️⃣ SUM — TOTAL AMOUNT
----------------------

Use:

SUM(
    CASE
        WHEN condition THEN Amount
        ELSE 0
    END
)

Example:

SUM(
    CASE
        WHEN Transaction_Type = 'Credit'
        THEN Transaction_Amount
        ELSE 0
    END
) AS Total_Credit_Amount

Why ELSE 0?

Because SUM adds everything.

Example:

Credit  500 → 500
Debit   300 → 0
Credit  700 → 700
Debit   200 → 0

Result:

500 + 0 + 700 + 0 = 1200


🧠 Remember:

SUM = "I WANT THE MONEY"

THEN Amount
ELSE 0


2️⃣ COUNT — COUNT MATCHING ROWS
-------------------------------

Use:

COUNT(
    CASE
        WHEN condition THEN 1
    END
)

Example:

COUNT(
    CASE
        WHEN Delivery_Status = 'Cancelled'
        THEN 1
    END
) AS Total_Cancelled_Deliveries

Why only THEN 1?

Because COUNT() counts NON-NULL values.

Cancelled → 1
Delivered → NULL
Cancelled → 1
Delivered → NULL

COUNT(1, NULL, 1, NULL) = 2


⚠️ DON'T DO THIS:

COUNT(
    CASE
        WHEN Delivery_Status = 'Cancelled'
        THEN 1
        ELSE 0
    END
)

Why?

Because COUNT() counts both 1 and 0.

COUNT(1, 0, 1, 0) = 4 ❌


🧠 Remember:

COUNT = "I JUST WANT TO COUNT"

MATCH → 1
NO MATCH → NULL


3️⃣ AVG — AVERAGE AMOUNT
-------------------------

Use:

AVG(
    CASE
        WHEN condition THEN Amount
    END
)

Example:

AVG(
    CASE
        WHEN Delivery_Status = 'Delivered'
        THEN Delivery_Amount
    END
) AS Average_Delivered_Amount

Why NO ELSE 0?

Because AVG() ignores NULL.

Delivered  500 → 500
Cancelled  300 → NULL
Delivered  700 → 700
Cancelled  200 → NULL

AVG(500, NULL, 700, NULL)

= (500 + 700) / 2

= 600


⚠️ DON'T DO THIS:

AVG(
    CASE
        WHEN Delivery_Status = 'Delivered'
        THEN Delivery_Amount
        ELSE 0
    END
)

Because:

AVG(500, 0, 700, 0)

= 300 ❌


🧠 Remember:

AVG = "AVERAGE ONLY THE MATCHING AMOUNTS"

MATCH → Amount
NO MATCH → NULL


================================================

🔥 FINAL CHEAT SHEET
================================================

SUM
→ Total Amount

SUM(CASE WHEN condition THEN Amount ELSE 0 END)


COUNT
→ Number of Matching Rows

COUNT(CASE WHEN condition THEN 1 END)


AVG
→ Average Matching Amount

AVG(CASE WHEN condition THEN Amount END)


================================================

⭐ MOST IMPORTANT THING TO REMEMBER
================================================

0    = participates in calculation
NULL = ignored by SUM / AVG / COUNT


So remember:

💰 SUM   → Amount + 0
🔢 COUNT → 1 + NULL
📊 AVG   → Amount + NULL


ONE-LINE MEMORY:

"SUM wants MONEY,
 COUNT wants 1,
 AVG wants MONEY and ignores NULL."
