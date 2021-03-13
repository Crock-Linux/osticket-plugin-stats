SELECT
	DAYOFWEEK(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS day_of_week,
	DAYNAME(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS `day`,
	HOUR(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS `hour`,
	COUNT(DAYNAME(CONVERT_TZ(entry_created, '+00:00', :timezone))) AS tickets
FROM
	stats_agents
WHERE
	CONVERT_TZ(entry_created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
GROUP BY
	DAYNAME(CONVERT_TZ(entry_created, '+00:00', :timezone)),
	HOUR(CONVERT_TZ(entry_created, '+00:00', :timezone))
ORDER BY
	day_of_week ASC,
	`hour` ASC
