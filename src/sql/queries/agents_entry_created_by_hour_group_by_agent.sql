SELECT
	agent,
	MD5(agent_email) AS agent_email_md5,
	HOUR(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS `hour`,
	COUNT(HOUR(CONVERT_TZ(entry_created, '+00:00', :timezone))) AS tickets
FROM
	stats_agents
WHERE
	CONVERT_TZ(entry_created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
GROUP BY
	agent,
	HOUR(CONVERT_TZ(entry_created, '+00:00', :timezone))
ORDER BY
	agent ASC,
	`hour` ASC
