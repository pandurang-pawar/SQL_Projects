use ig_clone;

-- Q.1. Create an ER diagram or draw a schema for the given database.
-- PDF
-- Q.2. We want to reward the user who has been around the longest, Find the 5 oldest users.
 select username, created_at from users
 order by created_at desc limit 5;
 
 -- Q.3. To understand when to run the ad campaign, figure out the day of 
 -- the week most users register on? 
select dayname(created_at) as created_day, count(created_at) as max_registration
from users group by created_day
order by max_registration desc limit 2 ; # Thursday and Sunday has the highest registration.
-- Q. 4. To target inactive users in an email ad campaign,
-- find the users who have never posted a photo.
drop view if exists active_users;
create view active_users (user_id) as select distinct(user_id) from photos;
select u.id as Inactive_user_id from users u left join active_users au on u.id=au.user_id 
where au.user_id is null
order by Inactive_user_id asc; # 26 users never posted a photo

-- Q.5.  Suppose you are running a contest to find out who got the most 
-- likes on a photo. Find out who won?

select user_id, photo_id, count(photo_id) as most_likes from likes 
group by photo_id
order by most_likes desc limit 1; # user_id 3 won the contest.

-- Q.6. The investors want to know how many times does the average user post.

drop view if exists per_user_posts;
create view per_user_posts (user_id,posts_per_user) as
select user_id, count(user_id) as posts_per_user from photos
group by user_id;
select sum(posts_per_user)/count(distinct(user_id)) as average_user_posts  from per_user_posts;
# The average user posts 3.47 times if we count active users only. 
							# Or#
select sum(posts_per_user)/100 as average_user_posts  from per_user_posts;
# If we take note aff all users, the average user posts 2.57 times and this is more correct.

-- Q.7. A brand wants to know which hashtag to use on a post, 
-- and find the top 5 most used hashtags

select t.tag_name as top_5_most_used_hashtags, pt.tag_id as max_total 
from photo_tags pt inner join tags t on pt.tag_id=t.id
group by pt.tag_id
order by pt.tag_id desc limit 5;

-- Q.8. To find out if there are bots, find users who have liked every single photo on the site.
select * from likes;
select * from photos;
select distinct photo_id from likes;
select user_id, count(photo_id) as total_likes from likes group by user_id
order by total_likes desc limit 13;
drop view if exists distinct_photos;
create view distinct_photos (user_id, likes) as
select user_id, count(photo_id) as total_likes from likes group by user_id;
select * from distinct_photos;
select user_id, likes from distinct_photos where likes=(select max(distinct photo_id) from likes);



 -- Q.9. To know who the celebrities are, find users who have never commented on a photo.
select distinct(user_id) from comments;
drop view if exists no_comment;
create view no_comment (user_id) as select distinct(user_id) from comments;

drop view if exists never_commented;
create view never_commented (never_commented_user_id) as
select u.id as User_id_never_commented 
from users u left join no_comment nc on u.id=nc.user_id
where nc.user_id is null; # 23 users never commented 
select * from never_commented;

-- Q. 10. Now it's time to find both of them together, find the 
-- users who have never commented on any photo or have commented on every photo.
select * from comments;
select * from users;
select distinct photo_id from comments;

drop view if exists comment_all;
create view comment_all (user_id, commented_on_every_photo) as
select user_id, count(photo_id) as user_id_commented_all from comments 
group by user_id;

select user_id, commented_on_every_photo from comment_all 
where commented_on_every_photo=(select max(distinct photo_id) from comments);


/* select * from comment_all; 
drop view if exists comment_all;
create view comment_all (user_id, user_id_commented_all) as
select user_id, count(photo_id) as commented_on_every_photo from 
comments group by user_id order by commented_on_every_photo ;*/ 

-- results:
select * from never_commented;
select * from comment_all;

select user_id from comment_all 
where commented_on_every_photo=(select max(distinct photo_id) from comments)
union all select never_commented_user_id from never_commented;



-- ----------------------------------------------------------------------------------

