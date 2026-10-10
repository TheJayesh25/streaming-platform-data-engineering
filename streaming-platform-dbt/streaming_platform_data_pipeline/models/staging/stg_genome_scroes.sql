WITH raw_genome_scores AS (
    SELECT * FROM MOVIELENS.RAW.RAW_GENOME_SCORES
)
SELECT 
    MOVIEID AS movie_id,
    TAGID AS tag_id,
    relevance
FROM raw_genome_scores