SELECT
    movie_id,
    genre_id,
    COUNT(*) AS row_count
FROM {{ ref('bridge_movie_genres') }}
GROUP BY
    movie_id,
    genre_id
HAVING COUNT(*) > 1