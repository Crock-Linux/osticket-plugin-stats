SELECT
	agent,
	MD5(agent_email) AS agent_email_md5,
	WEEKOFYEAR(entry_created) AS `week`,
	DAYOFWEEK(entry_created) AS day_of_week,
	DAYNAME(entry_created) AS `day`,
	COUNT(DAYNAME(entry_created)) AS tickets
FROM
	stats_agents
WHERE
	entry_created BETWEEN :date_from AND :date_to
GROUP BY
	agent,
	DAYNAME(entry_created)
ORDER BY
	WEEKOFYEAR(entry_created) ASC,
	DAYOFWEEK(entry_created) ASC
