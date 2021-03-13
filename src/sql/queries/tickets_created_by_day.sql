SELECT
	DATE(CONVERT_TZ(created, '+00:00', :timezone)) AS `day`,
	COUNT(DATE(CONVERT_TZ(created, '+00:00', :timezone))) AS tickets
FROM
	stats_tickets
WHERE
	CONVERT_TZ(created, '+00:00', :timezone) BETWEEN :date_from AND :date_to
GROUP BY
	DATE(CONVERT_TZ(created, '+00:00', :timezone))
ORDER BY
	day ASC
