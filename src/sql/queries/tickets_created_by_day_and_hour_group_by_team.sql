SELECT
	team_id,
	team_name,
	DAYOFWEEK(created) AS day_of_week,
	DAYNAME(created) AS `day`,
	HOUR(created) AS `hour`,
	COUNT(DAYNAME (created)) AS tickets
FROM
	stats_tickets
WHERE
	team_id IS NOT NULL AND created BETWEEN :date_from AND :date_to
GROUP BY
	team_name,
	DAYNAME(created),
	HOUR(created)
ORDER BY
	DAYOFWEEK(created) ASC,
	HOUR(created) ASC
