/***************************************************/
/* SQL for Data Analysis - Weekender Crash Course  */
/***************************************************/

/*Before you run these queries, make sure to create Sakila DB and import the related data first*/
SELECT *
FROM sakila.dbo.actor
/* Email Campaigns for customers of Store 2
First, Last name and Email address of customers from Store 2*/
SELECT first_name,
    last_name,
    email
FROM sakila.dbo.customer
WHERE store_id = 2

/* movie with rental rate of 0.99$*/

SELECT DISTINCT f.title AS movie_with_rental_rate_of_99cents
FROM sakila.dbo.rental r
JOIN sakila.dbo.payment p 
ON r.rental_id = p.rental_id
JOIN sakila.dbo.inventory i 
ON i.inventory_id = r.inventory_id
JOIN sakila.dbo.film f 
ON f.film_id = i.film_id
WHERE p.amount = .99


/* we want to see rental rate and how many movies are in each rental rate categories*/

SELECT DISTINCT rental_rate,
    COUNT(title) AS Count_of_movies
FROM sakila.dbo.film
GROUP BY rental_rate


/*Which rating do we have the most films in?*/
SELECT rating,
    COUNT(title) AS Count_of_titles
FROM sakila.dbo.film
GROUP BY rating
ORDER BY 2 DESC


/*Which rating is most prevalant in each store?*/

SELECT store_id,
    rating,
    COUNT(rating) AS Count
FROM sakila.dbo.film f 
JOIN sakila.dbo.inventory i 
ON i.film_id = f.film_id
GROUP BY store_id,
    rating
ORDER BY 3 DESC

/*We want to mail the customers about the upcoming promotion*/


/* List of films by Film Name, Category, Language*/
SELECT f.title AS Film_Name,
    l.name AS Language,
    cc.name AS Category
FROM sakila.dbo.film f
JOIN sakila.dbo.[language] l 
ON l.language_id = f.language_id 
JOIN sakila.dbo.film_category c 
ON f.film_id = c.film_id
JOIN sakila.dbo.category cc 
ON cc.category_id = c.category_id

