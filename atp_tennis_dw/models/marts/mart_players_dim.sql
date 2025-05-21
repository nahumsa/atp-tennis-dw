WITH players_dim AS (
	SELECT * FROM {{ ref('players_dim') }}
)

SELECT
  *
FROM
    players_dim
