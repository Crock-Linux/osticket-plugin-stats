SELECT
	WEEKOFYEAR(created) AS `week`,
	DAYOFWEEK(created) AS day_of_week,
	DAYNAME(created) AS `day`,
	COUNT(DAYNAME(created)) AS tickets
FROM
	stats_tickets
WHERE
	created BETWEEN :date_from AND :date_to
GROUP BY
	WEEKOFYEAR(created),
	DAYNAME(created)
ORDER BY
	WEEKOFYEAR(created) ASC,
	DAYOFWEEK(created) ASC
