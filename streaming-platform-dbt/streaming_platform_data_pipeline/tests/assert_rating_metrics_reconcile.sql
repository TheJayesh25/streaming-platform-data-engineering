WITH fact_count AS (
    SELECT COUNT(*) AS total_ratings
    FROM {{ ref('fct_ratings') }}
),

metric_count AS (
    SELECT SUM(rating_count) AS total_ratings
    FROM {{ ref('movie_rating_metrics') }}
)

SELECT *
FROM fact_count
CROSS JOIN metric_count
WHERE fact_count.total_ratings != metric_count.total_ratings