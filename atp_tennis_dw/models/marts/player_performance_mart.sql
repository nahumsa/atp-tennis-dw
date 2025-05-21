WITH matches_fact AS (
    SELECT * FROM {{ ref('matches_fact') }}
), players_dim AS (
	SELECT * FROM {{ ref('players_dim') }}
)

SELECT
    p.sk_player_key,
    f.nk_tournament_id,
    p.desc_name,
    f.mtr_year,
    COUNT(CASE WHEN f.fk_winner_id = p.sk_player_key THEN 1 END) AS wins,
    COUNT(CASE WHEN f.fk_winner_id = p.sk_player_key OR f.fk_loser_id = p.sk_player_key THEN 1 END) AS total_matches,
    ROUND(CAST(SUM(CASE WHEN f.fk_winner_id = p.sk_player_key THEN 1 ELSE 0 END) AS NUMERIC) / COUNT(CASE WHEN f.fk_winner_id = p.sk_player_key OR f.fk_loser_id = p.sk_player_key THEN 1 END), 2) AS win_percentage,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN f.mtr_minutes END), 2) AS avg_win_duration_minutes,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN f.mtr_minutes END), 2) AS avg_loss_duration_minutes,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN f.nst_winner_stats.ace / f.nst_winner_stats.serve_points END), 2) AS avg_win_ace_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN f.nst_loser_stats.ace / f.nst_loser_stats.serve_points END), 2) AS avg_loss_ace_pct,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN f.nst_winner_stats.double_fault / f.nst_winner_stats.serve_points END), 2) AS avg_win_double_fault_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN f.nst_loser_stats.double_fault / f.nst_loser_stats.serve_points END), 2) AS avg_loss_double_fault_pct,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN f.nst_winner_stats.first_serve_made / f.nst_winner_stats.serve_points END), 2) AS avg_win_first_serve_made_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN f.nst_loser_stats.first_serve_made / f.nst_loser_stats.serve_points END), 2) AS avg_loss_first_serve_made_pct,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN f.nst_winner_stats.first_serve_won / f.nst_winner_stats.serve_points END), 2) AS avg_win_first_serve_won_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN f.nst_loser_stats.first_serve_won / f.nst_loser_stats.serve_points END), 2) AS avg_loss_first_serve_won_pct,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN f.nst_winner_stats.second_serve_won / f.nst_winner_stats.serve_points END), 2) AS avg_win_second_serve_won_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN f.nst_loser_stats.second_serve_won / f.nst_loser_stats.serve_points END), 2) AS avg_loss_second_serve_won_pct,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN (f.nst_winner_stats.first_serve_won + f.nst_winner_stats.second_serve_won) / f.nst_winner_stats.serve_points END), 2) AS avg_win_serve_points_won_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN (f.nst_loser_stats.first_serve_won + f.nst_loser_stats.second_serve_won) / f.nst_loser_stats.serve_points END), 2) AS avg_loss_serve_points_won_pct,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN (f.nst_loser_stats.serve_points - f.nst_loser_stats.first_serve_won - f.nst_loser_stats.second_serve_won) / f.nst_loser_stats.serve_points END), 2) AS avg_win_receiving_points_won_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN (f.nst_winner_stats.serve_points - f.nst_winner_stats.first_serve_won - f.nst_winner_stats.second_serve_won) / f.nst_winner_stats.serve_points END), 2) AS avg_loss_receiving_points_won_pct,
    ROUND(AVG(CASE WHEN f.fk_winner_id = p.sk_player_key THEN ((f.nst_winner_stats.first_serve_won + f.nst_winner_stats.second_serve_won) + (f.nst_loser_stats.serve_points - f.nst_loser_stats.first_serve_won - f.nst_loser_stats.second_serve_won)) / (f.nst_loser_stats.serve_points + f.nst_winner_stats.serve_points) END), 2) AS avg_win_total_points_won_pct,
    ROUND(AVG(CASE WHEN f.fk_loser_id = p.sk_player_key THEN ((f.nst_winner_stats.first_serve_won + f.nst_winner_stats.second_serve_won) + (f.nst_loser_stats.serve_points - f.nst_loser_stats.first_serve_won - f.nst_loser_stats.second_serve_won)) / (f.nst_loser_stats.serve_points + f.nst_winner_stats.serve_points) END), 2) AS avg_loss_total_points_won_pct,
FROM
    players_dim p
LEFT JOIN
    matches_fact f ON p.sk_player_key = f.fk_winner_id OR p.sk_player_key = f.fk_loser_id
GROUP BY
    p.sk_player_key, p.desc_name, f.mtr_year
ORDER BY desc_name, mtr_year DESC
