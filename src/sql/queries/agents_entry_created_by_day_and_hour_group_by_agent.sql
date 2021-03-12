SELECT
	agent,
	MD5(agent_email) AS agent_email_md5,
	DAYOFWEEK(entry_created) AS day_of_week,
	DAYNAME(entry_created) AS `day`,
	HOUR(entry_created) AS `hour`,
	COUNT(DAYNAME(entry_created)) AS tickets
FROM
	stats_agents
WHERE
	entry_created BETWEEN :date_from AND :date_to
GROUP BY
	agent,
	DAYNAME(entry_created),
	HOUR(entry_created)
ORDER BY
	DAYOFWEEK(entry_created) ASC,
	HOUR(entry_created) ASC
