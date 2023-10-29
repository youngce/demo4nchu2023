CREATE DATABASE library;
USE library;

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    publication_year INT,
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);


CREATE TABLE ratings (
    userId INT,
    movieId INT,
    rating DECIMAL(3,1),
    timestamp INT,
    PRIMARY KEY (userId, movieId)
);

CREATE TABLE links (
    movieId INT,
    imdbId INT,
    tmdbId VARCHAR(255)
);

CREATE TABLE tags (
    userId INT,
    movieId INT,
    tag VARCHAR(255),
    timestamp INT
);


-- USE movielens;
-- -- Load csv to table
LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/ml-25m/movies.csv' INTO TABLE movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/ml-25m/ratings.csv' INTO TABLE ratings
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/ml-25m/links.csv' INTO TABLE links
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/data/ml-25m/tags.csv' INTO TABLE tags
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;



-- set FOREIGN KEY
ALTER TABLE ratings
ADD FOREIGN KEY (movieId) REFERENCES movies (movieId);

ALTER TABLE tags
ADD FOREIGN KEY (movtmdbIdieId) REFERENCES movies (movieId);

