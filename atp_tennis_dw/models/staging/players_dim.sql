WITH atp_matches AS (
    SELECT * FROM {{ source('raw_data', 'atp_matches') }}
), winners AS (
  SELECT
    DISTINCT
    winner_name AS name,
    winner_id AS id,
    winner_hand AS hand,
    winner_ht AS height,
    year - TRY_CAST(winner_age AS INTEGER) AS year_of_birth,
    winner_ioc AS ioc,
    FROM atp_matches
), losers AS (
  SELECT
    DISTINCT
    loser_name AS name,
    loser_id AS id,
    loser_hand AS hand,
    loser_ht AS height,
    year - TRY_CAST(loser_age AS INTEGER) AS year_of_birth,
    loser_ioc AS ioc,
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
	*
FROM all_players
QUALIFY ROW_NUMBER() OVER (PARTITION BY name ORDER BY year_of_birth DESC) = 1
