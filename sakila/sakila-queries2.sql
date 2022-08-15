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
    JOIN sakila.dbo.language l 
        ON l.language_id = f.language_id 
    JOIN sakila.dbo.film_category c 
        ON f.film_id = c.film_id
    JOIN sakila.dbo.category cc 
        ON cc.category_id = c.category_id

/* How many times each movie has been rented out? */
SELECT f.title,
     COUNT(r.inventory_id) times_rented
FROM sakila.dbo.rental r 
    JOIN sakila.dbo.inventory i
        ON i.inventory_id = r.inventory_id
    JOIN sakila.dbo.film f 
        ON f.film_id = i.film_id
GROUP BY f.title


/*Revenue per Movie */
SELECT f.title,
     SUM(p.amount) Revenue_per_Movie
FROM sakila.dbo.rental r 
    JOIN sakila.dbo.inventory i
        ON i.inventory_id = r.inventory_id
    JOIN sakila.dbo.film f 
        ON f.film_id = i.film_id
    JOIN sakila.dbo.payment p 
        ON p.customer_id = r.customer_id
GROUP BY f.title

/* Most Spending Customer so that we can send him/her rewards or debate points*/
 
SELECT c.first_name +' '+ c.last_name name
        ,a.address
        ,SUM(p.amount) amount_spent    
FROM sakila.dbo.rental r 
    JOIN sakila.dbo.inventory i
        ON i.inventory_id = r.inventory_id
    JOIN sakila.dbo.film f 
        ON f.film_id = i.film_id
    JOIN sakila.dbo.payment p 
        ON p.customer_id = r.customer_id
    JOIN sakila.dbo.customer c 
        ON c.customer_id = p.customer_id
    JOIN sakila.dbo.address a 
        ON a.address_id = c.address_id
GROUP BY c.first_name,c.last_name,a.address
ORDER BY 3 DESC   

/* What Store has historically brought the most revenue */
SELECT s.store_id
    ,SUM(p.amount) revenue
FROM sakila.dbo.payment p 
    JOIN sakila.dbo.staff staff 
        ON staff.staff_id = p.staff_id
    JOIN sakila.dbo.store s 
        ON s.store_id = staff.store_id
GROUP BY s.store_id
ORDER BY 2 DESC

