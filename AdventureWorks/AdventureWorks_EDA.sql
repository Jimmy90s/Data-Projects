/*

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




