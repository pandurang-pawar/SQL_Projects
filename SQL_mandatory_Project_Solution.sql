-- Mavenmovies Database: The aim was to fetch the information from mavenmovies database using SQL queries. The various insights like particular movies actor, director, 
number of movies they worked in, not acted in any movie, group by actor or director or movie, genre, year ect. 

-- Q.1.  Write a SQL query to find the actors who were cast in the movie 'Annie Hall'. 
-- Return actor first name, last name and role.
use moviedb;

select * from actors;
select * from movie;
select * from movie_cast;

select act_fname, act_lname, role from 
actors a join movie_cast mc on a.act_id=mc.act_id 
join movie m on m.mov_id=mc.mov_id where mov_title='Annie Hall';

-- Q.2.From the following tables, write a SQL query 
-- to find the director who directed a movie that casted a role for 'Eyes Wide Shut'. 
-- Return director first name, last name and movie title. 

select * from director;
select * from movie;
select * from movie_direction;

select dir_fname, dir_lname, mov_title from director d join
movie_direction md on d.dir_id=md.dir_id
join movie m on md.mov_id=m.mov_id where m.mov_title='Eyes Wide Shut';

--  Q.3. Write a SQL query to find who directed a movie that casted a 
-- role as ‘Sean Maguire’. Return director first name, last name and movie title.

select * from movie_cast;
select * from movie_direction;
select * from movie;

select dir_fname,dir_lname, mov_title from 
director d join movie_direction md on d.dir_id=md.dir_id
join movie_cast mc on md.mov_id=mc.mov_id
join movie m on m.mov_id=mc.mov_id where mc.role='Sean Maguire';

-- Q.4. Write a SQL query to find the actors who have not acted in any movie 
-- between 1990 and 2000 (Begin and end values are included.). 
-- Return actor first name, last name, movie title and release year. 

select * from actors;
select * from movie;
select * from movie_cast;

select act_fname, act_lname, mov_title, mov_year from 
actors a join movie_cast mc on a.act_id=mc.act_id
join movie m on m.mov_id=mc.mov_id where mov_year not between 1990 and 2000;

-- Q.5. Write a SQL query to find the directors with the number of genres of movies. 
-- Group the result set on director first name, last name and
-- generic title. Sort the result-set in ascending order by director 
-- first name and last name. Return director first name, last name and number
-- of genres of movies.

select * from movie_genres;
select * from movie_direction;
select * from genres;

select dir_fname,dir_lname, count(mg.gen_id) 
as number_of_genres_of_movies from 
director d join movie_direction md on d.dir_id=md.dir_id
join movie_genres mg on mg.mov_id=md.mov_id
join genres g on g.gen_id=mg.gen_id group by d.dir_fname, d.dir_lname 
order by d.dir_fname, d.dir_lname asc; 
