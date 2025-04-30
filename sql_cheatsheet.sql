SQL SHEET

SELECT * FROM customers
WHERE (age BETWEEN 18 AND 22) AND 
(state IN ('Tasmania', 'Victoria', 'Queensland')) AND
(gender IS NOT NULL) AND
(customer_name ~ '^[AB]');

SELECT  DISTINCT  u.city , 
COUNT(u.city) as total_orders
FROM trades as t
LEFT JOIN users as u
  ON t.user_id = u.user_id
WHERE t.status = 'Completed'
GROUP BY u.city, t.status
ORDER BY total_orders DESC LIMIT 3
;


SELECT
    user_id,
    (EXTRACT(DOY FROM MAX(post_date)::DATE)  - 
    EXTRACT(DOY FROM MIN(post_date)::DATE) ) as days_between
FROM posts
WHERE DATE_PART('year', post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_date) > 1;


QUESTION:
who has purchased at least one product from every product category listed in the products table.

WITH products_purchased AS (
SELECT DISTINCT customer_id, product_category 
 FROM customer_contracts as c
LEFT JOIN products as p 
  ON c.product_id = p.product_id
  GROUP BY customer_id, product_category
ORDER BY customer_id
)
SELECT customer_id FROM products_purchased
  GROUP BY  customer_id
  HAVING COUNT(product_category) > 2
;

OR 

WITH supercloud_cust AS (
  SELECT 
    customers.customer_id, 
    COUNT(DISTINCT products.product_category) AS product_count
  FROM customer_contracts AS customers
  INNER JOIN products 
    ON customers.product_id = products.product_id
  GROUP BY customers.customer_id
)

SELECT customer_id
FROM supercloud_cust
WHERE product_count = (
  SELECT COUNT(DISTINCT product_category) FROM products
);


SELECT order_id, item, max(order_id) as highest_order,
CASE 
    WHEN (order_id % 2 = 1) THEN 'Odd'
    WHEN (order_id % 2 = 0) THEN 'Even'
    ELSE NULL
END AS odd_even
FROM orders
GROUP BY order_id, item
;



QYUESTION TOP 5 ARTISTS:

Assume there are three Spotify tables: artists, songs, and global_song_rank, which contain information about the artists, songs, and music charts, respectively.

Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. Display the top 5 artist names in ascending order, along with their song appearance ranking.

WITH top_10_cte AS (
  SELECT 
    artists.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  INNER JOIN songs
    ON artists.artist_id = songs.artist_id
  INNER JOIN global_song_rank AS ranking
    ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY artists.artist_name
)

SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5; 


------- 

SELECT 
  EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);

-------


# to view the data and duplicates

SELECT company_id, title, description as duplicate_companies
FROM job_listings
ORDER BY title DESC  ;
 
WITH linkedin_cte AS (

SELECT company_id, title, description, COUNT(company_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(company_id) > 1
ORDER BY job_count DESC

)

SELECT COUNT(company_id) as duplicate_companies
FROM linkedin_cte
;


