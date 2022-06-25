/*
https://sqlzoo.net/wiki/AdventureWorks
*/

-- Concat first and last name
SELECT FirstName, LastName, FirstName +' '+ LastName AS FullName
FROM [AdventureWorksLT2019].[SalesLT].[Customer]

-- Show the first name and the email address of customer with CompanyName 'Bike World'
SELECT FirstName, EmailAddress
FROM AdventureWorksLT2019.SalesLT.Customer
WHERE CompanyName ='Bike World'

-- Show the CompanyName for all customers with an address in City 'Dallas'.
SELECT c.CompanyName
FROM AdventureWorksLT2019.SalesLT.Customer c
JOIN  AdventureWorksLT2019.SalesLT.Address a
ON c.CustomerId = a.AddressID
WHERE city = 'Dallas'

-- How many items with ListPrice more than $1000 have been sold?
SELECT COUNT(a.ListPrice) Num_sold_over_1000
FROM AdventureWorksLT2019.SalesLT.Product a
JOIN AdventureWorksLT2019.SalesLT.SalesOrderDetail b
ON a.ProductID = b.ProductID
WHERE a.ListPrice > 1000

-- Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight
SELECT a.CompanyName
FROM AdventureWorksLT2019.SalesLT.Customer a
JOIN AdventureWorksLT2019.SalesLT.SalesOrderHeader b
ON a.CustomerID = b.CustomerID
WHERE  b.SubTotal + b.TaxAmt + b.Freight > 100000

-- Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
WITH CTE
AS(
    SELECT SalesOrderID, Name, OrderQty
    FROM AdventureWorksLT2019.SalesLT.Product a
    JOIN AdventureWorksLT2019.SalesLT.SalesOrderDetail b
    ON a.ProductID = b.ProductID
    WHERE a.Name = 'Racing Socks, L'
),
CTE2
AS(
    SELECT a.SalesOrderID, CompanyName
    FROM AdventureWorksLT2019.SalesLT.SalesOrderHeader a
    JOIN AdventureWorksLT2019.SalesLT.Customer b
    ON a.CustomerID = b.CustomerID
    WHERE CompanyName = 'Riding Cycles'
)
SELECT SUM(a.OrderQty) AS 'Sum of Racing socks,L ordered from Riding Cycles'
FROM CTE a
JOIN CTE2 b
ON a.SalesOrderID = b.SalesOrderID

-- A "Single Item Order" is a customer order where only one item is ordered.
-- Show the SalesOrderID and the UnitPrice for every Single Item Order.
SELECT SalesOrderID ,UnitPrice
FROM AdventureWorksLT2019.SalesLT.SalesOrderDetail 
WHERE OrderQty = 1

-- Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'.
WITH CTE 
AS(
    SELECT SalesOrderID, Name, OrderQty
    FROM AdventureWorksLT2019.SalesLT.Product a
    JOIN AdventureWorksLT2019.SalesLT.SalesOrderDetail b
    ON a.ProductID = b.ProductID
    WHERE a.Name LIKE '%Racing Socks%'
),
CTE2
AS(
    SELECT a.SalesOrderID, CompanyName
    FROM AdventureWorksLT2019.SalesLT.SalesOrderHeader a
    JOIN AdventureWorksLT2019.SalesLT.Customer b
    ON a.CustomerID = b.CustomerID
)
SELECT Name , CompanyName
FROM CTE a
JOIN CTE2 b
ON a.SalesOrderID = b.SalesOrderID


-- Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. 
-- For each order show the CompanyName and the SubTotal and the total weight of the order.
SELECT SubTotal
FROM AdventureWorksLT2019.SalesLT.SalesOrderHeader 
ORDER BY 1 DESC

-- How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?

WITH CTE 
AS(
    SELECT a.Name, b.ProductID
    FROM AdventureWorksLT2019.SalesLT.ProductCategory a 
    JOIN AdventureWorksLT2019.SalesLT.Product b 
    ON a.ProductCategoryID = b.ProductCategoryID
    WHERE a.Name LIKE '%Cranksets'
),
CTE2
AS(
    SELECT CustomerID ,City
    FROM AdventureWorksLT2019.SalesLT.Address a 
    JOIN AdventureWorksLT2019.SalesLT.CustomerAddress b 
    ON a.AddressID = b.AddressID
    WHERE City = 'London'  
),
CTE3
AS(
    SELECT a.CustomerID , b.City, a.SalesOrderID
    FROM AdventureWorksLT2019.SalesLT.SalesOrderHeader a 
    JOIN CTE2 b 
    ON a.CustomerID = b.CustomerID
),
CTE4
AS(
    SELECT ProductID
    FROM AdventureWorksLT2019.SalesLT.SalesOrderDetail a 
    JOIN CTE3 b
    ON a.SalesOrderID = b.SalesOrderID
)
SELECT COUNT(*)
FROM CTE a 
JOIN CTE4 b 
ON a.ProductID = b.ProductID

