{{
    config(
        materialized = 'incremental',
        on_schema_change = 'fail'
    )
}}

SELECT
    user_id,
    movie_id,
    rating,
    rating_timestamp
FROM {{ ref('stg_ratings') }}
WHERE rating IS NOT NULL

{% if is_incremental() %}
    AND rating_timestamp > (
        SELECT MAX(rating_timestamp)
        FROM {{ this }}
    )
{% endif %}