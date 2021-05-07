-- ruts que han solicitado alguna integración con ecommerce
SELECT DISTINCT
	DATE_FORMAT(created, '%Y-%m-%d') AS created,
	rut,
	user_name,
	user_email,
	CASE
		WHEN body LIKE '%woocommerce%' THEN 'woocommerce'
		WHEN body LIKE '%jumpseller%' THEN 'jumpseller'
		WHEN body LIKE '%shopify%' THEN 'shopify'
		WHEN body LIKE '%spincommerce%' THEN 'spincommerce'
	END AS ecommerce
FROM
	stats_clients
WHERE
	source = 'V'
	AND (
		body LIKE '%woocommerce%'
		OR body LIKE '%jumpseller%'
		OR body LIKE '%shopify%'
		OR body LIKE '%spincommerce%'
	)
ORDER BY
	created DESC, rut
