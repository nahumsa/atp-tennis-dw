{{ config(
    materialized = 'table',
    indexes=[
      {'columns': ['sk_player_key'], 'type': 'hash'},
    ]
)}}
WITH players_dim AS (
	SELECT * FROM {{ ref('players_dim') }}
)

SELECT
  sk_player_key,
  nk_id,
  desc_name,
  desc_hand,
  mtr_year_of_birth,
  mtr_height,
  desc_ioc
FROM
    players_dim
