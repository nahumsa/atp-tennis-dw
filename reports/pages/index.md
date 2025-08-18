---
title: Player Performance
queries:
  - players: players.sql
---

## 1. Player Profile

```sql years
SELECT
 DISTINCT
  mtr_year AS year,
FROM
    player_performance f
INNER JOIN
    players_dim d
ON f.sk_player_key = d.sk_player_key
WHERE 1=1
    AND d.desc_name = '${inputs.player1.value}'
ORDER BY 1 DESC;
```

<Dropdown data={players} name=player1 value=player_name>
    <DropdownOption value="Roger Federer" valueLabel="All players" defaultValue="Roger Federer"/>
</Dropdown>
<Dropdown data={years} name=year1 value=year>
<DropdownOption  valueLabel="Year" defaultValue="2024"/>
</Dropdown>

```sql player_desc
SELECT
  desc_name AS name,
  desc_hand AS hand,
  mtr_year_of_birth AS year_of_birth,
  mtr_height as height,
  desc_ioc AS country
FROM
  atp_dw.players_dim
WHERE
  desc_name LIKE '${inputs.player1.value}';
```

```sql player_stats
SELECT
    mtr_year,
    desc_tournament_name,
    desc_surface,
    wins,
    total_matches,
    win_percentage,
    avg_win_duration_minutes,
    avg_loss_duration_minutes
FROM
    player_performance f
INNER JOIN
    players_dim d
ON f.sk_player_key = d.sk_player_key
INNER JOIN
    tournament_dim t
ON f.fk_tournament_key = t.sk_tournament_key
WHERE 1=1
    AND d.desc_name = '${inputs.player1.value}'
    AND f.mtr_year = ${inputs.year1.value}
ORDER BY
    mtr_year DESC;
```

{#if players.length == 1}
{/if}

<BigValue
data={player_desc}
value=name
/>
<BigValue
data={player_desc}
value=hand
/>
<BigValue
data={player_desc}
value=height
/>
<BigValue
data={player_desc}
value=country
/>
