-- Drop existing tables if they exist to allow for a clean run
DROP TABLE IF EXISTS directors;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS cast;
DROP TABLE IF EXISTS new_netflix_titles;


-- Create a new table without duplicates from netflix_titles
-- This step also handles data cleaning for `date_added` and `duration`
CREATE TABLE new_netflix_titles AS
WITH find_duplicates_cte AS (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY title, type ORDER BY show_id) AS rn
    FROM
        netflix_titles
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
    CASE WHEN duration IS NULL THEN rating ELSE duration END AS duration, -- This logic seems to assume rating contains duration if duration is null. Verify data.
    listed_in,
    description
FROM
    find_duplicates_cte
WHERE
    rn = 1;


-- Split up the director multivalue column into separate values
CREATE TABLE directors AS
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 100 -- Increased limit for potentially more directors
)
SELECT
    s.show_id,
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(s.director, ',', numbers.n),
            ',', -1
        )
    ) AS director
FROM
    new_netflix_titles s
JOIN
    numbers
ON
    numbers.n <= LENGTH(s.director) - LENGTH(REPLACE(s.director, ',', '')) + 1
WHERE
    s.director IS NOT NULL AND s.director != '' -- Exclude rows with empty or null director
ORDER BY
    s.show_id, numbers.n;


-- Split up the country multivalue column into separate values
CREATE TABLE countries AS
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 100 -- Increased limit
)
SELECT
    s.show_id,
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(s.country, ',', numbers.n),
            ',', -1
        )
    ) AS country
FROM
    new_netflix_titles s
JOIN
    numbers
ON
    numbers.n <= LENGTH(s.country) - LENGTH(REPLACE(s.country, ',', '')) + 1
WHERE
    s.country IS NOT NULL AND s.country != '' -- Exclude rows with empty or null country
ORDER BY
    s.show_id, numbers.n;


-- Split up the listed_in multivalue column into separate values and rename as genres
CREATE TABLE genre AS
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 100 -- Increased limit
)
SELECT
    s.show_id,
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(s.listed_in, ',', numbers.n),
            ',', -1
        )
    ) AS genre
FROM
    new_netflix_titles s
JOIN
    numbers
ON
    numbers.n <= LENGTH(s.listed_in) - LENGTH(REPLACE(s.listed_in, ',', '')) + 1
WHERE
    s.listed_in IS NOT NULL AND s.listed_in != '' -- Exclude rows with empty or null listed_in
ORDER BY
    s.show_id, numbers.n;


-- Split up the cast multivalue column into separate values
CREATE TABLE cast AS
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 500 -- Increased limit for potentially more cast members
)
SELECT
    s.show_id,
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(s.cast, ',', numbers.n),
            ',', -1
        )
    ) AS cast_member -- Renamed 'cast' to 'cast_member' to avoid conflict with SQL keyword
FROM
    new_netflix_titles s
JOIN
    numbers
ON
    numbers.n <= LENGTH(s.cast) - LENGTH(REPLACE(s.cast, ',', '')) + 1
WHERE
    s.cast IS NOT NULL AND s.cast != '' -- Exclude rows with empty or null cast
ORDER BY
    s.show_id, numbers.n;


-- Now drop the unnecessary columns from the main table
ALTER TABLE new_netflix_titles
DROP COLUMN director,
DROP COLUMN cast,
DROP COLUMN listed_in,
DROP COLUMN country;


-- Analysis Queries

-- 1. For each director, count the number of movies and TV shows created by them in separate columns
--    for directors who have created TV shows and movies both.
SELECT
    d.director,
    COUNT(CASE WHEN nx.type = 'Movie' THEN 1 END) AS movie_count,
    COUNT(CASE WHEN nx.type = 'TV Show' THEN 1 END) AS tv_count
FROM
    new_netflix_titles AS nx
INNER JOIN
    directors d ON nx.show_id = d.show_id
GROUP BY
    d.director
HAVING -- Added HAVING clause to filter for directors with both movies and TV shows
    COUNT(CASE WHEN nx.type = 'Movie' THEN 1 END) > 0
    AND COUNT(CASE WHEN nx.type = 'TV Show' THEN 1 END) > 0
ORDER BY
    tv_count DESC;


-- 2. Top 10 countries with the highest number of comedy movies
SELECT
    c.country,
    COUNT(c.country) AS total_comedy_movies
FROM
    new_netflix_titles AS nx
INNER JOIN
    countries c ON nx.show_id = c.show_id
INNER JOIN
    genre g ON nx.show_id = g.show_id
WHERE
    nx.type = 'Movie' AND g.genre = 'Comedies'
GROUP BY
    c.country
ORDER BY
    total_comedy_movies DESC
LIMIT 10;


-- 3. For each year (as per date added to Netflix), which director has the maximum number of movies released
WITH DirectorMovieCounts AS (
    SELECT
        d.director,
        YEAR(nx.date_added) AS release_year,
        COUNT(d.director) AS movie_count
    FROM
        new_netflix_titles nx
    INNER JOIN
        directors d ON nx.show_id = d.show_id
    WHERE
        nx.type = 'Movie' AND nx.date_added IS NOT NULL -- Filter for movies and valid date_added
    GROUP BY
        d.director,
        YEAR(nx.date_added)
),
RankedDirectors AS (
    SELECT
        director,
        release_year,
        movie_count,
        RANK() OVER (PARTITION BY release_year ORDER BY movie_count DESC) AS rnk
    FROM
        DirectorMovieCounts
)
SELECT
    release_year,
    director,
    movie_count
FROM
    RankedDirectors
WHERE
    rnk = 1
ORDER BY
    release_year DESC;


-- 4. What is the average duration of movies in each genre
SELECT
    g.genre,
    AVG(CAST(REPLACE(nx.duration, ' min', '') AS UNSIGNED)) AS avg_duration_minutes -- Cast duration to number
FROM
    new_netflix_titles nx
INNER JOIN
    genre g ON nx.show_id = g.show_id
WHERE
    nx.type = 'Movie' AND nx.duration LIKE '%min' -- Ensure only movie durations in minutes are considered
GROUP BY
    g.genre
ORDER BY
    avg_duration_minutes DESC;


-- 5. Find the list of directors who have created horror and comedy movies both.
--    Display director names along with the number of comedy and horror movies directed by them.
WITH DirectorGenreCounts AS (
    SELECT
        d.director,
        COUNT(CASE WHEN g.genre = 'Horror Movies' THEN 1 ELSE NULL END) AS horror_movie_count,
        COUNT(CASE WHEN g.genre = 'Comedies' THEN 1 ELSE NULL END) AS comedy_movie_count
    FROM
        new_netflix_titles nx
    INNER JOIN
        genre g ON nx.show_id = g.show_id
    INNER JOIN
        directors d ON nx.show_id = d.show_id
    WHERE
        nx.type = 'Movie'
        AND g.genre IN ('Comedies', 'Horror Movies')
    GROUP BY
        d.director
)
SELECT
    director,
    horror_movie_count,
    comedy_movie_count,
    (horror_movie_count + comedy_movie_count) AS total_movies_in_genres
FROM
    DirectorGenreCounts
WHERE
    horror_movie_count >= 1
    AND comedy_movie_count >= 1
ORDER BY
    total_movies_in_genres DESC;