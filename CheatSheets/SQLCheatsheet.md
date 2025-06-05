
# SQL Cheat Sheet & Interview Prep

This document consolidates key SQL concepts, common interview questions, and useful functions, structured for easy reference and learning.

## Table of Contents
1. [Useful Resources](#useful-resources)
2. [Must Know Differences in SQL](#must-know-differences-in-sql)

3.  [Useful Functions & Concepts](#useful-functions)
    * [CTEs](#ctes)
    * [Window Functions](#window-functions)
        * [Basic Window Function - Rank](#basic-window-function---rank)
        * [Sum with Windows Clause](#sum-with-windows-clause)
        * [Running total of followers per content_type](#running-total-of-followers-per-content_type)
        * [Lag & Lead](#lag--lead)
        * [RANK](#rank)
        * [ROWS BETWEEN lower_bound AND upper_bound](#rows-between-lower_bound-and-upper_bound)
    * [SELF JOINS](#self-joins)
    * [UNION](#union)
    * [RECURSIVE CTE](#recursive-cte)
        * [SIMPLE EXAMPLE - Months of the Year](#simple-example---months-of-the-year)
        * [HARDER EXAMPLE Order a Company by hierarchy - Director at the Top](#harder-example-order-a-company-by-hierarchy---director-at-the-top)
    * [PIVOT](#pivot)
        * [Basic Example](#basic-example)
        * [Dynamic Example when number of Columns not known](#dynamic-example-when-number-of-columns-not-known)
    * [STORED PROCEDURE // FUNCTION](#stored-procedure--function)
        * [PROCEDURE EXAMPLE](#procedure-example)
        * [FUNCTION EXAMPLE](#function-example)
    * [DELIMITER](#delimiter)
    * [INDEXING](#indexing)
    * [ANALYZE](#analyze)
    * [EXPLAIN](#explain)
    * [EXPLAIN ANALYZE](#explain-analyze)
    * [SQL INJECTION](#sql-injection)
4.  [Example Interview Questions](#example-interview-questions)
    * [Highest New Follower Growth per Content Type (May 2024)](#highest-new-follower-growth-per-content-type-may-2024)
    * [Average Marketing Spend per New Subscriber (Q1 2024)](#average-marketing-spend-per-new-subscriber-q1-2024)
    * [Customer Filtering Example](#customer-filtering-example)
    * [Total Orders by City](#total-orders-by-city)
    * [Days Between First and Last Post](#days-between-first-and-last-post)
    * [Customers Purchasing from Every Product Category](#customers-purchasing-from-every-product-category)
    * [Odd/Even Order ID](#oddeven-order-id)
    * [TOP 5 ARTISTS by Song Appearance in Top 10](#top-5-artists-by-song-appearance-in-top-10)
    * [Monthly Active Users (Consecutive Month Activity)](#monthly-active-users-consecutive-month-activity)
    * [Detecting Duplicate Job Listings](#detecting-duplicate-job-listings)
    * [Calculating Percentages within a Window Function](#calculating-percentages-within-a-window-function)
    * [Y-on-Y Growth Rate](#y-on-y-growth-rate)


---

## Useful Resources
* [TestGorilla SQL Basic Interview Questions](https://www.testgorilla.com/blog/sql-basic-interview-questions/)
* [Linkedin FAANG SQL Topics](https://www.linkedin.com/posts/nidhisingh-dataanalyst_sql-activity-7333507346939170818-rWGq?utm_source=share&utm_medium=member_desktop&rcm=ACoAADK-O8gBFz5f8pbKwYgxlrOM_c8j4btoM28)
* [Linkedin 𝟭𝟬𝟬 𝗔𝗱𝘃𝗮𝗻𝗰𝗲𝗱 𝗦𝗤𝗟 𝗖𝗵𝗮𝗹𝗹𝗲𝗻𝗴𝗲𝘀](https://www.linkedin.com/posts/aishwarya-pani-63a476167_top-100-advanced-sql-q-a-activity-7332593835350380544-fql0?utm_source=share&utm_medium=member_desktop&rcm=ACoAADK-O8gBFz5f8pbKwYgxlrOM_c8j4btoM28)
* [ Master SQL from Beginner to Advanced — All in One PDF!](https://www.linkedin.com/posts/parag-sharma-b2377a258_sql-activity-7334434754580099072-vCY6?utm_source=share&utm_medium=member_desktop&rcm=ACoAADK-O8gBFz5f8pbKwYgxlrOM_c8j4btoM28)


---

## Must Know Differences in SQL

### 📗 RANK vs DENSE_RANK:
* **RANK**: Provides a ranking with gaps if there are ties.
* **DENSE_RANK**: Provides a ranking without gaps, even in the case of ties.

### 📗 HAVING vs WHERE Clause:
* **WHERE**: Filters rows before grouping.
* **HAVING**: Filters groups after the `GROUP BY` clause.

### 📗 UNION vs UNION ALL:
* **UNION**: Removes duplicates and combines results.
* **UNION ALL**: Combines results without removing duplicates.

### 📗 JOIN vs UNION:
* **JOIN**: Combines columns from multiple tables.
* **UNION**: Combines rows from multiple tables with similar structure.

### 📗 DELETE vs DROP vs TRUNCATE: 📝
* **DELETE**: Removes rows, with the option to filter.
* **DROP**: Removes the entire table or database.
* **TRUNCATE**: Deletes all rows but keeps the table structure.

### 📗 COUNT() vs COUNT(*)
* **COUNT(salary)**: Counts only rows where `salary` is not `NULL`.
* **COUNT(*)**: Counts total number of rows in the result set.

### 📗 CTE vs TEMP TABLE: 📝
* **CTE**: Temporary result set used within a single query.
* **TEMP TABLE**: Physical temporary table that persists for the session.

### 📗 SUBQUERIES vs CTE:
* **SUBQUERIES**: Nested queries inside the main query.
* **CTE**: Can be more readable and used multiple times in a query.

### 📗 HANDLE NULLS: 📝
* **ISNULL**: Used in the WHERE clause to test for NULL values. It returns TRUE if the value is NULL, and FALSE otherwise.
   * SELECT column_name FROM table_name WHERE column_name IS NULL;
* **ISNOTNULL**: Used in the WHERE clause to test for non-NULL values. It returns TRUE if the value is not NULL, and FALSE otherwise.
   * SELECT column_name FROM table_name WHERE column_name IS NOT NULL;
* **COALESCE**: Returns the first non-NULL expression among its arguments. It can accept multiple parameters (expressions), making it more flexible than ISNULL.
   * SELECT COALESCE(column1, column2, 'DefaultValue') FROM table_name;
   * (If column1 is NULL, it tries column2; if both are NULL, it uses 'DefaultValue').

### 📗 INTERSECT vs INNER JOIN: 📝
* **INTERSECT**: Returns common rows from two queries.
* **INNER JOIN**: Combines matching rows from two tables based on a condition.

### 📗 LAG/LEAD vs BETWEEN WINDOW FRAME:
* **LAG/LEAD**
    * Accesses a specific row at a fixed offset from the current row.
    * Typically used to compare current vs previous/next value.
    * Works like: "give me the value 1 row back (or ahead)".

* **ROWS BETWEEN ...**
    * Defines a frame (range of rows) to perform an aggregation over, relative to the current row.
    * Typically used for running totals, moving averages, cumulative metrics.
    * Works like: "calculate over a range of rows around me".

**Example:**
```sql
SELECT
  date,
  close,
    LAG(close) OVER (ORDER BY date) AS previous_close,
    LAG(close, 3) OVER (ORDER BY date) AS three_months_ago_close,
  close - LAG(close, 3) OVER (ORDER BY date) AS three_month_diff,
  close - LAG(close) OVER (ORDER BY date) AS one_month_diff
FROM stock_prices;

SELECT
  date,
  close,
  FIRST_VALUE(close) OVER (
    ORDER BY date
    ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
  ) AS previous_close,
  FIRST_VALUE(close) OVER (
    ORDER BY date
    ROWS BETWEEN 3 PRECEDING AND 3 PRECEDING
  ) AS three_months_ago_close,
  close - FIRST_VALUE(close) OVER (
    ORDER BY date
    ROWS BETWEEN 3 PRECEDING AND 3 PRECEDING
  ) AS three_month_diff,
  close - FIRST_VALUE(close) OVER (
    ORDER BY date
    ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
  ) AS one_month_diff
FROM stock_prices; 
```

### 📗 CTE vs WINDOW FUNCTION:

 Use a CTE when:

* You need to build an intermediate aggregated or filtered dataset
* You have multi-step logic where step 1 feeds step 2
* You’re reusing a result across multiple queries within a bigger one
* You want to clean up deeply nested subqueries 

Use a window function when:

* You need running totals, rankings, moving averages
* You want to calculate things like row_number, rank, dense_rank, lag, lead, sum over a partition
* You need to keep all the individual rows intact while adding extra insights from other rows in their "window" (partition)

``` sql
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
```

### 📗 WINDOW CLAUSE vs WINDOW FUNCTION:

Window Function	A special type of function that performs a calculation across a set of rows related to the current row (the “window”)	RANK() OVER (...)
Window Clause	The part inside the OVER (...) that defines how the “window” of rows is constructed 
  — i.e. how to partition (group) and order rows for the window function	OVER (PARTITION BY content_type ORDER BY new_followers_count DESC)

The window function is when you want to calculate: RANK, SUM, etc
The window clause defines how to group/order the data for the calculation.

---

# Useful Functions

## CTEs 
**Definition:** Common Table Expressions (CTEs) are temporary result sets that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement.

## Recursive CTEs

A recursive CTE references itself. It returns the result subset, then it repeatedly (recursively) references itself, and stops when it returns all the results.

##### SIMPLE EXAMPLE - Months of the Year:
``` sql
WITH RecursiveMonths AS (
    SELECT
        1 AS MonthNumber,
        DATENAME(MONTH, CAST('2024-01-01' AS DATE)) AS MonthName   -- This is the first iteration (anchor member)

    UNION ALL -- Then union all the rest of results

    SELECT
        MonthNumber + 1,
        DATENAME(MONTH, DATEADD(MONTH, MonthNumber, '2024-01-01'))
    FROM RecursiveMonths
    WHERE MonthNumber < 12  -- Termination COndition
)
SELECT * FROM RecursiveMonths;
```

##### HARDER EXAMPLE Order a Company by hierarchy - Director at the Top:
``` sql
  WITH RECURSIVE company_hierarchy AS (
  SELECT    id,
            first_name,
            last_name,
            boss_id,
        0 AS hierarchy_level
  FROM employees
  WHERE boss_id IS NULL
  
  UNION ALL
  
    SELECT  
    		e.id,
            e.first_name,
            e.last_name,
            e.boss_id,
            hierarchy_level+1
  FROM employees e, company_hierarchy ch
  WHERE e.boss_id = ch.id
 )
 
SELECT ch.first_name AS employee_first_name,
       ch.last_name AS employee_last_name,
       CONCAT(e.first_name, " ", e.last_name)  AS boss_name,
       hierarchy_level
FROM company_hierarchy ch
LEFT JOIN employees e
ON ch.boss_id = e.id
ORDER BY ch.hierarchy_level, ch.boss_id;
``` 

##### In 3rd example, I’ll be using the table cities_route, which contains data about Dutch cities:

| city_from    | city_to       | distance |
|--------------|---------------|----------|
| Groningen    | Heerenveen    | 61.4     |
| Groningen    | Harlingen     | 91.6     |
| Harlingen    | Wieringerwerf | 52.3     |
| Wieringerwerf| Hoorn         | 26.5     |
| Hoorn        | Amsterdam     | 46.1     |
| Amsterdam    | Haarlem       | 30.0     |
| Heerenveen   | Lelystad      | 74.0     |
| Lelystad     | Amsterdam     | 57.2     |

Use this table to find all the possible routes from Groningen to Haarlem, showing the cities on the route and the total distance.

Here’s the query to solve this problem:

``` sql
WITH RECURSIVE possible_route AS (

  -- Anchor member
  SELECT 
    cd.city_to,
    CONCAT(cd.city_from, '->', cd.city_to) AS route,
    cd.distance
  FROM city_distances cd
  WHERE cd.city_from = 'Groningen'

  UNION ALL

  -- Recursive member
  SELECT 
    cd.city_to,   -- where you are now
    CAST(CONCAT(pr.route, '->', cd.city_to) AS CHAR(1000)) AS route,  -- build the route
    CAST((pr.distance + cd.distance) AS DECIMAL(10, 2)) -- sum the distance
  FROM possible_route pr.  -- previous recursion result
  INNER JOIN city_distances cd
    ON cd.city_from = pr.city_to
  WHERE pr.route NOT LIKE CONCAT('%', cd.city_to, '%') -- to avoid loops, you can track visited cities 

)

SELECT pr.route, pr.distance
FROM possible_route pr
WHERE pr.city_to = 'Haarlem'
ORDER BY pr.distance;

```



-----

## Windows Functions 

Name of the window being referenced by the current window. The referenced window must be among the windows defined in the WINDOW clause.

The other arguments are:
* PARTITION BY that divides the query result set into partitions.
* ORDER BY that defines the logical order of the rows within each partition of the result set.
* ROWS/RANGE that limits the rows within the partition by specifying start and end points within the partition.
    
Window functions differ from regular aggregate functions as they perform operations across a set of table rows related to the current row without collapsing them into a single output row. 
The `OVER` clause is crucial here, as it specifies the window over which the function operates.

### Basic Window Function - Rank 

``` sql
SELECT employee_id, salary,
  RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
```

### WINDOW Clause

The `WINDOW` clause is used in conjunction with window functions like `ROW_NUMBER()`, `RANK()`, or `SUM()` to perform calculations over a specified set of rows. 
It simplifies queries by allowing the reuse of window definitions across multiple functions.

## Window Functions
Window functions differ from regular aggregate functions as they perform operations across a set of table rows related to the current row without collapsing them into a single output row. The `OVER` clause is crucial here, as it specifies the window over which the function operates.

### Basic Window Function - Rank
```sql
SELECT employee_id, salary,
  RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
```

### Sum with Windows Clause
```sql
SELECT employee_id, department_id, salary,
       SUM(salary) OVER emp_window AS total_salary
FROM employees
WINDOW emp_window AS (PARTITION BY department_id ORDER BY salary);
```

### Running total of followers per content_type
```sql
SELECT 
  content_type,
  published_date,
  new_followers_count,
  SUM(new_followers_count) OVER (PARTITION BY content_type ORDER BY published_date) AS running_total_followers
FROM fct_creator_content;
```

### Lag & Lead
LEAD() and LAG() are time-series window functions used to access data from rows that come after, or before the current row within a result set based on a specific column order.

### RANK
```sql
SELECT 
 artist_name, 
 concert_revenue, 
 ROW_NUMBER() OVER (ORDER BY concert_revenue) AS row_num,
 RANK() OVER (ORDER BY concert_revenue) AS rank_num,
 DENSE_RANK() OVER (ORDER BY concert_revenue) AS dense_rank_num
FROM concerts;
```

### ROWS BETWEEN lower_bound AND upper_bound
The bounds can be any of these five options:
* UNBOUNDED PRECEDING - All rows before the current row.
* n PRECEDING - n rows before the current row.
* CURRENT ROW - Just the current row.
* n FOLLOWING - n rows after the current row.
* UNBOUNDED FOLLOWING - All rows after the current row.

**Example 1:** Running total
```sql
SELECT date, revenue,
    SUM(revenue) OVER (
      ORDER BY date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total
FROM sales
ORDER BY date;
```

**Example 2:** Three-days moving average temperature
```sql
SELECT city, date, temperature,
      ROUND(AVG(temperature) OVER (
        PARTITION BY city
        ORDER BY date DESC
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING), 1) mov_avg_3d_city
FROM weather
ORDER BY city, date;
```

**Example 3:** Three-day running total precipitation
```sql
SELECT city, date, precipitation,
  SUM(precipitation) OVER (
    PARTITION BY city
    ORDER BY date
    ROWS 2 PRECEDING) running_total_3d_city
FROM weather
ORDER BY city, date;
```

**Example 4:** UNBOUNDED PRECEDING
```sql
SELECT social_network, date, new_subscribers,
  SUM(new_subscribers) OVER (
    PARTITION BY social_network
    ORDER BY date
    ROWS UNBOUNDED PRECEDING) running_total_network
FROM subscribers
ORDER BY social_network, date;
```

**Example 5:** FIRST_VALUE and LAST_VALUE
```sql
SELECT social_network, date, new_subscribers,
  FIRST_VALUE(new_subscribers) OVER(
    PARTITION BY social_network
    ORDER BY date) AS first_day,
  LAST_VALUE(new_subscribers) OVER(
    PARTITION BY social_network
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_day
FROM subscribers
ORDER BY social_network, date;
```


### ROWS BETWEEN Clause
Explanation of frame specification for window functions.

### Partitioning Data
How PARTITION BY divides data into groups for window calculations.

### Common Use Cases
Typical scenarios where window functions provide value.

### Performance Considerations
Important notes about window function performance impacts.
xxxx



## Common Table Expressions (CTEs)



### Basic CTE Structure
Overview of CTE syntax and components.


### CTE vs Subqueries
Comparison of these two query structuring approaches.

### Multiple CTEs
How to chain multiple CTEs in a single query.

----

# Query Optimization

## Indexing Strategies

Indexing is a technique used in database management systems to improve the speed and efficiency of data retrieval operations. An index is a data structure that provides a quick way to look up rows in a table based on the values in one or more columns. Technically, an index is a data structure (usually a B-tree or a hash table) that stores the values of one or more columns in a way that allows for quick searches, sorting, and filtering.

The index provides pointers to the actual rows in the database table where the data resides. For example, if many queries filter or sort by a specific column, indexing that column can improve performance.

Best practices for index creation with window functions.


### Clustered Index

### Non-Clustered Index

### How to Build an Index in MYSQL

---

## When to Use Indexes in Databases

## 1. High-Volume Read Operations  
**Use Case:** Tables frequently queried for data retrieval (read-heavy applications).  
**Why:** Indexes speed up data retrieval by avoiding full table scans.  
**Example:** A table with millions of customer records where searches are often done by `customer_id` or `email`.  

## 2. Frequent Filtering (WHERE Clauses)  
**Use Case:** Columns often used in `WHERE` clauses.  
**Why:** Indexes help quickly locate rows matching filter conditions.  
**Example:** A table where queries frequently filter by `status`, `date`, or `category`.  

## 3. Frequent Sorting (ORDER BY Clauses)  
**Use Case:** Columns often used in `ORDER BY` for sorting.  
**Why:** Indexes allow faster sorting, especially when combined with filtering.  
**Example:** An orders table frequently sorted by `order_date` or `amount`.  

## 4. JOIN Operations  
**Use Case:** Columns used in `JOIN` operations (e.g., foreign keys).  
**Why:** Indexes improve join performance by speeding up record matching.  
**Example:** Joining `orders` and `customers` tables on `customer_id`.  

## 5. Unique Constraints  
**Use Case:** Columns requiring uniqueness (e.g., emails, usernames).  
**Why:** Indexes enforce uniqueness by preventing duplicate values.  
**Example:** An `email` column in a `users` table with a unique constraint.  

## 6. Foreign Key Columns  
**Use Case:** Columns defined as foreign keys.  
**Why:** Indexes improve performance for lookups, updates, and deletions involving related tables.  
**Example:** A `product_id` in `order_items` referencing `id` in `products`.  

## 7. Large Tables  
**Use Case:** Tables with millions of rows where full scans are expensive.  
**Why:** As tables grow, indexes significantly reduce query costs.  
**Example:** A `logs` table storing system logs with millions of records.  

## 8. Aggregations (GROUP BY Clauses)  
**Use Case:** Columns frequently used in `GROUP BY`.  
**Why:** Indexes speed up grouping and aggregation operations.  
**Example:** A `sales` table grouped by `region` or `product_category` for reports.  

--- 

### Key Notes:  
- **Balance is crucial:** While indexes improve read performance, they slow down writes (INSERT/UPDATE/DELETE).  
- **Monitor usage:** Not all columns need indexing—focus on high-impact queries.  

----------------

# When **Not** to Use Indexes in Databases  

While indexes improve query performance, they are not always beneficial. Below are scenarios where indexes may be unnecessary or even harmful:  

## 1. **Low-Volume Tables**  
**Scenario:** Small tables with few records.  
**Why Avoid?**  
- The overhead of maintaining an index may outweigh its benefits.  
- Full table scans are already fast for small datasets.  
**Example:** A `config` table with only 100 rows.  

## 2. **Frequent Writes (INSERT/UPDATE/DELETE)**  
**Scenario:** Tables with heavy write operations.  
**Why Avoid?**  
- Indexes slow down writes because the database must update both the data **and** the index.  
- High write-load tables may suffer performance degradation.  
**Example:** A high-traffic `audit_log` table with constant inserts.  

## 3. **Low-Cardinality Columns**  
**Scenario:** Columns with very few unique values (e.g., booleans, enums).  
**Why Avoid?**  
- Indexes on such columns don’t significantly reduce the search space.  
- The query optimizer may ignore the index anyway.  
**Example:** A `gender` column with only `M`/`F`/`Other` values.  

## 4. **Temporary Tables**  
**Scenario:** Short-lived tables (e.g., temp tables in sessions).  
**Why Avoid?**  
- Index creation overhead isn’t justified for temporary usage.  
- Small temp tables can be scanned quickly without indexes.  
**Example:** A transient `session_data` table dropped after use.  

--------

### **Additional Considerations**  
- **Storage Overhead:** Indexes consume extra disk space.  
- **Maintenance Cost:** Indexes require updates during DML operations.  
- **Optimizer Behavior:** Sometimes, indexes are **not used** even if they exist (e.g., with functions on indexed columns like `WHERE UPPER(name) = 'ALICE'`).  


```markdown
## 📖 Scenario (Interview-style)
Imagine you're working for an e-commerce platform. You have a table called `Orders` with millions of rows. This table contains:

```sql
Orders
----------
order_id          INT PRIMARY KEY
customer_id       INT
order_date        DATETIME
total_amount      DECIMAL(10,2)
status            VARCHAR(20)
```

You've noticed a report query that's slowing down:

```sql
SELECT order_id, total_amount
FROM Orders
WHERE customer_id = 12345
ORDER BY order_date DESC
LIMIT 10;
```

The interviewer asks: how would you optimize this query?

## 🎯 What You Should Say in an Interview:
1. Check the query execution plan to see if an index is being used.
2. Explain that scanning millions of rows by `customer_id` and sorting by `order_date` is slow without an index.
3. Propose a composite index on `(customer_id, order_date DESC)` to optimize both the filter and the order.

## 📌 How to Build That Index
```sql
CREATE INDEX idx_customer_date 
ON Orders (customer_id, order_date DESC);
```

## ✅ How That Index Helps
- Filters efficiently on `customer_id`
- Keeps `order_date` sorted within each `customer_id` group — so the `ORDER BY order_date DESC` and `LIMIT 10` become fast
- The query can use an index seek + range scan instead of a full table scan

## 🧭 How to Check the Query Plan (SQL Server / MySQL / Postgres)
```sql
EXPLAIN ANALYZE
SELECT order_id, total_amount
FROM Orders
WHERE customer_id = 12345
ORDER BY order_date DESC
LIMIT 10;
```

Look for:
- Index Seek or Index Scan on `idx_customer_date`
- Avoid "Seq Scan" (Postgres) or "Full Table Scan" (MySQL)

## 📦 Bonus Follow-Up Question:
**What if most customers have very few orders — would this index still be worth it?**

- If most `customer_id` values have very few rows, a full table scan might not be that bad
- But if the query is frequent and latency-sensitive, or for heavy users with lots of orders, the index pays off
- You might consider a partial index (Postgres) or filtered index (SQL Server) for active users or recent orders

## 📝 Summary (What You Should Memorize)

| Situation | Solution |
|-----------|----------|
| Filtering and ordering on large tables | Composite index |
| Columns in WHERE and ORDER BY | Index in same order |
| Small selectivity | Maybe skip or use partial index |
| Always check EXPLAIN/Query Plan | Confirm index is used |


### EXPLAIN Command
How to analyze query execution plans.

### Partitioning Large Datasets
Techniques for improving performance on large tables.




## Useful Functions


### SELF JOINS

### UNION

### RECURSIVE CTE
**Process:**
1. Anchor Member Execution: The CTE starts its execution with the anchor member which is a non recursive query.
2. Recursive Member Execution(Iterations): The recursive member mainly consists of the SELECT statement that references the CTE itself.
3. Termination Condition Check: The termination condition is essential for the termination of the recursive query.
4. Union Result Sets: The UNION ALL operator combines the results from the anchor member as well as the results obtained from all of the iterations.
5. Return Final Result: Finally the result set is returned to the user.

**Simple Example - Months of the Year:**
```sql
WITH RecursiveMonths AS (
    SELECT
        1 AS MonthNumber,
        DATENAME(MONTH, CAST('2024-01-01' AS DATE)) AS MonthName

    UNION ALL

    SELECT
        MonthNumber + 1,
        DATENAME(MONTH, DATEADD(MONTH, MonthNumber, '2024-01-01'))
    FROM RecursiveMonths
    WHERE MonthNumber < 12
)
SELECT * FROM RecursiveMonths;
```

**Harder Example - Company Hierarchy:**
```sql
WITH RECURSIVE company_hierarchy AS (
  SELECT id,
        first_name,
        last_name,
        boss_id,
        0 AS hierarchy_level
  FROM employees
  WHERE boss_id IS NULL
  
  UNION ALL
  
  SELECT e.id,
        e.first_name,
        e.last_name,
        e.boss_id,
        hierarchy_level+1
  FROM employees e, company_hierarchy ch
  WHERE e.boss_id = ch.id
)
 
SELECT ch.first_name AS employee_first_name,
       ch.last_name AS employee_last_name,
       CONCAT(e.first_name, " ", e.last_name) AS boss_name,
       hierarchy_level
FROM company_hierarchy ch
LEFT JOIN employees e
ON ch.boss_id = e.id
ORDER BY ch.hierarchy_level, ch.boss_id;
```

### PIVOT
The PIVOT operation is typically used when you need to convert row data into columns for better analytical insight.

**Basic Example:**
```sql
SELECT 
  department,
  SUM(CASE WHEN month = 'Jan' THEN sales ELSE 0 END) AS Jan_Sales,
  SUM(CASE WHEN month = 'Feb' THEN sales ELSE 0 END) AS Feb_Sales
FROM sales_data
GROUP BY department;
```

**Dynamic Example (when number of columns not known):**
```sql
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
```

### STORED PROCEDURE vs FUNCTION
**Definitions:**
- A stored procedure is a saved, precompiled block of SQL code that you can call and execute whenever you need it — optionally passing in parameters.
- Functions are designed to encapsulate calculations or transformations and return the result.

**Key Differences:**
- Functions MUST return a value and cannot alter the data they receive as parameters
- Functions are not allowed to change anything, must have at least one parameter
- Stored procs do not have to have a parameter, can change database objects, and do not have to return a value

**Procedure Example:**
```sql
CREATE PROCEDURE SelectAllCustomers @City nvarchar(30), @PostalCode nvarchar(10)
AS
SELECT * FROM Customers WHERE City = @City AND PostalCode = @PostalCode
GO;

EXEC SelectAllCustomers @City = 'London', @PostalCode = 'WA1 1DP';
```

**Function Example:**
```sql
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

-- Usage:
SELECT 
  content_id,
  content_type,
  likes_count,
  comments_count,
  shares_count,
  calculate_engagement_score(likes_count, comments_count, shares_count) AS engagement_score
FROM fct_creator_content;
```

### DELIMITER
When writing multi-statement SQL blocks like stored procedures or functions, you need to temporarily change the statement terminator.

```sql
DELIMITER $$     -- Tell MySQL: "For now, don't treat semicolons as end of statement"

CREATE FUNCTION my_function()
RETURNS INT
BEGIN
  DECLARE my_variable INT;
  SET my_variable = 10;
  RETURN my_variable;
END$$           -- Here's the actual end of the entire function definition

DELIMITER ;     -- Put it back to normal for regular SQL statements
```



### ANALYZE
`ANALYZE TABLE` is typically used when there are significant changes in the data distribution within a table.

```sql
ANALYZE TABLE orders, customers;
```

### EXPLAIN
The `EXPLAIN` statement in MySQL is a performance optimization tool used to provide insight into how MySQL executes a query.

```sql
EXPLAIN SELECT orders.order_id, customers.customer_name
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.date > '2023-01-01';
```

### EXPLAIN ANALYZE
```sql
EXPLAIN ANALYZE SELECT * FROM table_name WHERE condition;
```

### SQL INJECTION

---

## Example Interview Questions

**Question 1:** For content published in May 2024, which creator IDs show the highest new follower growth within each content type?

```sql
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
WHERE rn = 1;
```

**Question 2:** Determine the average marketing spend per new subscriber for each country in Q1 2024

```sql
SELECT dc.country_name,
  CEIL(SUM(fms.amount_spent) * 1.0 / NULLIF(SUM(fds.num_new_subscribers), 0)) AS marketing_spend_per_subscribers
FROM fact_daily_subscriptions as fds 
INNER JOIN dimension_country as dc ON fds.country_id = dc.country_id
INNER JOIN fact_marketing_spend as fms ON fms.country_id = dc.country_id  
WHERE fds.signup_date between '2024-01-01' and '2024-03-31' 
AND fms.campaign_date between '2024-01-01' and '2024-03-31'  
GROUP BY dc.country_name;
```

**Question 3:** Find customers who have purchased at least one product from every product category

```sql
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
```

**Question 4:** Top 5 artists whose songs appear most frequently in the Top 10

```sql
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
```

**Question 5:** Calculating percentages within a window function

```sql
SELECT order_id, total_amount, 
ROUND(total_amount * 100.0 / SUM(total_amount) OVER(), 2) as total_sales_participation
FROM orders
GROUP BY order_id;
```

**Question 6:** Year-over-Year Growth Rate

```sql
WITH cte as (
SELECT Extract(YEAR FROM transaction_date) AS year,
product_id,
spend,
LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date) as prev_year_spend
FROM user_transactions
)

SELECT Year, product_id, spend as curr_year_spend, prev_year_spend,
ROUND(100*(spend-prev_year_spend)/prev_year_spend,2) as yoy_rate
FROM cte;
```
```
