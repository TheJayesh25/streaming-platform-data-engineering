WITH raw_ratings AS (
    SELECT * FROM {{ source('movielens','r_ratings') }}
)
SELECT 
    userId AS user_id,
    movieId AS movie_id,
    rating,
    to_timestamp_ltz(timestamp) AS rating_timestamp
FROM raw_ratings