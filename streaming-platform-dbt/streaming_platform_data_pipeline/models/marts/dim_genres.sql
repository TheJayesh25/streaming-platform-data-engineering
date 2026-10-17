WITH movies AS (
    SELECT * FROM {{ ref('stg_movies') }}
),

genres AS (
    SELECT DISTINCT
        TRIM(value) AS genre_name
    FROM movies,
    LATERAL SPLIT_TO_TABLE(movies.genres, '|')
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['genre_name']) }} AS genre_id,
    INITCAP(genre_name) AS genre_name
FROM genres
WHERE genre_name IS NOT NULL
  AND LOWER(genre_name) != '(no genres listed)'