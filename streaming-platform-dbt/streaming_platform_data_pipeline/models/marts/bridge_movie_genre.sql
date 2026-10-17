WITH movies AS (
    SELECT * FROM {{ ref('stg_movies') }}
),

movie_genres AS (
    SELECT DISTINCT
        movie_id,
        TRIM(value) AS genre_name
    FROM movies,
    LATERAL SPLIT_TO_TABLE(movies.genres, '|')
)

SELECT
    mg.movie_id,
    {{ dbt_utils.generate_surrogate_key(['mg.genre_name']) }} AS genre_id
FROM movie_genres mg
WHERE LOWER(mg.genre_name) != '(no genres listed)'