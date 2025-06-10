{{ config(
    schema='stg'
) }}

WITH atp_matches AS (
    SELECT * FROM {{ source('raw_data', 'atp_matches') }}
)

SELECT
  tourney_id::STRING AS tourney_id,
  tourney_name::STRING AS tourney_name,
  surface::STRING AS surface,
  draw_size::INTEGER AS draw_size,
  tourney_level::STRING AS tourney_level,
  STRPTIME(CAST(tourney_date AS STRING), '%Y%m%d') AS tourney_date,
  match_num::INTEGER AS match_num,
  winner_id::INTEGER AS winner_id,
  loser_id::INTEGER AS loser_id,
  TRY_CAST(winner_seed AS INTEGER) AS winner_seed,
  winner_entry::STRING AS winner_entry,
  winner_name::STRING AS winner_name,
  winner_hand::STRING AS winner_hand,
  TRY_CAST(winner_ht AS INTEGER) AS winner_ht,
  winner_ioc::STRING AS winner_ioc,
  TRY_CAST(winner_age AS INTEGER) AS winner_age,
  TRY_CAST(loser_seed AS INTEGER) AS loser_seed,
  loser_entry::STRING AS loser_entry,
  loser_name::STRING AS loser_name,
  loser_hand::STRING AS loser_hand,
  TRY_CAST(loser_ht AS INTEGER) AS loser_ht,
  loser_ioc::STRING AS loser_ioc,
  TRY_CAST(loser_age AS INTEGER) AS loser_age,
  score::STRING AS score,
  best_of::INTEGER AS best_of,
  round::STRING AS round,
  TRY_CAST(minutes AS INTEGER) AS minutes,
  TRY_CAST(w_ace AS INTEGER) AS w_ace,
  TRY_CAST(w_df AS INTEGER) AS w_df,
  TRY_CAST(w_svpt AS INTEGER) AS w_svpt,
  TRY_CAST(w_1st_in AS INTEGER) AS w_1st_in,
  TRY_CAST(w_1st_won AS INTEGER) AS w_1st_won,
  TRY_CAST(w_2nd_won AS INTEGER) AS w_2nd_won,
  TRY_CAST(w_sv_gms AS INTEGER) AS w_sv_gms,
  TRY_CAST(w_bp_saved AS INTEGER) AS w_bp_saved,
  TRY_CAST(w_bp_faced AS INTEGER) AS w_bp_faced,
  TRY_CAST(l_ace AS INTEGER) AS l_ace,
  TRY_CAST(l_df AS INTEGER) AS l_df,
  TRY_CAST(l_svpt AS INTEGER) AS l_svpt,
  TRY_CAST(l_1st_in AS INTEGER) AS l_1st_in,
  TRY_CAST(l_1st_won AS INTEGER) AS l_1st_won,
  TRY_CAST(l_2nd_won AS INTEGER) AS l_2nd_won,
  TRY_CAST(l_sv_gms AS INTEGER) AS l_sv_gms,
  TRY_CAST(l_bp_saved AS INTEGER) AS l_bp_saved,
  TRY_CAST(l_bp_faced AS INTEGER) AS l_bp_faced,
  TRY_CAST(winner_rank AS INTEGER) AS winner_rank,
  TRY_CAST(winner_rank_points AS INTEGER) AS winner_rank_points,
  TRY_CAST(loser_rank AS INTEGER) AS loser_rank,
  TRY_CAST(loser_rank_points AS INTEGER) AS loser_rank_points,
  year,
  updated_at
FROM atp_matches

