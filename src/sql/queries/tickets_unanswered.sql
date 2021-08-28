SELECT
    st.ticket_id,
    st.`number` AS ticket_number,
    st.subject,
    st.created,
    st.staff_id,
    st.staff_name,
    st.team_id,
    st.team_name,
    st.user_id,
    st.user_name,
    st.user_email,
    st.staff_messages,
    CASE WHEN st.reopened IS NOT NULL THEN 1 ELSE 0 END AS reopened
FROM
    stats_tickets AS st
WHERE
    st.closed IS NULL
    AND st.isanswered = 0
ORDER BY staff_messages
