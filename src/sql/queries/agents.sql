SELECT
	as2.agent,
	MD5(as2.agent_email) AS agent_email_md5,
	r.messages_tickets,
	r.messages_total,
	n.internal_notes_tickets,
	n.internal_notes_total,
	COUNT(DISTINCT ticket_id) AS actions_tickets,
	COUNT(ticket_id) AS actions_total
FROM
	stats_agents as2
	JOIN ost_staff os ON os.staff_id = as2.agent_id
	LEFT JOIN (
		SELECT
			agent,
			COUNT(DISTINCT ticket_id) AS messages_tickets,
			COUNT(ticket_id) AS messages_total
		FROM
			stats_agents
		WHERE
			entry_type = 'R'
			AND CONVERT_TZ(entry_created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
		GROUP BY
			agent
	) AS r ON r.agent = as2.agent
	LEFT JOIN (
		SELECT
			agent,
			COUNT(DISTINCT ticket_id) AS internal_notes_tickets,
			COUNT(ticket_id) AS internal_notes_total
		FROM
			stats_agents
		WHERE
			entry_type = 'N'
			AND CONVERT_TZ(entry_created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
		GROUP BY
			agent
	) AS n ON n.agent = as2.agent
WHERE
        CONVERT_TZ(as2.entry_created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
GROUP BY
	as2.agent
ORDER BY
	actions_total DESC
