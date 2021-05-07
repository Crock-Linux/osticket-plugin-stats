-- ruts que han solicitado servicios con sus datos
SELECT DISTINCT
	DATE_FORMAT(created, '%Y-%m-%d') AS created,
	rut,
	user_name,
	user_email,
	subject AS service
FROM
	stats_clients
WHERE
	source = 'V'
ORDER BY
	created DESC, subject
