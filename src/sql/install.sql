-- estadísticas de los agentes
CREATE OR REPLACE VIEW stats_agents AS
SELECT
    os.staff_id AS agent_id,
    CONCAT(os.firstname, ' ', os.lastname) AS agent,
    os.email AS agent_email,
    os.dept_id AS department_id,
    od.name AS department_name,
    ot.ticket_id,
    ot.`number` AS ticket_number,
    ot.created AS ticket_created,
    ot.closed AS ticket_closed,
    DATEDIFF(ot.closed, ot.created)  AS ticket_service_time,
    ote.`type` AS entry_type,
    ote.created AS entry_created,
    ot3.team_id,
    ot3.name AS team_name,
    oht.topic_id,
    oht.topic AS topic_name
FROM
    ost_thread_entry ote
    JOIN ost_thread ot2 ON ot2.id = ote.thread_id
    JOIN ost_ticket ot ON ot.ticket_id = ot2.object_id
    JOIN ost_staff os ON os.staff_id = ote.staff_id
    JOIN ost_department od ON od.id = os.dept_id
    LEFT JOIN ost_team ot3 ON ot3.team_id = ot.team_id
    LEFT JOIN ost_help_topic oht  ON oht.topic_id = ot.topic_id
;

-- estadísticas de los tickets
CREATE OR REPLACE VIEW stats_tickets AS
SELECT
    ot.ticket_id,
    ot.`number`,
    otc.subject,
    ot.created,
    ot.closed,
    DATEDIFF(ot.closed, ot.created)  AS service_time,
    ot3.team_id,
    ot3.name AS team_name,
    oht.topic_id,
    oht.topic AS topic_name,
    ou.id AS user_id,
    ou.name AS user_name,
    oue.address AS user_email,
    cm.client_messages,
    sm.staff_messages,
    `in`.internal_notes
FROM
    ost_ticket ot
    JOIN ost_ticket__cdata otc ON otc.ticket_id = ot.ticket_id
    JOIN ost_user ou ON ou.id = ot.user_id
    JOIN ost_user_email oue ON oue.id = ou.default_email_id
    LEFT JOIN (
        SELECT
            ot2.object_id AS ticket_id,
            COUNT(*) AS client_messages
        FROM
            ost_thread ot2
            JOIN ost_thread_entry ote ON ote.thread_id = ot2.id
        WHERE
            type = 'M'
        GROUP BY
            ot2.object_id
    ) AS cm ON cm.ticket_id = ot.ticket_id
    LEFT JOIN (
        SELECT
            ot2.object_id AS ticket_id,
            COUNT(*) AS staff_messages
        FROM
            ost_thread ot2
            JOIN ost_thread_entry ote ON ote.thread_id = ot2.id
        WHERE
            type = 'R'
        GROUP BY
            ot2.object_id
    ) AS sm ON sm.ticket_id = ot.ticket_id
    LEFT JOIN (
        SELECT
            ot2.object_id AS ticket_id,
            COUNT(*) AS internal_notes
        FROM
            ost_thread ot2
            JOIN ost_thread_entry ote ON ote.thread_id = ot2.id
        WHERE
            type = 'N' AND poster != 'SYSTEM'
        GROUP BY
            ot2.object_id
    ) AS `in` ON `in`.ticket_id = ot.ticket_id
    LEFT JOIN ost_team ot3 ON ot3.team_id = ot.team_id
    LEFT JOIN ost_help_topic oht  ON oht.topic_id = ot.topic_id
;

-- estadísticas de los clientes
CREATE OR REPLACE VIEW stats_clients AS
SELECT
    t.source,
    t.ticket_id,
    ot.`number`,
    t.subject,
    t.rut,
    cm.body,
    ot.created,
    ot.closed,
    DATEDIFF(ot.closed, ot.created)  AS service_time,
    ot3.team_id,
    ot3.name AS team_name,
    oht.topic_id,
    oht.topic AS topic_name,
    ou.id AS user_id,
    ou.name AS user_name,
    oue.address AS user_email,
    cm.client_messages,
    sm.staff_messages,
    `in`.internal_notes
FROM
    (
        (
            SELECT
                'S' AS source,
                ot.ticket_id,
                TRIM(SUBSTRING(otc.subject,LOCATE(']',otc.subject,2)+1)) AS subject,
                TRIM(SUBSTRING(otc.subject,2,LOCATE(']',otc.subject,2)-2)) AS rut
            FROM
                ost_ticket ot
                JOIN ost_ticket__cdata otc ON otc.ticket_id = ot.ticket_id
            WHERE
                otc.subject LIKE '{SUBJECT_SUPPORT_LIKE}'
        ) UNION(
            SELECT
                'V' AS source,
                ot.ticket_id,
                TRIM(SUBSTRING(subject, 19, LOCATE(' ', subject, 19) - 19)) AS subject,
                TRIM(SUBSTRING(subject, LOCATE(' ', subject, 19) + 1, LOCATE(' ', subject, LOCATE(' ', subject, 19) + 1) - LOCATE(' ', subject, 19) - 1)) AS rut
            FROM
                ost_ticket ot
            JOIN ost_ticket__cdata otc ON otc.ticket_id = ot.ticket_id
            WHERE
                subject LIKE '{SUBJECT_SALES_LIKE}'
        )
    ) AS t
    JOIN ost_ticket ot ON ot.ticket_id = t.ticket_id
    JOIN ost_user ou ON ou.id = ot.user_id
    JOIN ost_user_email oue ON oue.id = ou.default_email_id
    LEFT JOIN (
        SELECT
            ot2.object_id AS ticket_id,
            ote.body,
            COUNT(*) AS client_messages
        FROM
            ost_thread ot2
            JOIN ost_thread_entry ote ON ote.thread_id = ot2.id
        WHERE
            type = 'M'
        GROUP BY
            ot2.object_id
    ) AS cm ON cm.ticket_id = ot.ticket_id
    LEFT JOIN (
        SELECT
            ot2.object_id AS ticket_id,
            COUNT(*) AS staff_messages
        FROM
            ost_thread ot2
            JOIN ost_thread_entry ote ON ote.thread_id = ot2.id
        WHERE
            type = 'R'
        GROUP BY
            ot2.object_id
    ) AS sm ON sm.ticket_id = ot.ticket_id
    LEFT JOIN (
        SELECT
            ot2.object_id AS ticket_id,
            COUNT(*) AS internal_notes
        FROM
            ost_thread ot2
            JOIN ost_thread_entry ote ON ote.thread_id = ot2.id
        WHERE
            type = 'N' AND poster != 'SYSTEM'
        GROUP BY
            ot2.object_id
    ) AS `in` ON `in`.ticket_id = ot.ticket_id
    LEFT JOIN ost_team ot3 ON ot3.team_id = ot.team_id
    LEFT JOIN ost_help_topic oht  ON oht.topic_id = ot.topic_id
;
