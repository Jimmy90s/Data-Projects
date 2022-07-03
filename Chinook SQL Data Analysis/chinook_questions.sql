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
SELECT T.Name
    ,T.Composer
    ,L.InvoiceId
FROM chinook.dbo.InvoiceLine L 
JOIN chinook.dbo.Track T 
ON L.TrackId = T.TrackId

-- Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT BillingCountry 
    ,COUNT(BillingCountry) AS Cnt_of_invoices_per_country
FROM chinook.dbo.Invoice 
GROUP BY BillingCountry

-- Provide a query that shows the total number of tracks in each playlist. The Playlist name should be included on the resultant table.
SELECT a.Name
    ,COUNT(b.TrackId) Tracks_per_playlist
FROM chinook.dbo.Playlist a
JOIN chinook.dbo.PlaylistTrack b
ON a.PlaylistId = b.PlaylistId
GROUP BY a.Name

-- Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
WITH title
AS(
    SELECT a.Title , t.TrackId
    FROM chinook.dbo.Track t
    JOIN chinook.dbo.Album a
    ON  a.AlbumId = t.AlbumId
),
mediatype
AS(
    SELECT m.Name , t.TrackId
    FROM chinook.dbo.Track t
    JOIN chinook.dbo.MediaType m
    ON  t.MediaTypeId = m.MediaTypeId
),
genre
AS(
    SELECT g.Name , t.TrackId
    FROM chinook.dbo.Track t
    JOIN chinook.dbo.Genre g
    ON  t.GenreId = g.GenreId
)
SELECT t.Title AS Album_Name
    ,m.Name AS Media_type
    ,g.Name AS Genre
FROM title t
JOIN mediatype m
ON t.TrackId = m.TrackId
JOIN genre g 
ON g.TrackId = t.TrackId
--GROUP BY m.Name,t.Title,g.Name

-- Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT a.InvoiceId
    ,COUNT(b.InvoiceId) AS cnt_of_line_times
FROM chinook.dbo.Invoice a
JOIN chinook.dbo.InvoiceLine b
ON a.InvoiceId = b.InvoiceId
GROUP BY a.InvoiceId

-- Provide a query that shows total sales made by each sales agent.
SELECT e.FirstName + ' ' + e.LastName AS Agent
    ,SUM(i.Total) AS Total_Sales
FROM chinook.dbo.Customer c
JOIN chinook.dbo.Employee e
ON c.SupportRepId = e.EmployeeId
JOIN chinook.dbo.Invoice i 
ON i.CustomerId = c.CustomerId
GROUP BY e.FirstName, e.LastName

-- Which sales agent made the most in sales in 2009?
WITH sales 
AS( 
    SELECT e.FirstName + ' ' + e.LastName AS Agent
        ,YEAR(i.InvoiceDate) AS Year
        ,i.Total as Total
    FROM chinook.dbo.Customer c
    JOIN chinook.dbo.Employee e
    ON c.SupportRepId = e.EmployeeId
    JOIN chinook.dbo.Invoice i 
    ON i.CustomerId = c.CustomerId
    WHERE YEAR(i.InvoiceDate) = 2009
)
SELECT Agent 
    ,Year
    ,SUM(Total) AS Total_Sales
FROM sales
GROUP BY Agent, Year
ORDER BY SUM(Total) DESC

-- Which sales agent made the most in sales in 2010?
WITH sales 
AS( 
    SELECT e.FirstName + ' ' + e.LastName AS Agent
        ,YEAR(i.InvoiceDate) AS Year
        ,i.Total as Total
    FROM chinook.dbo.Customer c
    JOIN chinook.dbo.Employee e
    ON c.SupportRepId = e.EmployeeId
    JOIN chinook.dbo.Invoice i 
    ON i.CustomerId = c.CustomerId
    WHERE YEAR(i.InvoiceDate) = 2010
)
SELECT Agent 
    ,Year
    ,SUM(Total) AS Total_Sales
FROM sales
GROUP BY Agent, Year
ORDER BY SUM(Total) DESC

