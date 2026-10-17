WITH ratings AS (
    SELECT
        user_id,
        movie_id,
        rating_timestamp,
        rating
    FROM {{ ref('fct_ratings') }}
)

SELECT
    CAST(rating_timestamp AS DATE) AS rating_date,
    movie_id,
    COUNT(*) AS rating_count,
    COUNT(DISTINCT user_id) AS unique_raters,
    ROUND(AVG(rating), 2) AS average_rating,
    MIN(rating) AS minimum_rating,
    MAX(rating) AS maximum_rating
FROM ratings
GROUP BY
    CAST(rating_timestamp AS DATE),
    movie_id