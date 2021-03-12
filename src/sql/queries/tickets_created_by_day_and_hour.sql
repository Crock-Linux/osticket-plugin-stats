SELECT
	DAYOFWEEK(created) AS day_of_week,
	DAYNAME(created) AS `day`,
	HOUR(created) AS `hour`,
	COUNT(DAYNAME(created)) AS tickets
FROM
	stats_tickets
WHERE
	created BETWEEN :date_from AND :date_to
GROUP BY
	DAYNAME(created),
	HOUR(created)
ORDER BY
	DAYOFWEEK(created) ASC,
	HOUR(created) ASC
