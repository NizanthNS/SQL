USE Daily_SQL;

-- SESSION - Real-World Multi-Table Query Practice

-- E-Commerce Sales Analytics
-- Topic: Advanced Multi-Table SQL Practice

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Join_Date DATE
);

CREATE TABLE Categories (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(50)
);

CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category_ID INT,
    Unit_Price DECIMAL(10,2),
    FOREIGN KEY (Category_ID) REFERENCES Categories(Category_ID)
);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

CREATE TABLE Order_Items (
    Order_Item_ID INT PRIMARY KEY,
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    Order_ID INT,
    Payment_Date DATE,
    Payment_Method VARCHAR(30),
    Payment_Status VARCHAR(20),
    Amount DECIMAL(10,2),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);


INSERT INTO Customers
VALUES
    (1, 'James Anderson', 'New York', '2024-01-15'),
    (2, 'Sophia Williams', 'London', '2024-01-20'),
    (3, 'Daniel Martinez', 'Madrid', '2024-02-05'),
    (4, 'Emma Johnson', 'Toronto', '2024-02-18'),
    (5, 'Lucas Dubois', 'Paris', '2024-03-01'),
    (6, 'Olivia Smith', 'Sydney', '2024-03-12'),
    (7, 'Noah Wilson', 'Chicago', '2024-03-25'),
    (8, 'Mia Taylor', 'Melbourne', '2024-04-10'),
    (9, 'Ethan Brown', 'Berlin', '2024-04-22'),
    (10, 'Ava Thompson', 'Amsterdam', '2024-05-05');


INSERT INTO Categories
VALUES
    (1, 'Electronics'),
    (2, 'Clothing'),
    (3, 'Books'),
    (4, 'Home Appliances'),
    (5, 'Sports');


INSERT INTO Products
VALUES
    (101, 'Laptop', 1, 65000.00),
    (102, 'Smartphone', 1, 30000.00),
    (103, 'Headphones', 1, 2500.00),
    (104, 'T-Shirt', 2, 800.00),
    (105, 'Jeans', 2, 1800.00),
    (106, 'Jacket', 2, 2500.00),
    (107, 'SQL Book', 3, 900.00),
    (108, 'Python Book', 3, 1000.00),
    (109, 'Data Science Book', 3, 1500.00),
    (110, 'Mixer Grinder', 4, 4500.00),
    (111, 'Microwave Oven', 4, 12000.00),
    (112, 'Air Cooler', 4, 9500.00),
    (113, 'Cricket Bat', 5, 3000.00),
    (114, 'Football', 5, 1200.00),
    (115, 'Running Shoes', 5, 3500.00);


INSERT INTO Orders
VALUES
    (1001, 1, '2024-06-01', 'Completed'),
    (1002, 2, '2024-06-02', 'Completed'),
    (1003, 3, '2024-06-03', 'Completed'),
    (1004, 1, '2024-06-05', 'Completed'),
    (1005, 4, '2024-06-06', 'Cancelled'),
    (1006, 5, '2024-06-08', 'Completed'),
    (1007, 6, '2024-06-10', 'Completed'),
    (1008, 7, '2024-06-12', 'Completed'),
    (1009, 8, '2024-06-15', 'Completed'),
    (1010, 9, '2024-06-18', 'Completed'),
    (1011, 10, '2024-06-20', 'Completed'),
    (1012, 2, '2024-06-22', 'Completed'),
    (1013, 3, '2024-06-24', 'Completed'),
    (1014, 5, '2024-06-25', 'Cancelled'),
    (1015, 7, '2024-06-27', 'Completed');


INSERT INTO Order_Items
VALUES
    (1, 1001, 101, 1, 65000.00),
    (2, 1001, 103, 2, 2500.00),

    (3, 1002, 102, 1, 30000.00),
    (4, 1002, 104, 2, 800.00),

    (5, 1003, 107, 2, 900.00),
    (6, 1003, 113, 1, 3000.00),

    (7, 1004, 105, 2, 1800.00),
    (8, 1004, 108, 1, 1000.00),
    (9, 1004, 114, 2, 1200.00),

    (10, 1005, 111, 1, 12000.00),

    (11, 1006, 109, 2, 1500.00),
    (12, 1006, 110, 1, 4500.00),

    (13, 1007, 102, 1, 30000.00),
    (14, 1007, 106, 1, 2500.00),
    (15, 1007, 115, 1, 3500.00),

    (16, 1008, 101, 1, 65000.00),
    (17, 1008, 107, 1, 900.00),

    (18, 1009, 112, 1, 9500.00),
    (19, 1009, 113, 2, 3000.00),

    (20, 1010, 104, 3, 800.00),
    (21, 1010, 108, 2, 1000.00),

    (22, 1011, 103, 2, 2500.00),
    (23, 1011, 115, 1, 3500.00),

    (24, 1012, 102, 1, 30000.00),
    (25, 1012, 109, 1, 1500.00),
    (26, 1012, 114, 1, 1200.00),

    (27, 1013, 101, 1, 65000.00),
    (28, 1013, 111, 1, 12000.00),

    (29, 1014, 105, 1, 1800.00),
    (30, 1014, 110, 1, 4500.00),

    (31, 1015, 106, 2, 2500.00),
    (32, 1015, 113, 1, 3000.00),
    (33, 1015, 115, 2, 3500.00);


