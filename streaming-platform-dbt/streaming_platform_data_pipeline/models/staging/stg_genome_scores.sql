WITH raw_genome_scores AS (
    SELECT * FROM {{ source('movielens','r_genome_scores') }}
)
SELECT 
    MOVIEID AS movie_id,
    TAGID AS tag_id,
    relevance
FROM raw_genome_scores