-- Which sales agent made the most in sales over all?
WITH sales 
AS( 
    SELECT e.FirstName + ' ' + e.LastName AS Agent
        ,YEAR(i.InvoiceDate) AS Year
        ,i.Total as Total
    FROM chinook.dbo.Customer c
    JOIN chinook.dbo.Employee e
    ON c.SupportRepId = e.EmployeeId
    JOIN chinook.dbo.Invoice i 
    ON i.CustomerId = c.CustomerId
    --WHERE YEAR(i.InvoiceDate) = 2009
)
SELECT Agent 
    ,SUM(Total) AS Total_Sales
FROM sales
GROUP BY Agent
ORDER BY SUM(Total) DESC

-- Provide a query that shows the # of customers assigned to each sales agent.
SELECT e.FirstName + ' ' + e.LastName AS Agent
    ,COUNT(c.CustomerId) AS Customers_assinged
FROM chinook.dbo.Customer c
JOIN chinook.dbo.Employee e
ON c.SupportRepId = e.EmployeeId
GROUP BY e.FirstName, e.LastName

-- Provide a query that shows the total sales per country. Which country's customers spent the most?
SELECT BillingCountry AS Country
    ,SUM(Total) Total
FROM chinook.dbo.Invoice
GROUP BY BillingCountry
ORDER BY SUM(Total) DESC

-- Provide a query that shows the most purchased track of 2013.
WITH _2013
AS(
    SELECT t.Name
        ,i.Total
    FROM chinook.dbo.Invoice i 
    JOIN chinook.dbo.InvoiceLine l 
    ON i.InvoiceId = l.InvoiceId
    JOIN chinook.dbo.Track t 
    ON t.TrackId = l.TrackId
    WHERE YEAR(i.InvoiceDate) = 2013
)
SELECT Name
    ,SUM(Total) AS Total
FROM _2013
GROUP BY Name
ORDER BY SUM(Total) DESC

-- Provide a query that shows the top 5 most purchased tracks over all.
WITH all_time
AS(
    SELECT t.Name
        ,i.Total
    FROM chinook.dbo.Invoice i 
    JOIN chinook.dbo.InvoiceLine l 
    ON i.InvoiceId = l.InvoiceId
    JOIN chinook.dbo.Track t 
    ON t.TrackId = l.TrackId
)
SELECT Name
    ,SUM(Total) AS Total
FROM all_time
GROUP BY Name
ORDER BY SUM(Total) DESC

-- Provide a query that shows the top 3 best selling artists.
WITH all_time
AS(
    SELECT t.Composer
        ,i.Total
    FROM chinook.dbo.Invoice i 
    JOIN chinook.dbo.InvoiceLine l 
    ON i.InvoiceId = l.InvoiceId
    JOIN chinook.dbo.Track t 
    ON t.TrackId = l.TrackId
    WHERE t.Composer IS NOT NULL
)
SELECT Composer
    ,SUM(Total) AS Total
FROM all_time
GROUP BY Composer
ORDER BY SUM(Total) DESC

-- Provide a query that shows the most purchased Media Type.
WITH all_time
AS(
    SELECT m.Name
        ,i.Total
    FROM chinook.dbo.Invoice i 
    JOIN chinook.dbo.InvoiceLine l 
    ON i.InvoiceId = l.InvoiceId
    JOIN chinook.dbo.Track t 
    ON t.TrackId = l.TrackId
    JOIN chinook.dbo.MediaType m 
    ON m.MediaTypeId = t.MediaTypeId
)
SELECT Name
    ,SUM(Total) AS Total
FROM all_time
GROUP BY Name
ORDER BY SUM(Total) DESC

-- Provide a query that shows the number of tracks purchased in all invoices that contain more than one genre.
WITH genres
AS(
    SELECT t.Name AS Track
        ,g.Name AS Genre
    FROM chinook.dbo.Invoice i 
    JOIN chinook.dbo.InvoiceLine l 
    ON i.InvoiceId = l.InvoiceId
    JOIN chinook.dbo.Track t 
    ON t.TrackId = l.TrackId
    JOIN chinook.dbo.Genre g
    ON g.GenreId = t.GenreId
    WHERE g.Name LIKE '%&%' 
    OR g.Name LIKE '%/%'
) 
SELECT COUNT(*) AS tracks_with_2_or_more_genres
FROM genres
