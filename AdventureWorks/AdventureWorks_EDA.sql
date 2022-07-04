/*
https://sqlzoo.net/wiki/AdventureWorks
*/

-- Concat first and last name
SELECT FirstName +' '+ LastName AS FullName
FROM [AdventureWorksLT2019].[SalesLT].[Customer]

-- look for duplicates
WITH cte AS (
    SELECT 
        SalesOrderDetailID,
        ROW_NUMBER() OVER (
            PARTITION BY SalesOrderDetailID
            ORDER BY SalesOrderDetailID) row_num
    FROM 
        AdventureWorksLT2019.SalesLT.SalesOrderDetail
) 
SELECT * FROM cte 
WHERE row_num > 1;

-- Most popular ProductIDs by saleorderdetailid
SELECT ProductID ,COUNT(SalesOrderDetailID)
FROM AdventureWorksLT2019.SalesLT.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(SalesOrderDetailID) > 1
ORDER BY COUNT(SalesOrderDetailID) DESC

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
WITH CTE 
AS(
    SELECT a.SubTotal ,b.CompanyName ,a.SalesOrderID
    FROM AdventureWorksLT2019.SalesLT.SalesOrderHeader a 
    JOIN AdventureWorksLT2019.SalesLT.Customer b 
    ON a.CustomerID = b.CustomerID
),
CTE2
AS(
    SELECT d.OrderQty  ,c.Weight , d.SalesOrderID
    FROM AdventureWorksLT2019.SalesLT.Product c 
    JOIN AdventureWorksLT2019.SalesLT.SalesOrderDetail d  
    ON d.ProductID = c.ProductID
)
SELECT a.SubTotal , CompanyName ,SUM(b.OrderQty * b.Weight) Total_weight
FROM CTE a
JOIN CTE2 b
ON a.SalesOrderID = b.SalesOrderID
GROUP BY a.SubTotal , CompanyName, a.SalesOrderID
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
SELECT COUNT(*) AS Cranksets_sold_to_London
FROM CTE a 
JOIN CTE4 b 
ON a.ProductID = b.ProductID


-- For every customer with a 'Main Office' in Dallas show AddressLine1 of the 'Main Office' and AddressLine1 of the 'Shipping' address
-- if there is no shipping address leave it blank. Use one row per customer.
SELECT c.CompanyName ,s.AddressLine1
FROM AdventureWorksLT2019.SalesLT.Customer c
FULL JOIN AdventureWorksLT2019.SalesLT.CustomerAddress a 
ON c.CustomerID = a.CustomerID
FULL JOIN AdventureWorksLT2019.SalesLT.Address s 
ON s.AddressID = a.AddressID
WHERE a.AddressType = 'Main Office'
AND s.City = 'Dallas'
GROUP BY c.CompanyName, s.AddressLine1
--^^my wrong answer^^--fixed below--
SELECT
  c.CompanyName,
  MAX(CASE WHEN AddressType = 'Main Office' THEN AddressLine1 ELSE '' END) AS 'Main Office Address',
  MAX(CASE WHEN AddressType = 'Shipping' THEN AddressLine1 ELSE '' END) AS 'Shipping Address'
FROM
  AdventureWorksLT2019.SalesLT.Customer c
  JOIN
    AdventureWorksLT2019.SalesLT.CustomerAddress a
    ON c.CustomerID = a.CustomerID
  JOIN
    AdventureWorksLT2019.SalesLT.Address b
    ON a.AddressID = b.AddressID
WHERE
  b.City = 'Dallas'
GROUP BY
  c.CompanyName;

-- For each order show the SalesOrderID and SubTotal calculated three ways:
-- A) From the SalesOrderHeader
-- B) Sum of OrderQty*UnitPrice
-- C) Sum of OrderQty*ListPrice
SELECT h.SalesOrderID
    ,SUM(d.OrderQty * d.UnitPrice) AS sum_of_qty_x_unitprice
    ,SUM(d.OrderQty * p.ListPrice) AS sum_of_qty_x_listprice
FROM  AdventureWorksLT2019.SalesLT.SalesOrderHeader h 
JOIN  AdventureWorksLT2019.SalesLT.SalesOrderDetail d 
ON h.SalesOrderID = d.SalesOrderID
JOIN  AdventureWorksLT2019.SalesLT.Product p 
ON p.ProductID = d.ProductID
GROUP BY h.SalesOrderID

-- Show the best selling item by value.
SELECT p.Name
    ,SUM(d.OrderQty * d.UnitPrice) AS Total
FROM  AdventureWorksLT2019.SalesLT.SalesOrderDetail d 
JOIN  AdventureWorksLT2019.SalesLT.Product p 
ON p.ProductID = d.ProductID
GROUP BY p.Name
ORDER BY Total DESC

-- Show how many orders are in the following ranges (in $):
/*   RANGE      Num Orders      Total Value
    0-  99
  100- 999
 1000-9999
10000-*/
WITH _range 
AS( 
SELECT h.TotalDue,
    CASE WHEN h.TotalDue BETWEEN 0 AND 99 THEN '0-99' 
    WHEN h.TotalDue BETWEEN 100 AND 999 THEN '100-999'
    WHEN h.TotalDue BETWEEN 1000 AND 9999 THEN '1000-9999' 
    WHEN h.TotalDue > 10000 THEN '10000-*' 
    ELSE '' END AS range
FROM AdventureWorksLT2019.SalesLT.SalesOrderDetail d 
JOIN AdventureWorksLT2019.SalesLT.SalesOrderHeader h 
ON h.SalesOrderID = d.SalesOrderID
)
SELECT range 
    ,COUNT(range) AS Num_Orders
    ,SUM(TotalDue) AS Total_value
FROM _range
GROUP BY range
