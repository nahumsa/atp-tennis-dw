WITH matches AS (
    SELECT * FROM {{ source('raw_data', 'atp_matches') }}
)

SELECT
  DISTINCT
  hash(MD5(CONCAT(tourney_name, surface))) AS sk_tournament_key,
  tourney_id AS nk_tournament_id,
  tourney_name AS desc_tournament_name,
  surface AS desc_surface,
  best_of AS desc_best_of,
  STRPTIME(CAST(tourney_date AS STRING), '%Y%m%d') AS dt_tournament_start_date,
  updated_at::timestamp AS updated_at
FROM matches
WHERE UPPER(tourney_name) NOT LIKE '%DAVIS CUP%'
