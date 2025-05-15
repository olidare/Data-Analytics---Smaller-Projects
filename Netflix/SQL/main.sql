--remove duplicates 

select show_id, COUNT(*) 
from netflix_titles
group by show_id 
having COUNT(*)>1;

-- where there are duplicate titles
SELECT n.* 
FROM netflix_titles n
JOIN (
    SELECT UPPER(title) AS utitle, type
    FROM netflix_titles
    GROUP BY UPPER(title), type
    HAVING COUNT(*) > 1
) dup ON UPPER(n.title) = dup.utitle AND n.type = dup.type
ORDER BY n.title;

SELECT * FROM netflix_titles
where country is null
;


-- Create a new table without duplicates
CREATE TABLE IF NOT EXISTS new_netflix_titles AS
WITH find_duplicates_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY title, type ORDER BY show_id) AS rn
    FROM netflix_titles
)
SELECT 
    show_id,
    type,
    title,
    director,
    cast,
    country,
    STR_TO_DATE(date_added, '%M %d, %Y') AS date_added,  
    release_year,
    rating,
    CASE WHEN duration IS NULL THEN rating ELSE duration END AS duration,
    listed_in,
    description
FROM find_duplicates_cte
WHERE rn = 1;


SELECT * FROM new_netflix_titles;

-- Split up the director  multivalue column into separate values
CREATE TABLE IF NOT EXISTS directors AS
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT
  s.show_id,
  TRIM(
    SUBSTRING_INDEX(
      SUBSTRING_INDEX(s.director, ',', numbers.n),
      ',', -1
    )
  ) AS director
FROM new_netflix_titles s
JOIN numbers 
  ON numbers.n <= CHAR_LENGTH(s.director) - CHAR_LENGTH(REPLACE(s.director, ',', '')) + 1
ORDER BY s.show_id, numbers.n;


select * from directors;

-- Split up the country  multivalue column into separate values

CREATE TABLE IF NOT EXISTS countries AS
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT
  s.show_id,
  TRIM(
    SUBSTRING_INDEX(
      SUBSTRING_INDEX(s.country, ',', numbers.n),
      ',', -1
    )
  ) AS country
FROM new_netflix_titles s
JOIN numbers 
  ON numbers.n <= CHAR_LENGTH(s.country) - CHAR_LENGTH(REPLACE(s.country, ',', '')) + 1
ORDER BY s.show_id, numbers.n;


select * from countries;


-- Split up the listed_in  multivalue column into separate values and rename as genres

CREATE TABLE IF NOT EXISTS genre AS
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT
  s.show_id,
  TRIM(
    SUBSTRING_INDEX(
      SUBSTRING_INDEX(s.listed_in, ',', numbers.n),
      ',', -1
    ) 
  ) AS genre
FROM new_netflix_titles s
JOIN numbers 
  ON numbers.n <= CHAR_LENGTH(s.listed_in) - CHAR_LENGTH(REPLACE(s.listed_in, ',', '')) + 1
ORDER BY s.show_id, numbers.n;


select * from genre;

-- Split up the cast  multivalue column into separate values

CREATE TABLE IF NOT EXISTS cast AS
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT
  s.show_id,
  TRIM(
    SUBSTRING_INDEX(
      SUBSTRING_INDEX(s.cast, ',', numbers.n),
      ',', -1
    )
  ) AS cast
FROM new_netflix_titles s
JOIN numbers 
  ON numbers.n <= CHAR_LENGTH(s.cast) - CHAR_LENGTH(REPLACE(s.cast, ',', '')) + 1
ORDER BY s.show_id, numbers.n;


select * from cast;


-- now drop the unnecessary column from the main table

ALTER TABLE new_netflix_titles
DROP COLUMN director,
DROP COLUMN cast,
DROP COLUMN listed_in,
DROP COLUMN country;




-- Analysis

/*1  for each director count the no of movies and tv shows created by them in separate columns 
for directors who have created tv shows and movies both */

SELECT  d.director, 
     	COUNT(CASE WHEN nx.type = 'Movie' THEN 1 END) AS movie_count,
    	COUNT(CASE WHEN nx.type = 'TV Show' THEN 1 END) AS tv_count
FROM new_netflix_titles as nx
inner join directors d on nx.show_id=d.show_id
GROUP BY d.director
ORDER BY    COUNT(CASE WHEN nx.type = 'TV Show' THEN 1 END) DESC

;

/*2 Top 10 countries with highest number of comedy movies */


SELECT c.country, COUNT(c.country) as total
FROM new_netflix_titles as nx
INNER JOIN countries c ON nx.show_id = c.show_id
INNER JOIN genre g ON nx.show_id=g.show_id
WHERE genre = 'Comedies'
GROUP BY c.country
ORDER BY COUNT(c.country) DESC LIMIT 10






