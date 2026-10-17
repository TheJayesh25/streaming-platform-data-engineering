SELECT *
FROM {{ ref('fct_genome_tag_relevance') }}
WHERE relevance_score < 0
   OR relevance_score > 1