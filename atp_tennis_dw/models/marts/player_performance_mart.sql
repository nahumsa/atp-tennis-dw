WITH matches_fact AS (
    SELECT * FROM {{ ref('matches_fact') }}
), players_dim AS (
	SELECT * FROM {{ ref('players_dim') }}
)

SELECT
    p.sk_player_key,
    p.desc_name,
    COUNT(CASE WHEN f.fk_winner_id = p.sk_player_key THEN 1 END) AS wins,
    COUNT(CASE WHEN f.fk_winner_id = p.sk_player_key OR f.fk_loser_id = p.sk_player_key THEN 1 END) AS total_matches,
    ROUND(CAST(SUM(CASE WHEN f.fk_winner_id = p.sk_player_key THEN 1 ELSE 0 END) AS NUMERIC) / COUNT(CASE WHEN f.fk_winner_id = p.sk_player_key OR f.fk_loser_id = p.sk_player_key THEN 1 END), 2) AS win_percentage,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN f.mtr_minutes END), 2) AS avg_win_duration,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN f.mtr_minutes END), 2) AS avg_loss_duration,
FROM
    players_dim p
LEFT JOIN
    matches_fact f ON p.sk_player_key = f.fk_winner_id OR p.sk_player_key = f.fk_loser_id
GROUP BY
    p.sk_player_key, p.desc_name
