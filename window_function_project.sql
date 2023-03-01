-- Advance SQL non mandatory Assignment--alter1. 

-- Q.1. Write a SQL query to find the actors who played a role in the movie 'Annie IDENTITY’. 
-- Return all the fields of the actor table 
use mavenmovies;
select * from actor;
select * from film;
select * from film_actor;

select a.actor_id, a.first_name, a.last_name, a.last_update from actor a 
inner join film_actor fa on a.actor_id=fa.actor_id 
inner join film f on f.film_id=fa.film_id where f.title= 'Annie IDENTITY';

-- Q.2. Which customer has the highest 
-- customer ID number, whose first name starts with an 'E' and has an address ID lower than 500?
select * from customer;
select concat(first_name,' ', last_name) as Customer from customer c where c.first_name in
(select first_name from customer where first_name regexp '^E') and c.address_id in
(select address_id from customer where address_id<500) order by customer_id desc limit 1;

select first_name, last_name from customer
where address_id < 500 and first_name like 'e%'
order by customer_id desc
limit 1;

-- Q.3. Find the films which are rented by both Indian and Pakistani customers. 
-- (Hint: You can use CTE’s)
-- steps:
-- 1. pull the indian customers 
-- 2. films rented by Indian customers
-- 3. pull pakistani customer
-- 4. films rented by pakistani customers 
-- 5. join 
select ind_films as common_films from
(with indian_cust as 
				(select cs.customer_id, cn.country, cs.first_name, cs.last_name 
                from customer cs
                inner join address a on a.address_id=cs.address_id
                inner join city c on c.city_id=a.city_id
                inner join country cn on c.country_id=cn.country_id
                inner join film f on customer_id
                group by cs.customer_id
                having cn.country= 'India'),
                
	ind_films_rented as (select f.title ind_films, ic.first_name, ic.last_name, ic.country
    from indian_cust ic 
    inner join rental r on r.customer_id=ic.customer_id
    inner join inventory i on i.inventory_id=r.inventory_id
    inner join film f on f.film_id=i.film_id),

pak_cust as     (select cs.customer_id, cn.country, cs.first_name,cs.last_name 
                from customer cs
                inner join address a on a.address_id=cs.address_id
                inner join city c on c.city_id=a.city_id
                inner join country cn on c.country_id=cn.country_id
                inner join film f on customer_id
                group by cs.customer_id
                having cn.country= 'Pakistan'), 
pak_cust_rented as (select f.title pak_films
    from pak_cust ic 
    inner join rental r on r.customer_id=ic.customer_id
    inner join inventory i on i.inventory_id=r.inventory_id
    inner join film f on f.film_id=i.film_id)
    
select * from pak_cust_rented pcr inner join ind_films_rented pfr on pfr.ind_films=pcr.pak_films
group by pfr.ind_films) result;

-- Q.4. Find the films (if any) which are rented by Indian 
-- customers and not rented by Pakistani customers.
-- steps: 
-- 1. find indian customers
-- 2. find films rented by Indian customers
-- 3. find pakistani customers
-- 4. find films rented by pakistani customers

select film_rent_ind as only_rent_ind_cust from
(with ind_cust as (select cs.customer_id, cn.country, cs.first_name, cs.last_name 
from customer cs 
inner join address a on a.address_id=cs.address_id
inner join city c on c.city_id=a.city_id
inner join country cn on cn.country_id=c.country_id
inner join film f on cs.customer_id
group by cs.customer_id
having cn.country= 'India'),
ind_film_rented as (select f.title film_rent_ind, ic.first_name, ic.last_name
from ind_cust ic
inner join rental r on r.customer_id=ic.customer_id
inner join inventory i on i.inventory_id=r.inventory_id
inner join film f on f.film_id=i.film_id),
pak_cust as (select cs.customer_id, cn.country, cs.first_name, cs.last_name 
from customer cs 
inner join address a on a.address_id=cs.address_id
inner join city c on c.city_id=a.city_id
inner join country cn on cn.country_id=c.country_id
inner join film f on cs.customer_id
group by cs.customer_id
having cn.country= 'Pakistan'),
pak_film_rented as (select f.title film_rent_pak
from pak_cust pc
inner join rental r on r.customer_id=pc.customer_id
inner join inventory i on i.inventory_id=r.inventory_id
inner join film f on f.film_id=i.film_id)

select * from pak_film_rented pfr 
right join ind_film_rented ifr on ifr.film_rent_ind=pfr.film_rent_pak
group by ifr.film_rent_ind 
having pfr.film_rent_pak is null) only_ind;





-- Q.5. Find the customers who paid a sum of 100 dollars or more, for 
-- all the rentals taken by them.

select * from customer;
select * from payment;
select first_name, last_name, sum(amount) from customer c join payment p 
on c.customer_id=p.customer_id group by p.customer_id having sum(amount)>100 order by sum(amount) desc

select c.first_name, c.last_name, sum(amount) from payment p
inner join customer c on c.customer_id = p.customer_id
group by c.customer_id
having sum(amount) > 100
order by sum(amount) desc;

/* -- Q.3. solution by Odin---
use mavenmovies;
--India and Pak---
select ind_films as common_films from
(with cust_india as (select c.customer_id, c.first_name, c.last_name, ct.city, cn.country 
from customer c 
inner join address a on c.address_id = a.address_id 
inner join city ct on ct.city_id = a.city_id
inner  join country cn on cn.country_id = ct.country_id
inner join film f on c.customer_id
group by c.customer_id
having cn.country = 'india'), # Pulls the indian customers

cust_india_films as (select f.title ind_films, ci.first_name, ci.last_name, ci.country 
from 
cust_india ci inner join rental r on ci.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id), # Pull the films rented by Indian customers

cust_pakistan as (select c.customer_id, c.first_name, c.last_name, ct.city, cn.country 
from customer c 
inner join address a on c.address_id = a.address_id 
inner join city ct on ct.city_id = a.city_id
inner  join country cn on cn.country_id = ct.country_id
inner join film f on c.customer_id
group by c.customer_id
having cn.country = 'pakistan'), # Pull the pakistan customers

cust_pakistan_films as (select f.title pak_films from 
cust_pakistan cp 
inner join rental r on cp.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id) # Pull the films rented by pakistan customers

select * from cust_pakistan_films cpf 
inner join cust_india_films cif on cpf.pak_films = cif.ind_films
group by cif.ind_films) dummy; # Get the common films.*/