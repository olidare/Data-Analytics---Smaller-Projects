DROP TABLE IF EXISTS netflix_titles;

CREATE TABLE netflix_titles (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(10) NULL,
    title NVARCHAR(200) NULL,
    director VARCHAR(250) NULL,
    `cast` VARCHAR(1000) NULL,
    country VARCHAR(150) NULL,
    date_added VARCHAR(20) NULL,
    release_year INT NULL,
    rating VARCHAR(10) NULL,
    duration VARCHAR(10) NULL,
    listed_in VARCHAR(100) NULL,
    description VARCHAR(500) NULL
);