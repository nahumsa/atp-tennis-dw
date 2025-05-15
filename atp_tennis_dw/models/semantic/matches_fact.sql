WITH atp_matches AS (
    SELECT * FROM {{ ref('stg_atp_matches') }}
)

SELECT
  hash(MD5(CONCAT(winner_name, winner_id))) AS fk_winner_id,
  hash(MD5(CONCAT(loser_name, loser_id))) AS fk_loser_id,
  minutes AS mtr_minutes,
  {
  'ace' : w_ace,
  'double_fault' : w_df,
  'serve_points' : w_svpt,
  'first_serve_made' : w_1st_in,
  'first_serve_won' : w_1st_won,
  'second_serve_made' : w_svpt - w_1st_in,
  'second_serve_won' : w_2nd_won,
  'serve_games' : w_sv_gms,
  'break_point_saved' : w_bp_saved,
  'break_point_faced' : w_bp_faced,
  } AS nst_winner_stats,
  {
  'ace' : l_ace,
  'double_fault' : l_df,
  'serve_points' : l_svpt,
  'first_serve_made' : l_1st_in,
  'first_serve_won' : l_1st_won,
  'second_serve_made' : l_svpt - l_1st_in,
  'second_serve_won' : l_2nd_won,
  'serve_games' : l_sv_gms,
  'break_point_saved' : l_bp_saved,
  'break_point_faced' : l_bp_faced,
  } AS nst_looser_stats
FROM atp_matches
