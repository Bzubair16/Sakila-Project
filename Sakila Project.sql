-- first, last name and email address of customers from store 2
select first_name , last_name, email
from customer
where store_id = 2;

-- movie with rental rate of 0.99$
select title
from film 
where rental_rate = 0.99;

-- we want to see rental rate and how many movies are in each rental rate categories
select rental_rate, count(title) no_of_movies
from film
group by rental_rate;

-- which rating is most prevalant to each store
select store_id, count(rating) no_of_rating, rating
from film f
join inventory i
using (film_id)
join store s
using (store_id)
group by rating, store_id
order by no_of_rating desc
limit 2;

-- which rating do we have the most film in
select rating, count(title) no_of_movies
from film
group by rating
order by no_of_movies desc
limit 1;

-- list of films by full name, category, language
select title as movie_title, c.name as category , l.name as language
from film f
join language l
using (language_id) 
join film_category fc
using (film_id)
join category c
using (category_id);

-- how many times each movie has been rented out
select count(rental_id) as no_of_time_rented,  title
from rental r
join inventory i
using (inventory_id)
join film f
using (film_id)
group by title;

-- revenue per movie
select sum(amount) as revenue, title
from payment p
join rental r
using (rental_id)
join inventory i
using (inventory_id)
join film
using (film_id)
group by title;

-- most spending customer 
select concat(first_name," " , last_name) as full_name, sum(amount) total_amount_spent
from customer c
join payment p
using (customer_id)
group by full_name
order by total_amount_spent desc
limit 1;

-- what store has historically brought the most revenue
select sum(amount) as total_revenue , store_id, a.address
from payment p
join customer c
using (customer_id)
join store s 
using (store_id)
join address a
on a.address_id = s.address_id
group by store_id
order by total_revenue desc
limit 1;

-- how many rentals do we have by each month  
select monthname(rental_date) as month, count(rental_id) as no_of_rentals
from rental right
join payment
using (rental_id)
group by month;

-- which date first movie was rented out
select min(rental_date) as date
from rental;

-- which date last movie rented out
select max(rental_date) as date
from rental;

-- for each movie, when was the first and last time it was rented out
select title ,min(rental_date) first_date_rented_out, max(rental_date) as last_date_rented_out
from rental r
join inventory i
using (inventory_id)
join film f
using (film_id)
group by title;

-- last rental date of each customers
select max(rental_date) as last_rent_date, concat(first_name, " ", last_name) as full_name
from rental r
join customer c
using (customer_id)
group by full_name;

-- revenue per month
select monthname(rental_date) as month, sum(amount) as revenue
from rental right
join payment
using (rental_id)
group by month;

-- how many distinct renters per month
select count(rental_id) as no_of_rentage, monthname(rental_date) as month
from rental
group by month;

-- number of distinct film rented each month
select distinct title,count(rental_id) ,  monthname(rental_date) as month
from rental r
join inventory i
using (inventory_id)
join film
using (film_id)
group by month, title;

-- number of rentals in comedy, sport and family
select name, count(rental_id) as no_of_rentage 
from rental r
join inventory i
using (inventory_id)
join film_category fc
using (film_id)
join category c
using (category_id)
where name in ( "sports", "family", "comedy")
group by name;

-- users who have rented at least 3 times
select count(rental_id) as no_of_rentage ,concat(first_name, " ", last_name) as full_name
from customer c
join rental r
using (customer_id)
where active = 1  
group by first_name ;

-- how much revenue has one single store made over pg13 and r rated films
select s.store_id, sum(amount) , rating
from payment p
join customer c
using (customer_id)
join store s
using (store_id)
where rating in (select rating from film where film = "pg");



-- active users where active = 1
select concat(first_name, " ", last_name) as full_name
from customer c
join rental r
using (customer_id)
where active = 1  
group by first_name ;

-- users who has rented at least 30 times
select concat(first_name, " ", last_name) as reward_users, count(rental_id) as no_of_rentage
from rental r
join customer c
using (customer_id)
group by first_name
having no_of_rentage >=30;

-- users who has rented at least 30 times and also active
select concat(first_name, " ", last_name) as reward_users, count(rental_id) as no_of_rentage
from rental r
join customer c
using (customer_id)
where active =1
group by first_name
having no_of_rentage >=30;

-- all reward users with phone
select concat(first_name, " ", last_name) as reward_users, count(rental_id) as no_of_rentage
from rental r
join customer c
using (customer_id)
join address 
using (address_id)
where active =1 and phone is not null
group by first_name
having no_of_rentage >=30;


