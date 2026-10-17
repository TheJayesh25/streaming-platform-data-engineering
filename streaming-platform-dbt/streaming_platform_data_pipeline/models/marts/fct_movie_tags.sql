SELECT
    user_id,
    movie_id,
    tag,
    tag_timestamp
FROM {{ ref('stg_tags') }}
WHERE tag IS NOT NULL