---
title: "Tennis Analytics Dashboard"
---

## 📊 Overview

```SQL total_players
SELECT
  COUNT(*) AS val
FROM players_dim;
```

```SQL avg_height
SELECT
  ROUND(AVG(mtr_height),0) AS val
FROM players_dim;
```

```sql avg_yob
SELECT
  ROUND(AVG(mtr_year_of_birth),0) AS val
FROM players_dim;
```

```sql total_countries
SELECT
  COUNT(DISTINCT desc_ioc) AS val
FROM players_dim;
```

<BigValue title="Total Players" data={total_players} value=val />
<BigValue title="Avg Height (cm)" data={avg_height} value=val />
<BigValue title="Avg Year of Birth" data={avg_yob} value=val />
<BigValue title="Countries Represented" data={total_countries} value=val />

---

## 📈 Player Performance Trends

```sql players
SELECT DISTINCT
  d.desc_name AS value
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key;
```

```sql years
SELECT DISTINCT
  f.mtr_year AS value
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}'
ORDER BY 1 DESC;
```

```sql win_pct
SELECT
  f.mtr_year,
  f.win_percentage
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}';
```

```sql wins_matches
SELECT
  f.mtr_year,
  f.wins,
  f.total_matches
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}';
```

```sql avg_win_dur
SELECT
  ROUND(AVG(f.avg_win_duration_minutes),1) AS val
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}';
```

```sql avg_loss_dur
SELECT
  ROUND(AVG(f.avg_loss_duration_minutes), 1) AS val
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}';
```

<Dropdown name=player title="Select Player" data={players} defaultValue="Roger Federer"/>
<Dropdown name=year title="Select Year" data={years} />

<BarChart title="Win Percentage by Year" x=mtr_year y=win_percentage data={win_pct} />
<BarChart title="Wins vs Matches" x=mtr_year y=wins y2=total_matches data={wins_matches} />

<BigValue title="Avg Win Duration (min)" data={avg_win_dur} value=val />
<BigValue title="Avg Loss Duration (min)" data={avg_loss_dur} value=val />

---

## 🎯 Single Player Detailed Statistics

```sql serve_stats
SELECT
  f.mtr_year,
  ROUND(AVG(f.avg_win_ace_pct),2) AS win_aces,
  ROUND(AVG(f.avg_loss_ace_pct),2) AS loss_aces,
  ROUND(AVG(f.avg_win_double_fault_pct),2) AS win_df,
  ROUND(AVG(f.avg_loss_double_fault_pct),2) AS loss_df
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}'
GROUP BY f.mtr_year
ORDER BY f.mtr_year;
```

<LineChart title="Ace % (Wins vs Losses)" x="mtr_year" y="win_aces" y2="loss_aces" data={serve_stats} />
<LineChart title="Double Fault % (Wins vs Losses)" x="mtr_year" y="win_df" y2="loss_df" data={serve_stats} />

---

```sql serve_effectiveness
SELECT
  f.mtr_year,
  ROUND(AVG(f.avg_win_first_serve_made_pct),2) AS first_in,
  ROUND(AVG(f.avg_win_first_serve_won_pct),2) AS first_won,
  ROUND(AVG(f.avg_win_second_serve_won_pct),2) AS second_won
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}'
GROUP BY f.mtr_year
ORDER BY f.mtr_year;
```

<LineChart title="Serve Effectiveness (Wins)" x="mtr_year" y="first_in" y2="first_won" y3="second_won" data={serve_effectiveness} />

---

```sql points_stats
SELECT
  f.mtr_year,
  ROUND(AVG(f.avg_win_serve_points_won_pct),2) AS serve_pts,
  ROUND(AVG(f.avg_win_receiving_points_won_pct),2) AS receiving_pts,
  ROUND(AVG(f.avg_win_total_points_won_pct),2) AS total_pts
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}'
GROUP BY f.mtr_year
ORDER BY f.mtr_year;
```

<LineChart title="Points Won % (Serve, Receiving, Total)" x="mtr_year" y="serve_pts" y2="receiving_pts" y3="total_pts" data={points_stats} />

---

