use sakila; 

-- 1a Actors first and last names
select first_name, last_name
from actor;

-- 1b First and last names in one column 
select concat(first_name, " ", last_name) as 'Actor Name'
from actor;

-- 2a. Info search by first name
select first_name, last_name, actor_id
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select *
from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name 
-- and first name, in that order:
select *
from actor
where last_name like '%LI%'
order by last_name, first_name asc;

-- 2d. Using IN, display the country_id and country columns
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add description column to actor table
alter table actor
add description blob(500);

-- 3b. Delete the description column
alter table actor
drop description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as 'Count'
from actor
group by last_name;

-- 4b. Shared last names at least 2
select last_name, count(*) as 'Count'
from actor
group by last_name
having count(*) >1;

-- 4c. Update HARPO WILLIAMS name
update actor
set first_name = 'Harpo'
where first_name = 'Groucho' and last_name = 'Williams';

-- 4d. Change all first name Harpo to Groucho
update actor
set first_name = 'Groucho'
where first_name = 'Harpo';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
select address.address, staff.first_name, staff.last_name
from address
inner join staff on
address.address_id = staff.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff 
-- and payment.
select staff.staff_id, staff.first_name, staff.last_name, sum(payment.amount)
from staff
inner join payment on
staff.staff_id = payment.staff_id 
where month (payment.payment_date) = 8 and year (payment.payment_date) = 2005
group by staff_id, staff.first_name, staff.last_name
;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
select film.film_id, film.title, count(film_actor.actor_id) as 'Actors in film'
from film
inner join film_actor on
film.film_id = film_actor.film_id
group by film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- ANSWER: Just one
select count(title) as 'Movie Count', film.title, film_id
from film
where title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select customer.customer_id, customer.first_name, customer.last_name, sum(payment.amount) as 'Total payments'
from customer
inner join payment on
customer.customer_id = payment.customer_id
group by customer_id
order by last_name asc;

-- 7a.  Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title, language_id
from film
where title like 'K%' or 'Q%' and language_id in
(
	select language_id
	from language
	where name = 'English'
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name, ' ', last_name) as 'Actors'
from actor
where actor_id in
(
	select actor_id
    from film_actor
    where film_id in
(
		select film_id
        from film
        where title = 'Alone Trip'
)
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email 
-- addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.email, country.country
from customer
	join address
		on address.address_id = customer.address_id
	join city
		on city.city_id = address.city_id
	join country
		on country.country_id = city.country_id
where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
select title
from film
where film_id in
(
	select film_id
    from film_category
    where category_id in
(
		select category_id
        from category
        where name = 'Family'
)
);
     
-- 7e. Display the most frequently rented movies in descending order.
select film.title, count(rental.rental_id) as 'Rental count'
from film
	join inventory
		on inventory.film_id = film.film_id
	join rental
		on rental.inventory_id = inventory.inventory_id
group by film.title
order by count(rental.rental_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select sum(payment.amount) as 'Total revenue', staff.store_id
from payment
inner join staff on
payment.staff_id = staff.staff_id
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country
from store
	join address
		on store.address_id = address.address_id
	join city
		on city.city_id = address.city_id
	join country
		on country.country_id = city.country_id;
        
-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select sum(payment.amount) as 'Total revenue', category.name
from payment
	join rental on
		payment.rental_id = rental.rental_id
	join inventory on
		rental.inventory_id = inventory.inventory_id
	join film_category on
		film_category.film_id = inventory.film_id
	join category on 
		category.category_id = film_category.category_id
group by name
order by sum(payment.amount) desc;

-- 8a. Use the solution from the problem above to create a view. 
create view top_five_genres as
select sum(payment.amount) as 'Total revenue', category.name
from payment
	join rental on
		payment.rental_id = rental.rental_id
	join inventory on
		rental.inventory_id = inventory.inventory_id
	join film_category on
		film_category.film_id = inventory.film_id
	join category on 
		category.category_id = film_category.category_id
group by name
order by sum(payment.amount) desc;

-- 8b. How would you display the view that you created in 8a?
select * from top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genres;