INSERT INTO Payments
VALUES
    (501, 1001, '2024-06-01', 'Credit Card', 'Paid', 70000.00),
    (502, 1002, '2024-06-02', 'UPI', 'Paid', 31600.00),
    (503, 1003, '2024-06-03', 'Debit Card', 'Paid', 4800.00),
    (504, 1004, '2024-06-05', 'UPI', 'Paid', 8200.00),
    (505, 1005, '2024-06-06', 'Credit Card', 'Refunded', 12000.00),
    (506, 1006, '2024-06-08', 'UPI', 'Paid', 7500.00),
    (507, 1007, '2024-06-10', 'Credit Card', 'Paid', 36000.00),
    (508, 1008, '2024-06-12', 'Debit Card', 'Paid', 65900.00),
    (509, 1009, '2024-06-15', 'UPI', 'Paid', 15500.00),
    (510, 1010, '2024-06-18', 'Cash', 'Paid', 4400.00),
    (511, 1011, '2024-06-20', 'UPI', 'Paid', 8500.00),
    (512, 1012, '2024-06-22', 'Credit Card', 'Paid', 32700.00),
    (513, 1013, '2024-06-24', 'Debit Card', 'Paid', 77000.00),
    (514, 1014, '2024-06-25', 'UPI', 'Refunded', 6300.00),
    (515, 1015, '2024-06-27', 'Credit Card', 'Paid', 14500.00);
        
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Order_Items;
SELECT * FROM Products;
SELECT * FROM Categories; 
SELECT * FROM Payments;      


-- Q1. Find the top 3 customers in each category by total spending.
--  - Consider only Completed orders.
--    - If two customers have the same spending, they should receive the same rank.

SELECT Customer_ID, Customer_Name, Category_Name, Total_Spending
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY Category_Id
           ORDER BY Total_Spending DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, G.Category_ID, G.Category_Name,
			   COALESCE(SUM(I.Quantity * I.Unit_Price), 0) AS Total_Spending
		FROM Customers C
        INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		INNER JOIN Order_Items I
			ON O.Order_ID = I.Order_ID
		INNER JOIN Products P
			ON I.Product_ID = P.Product_ID
		INNER JOIN Categories G
			ON P.Category_ID = G.Category_ID
		WHERE O.Status = 'Completed'
        GROUP BY C.Customer_ID, C.Customer_Name, G.Category_ID, G.Category_Name
	)C
)T
WHERE D_Rank <= 3;
        

-- Q2. Find customers who have purchased products from at least 3 different categories.


SELECT C.Customer_ID, C.Customer_Name,
	   COUNT(DISTINCT G.Category_ID) AS Diff_Cat
FROM Customers C
INNER JOIN Orders O
	ON C.Customer_ID = O.Customer_ID
INNER JOIN Order_Items I
	ON O.Order_ID = I.Order_ID
INNER JOIN Products P
	ON I.Product_ID = P.Product_ID
INNER JOIN Categories G
	ON P.Category_ID = G.Category_ID
WHERE O.Status = 'Completed'
GROUP BY C.Customer_ID, C.Customer_Name
HAVING COUNT(DISTINCT G.Category_ID) >= 3;


-- Q3. Find the highest-spending customer in each city.
--    - If two customers have the same spending, return both customers.

SELECT Customer_ID, Customer_Name, City, Total_Spending
FROM (
	SELECT *,
		   DENSE_RANK() OVER(PARTITION BY City
           ORDER BY Total_Spending DESC) AS D_Rank
	FROM (
		SELECT C.Customer_ID, C.Customer_Name, C.City,
			   COALESCE(SUM(I.Quantity * I.Unit_Price), 0) AS Total_Spending
		FROM Customers C
        INNER JOIN Orders O
			ON C.Customer_ID = O.Customer_ID
		INNER JOIN Order_Items I
			ON O.Order_ID = I.Order_ID
		INNER JOIN Products P
			ON I.Product_ID = P.Product_ID
		INNER JOIN Categories G
			ON P.Category_ID = G.Category_ID
		WHERE O.Status = 'Completed'
        GROUP BY C.Customer_ID, C.Customer_Name, C.City
	)C
)T
WHERE D_Rank <= 1;


-- Q4. Find products whose total sales are greater than the average product sales within their category.

SELECT Product_ID, Product_Name, Category_Name, Total_Sales, Avg_Sale
FROM (
	SELECT *,
		   ROUND(Exact_Avg, 2) AS Avg_Sale
	FROM (
		SELECT *,
			   AVG(Total_Sales) OVER(PARTITION BY Category_ID) AS Exact_Avg
		FROM (
			SELECT P.Product_ID, P.Product_Name, G.Category_ID, G.Category_Name,
				   COALESCE(SUM(I.Quantity * I.Unit_Price), 0) AS Total_Sales
			FROM Customers C
			INNER JOIN Orders O
				ON C.Customer_ID = O.Customer_ID
			INNER JOIN Order_Items I
				ON O.Order_ID = I.Order_ID
			INNER JOIN Products P
				ON I.Product_ID = P.Product_ID
			INNER JOIN Categories G
				ON P.Category_ID = G.Category_ID
			WHERE O.Status = 'Completed'
			GROUP BY P.Product_ID, P.Product_Name, G.Category_ID, G.Category_Name
		)C
	)T
)E
WHERE Total_Sales > Avg_Sale;


-- Q5. Find customers who have purchased products from every category in the Categories table.

WITH CTE AS (
    SELECT C.Customer_ID, C.Customer_Name,
           COUNT(DISTINCT P.Category_ID) AS Purchased_Categories
    FROM Customers C
    INNER JOIN Orders O
        ON C.Customer_ID = O.Customer_ID
    INNER JOIN Order_Items I
        ON O.Order_ID = I.Order_ID
    INNER JOIN Products P
        ON I.Product_ID = P.Product_ID
    WHERE O.Status = 'Completed'
    GROUP BY C.Customer_ID, C.Customer_Name
)
SELECT Customer_ID, Customer_Name
FROM CTE
WHERE Purchased_Categories = (
    SELECT COUNT(*)
    FROM Categories
);
