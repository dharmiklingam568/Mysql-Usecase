/*How many times does the average user post?*/
select avg(id) as avg_user_post from users;


/*Find the top 5 most used hashtags.*/
select t.id,t.tag_name,count(t.id) as count_of_photos_tag
from tags as t
join photo_tags as pt on t.id=pt.tag_id
join photos as p on p.id=pt.photo_id
group by t.id
order by count_of_photos_tag desc
limit 5;



/*Find users who have liked every single photo on the site.*/
select u.id,u.username,i.photo_id
from users as u 
join likes as i on u.id=i.user_id
join photos as p on i.photo_id=p.id
group by u.id,u.username,i.photo_id
order by u.id asc;



/*Retrieve a list of users along with their usernames and the rank of their account creation, ordered by the creation date in ascending order.*/
select *,
dense_rank() over(order by created_at asc)as rnk
from users;



/*List the comments made on photos with their comment texts, photo URLs, and usernames of users who posted the comments. Include the comment count for each photo*/
select u.id,p.id,u.username,c.comment_text,p.image_url,count(c.id) as comment_count
from comments as c
join photos as p on c.photo_id = p.id
join users as u on c.user_id = u.id
group by c.id,p.id;



/*For each tag, show the tag name and the number of photos associated with that tag. Rank the tags by the number of photos in descending order.*/
select t.id,t.tag_name,count(pt.tag_id) as count_of_photos,
	   dense_rank() over(order by count(pt.tag_id) desc)as rnk
from tags as t
left join photo_tags as pt on t.id=pt.tag_id
left join photos as p on pt.photo_id=p.id
group by t.id,t.tag_name;



/*List the usernames of users who have posted photos along with the count of photos they have posted. Rank them by the number of photos in descending order*/
select u.id,u.username,count(p.id) as count_of_photos,
	   dense_rank() over(order by count(p.id) desc) as rnk
from users as u
left join photos as p on u.id=p.user_id
group by u.id,u.username;



/*Display the username of each user along with the creation date of their first posted photo and the creation date of their next posted photo.*/
select u.id,u.username,p.created_at,p.image_url,
	   row_number() over(partition by u.id) as created_photo
from users as u
left join photos as p on u.id=p.user_id;


/*For each comment, show the comment text, the username of the commenter, and the comment text of the previous comment made on the same photo.*/
select p.id,u.username,c.comment_text as current_comment,
       lag(c.comment_text) over(partition by p.id )as previous_comment
from comments as c
join photos as p on c.photo_id = p.id
join users as u on c.user_id = u.id;



/* Show the username of each user along with the number of photos they have posted
   and the number of photos posted by the user before them and after them, based on the creation date*/
   
select 	u.id,u.username,p.created_at,count(p.id) as count_of_photos,
		lag(count(p.id)) over(order by p.created_at) as photo_posted_before,
		lead(count(p.id)) over(order by p.created_at) as photo_posted_after
from users as u
join photos as p on u.id=p.user_id
group by u.id,u.username,p.created_at;












