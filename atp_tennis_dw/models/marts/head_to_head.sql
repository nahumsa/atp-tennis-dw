{{ config(
    materialized = 'table',
    indexes=[
      {'columns': ['player1_key'], 'type': 'hash'},
      {'columns': ['player2_key'], 'type': 'hash'},
    ]
)}}
WITH matches_fact AS (
    SELECT * FROM {{ ref('matches_fact') }}
), players_dim AS (
	SELECT * FROM {{ ref('players_dim') }}
)

SELECT
    CASE WHEN w.sk_player_key < l.sk_player_key THEN w.sk_player_key ELSE l.sk_player_key END AS player1_key,
    CASE WHEN w.sk_player_key < l.sk_player_key THEN l.sk_player_key ELSE w.sk_player_key END AS player2_key,
    COUNT(*) AS matches,
    SUM(CASE WHEN mf.fk_winner_id = CASE WHEN w.sk_player_key < l.sk_player_key THEN w.sk_player_key ELSE l.sk_player_key END THEN 1 ELSE 0 END) AS p1_wins,
    SUM(CASE WHEN mf.fk_winner_id = CASE WHEN w.sk_player_key < l.sk_player_key THEN l.sk_player_key ELSE w.sk_player_key END THEN 1 ELSE 0 END) AS p2_wins,
    ROUND(AVG(mf.mtr_minutes), 2) AS average_duration_time,
    SUM(CASE WHEN mf.fk_winner_id = CASE WHEN w.sk_player_key < l.sk_player_key THEN w.sk_player_key ELSE l.sk_player_key END THEN mf.nst_winner_stats.ace ELSE mf.nst_loser_stats.ace END) AS p1_total_aces,
    SUM(CASE WHEN mf.fk_winner_id = CASE WHEN w.sk_player_key < l.sk_player_key THEN l.sk_player_key ELSE w.sk_player_key END THEN mf.nst_winner_stats.ace ELSE mf.nst_loser_stats.ace END) AS p2_total_aces,
FROM
    matches_fact mf
JOIN
    players_dim w ON mf.fk_winner_id = w.sk_player_key
JOIN
    players_dim l ON mf.fk_loser_id = l.sk_player_key
GROUP BY
    CASE WHEN w.sk_player_key < l.sk_player_key THEN w.sk_player_key ELSE l.sk_player_key END,
    CASE WHEN w.sk_player_key < l.sk_player_key THEN l.sk_player_key ELSE w.sk_player_key END
