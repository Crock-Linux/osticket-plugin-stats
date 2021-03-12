-- Cantidad de contribuyentes con tickets de ventas por código de servicio
SELECT
	subject,
	COUNT(subject) AS tickets
FROM
	(
		SELECT DISTINCT
			subject,
			rut
		FROM
			stats_clients
		WHERE
			source = 'V'
			AND created BETWEEN :date_from AND :date_to
	) AS t
GROUP BY
	subject
ORDER BY
	tickets DESC
