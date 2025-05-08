WITH atp_matches AS (
    SELECT * FROM {{ source('raw_data', 'atp_matches') }}
), winners AS (
  SELECT
    DISTINCT
    winner_name AS desc_name,
    winner_id AS nk_id,
    winner_hand AS desc_hand,
    winner_ht AS mtr_height,
    year - TRY_CAST(winner_age AS INTEGER) AS mtr_year_of_birth,
    winner_ioc AS desc_ioc,
    FROM atp_matches
), losers AS (
  SELECT
    DISTINCT
    loser_name AS desc_name,
    loser_id AS nk_id,
    loser_hand AS desc_hand,
    loser_ht AS mtr_height,
    year - TRY_CAST(loser_age AS INTEGER) AS mtr_year_of_birth,
    loser_ioc AS desc_ioc,
    FROM atp_matches
), all_players AS (
SELECT
  *
FROM winners
UNION DISTINCT
SELECT
  *
FROM losers)

SELECT
	*,
  hash(MD5(CONCAT(desc_name, nk_id))) AS sk_player_key,
FROM all_players
QUALIFY ROW_NUMBER() OVER (PARTITION BY desc_name ORDER BY mtr_year_of_birth DESC) = 1
