SELECT
	team_name,
	ticket_id,
	ticket_number,
	agent,
	MD5(agent_email) AS agent_email_md5,
	MAX(CONVERT_TZ(entry_created, '+00:00', :timezone)) AS last_entry,
	CASE WHEN ticket_closed IS NOT NULL THEN 1 ELSE 0 END AS ticket_closed
FROM
	stats_agents
WHERE
	CONVERT_TZ(entry_created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
	AND entry_type = 'R'
GROUP BY
	team_name,
	ticket_id,
	ticket_number,
	agent,
	MD5(agent_email)
ORDER BY last_entry DESC
