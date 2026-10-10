WITH stg_ratings AS (
    SELECT DISTINCT user_id FROM {{ ref('stg_ratings') }}
),

stg_tags AS (
    SELECT DISTINCT user_id FROM {{ ref('stg_tags') }}
)
SELECT * FROM stg_ratings
UNION
SELECT * FROM stg_tags