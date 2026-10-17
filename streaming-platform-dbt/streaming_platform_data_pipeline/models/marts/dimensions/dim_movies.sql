WITH movies AS (
    SELECT * FROM {{ ref('stg_movies') }}
),

links AS (
    SELECT * FROM {{ ref('stg_links') }}
)

SELECT
    m.movie_id,
    INITCAP(TRIM(m.title)) AS movie_title,
    l.imdb_id,
    l.tmdb_id
FROM movies m
LEFT JOIN links l
    ON m.movie_id = l.movie_id