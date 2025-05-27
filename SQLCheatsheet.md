
# SQL Cheat Sheet & Interview Prep

This document consolidates key SQL concepts, common interview questions, and useful functions, structured for easy reference and learning.

## Table of Contents
1.  [Must Know Differences in SQL](#must-know-differences-in-sql)
    * [RANK vs DENSE_RANK](#rank-vs-dense_rank)
    * [HAVING vs WHERE Clause](#having-vs-where-clause)
    * [UNION vs UNION ALL](#union-vs-union-all)
    * [JOIN vs UNION](#join-vs-union)
    * [DELETE vs DROP vs TRUNCATE](#delete-vs-drop-vs-truncate)
    * [COUNT() vs COUNT(*)](#count-vs-count)
    * [CTE vs TEMP TABLE](#cte-vs-temp-table)
    * [SUBQUERIES vs CTE](#subqueries-vs-cte)
    * [ISNULL vs COALESCE](#isnull-vs-coalesce)
    * [INTERSECT vs INNER JOIN](#intersect-vs-inner-join)
    * [LAG/LEAD vs BETWEEN WINDOW FRAME](#laglead-vs-between-window-frame)
    * [CTE vs WINDOW FUNCTION](#cte-vs-window-function)
    * [WINDOW CLAUSE vs WINDOW FUNCTION](#window-clause-vs-window-function)
2.  [Useful Functions & Concepts](#useful-functions--concepts)
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
3.  [Example Interview Questions](#example-interview-questions)
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

## BASIC Qs:
* [TestGorilla SQL Basic Interview Questions](https://www.testgorilla.com/blog/sql-basic-interview-questions/)

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

### 📗 ISNULL vs COALESCE: 📝
* **ISNULL**: Replaces `NULL` with a specified value, accepts two parameters.
* **COALESCE**: Returns the first non-`NULL` value from a list of expressions, accepting multiple parameters.

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
