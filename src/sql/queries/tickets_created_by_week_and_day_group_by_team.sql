SELECT
	team_id,
	team_name,
	WEEK(created) AS `week`,
	DAYOFWEEK(created) AS day_of_week,
	DAYNAME(created) AS `day`,
	COUNT(DAYNAME (created)) AS tickets
FROM
	stats_tickets
WHERE
	team_id IS NOT NULL AND created BETWEEN :date_from AND :date_to
GROUP BY
	team_name,
	WEEK(created),
	DAYNAME(created)
ORDER BY
	WEEK(created) ASC,
	DAYOFWEEK(created) ASC
