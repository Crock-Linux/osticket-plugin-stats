SELECT
	team_id,
	team_name,
	WEEK(CONVERT_TZ(created, '+00:00', :timezone)) AS `week`,
	DAYOFWEEK(CONVERT_TZ(created, '+00:00', :timezone)) AS day_of_week,
	DAYNAME(CONVERT_TZ(created, '+00:00', :timezone)) AS `day`,
	COUNT(DAYNAME (CONVERT_TZ(created, '+00:00', :timezone))) AS tickets
FROM
	stats_tickets
WHERE
	team_id IS NOT NULL
	AND CONVERT_TZ(created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
GROUP BY
	team_name,
	WEEK(CONVERT_TZ(created, '+00:00', :timezone)),
	DAYNAME(CONVERT_TZ(created, '+00:00', :timezone))
ORDER BY
	`week` ASC,
	day_of_week ASC
