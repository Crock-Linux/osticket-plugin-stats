SELECT
	st.ticket_id,
	st.`number` AS ticket_number,
	st.subject,
	st.created,
	st.team_name,
	st.user_id,
	st.user_name,
	st.user_email,
	COALESCE(ot.duedate, ot.est_duedate) AS duedate,
	CASE WHEN ot.reopened IS NOT NULL THEN 1 ELSE 0 END AS reopened
FROM
	stats_tickets AS st
	JOIN ost_ticket AS ot ON ot.ticket_id = st.ticket_id
WHERE
	ot.isoverdue = 1
ORDER BY duedate
