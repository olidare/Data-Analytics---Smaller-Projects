
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
        * [RANK (Detailed Example)](#rank-detailed-example)
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

# Useful Functions

### CTEs 
Def: 
  
### Windows Functions 

Name of the window being referenced by the current window. The referenced window must be among the windows defined in the WINDOW clause.

The other arguments are:
* PARTITION BY that divides the query result set into partitions.
* ORDER BY that defines the logical order of the rows within each partition of the result set.
* ROWS/RANGE that limits the rows within the partition by specifying start and end points within the partition.
    
Window functions differ from regular aggregate functions as they perform operations across a set of table rows related to the current row without collapsing them into a single output row. 
The `OVER` clause is crucial here, as it specifies the window over which the function operates.

#### Basic Window Function - Rank 

``` sql
SELECT employee_id, salary,
  RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
```

### WINDOW Clause

The `WINDOW` clause is used in conjunction with window functions like `ROW_NUMBER()`, `RANK()`, or `SUM()` to perform calculations over a specified set of rows. 
It simplifies queries by allowing the reuse of window definitions across multiple functions.

#### Sum with Windows Clause 

``` sql
SELECT employee_id, department_id, salary,
       SUM(salary) OVER emp_window AS total_salary
FROM employees
WINDOW emp_window AS (PARTITION BY department_id ORDER BY salary);
```

### Lag & Lead Functions
Description of time-series analysis functions for accessing adjacent rows.

### ROWS BETWEEN Clause
Explanation of frame specification for window functions.

### Partitioning Data
How PARTITION BY divides data into groups for window calculations.

### Common Use Cases
Typical scenarios where window functions provide value.

### Performance Considerations
Important notes about window function performance impacts.

## Common Table Expressions (CTEs)

### Basic CTE Structure
Overview of CTE syntax and components.

### Recursive CTEs

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

### CTE vs Subqueries
Comparison of these two query structuring approaches.

### Multiple CTEs
How to chain multiple CTEs in a single query.

## Query Optimization

### EXPLAIN Command
How to analyze query execution plans.

### Indexing Strategies
Best practices for index creation with window functions.

### Partitioning Large Datasets
Techniques for improving performance on large tables.
