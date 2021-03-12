-- Cantidad de tickets en orden descendente, por id usuario (cuántos tickets ha abierto un usuario en total)
SELECT
	rut,
	COUNT(rut) AS tickets,
	MIN(created) AS first_created,
	MAX(created) AS last_created,
	ROUND(AVG(service_time)) AS avg_service_time,
	SUM(client_messages) AS sum_client_messages,
	ROUND(AVG(client_messages)) AS avg_client_messages,
	SUM(staff_messages) AS sum_staff_messages,
	ROUND(AVG(staff_messages)) AS avg_staff_messages,
	SUM(internal_notes) AS sum_internal_notes,
	ROUND(AVG(internal_notes)) AS avg_internal_notes
FROM
	stats_clients
WHERE
	created BETWEEN :date_from AND :date_to
GROUP BY
	rut
ORDER BY
	tickets DESC
