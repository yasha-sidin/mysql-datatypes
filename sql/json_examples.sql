SET NAMES utf8mb4;

USE mysql_datatypes;

INSERT INTO order_events (order_id, event_type, source_ip, payload)
SELECT
    o.order_id,
    'json_checked',
    INET6_ATON('10.10.0.5'),
    JSON_OBJECT(
        'checked_by', 'sql/json_examples.sql',
        'fields', JSON_ARRAY('delivery_details.city', 'products.attributes.color')
    )
FROM orders AS o
WHERE o.order_number = 'ORD-2026-0001'
  AND NOT EXISTS (
      SELECT 1
      FROM order_events AS e
      WHERE e.order_id = o.order_id
        AND e.event_type = 'json_checked'
  );

UPDATE customers
SET preferences = JSON_ARRAY_APPEND(preferences, '$.favorite_categories', 'books')
WHERE email = 'anna.serova@example.com'
  AND JSON_CONTAINS(JSON_EXTRACT(preferences, '$.favorite_categories'), JSON_QUOTE('books')) = 0;

SELECT
    product_id,
    sku,
    title,
    color AS indexed_color,
    JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.dimensions.width_mm')) AS width_mm,
    JSON_EXTRACT(attributes, '$.features') AS features
FROM products
ORDER BY product_id;

SELECT
    order_number,
    delivery_details->>'$.city' AS city,
    delivery_details->>'$.courier.company' AS courier_company,
    delivery_details->>'$.coordinates.lat' AS latitude
FROM orders
WHERE delivery_details->>'$.city' = 'Москва';

SELECT
    c.full_name,
    preferred.category
FROM customers AS c
JOIN JSON_TABLE(
    c.preferences,
    '$.favorite_categories[*]'
    COLUMNS (
        category VARCHAR(40) PATH '$'
    )
) AS preferred
ORDER BY c.customer_id, preferred.category;

SELECT
    sku,
    title
FROM products
WHERE JSON_CONTAINS(JSON_EXTRACT(attributes, '$.features'), JSON_QUOTE('mechanical'));

SELECT
    event_type,
    INET6_NTOA(source_ip) AS source_ip,
    JSON_PRETTY(payload) AS payload
FROM order_events
ORDER BY event_id;
