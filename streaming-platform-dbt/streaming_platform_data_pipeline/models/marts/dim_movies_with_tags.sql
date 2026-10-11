-- Ephemeral Model is not directly built into the database
-- These tables however can be used in any other models be it dims, facts, staging, etc
-- So it does not take storage space
-- Basically you could use this as reference and query data from this type of below table even tho it does not exist in the database

{{
    config(
        materialized = 'ephemeral'
    )
}}

WITH movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),
tags AS (
    SELECT * FROM {{ ref('dim_genome_tags') }}
),
scores AS (
    SELECT * FROM {{ ref('fct_genome_scores') }}
)

SELECT
    m.movie_id,
    m.movie_title,
    m.genres,
    t.tag_name,
    s.relevance_score
FROM movies m
LEFT JOIN scores s ON m.movie_id = s.movie_id
LEFT JOIN tags t ON t.tag_id = m.tag_id
