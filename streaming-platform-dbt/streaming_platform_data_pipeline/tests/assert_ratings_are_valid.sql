SELECT *
FROM {{ ref('fct_ratings') }}
WHERE rating < 0
   OR rating > 5