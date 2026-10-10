WITH raw_links AS (
    SELECT * FROM MOVIELENS.RAW.RAW_LINKS
)
SELECT 
    movieId AS movie_id,
    imdbId AS imdb_id,
    tmdbId AS tmdb_id,
    to_timestamp_ltz(timestamp) AS tag_timestamp
FROM raw_links