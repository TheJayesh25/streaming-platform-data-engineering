WITH raw_links AS (
    SELECT * FROM {{ source('movielens','r_links') }}
)
SELECT 
    MOVIEID AS movie_id,
    IMDBID AS imdb_id,
    TMDBID AS tmdb_id
FROM raw_links