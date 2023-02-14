use sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
select count(film_id) as CNT from inventory 
where film_id in (
	select film_id
    from film
    where title = "Hunchback Impossible"
);


--  List all films whose length is longer than the average of all the films.
select film_id, title from film
where length > (
	select avg(length) as avg
    from film
);


-- Use subqueries to display all actors who appear in the film Alone Trip.
select actor_id, first_name, last_name from actor 
where actor_id in (
	select actor_id
    from film_actor
    where film_id in (
		select film_id
        from film
        where title = "Alone Trip"
	)
);


-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.film_id, f.title from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
where c.name = "family";



-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select cu.customer_id, cu.first_name, cu.last_name, cu.email from country co
join city c on co.country_id = c.country_id
join address a on c.city_id = a.city_id
join customer cu on a.address_id = cu.address_id
where co.country = "Canada";



-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select film_id, title from film
where film_id in (
	select film_id
	from film_actor
	where actor_id in (
		select actor_id from (
			select actor_id, count(film_id) n_film
			from film_actor
			group by actor_id
			order by n_film desc
			limit 1
		) sub1
	)
);


-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select film_id, title from film
where film_id in (
	select film_id
    from inventory
    where inventory_id in (
		select inventory_id
        from rental
        where customer_id in (
			select customer_id from (
				select customer_id, sum(amount) as sum1
				from payment
				group by customer_id
				order by sum1 desc
				limit 1
			) sub1
		)
	)
);


-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select customer_id, sum(amount) as total_amount_spent from payment
group by customer_id
having total_amount_spent > (
	select sum(amount)/count(distinct(customer_id))
    from payment
);