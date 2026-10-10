create database grocery;
use grocery;
-- 1. Suppliers Table (Source: Suppliers.csv)
CREATE TABLE IF NOT EXISTS suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    Address TEXT
);

-- 2. Categories Table (Source: Categories.csv)
CREATE TABLE IF NOT EXISTS categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL
);

-- 3. Store Employees Table (Source: Store_Employees.csv)
CREATE TABLE IF NOT EXISTS store_employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    HireDate VARCHAR(50)
);

-- 4. Customers Table (Source: Customers.csv)
CREATE TABLE IF NOT EXISTS customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address TEXT
);

-- 5. Products Table (Source: Products.csv)
CREATE TABLE IF NOT EXISTS products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (SupplierID) REFERENCES suppliers(SupplierID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID)
        ON UPDATE CASCADE ON DELETE CASCADE
);


-- 6. Orders Table (Source: Orders.csv)
CREATE TABLE IF NOT EXISTS orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES store_employees(EmployeeID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- 7. Order Details Table (Source: OrderDetails.csv)
CREATE TABLE IF NOT EXISTS orderdetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PriceEach DECIMAL(10, 2),
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
show tables;
select * from suppliers;
select * from products;
select * from categories;
select * from customers;
select * from orders;
select * from orderdetails;
select * from store_employees;
SELECT 'customers' AS table_name, COUNT(*) AS records FROM customers
UNION ALL
SELECT 'store_employees', COUNT(*) FROM store_employees
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'orderdetails', COUNT(*) FROM orderdetails;
describe products;
select * from products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orderdetails;
SELECT 'customers' AS TableName, COUNT(*) AS RecordCount FROM customers
UNION ALL
SELECT 'store_employees', COUNT(*) FROM store_employees
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'orderdetails', COUNT(*) FROM orderdetails;
SELECT 'customers' AS TableName, COUNT(*) AS RecordCount FROM customers
UNION ALL
SELECT 'store_employees', COUNT(*) FROM store_employees
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'orderdetails', COUNT(*) FROM orderdetails;
show tables;
use grocery;
# How many unique customers have placed orders?
SELECT 
    COUNT(DISTINCT CustomerID) AS UniqueCustomersWithOrders
FROM orders;
# Which customers have placed the highest number of orders?
SELECT 
    c.CustomerID, 
    c.Name AS CustomerName, 
    COUNT(o.OrderID) AS OrderCount
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY OrderCount DESC;
# What is the total and average purchase value per customer?
SELECT 
    c.CustomerID, 
    c.Name AS CustomerName, 
    ROUND(SUM(od.TotalPrice), 2) AS TotalPurchaseValue,
    ROUND(SUM(od.TotalPrice) / COUNT(DISTINCT o.OrderID), 2) AS AvgPurchaseValuePerOrder
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
ORDER BY TotalPurchaseValue DESC;
# Who are the top 5 customers by total purchase amount?
SELECT 
    c.CustomerID, 
    c.Name AS CustomerName, 
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    ROUND(SUM(od.TotalPrice), 2) AS TotalPurchaseAmount
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
ORDER BY TotalPurchaseAmount DESC
LIMIT 5;
# How many products exist in each category?
SELECT 
    cat.CategoryID, 
    cat.CategoryName, 
    COUNT(p.ProductID) AS ProductCount
FROM categories cat
LEFT JOIN products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryID, cat.CategoryName
ORDER BY ProductCount DESC;
# What is the average price of products by category?
SELECT 
    cat.CategoryID, 
    cat.CategoryName, 
    ROUND(AVG(p.Price), 2) AS AvgProductPrice
FROM categories cat
JOIN products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryID, cat.CategoryName
ORDER BY AvgProductPrice DESC;
# Which products have the highest total sales volume (by quantity)?
SELECT 
    p.ProductID, 
    p.Name AS ProductName, 
    SUM(od.Quantity) AS TotalQuantitySold
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalQuantitySold DESC;
# What is the total revenue generated by each product?
SELECT 
    p.ProductID, 
    p.Name AS ProductName, 
    ROUND(SUM(od.TotalPrice), 2) AS TotalRevenueGenerated
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalRevenueGenerated DESC;
# How do product sales vary by category and supplier?
SELECT 
    cat.CategoryName,
    sup.SupplierName,
    COUNT(DISTINCT p.ProductID) AS ProductsOffered,
    SUM(od.Quantity) AS TotalUnitsSold,
    ROUND(SUM(od.TotalPrice), 2) AS TotalRevenue
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
JOIN categories cat ON p.CategoryID = cat.CategoryID
JOIN suppliers sup ON p.SupplierID = sup.SupplierID
GROUP BY cat.CategoryName, sup.SupplierName
ORDER BY cat.CategoryName, TotalRevenue DESC;
# How many orders have been placed in total?
SELECT 
    COUNT(OrderID) AS TotalOrdersPlaced
FROM orders;
# What is the average value per order?
SELECT 
    ROUND(SUM(od.TotalPrice) / COUNT(DISTINCT o.OrderID), 2) AS AverageOrderValue
FROM orders o
JOIN orderdetails od ON o.OrderID = od.OrderID;
# On which dates were the most orders placed?
SELECT 
    STR_TO_DATE(OrderDate, '%m/%d/%Y') AS FormattedDate, 
    COUNT(OrderID) AS OrdersPlaced
FROM orders
GROUP BY STR_TO_DATE(OrderDate, '%m/%d/%Y')
ORDER BY OrdersPlaced DESC
LIMIT 5;
# What are the monthly trends in order volume and revenue?
SELECT 
    DATE_FORMAT(STR_TO_DATE(o.OrderDate, '%m/%d/%Y'), '%Y-%m') AS YearMonth,
    COUNT(DISTINCT o.OrderID) AS OrderVolume,
    SUM(od.Quantity) AS TotalItemsSold,
    ROUND(SUM(od.TotalPrice), 2) AS TotalRevenue
FROM orders o
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY DATE_FORMAT(STR_TO_DATE(o.OrderDate, '%m/%d/%Y'), '%Y-%m')
ORDER BY YearMonth ASC;
# How do order patterns vary across weekdays and weekends?
SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(o.OrderDate, '%m/%d/%Y')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    ROUND(SUM(od.TotalPrice), 2) AS TotalRevenue,
    ROUND(SUM(od.TotalPrice) / COUNT(DISTINCT o.OrderID), 2) AS AverageOrderValue
FROM orders o
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY DayType;
# How many suppliers are there in the database?
SELECT 
    COUNT(SupplierID) AS TotalSuppliers
FROM suppliers;
# Which supplier provides the most products?
SELECT 
    s.SupplierID, 
    s.SupplierName, 
    COUNT(p.ProductID) AS ProductsSupplied
FROM suppliers s
JOIN products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY ProductsSupplied DESC;
# What is the average price of products from each supplier?
SELECT 
    s.SupplierID, 
    s.SupplierName, 
    ROUND(AVG(p.Price), 2) AS AvgProductPrice
FROM suppliers s
JOIN products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY AvgProductPrice DESC;
# Which suppliers contribute the most to total product sales (by revenue)?
SELECT 
    s.SupplierID, 
    s.SupplierName, 
    SUM(od.Quantity) AS TotalUnitsSold,
    ROUND(SUM(od.TotalPrice), 2) AS RevenueContribution
FROM suppliers s
JOIN products p ON s.SupplierID = p.SupplierID
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY RevenueContribution DESC;
# How many employees have processed orders?
SELECT 
    COUNT(DISTINCT EmployeeID) AS ActiveEmployeesProcessingOrders
FROM orders;
# Which employees have handled the most orders?
SELECT 
    emp.EmployeeID, 
    emp.Name AS EmployeeName, 
    COUNT(o.OrderID) AS OrdersHandled
FROM store_employees emp
JOIN orders o ON emp.EmployeeID = o.EmployeeID
GROUP BY emp.EmployeeID, emp.Name
ORDER BY OrdersHandled DESC;
# What is the total sales value processed by each employee?
SELECT 
    emp.EmployeeID, 
    emp.Name AS EmployeeName, 
    ROUND(SUM(od.TotalPrice), 2) AS TotalSalesProcessed
FROM store_employees emp
JOIN orders o ON emp.EmployeeID = o.EmployeeID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY emp.EmployeeID, emp.Name
ORDER BY TotalSalesProcessed DESC;
# What is the average order value handled per employee?
SELECT 
    emp.EmployeeID, 
    emp.Name AS EmployeeName, 
    COUNT(DISTINCT o.OrderID) AS OrdersHandled,
    ROUND(SUM(od.TotalPrice), 2) AS TotalSalesHandled,
    ROUND(SUM(od.TotalPrice) / COUNT(DISTINCT o.OrderID), 2) AS AverageOrderValueHandled
FROM store_employees emp
JOIN orders o ON emp.EmployeeID = o.EmployeeID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY emp.EmployeeID, emp.Name
ORDER BY AverageOrderValueHandled DESC;
# What is the relationship between quantity ordered and total price?
SELECT 
    Quantity, 
    COUNT(OrderDetailID) AS TotalOrderLineItems,
    ROUND(AVG(TotalPrice), 2) AS AverageTotalPrice,
    ROUND(MIN(TotalPrice), 2) AS MinTotalPrice,
    ROUND(MAX(TotalPrice), 2) AS MaxTotalPrice
FROM orderdetails
GROUP BY Quantity
ORDER BY Quantity ASC;
# What is the average quantity ordered per product?
SELECT 
    p.ProductID, 
    p.Name AS ProductName, 
    ROUND(AVG(od.Quantity), 2) AS AvgQuantityPerOrderLineItem,
    SUM(od.Quantity) AS TotalQuantitySold
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY AvgQuantityPerOrderLineItem DESC;
# How does the unit price vary across products and orders?
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.Price AS CatalogUnitPrice,
    ROUND(AVG(od.PriceEach), 2) AS AverageBilledUnitPrice,
    ROUND(MIN(od.PriceEach), 2) AS MinBilledUnitPrice,
    ROUND(MAX(od.PriceEach), 2) AS MaxBilledUnitPrice
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.Name, p.Price
ORDER BY CatalogUnitPrice DESC;





