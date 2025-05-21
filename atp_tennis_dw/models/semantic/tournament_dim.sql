WITH matches AS (
    SELECT * FROM {{ ref('stg_atp_matches') }}
)

SELECT
  DISTINCT
  hash(MD5(CONCAT(tourney_name))) AS sk_tournament_key,
  tourney_id AS nk_tournament_id,
  tourney_name AS desc_tournament_name,
  surface AS desc_surface,
  best_of AS desc_best_of,
  tourney_date AS dt_tournament_start_date
FROM matches
WHERE UPPER(tourney_name) NOT LIKE '%DAVIS CUP%'
