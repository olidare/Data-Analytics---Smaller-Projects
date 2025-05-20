SQL SHEET

  

###################################################################################################################################################

  # Must Know difference in SQL

###################################################################################################################################################
  


📗 RANK vs DENSE_RANK:
RANK: Provides a ranking with gaps if there are ties.
DENSE_RANK: Provides a ranking without gaps, even in the case of ties.

📗 HAVING vs WHERE Clause:
WHERE: Filters rows before grouping.
HAVING: Filters groups after the GROUP BY clause.

📗 UNION vs UNION ALL:
UNION: Removes duplicates and combines results.
UNION ALL: Combines results without removing duplicates.

📗 JOIN vs UNION:
JOIN: Combines columns from multiple tables.
UNION: Combines rows from multiple tables with similar structure.

📗 DELETE vs DROP vs TRUNCATE:
DELETE: Removes rows, with the option to filter.
DROP: Removes the entire table or database.
TRUNCATE: Deletes all rows but keeps the table structure.

📗 CTE vs TEMP TABLE:
CTE: Temporary result set used within a single query.
TEMP TABLE: Physical temporary table that persists for the session.

📗 SUBQUERIES vs CTE:
SUBQUERIES: Nested queries inside the main query.
CTE: Can be more readable and used multiple times in a query.

📗 ISNULL vs COALESCE:
ISNULL: Replaces NULL with a specified value, accepts two parameters.
COALESCE: Returns the first non-NULL value from a list of expressions, accepting multiple parameters.

📗 INTERSECT vs INNER JOIN:
INTERSECT: Returns common rows from two queries.
INNER JOIN: Combines matching rows from two tables based on a condition.


📗 CTE vs WINDOW FUNCTION:

 Use a CTE when:

* You need to build an intermediate aggregated or filtered dataset
* You have multi-step logic where step 1 feeds step 2
* You’re reusing a result across multiple queries within a bigger one
* You want to clean up deeply nested subqueries 

Use a window function when:

* You need running totals, rankings, moving averages
* You want to calculate things like row_number, rank, dense_rank, lag, lead, sum over a partition
* You need to keep all the individual rows intact while adding extra insights from other rows in their "window" (partition)

  e.g.
WITH follower_ranks AS (
  SELECT 
    creator_id,
    content_type,
    new_followers_count,
    RANK() OVER (PARTITION BY content_type ORDER BY new_followers_count DESC) AS rank_in_type
  FROM fct_creator_content
)
SELECT * FROM follower_ranks
WHERE rank_in_type = 1;

📗 WINDOW CLAUSE vs WINDOW FUNCTION:

Window Function	A special type of function that performs a calculation across a set of rows related to the current row (the “window”)	RANK() OVER (...)
Window Clause	The part inside the OVER (...) that defines how the “window” of rows is constructed 
  — i.e. how to partition (group) and order rows for the window function	OVER (PARTITION BY content_type ORDER BY new_followers_count DESC)

The window function is what you're calculating (RANK, SUM, etc).
The window clause defines how to group/order the data for the calculation.


###################################################################################################################################################

  # Useful Functions

###################################################################################################################################################

  
#### CTEs ####
Def: 
  
#### Windows Functions #####

Name of the window being referenced by the current window. The referenced window must be among the windows defined in the WINDOW clause.

The other arguments are:
* PARTITION BY that divides the query result set into partitions.
* ORDER BY that defines the logical order of the rows within each partition of the result set.
* ROWS/RANGE that limits the rows within the partition by specifying start and end points within the partition.
    
Window functions differ from regular aggregate functions as they perform operations across a set of table rows related to the current row without collapsing them into a single output row. 
The `OVER` clause is crucial here, as it specifies the window over which the function operates.

# Basic Window Function - Rank #
SELECT employee_id, salary,
  RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

The `WINDOW` clause is used in conjunction with window functions like `ROW_NUMBER()`, `RANK()`, or `SUM()` to perform calculations over a specified set of rows. 
It simplifies queries by allowing the reuse of window definitions across multiple functions.

# Sum with Windows Clause #
  
SELECT employee_id, department_id, salary,
       SUM(salary) OVER emp_window AS total_salary
FROM employees
WINDOW emp_window AS (PARTITION BY department_id ORDER BY salary);

# Running total of followers per content_type  #
  
SELECT 
  content_type,
  published_date,
  new_followers_count,
  SUM(new_followers_count) OVER (PARTITION BY content_type ORDER BY published_date) AS running_total_followers
FROM fct_creator_content;

# Lag #

# Lead #
    

#### SELF JOINS #####


#### UNION ####
  
#### PIVOT #####

The PIVOT operation is typically used when you need to convert row data into columns for better analytical insight, often employing custom SQL queries or stored procedures. 
The syntax involves using aggregate functions and CASE statements to simulate a PIVOT table.

The PIVOT clause in MySQL is not natively supported as a direct SQL command but can be simulated to transform rows into columns.
  
In Postgres (use dedicated function):
SELECT 
  UNNEST(ARRAY['likes', 'shares', 'comments']),
  UNNEST(ARRAY[100, 20, 30])

In MySQL:

#Basic Example
SELECT 
  department,
  SUM(CASE WHEN month = 'Jan' THEN sales ELSE 0 END) AS Jan_Sales,
  SUM(CASE WHEN month = 'Feb' THEN sales ELSE 0 END) AS Feb_Sales
FROM 
  sales_data
GROUP BY 
  department;

