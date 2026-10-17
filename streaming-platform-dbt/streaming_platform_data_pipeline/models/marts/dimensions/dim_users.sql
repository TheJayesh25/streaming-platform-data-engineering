WITH rating_users AS (
    SELECT DISTINCT user_id
    FROM {{ ref('stg_ratings') }}
),

tag_users AS (
    SELECT DISTINCT user_id
    FROM {{ ref('stg_tags') }}
)

SELECT user_id
FROM rating_users

UNION

SELECT user_id
FROM tag_users