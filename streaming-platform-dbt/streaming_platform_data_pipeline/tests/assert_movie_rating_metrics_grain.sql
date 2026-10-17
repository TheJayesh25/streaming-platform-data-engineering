SELECT
    rating_date,
    movie_id,
    COUNT(*) AS row_count
FROM {{ ref('movie_rating_metrics') }}
GROUP BY
    rating_date,
    movie_id
HAVING COUNT(*) > 1