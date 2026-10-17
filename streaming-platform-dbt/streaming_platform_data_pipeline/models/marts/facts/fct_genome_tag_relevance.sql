SELECT
    movie_id,
    tag_id,
    ROUND(relevance, 4) AS relevance_score
FROM {{ ref('stg_genome_scores') }}