-- SQL query exercise sourced from:
-- https://github.com/nashville-software-school/bangazon-corp/blob/master/post-orientation-exercises/chinook/02-sql_queries-chinook.md


-- Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName + ' ' + LastName AS FullName
    ,CustomerId
    ,Country
FROM chinook.dbo.Customer

-- Provide a query only showing the Customers from Brazil.
SELECT FirstName + ' ' + LastName AS FullName
FROM chinook.dbo.Customer
WHERE Country = 'Brazil'

-- Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT FirstName + ' ' + LastName AS FullName
    ,InvoiceId 
    ,InvoiceDate
FROM chinook.dbo.Customer c 
JOIN chinook.dbo.Invoice i 
ON c.CustomerId = i.CustomerId
WHERE Country = 'Brazil'

-- Provide a query showing only the Employees who are Sales Agents.
SELECT FirstName + ' ' + LastName AS FullName
    ,Title
FROM chinook.dbo.Employee
WHERE Title LIKE '%Agent'

-- Provide a query showing a unique list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM chinook.dbo.Invoice

-- Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT e.FirstName + ' ' + e.LastName AS AgentFullName
    ,i.InvoiceDate
    ,i.Total
FROM chinook.dbo.Customer c 
JOIN chinook.dbo.Invoice i 
ON c.CustomerId = i.CustomerId
JOIN chinook.dbo.Employee e 
ON e.State = i.BillingState
WHERE Title LIKE '%Agent'

-- Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT i.Total
    ,c.FirstName + ' ' + c.LastName AS CustomerFullName
    ,i.BillingCountry
    ,e.FirstName + ' ' + e.LastName AS AgentFullName
FROM chinook.dbo.Customer c 
JOIN chinook.dbo.Invoice i 
ON c.CustomerId = i.CustomerId
JOIN chinook.dbo.Employee e 
ON e.State = i.BillingState

-- How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?
SELECT COUNT(Total) AS Invoice_Total
    ,YEAR(InvoiceDate)
FROM chinook.dbo.Invoice
WHERE InvoiceDate BETWEEN ('2009-01-01 00:00:00.000') AND ('2011-12-31 00:00:00.000')
GROUP BY YEAR(InvoiceDate)

-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(*) AS Items_Count
FROM chinook.dbo.InvoiceLine
WHERE InvoiceId = 37

-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT COUNT(*) AS Items_Count
    ,SUM(Total) AS Total
    ,i.InvoiceId
FROM chinook.dbo.InvoiceLine L 
JOIN chinook.dbo.Invoice i
ON L.InvoiceId = i.InvoiceId
GROUP BY i.InvoiceId
ORDER BY 2 DESC

-- Provide a query that includes the track name with each invoice line item.
SELECT T.Name
    ,L.InvoiceId
FROM chinook.dbo.InvoiceLine L 
JOIN chinook.dbo.Track T 
ON L.TrackId = T.TrackId

-- Provide a query that includes the purchased track name AND artist name with each invoice line item.


-- Provide a query that shows the # of invoices per country. HINT: GROUP BY
-- Provide a query that shows the total number of tracks in each playlist. The Playlist name should be included on the resultant table.
-- Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
-- Provide a query that shows all Invoices but includes the # of invoice line items.
-- Provide a query that shows total sales made by each sales agent.
-- Which sales agent made the most in sales in 2009?
-- Which sales agent made the most in sales in 2010?
-- Which sales agent made the most in sales over all?
-- Provide a query that shows the # of customers assigned to each sales agent.
-- Provide a query that shows the total sales per country. Which country's customers spent the most?
-- Provide a query that shows the most purchased track of 2013.
-- Provide a query that shows the top 5 most purchased tracks over all.
-- Provide a query that shows the top 3 best selling artists.
-- Provide a query that shows the most purchased Media Type.
-- Provide a query that shows the number tracks purchased in all invoices that contain more than one genre.