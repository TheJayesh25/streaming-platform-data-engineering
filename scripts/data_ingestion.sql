-- ============================================================
-- MovieLens Raw Data Load
-- ============================================================
-- Purpose:
--   Create raw Snowflake tables and load the MovieLens source
--   files from the external S3 stage.
--
-- Source:
--   @MOVIELENS_STAGE
-- ============================================================

-- Set defaults
USE WAREHOUSE MOVIELENS_WH;
USE DATABASE MOVIELENS;
USE SCHEMA RAW;

-- Load raw_movies
CREATE OR REPLACE TABLE raw_movies (
  movieId INTEGER,
  title STRING,
  genres STRING
);

COPY INTO raw_movies
FROM '@movielens_stage/movies.csv'
FILE_FORMAT = (FORMAT_NAME = MY_CSV_FORMAT);

-- Load raw_ratings
CREATE OR REPLACE TABLE raw_ratings (
  userId INTEGER,
  movieId INTEGER,
  rating FLOAT,
  timestamp BIGINT
);

COPY INTO raw_ratings
FROM '@movielens_stage/ratings.csv'
FILE_FORMAT = (FORMAT_NAME = MY_CSV_FORMAT);

-- Load raw_tags
CREATE OR REPLACE TABLE raw_tags (
  userId INTEGER,
  movieId INTEGER,
  tag STRING,
  timestamp BIGINT
);

COPY INTO raw_tags
FROM '@movielens_stage/tags.csv'
FILE_FORMAT = (FORMAT_NAME = MY_CSV_FORMAT)
ON_ERROR = 'CONTINUE';

-- Load raw_genome_scores
CREATE OR REPLACE TABLE raw_genome_scores (
  movieId INTEGER,
  tagId INTEGER,
  relevance FLOAT
);

COPY INTO raw_genome_scores
FROM '@movielens_stage/genome-scores.csv'
FILE_FORMAT = (FORMAT_NAME = MY_CSV_FORMAT);

-- Load raw_genome_tags
CREATE OR REPLACE TABLE raw_genome_tags (
  tagId INTEGER,
  tag STRING
);

COPY INTO raw_genome_tags
FROM '@movielens_stage/genome-tags.csv'
FILE_FORMAT = (FORMAT_NAME = MY_CSV_FORMAT);

-- Load raw_links
CREATE OR REPLACE TABLE raw_links (
  movieId INTEGER,
  imdbId INTEGER,
  tmdbId INTEGER
);

COPY INTO raw_links
FROM '@movielens_stage/links.csv'
FILE_FORMAT = (FORMAT_NAME = MY_CSV_FORMAT);

SELECT COUNT(*) FROM RAW_MOVIES;
SELECT COUNT(*) FROM RAW_RATINGS;
SELECT COUNT(*) FROM RAW_TAGS;
SELECT COUNT(*) FROM RAW_GENOME_SCORES;
SELECT COUNT(*) FROM RAW_GENOME_TAGS;
SELECT COUNT(*) FROM RAW_LINKS;
