SELECT
	agent,
	MD5(agent_email) AS agent_email_md5,
	WEEKOFYEAR(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS `week`,
	DAYOFWEEK(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS day_of_week,
	DAYNAME(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS `day`,
	COUNT(DAYNAME(CONVERT_TZ(entry_created, '+00:00', :timezone))) AS tickets
FROM
	stats_agents
WHERE
	CONVERT_TZ(entry_created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
GROUP BY
	agent,
	DAYNAME(CONVERT_TZ(entry_created, '+00:00', :timezone))
ORDER BY
	`week` ASC,
	day_of_week ASC