```sql overall_summary
SELECT
  ROUND(AVG(f.avg_win_ace_pct),2) AS avg_aces,
  ROUND(AVG(f.avg_win_double_fault_pct),2) AS avg_df,
  ROUND(AVG(f.avg_win_first_serve_won_pct),2) AS first_won,
  ROUND(AVG(f.avg_win_second_serve_won_pct),2) AS second_won,
  ROUND(AVG(f.avg_win_total_points_won_pct),2) AS total_pts
FROM player_performance f
INNER JOIN players_dim d
  ON f.sk_player_key = d.sk_player_key
WHERE d.desc_name = '${inputs.player.value}';
```

<BigValue title="Avg Ace %" data={overall_summary} value=avg_aces />
<BigValue title="Avg Double Fault %" data={overall_summary} value=avg_df />
<BigValue title="First Serve Points Won %" data={overall_summary} value=first_won />
<BigValue title="Second Serve Points Won %" data={overall_summary} value=second_won />
<BigValue title="Total Points Won %" data={overall_summary} value=total_pts />

---

## ⚔️ Head-to-Head Analysis

```sql headtohead_players
SELECT DISTINCT
  desc_name AS value
FROM players_dim
ORDER BY 1;
```

```sql h2h_matches
SELECT h.matches AS val
FROM head_to_head h
INNER JOIN players_dim p1
  ON h.player1_key = p1.sk_player_key
INNER JOIN players_dim p2
  ON h.player2_key = p2.sk_player_key
WHERE p1.desc_name = '${inputs.player1.value}'
  AND p2.desc_name = '${inputs.player2.value}';
```

```sql h2h_p1_wins
SELECT h.p1_wins AS val
FROM head_to_head h
INNER JOIN players_dim p1
  ON h.player1_key = p1.sk_player_key
INNER JOIN players_dim p2
  ON h.player2_key = p2.sk_player_key
WHERE p1.desc_name = '${inputs.player1.value}'
  AND p2.desc_name = '${inputs.player2.value}';
```

```sql h2h_p2_wins
SELECT h.p2_wins AS val
FROM head_to_head h
INNER JOIN players_dim p1
  ON h.player1_key = p1.sk_player_key
INNER JOIN players_dim p2
  ON h.player2_key = p2.sk_player_key
WHERE p1.desc_name = '${inputs.player1.value}'
  AND p2.desc_name = '${inputs.player2.value}';
```

```sql h2h_avg_dur
SELECT ROUND(h.average_duration_time,1) AS val
FROM head_to_head h
INNER JOIN players_dim p1
  ON h.player1_key = p1.sk_player_key
INNER JOIN players_dim p2
  ON h.player2_key = p2.sk_player_key
WHERE p1.desc_name = '${inputs.player1.value}'
  AND p2.desc_name = '${inputs.player2.value}';
```

```sql h2h_aces
SELECT p1.desc_name AS player, h.p1_total_aces AS aces
FROM head_to_head h
INNER JOIN players_dim p1
  ON h.player1_key = p1.sk_player_key
INNER JOIN players_dim p2
  ON h.player2_key = p2.sk_player_key
WHERE p1.desc_name = '${inputs.player1.value}'
  AND p2.desc_name = '${inputs.player2.value}'
UNION ALL
SELECT p2.desc_name AS player, h.p2_total_aces AS aces
FROM head_to_head h
INNER JOIN players_dim p1
  ON h.player1_key = p1.sk_player_key
INNER JOIN players_dim p2
  ON h.player2_key = p2.sk_player_key
WHERE p1.desc_name = '${inputs.player1.value}'
  AND p2.desc_name = '${inputs.player2.value}';
```

<Dropdown name=player1 title="Select Player 1" data={headtohead_players} defaultValue="Novak Djokovic"/>
<Dropdown name=player2 title="Select Player 2" data={headtohead_players} defaultValue="Carloz Alcaraz"/>

<Grid cols=2>
<BigValue title="Matches Played" data={h2h_matches} value=val />
<BigValue title="P1 Wins" data={h2h_p1_wins} value=val />
<BigValue title="P2 Wins" data={h2h_p2_wins} value=val />
<BigValue title="Avg Match Duration" data={h2h_avg_dur} value=val />
</Grid>

<BarChart title="Aces (P1 vs P2)" x=player y=aces data={h2h_aces} />