# Dynamic Example when number of Columns not known
SET @sql = NULL;
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'SUM(CASE WHEN month = ''',
      month,
      ''' THEN sales ELSE 0 END) AS ',
      CONCAT(month, '_Sales')
    )
  ) INTO @sql
FROM sales_data;

SET @sql = CONCAT('SELECT department, ', @sql, ' FROM sales_data GROUP BY department');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

#### STORED PROCEDURE // FUNCTION ####

# DEF #
A stored procedure is a saved, precompiled block of SQL code that you can call and execute whenever you need it — optionally passing in parameters.
Functions are designed to encapsulate calculations or transformations and return the result.

Functions follow the computer-science definition in that they MUST return a value and cannot alter the data they receive as parameters (the arguments). 
Functions are not allowed to change anything, must have at least one parameter, and they must return a value. 
Stored procs do not have to have a parameter, can change database objects, and do not have to return a value.
  
Stored procedures are designed for performing data manipulation and database operations, 
while functions are designed for returning a single value, often the result of a calculation or transformation

  # PROCEDURE EXAMPLE
  
  CREATE PROCEDURE SelectAllCustomers @City nvarchar(30), @PostalCode nvarchar(10)
  AS
  SELECT * FROM Customers WHERE City = @City AND PostalCode = @PostalCode
  GO;
  
  EXEC SelectAllCustomers @City = 'London', @PostalCode = 'WA1 1DP';

  
  # FUNCTION EXAMPLE  

  Let’s say you want a function that calculates an engagement score for each content item based on a weighted formula:
  engagement_score = (likes_count * 2) + (comments_count * 3) + (shares_count * 5)

  # Build Function
    DELIMITER $$
  
  CREATE FUNCTION calculate_engagement_score(
    likes INT,
    comments INT,
    shares INT
  )
  RETURNS INT
  DETERMINISTIC
  BEGIN
    DECLARE engagement_score INT;
  
    SET engagement_score = (likes * 2) + (comments * 3) + (shares * 5);
  
    RETURN engagement_score;
  END$$
  
  DELIMITER ;

  # How to Use:
    SELECT 
  content_id,
  content_type,
  likes_count,
  comments_count,
  shares_count,
  calculate_engagement_score(likes_count, comments_count, shares_count) AS engagement_score
FROM fct_creator_content;



#### DELIMETER ####

When you're writing multi-statement SQL blocks like stored procedures, functions, or triggers — you need a way to tell MySQL where the end of your entire block is.

By default, MySQL considers the semicolon ; as the end of a statement.
But inside a stored procedure or function, you're going to use a bunch of semicolons to separate individual statements.
So — you need to temporarily change the statement terminator to something else while you're defining the procedure/function

  DELIMITER $$     -- Tell MySQL: "For now, don't treat semicolons as end of statement."

CREATE FUNCTION my_function()
RETURNS INT
BEGIN
  DECLARE my_variable INT;
  SET my_variable = 10;
  RETURN my_variable;
END$$           -- Here's the actual end of the entire function definition.

DELIMITER ;     -- Put it back to normal for regular SQL statements.

  
#### INDEXING ####


  
#### ANALYZE ####

`ANALYZE TABLE` is typically used when there are significant changes in the data distribution within a table, such as after a large number of insertions, deletions, or updates.
It helps ensure that the query optimizer has the most accurate data to make informed decisions.

ANALYZE TABLE orders, customers;


#### EXPLAIN ####

The `EXPLAIN` statement in MySQL is a performance optimization tool used to provide insight into how MySQL executes a query. 
It helps developers understand the execution plan and optimize queries for better performance.

  
EXPLAIN SELECT orders.order_id, customers.customer_name
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.date > '2023-01-01';

#### EXPLAIN ANALYZE ####

The MySQL EXPLAIN ANALYZE command provides information about the query execution plan, including specifics about the optimizer's decisions, access methods, and estimated costs. 
  EXPLAIN ANALYZE is a useful tool for query performance study since it performs the query and offers runtime information, unlike EXPLAIN, which only presents the process plan without actually executing the query.
  
EXPLAIN ANALYZE SELECT * FROM table_name WHERE condition;


  
#### SQL INJECTION ####
  












  

###################################################################################################################################################

  # Example Interview Qs

###################################################################################################################################################
  
#For content published in May 2024, which creator IDs show the highest new follower growth within each content type? 
  #If a creator published multiple of the same content type, we want to look at the total new follower growth from that content type.


WITH follower_growth AS (
  SELECT 
    fcc.creator_id,
    dc.creator_name,
    fcc.content_type,
    SUM(fcc.new_followers_count) AS total_new_followers
  FROM fct_creator_content AS fcc
  INNER JOIN dim_creator AS dc 
    ON fcc.creator_id = dc.creator_id
  WHERE fcc.published_date BETWEEN '2024-05-01' AND '2024-05-31'
  GROUP BY fcc.creator_id, dc.creator_name, fcc.content_type
)

SELECT 
  creator_name,
  content_type,
  total_new_followers
FROM (
  SELECT 
    creator_name,
    content_type,
    total_new_followers,
    RANK() OVER (PARTITION BY content_type ORDER BY total_new_followers DESC) AS rn
  FROM follower_growth
) ranked
WHERE rn = 1;e

# Determine the average marketing spend per new subscriber for each country in Q1 2024 by rounding up to the nearest whole number to evaluate campaign efficiency.
SELECT dc.country_name,
  CEIL(SUM(fms.amount_spent) * 1.0 / NULLIF(SUM(fds.num_new_subscribers), 0)) AS marketing_spend_per_subscribers
   FROM fact_daily_subscriptions as fds 
   INNER JOIN dimension_country as dc ON fds.country_id = dc.country_id
   INNER JOIN fact_marketing_spend as fms ON fms.country_id = dc.country_id  
   WHERE fds.signup_date between '2024-01-01' and '2024-03-31' 
   AND fms.campaign_date between '2024-01-01' and '2024-03-31'  
   GROUP BY dc.country_name


  
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




