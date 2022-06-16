-- Dataset was downloaded from :
-- https://www.kaggle.com/datasets/mohamedharris/supermart-grocery-sales-retail-analytics-dataset
-- This is a fictional dataset created for helping the data analysts to practice exploratory data analysis 
-- and data visualization. The dataset has data on orders placed by customers on a grocery delivery application.
-- The dataset is designed with an assumption that the orders are placed by customers living in the state of Tamil Nadu, India.

-- My Goal is to examine and explore who is our most profitable customer?
-- What is our most profitable Category?
-- Where are the most sales happening?
-- What customer is getting the most discounts?
-- Anythign els that might be helpfull.

-- Examine Table
SELECT *
FROM [master].[dbo].[Sales]

-- After looking at the table I can see the data types are not correct
-- Im looking to gather data on profit and discount so ill need to change those coulums data types

-- Change Profit column to float
ALTER TABLE [master].[dbo].[Sales]
ALTER COLUMN Profit FLOAT

-- Change Discount column to float
ALTER TABLE [master].[dbo].[Sales]
ALTER COLUMN Discount FLOAT

-- List of unique Customers
SELECT DISTINCT [Customer Name]
FROM [master].[dbo].[Sales]

-- Count of unique customers
SELECT COUNT(DISTINCT [Customer Name]) AS [Customer Count]
FROM [master].[dbo].[Sales]

-- See the unquie cities
SELECT DISTINCT City
FROM [master].[dbo].[Sales]

-- Count of unquie cities
SELECT COUNT(DISTINCT City) AS [City Count]
FROM [master].[dbo].[Sales]

-- Average Profit by City
SELECT City, AVG(Profit) AS [Avg Profit]
FROM [master].[dbo].[Sales]
GROUP BY City
ORDER BY 2 DESC

-- Most Profitable Customers
SELECT [Customer Name] , SUM(Profit) AS [Total Profit]
FROM [master].[dbo].[Sales]
GROUP BY [Customer Name]
ORDER BY SUM(Profit) DESC

-- Most Profitable Cities
SELECT City , SUM(Profit) AS [Total Profit]
FROM [master].[dbo].[Sales]
GROUP BY City
ORDER BY SUM(Profit) DESC

-- Profit Total by Region
SELECT TOP 4 Region , SUM(Profit) AS [Total Profit]
FROM [master].[dbo].[Sales]
GROUP BY Region
ORDER BY SUM(Profit) DESC

-- Average Dicount 
SELECT AVG(Discount) AS [Avg Discount]
FROM [master].[dbo].[Sales]

-- Average Dicount by City
SELECT City, AVG(Discount) AS [Avg Discount]
FROM [master].[dbo].[Sales]
GROUP BY City
ORDER BY AVG(Discount) DESC

-- Total Profit by Category
SELECT Category , SUM(Profit) AS [Total Profit]
FROM [master].[dbo].[Sales]
GROUP BY Category
ORDER BY SUM(Profit) DESC

-- Customers getting the most discounts
SELECT [Customer Name], SUM(Discount) AS [Total Discount]
FROM [master].[dbo].[Sales]
GROUP BY [Customer Name]
ORDER BY AVG(Discount) DESC