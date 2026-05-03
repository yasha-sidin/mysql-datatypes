SET NAMES utf8mb4;

USE mysql_datatypes;

INSERT INTO customers
    (customer_id, public_code, email, phone, full_name, birth_date, loyalty_points, rating, is_active, preferences)
VALUES
    (1, 'CUST00000001', 'anna.serova@example.com', '79990000001', 'Анна Серова', '1992-04-18', 1200, 5, TRUE,
     '{"newsletter": true, "favorite_categories": ["electronics", "home"], "limits": {"max_order_amount": 150000}}'),
    (2, 'CUST00000002', 'ivan.petrov@example.com', '79990000002', 'Иван Петров', '1988-11-03', 350, 4, TRUE,
     '{"newsletter": false, "favorite_categories": ["books"], "limits": {"max_order_amount": 50000}}'),
    (3, 'CUST00000003', 'maria.sokolova@example.com', NULL, 'Мария Соколова', NULL, 0, 3, TRUE,
     '{"newsletter": true, "favorite_categories": ["digital"], "limits": {"max_order_amount": 30000}}');

INSERT INTO products
    (product_id, sku, title, description, category, tags, price, weight_grams, stock_quantity, is_digital, manufactured_year, attributes)
VALUES
    (1, 'KB-MECH-001', 'Механическая клавиатура', 'Клавиатура с подсветкой и сменными переключателями.', 'electronics', 'new,heavy',
     8990.00, 980, 42, FALSE, 2025,
     '{"color": "black", "warranty_months": 24, "dimensions": {"width_mm": 435, "height_mm": 38, "depth_mm": 130}, "features": ["mechanical", "backlight", "hot-swap"]}'),
    (2, 'MUG-CER-330', 'Керамическая кружка 330 мл', 'Простая кружка для офиса и дома.', 'home', 'fragile,discount',
     690.00, 340, 120, FALSE, 2024,
     '{"color": "white", "volume_ml": 330, "material": "ceramic", "features": ["dishwasher-safe"]}'),
    (3, 'BOOK-SQL-001', 'Книга по SQL', 'Печатная книга с примерами запросов.', 'books', '',
     2490.00, 620, 18, FALSE, 2026,
     '{"color": "blue", "pages": 420, "language": "ru", "features": ["paperback", "examples"]}'),
    (4, 'COURSE-MYSQL', 'Онлайн-курс по MySQL', 'Цифровой продукт без физической доставки.', 'digital', 'digital,new',
     12900.00, NULL, 9999, TRUE, 2026,
     '{"color": "none", "duration_hours": 18, "access_days": 180, "features": ["video", "practice", "certificate"]}');

INSERT INTO orders
    (order_id, order_number, customer_id, status, payment_status, total_amount, delivery_date, delivery_time_from, delivery_time_to, paid_at, delivery_details, customer_comment)
VALUES
    (1, 'ORD-2026-0001', 1, 'paid', 'paid', 9680.00, '2026-05-05', '10:00:00', '14:00:00', CURRENT_TIMESTAMP(6),
     '{"city": "Москва", "street": "Тверская", "house": "1", "apartment": "12", "courier": {"company": "Boxberry", "tracking": "BB-1001"}, "coordinates": {"lat": 55.7558, "lon": 37.6173}}',
     'Позвонить за час до доставки.'),
    (2, 'ORD-2026-0002', 2, 'new', 'waiting', 2490.00, '2026-05-06', '18:00:00', '21:00:00', NULL,
     '{"city": "Санкт-Петербург", "street": "Невский проспект", "house": "10", "courier": {"company": "CDEK", "tracking": null}, "coordinates": {"lat": 59.9343, "lon": 30.3351}}',
     NULL),
    (3, 'ORD-2026-0003', 3, 'completed', 'paid', 12900.00, NULL, NULL, NULL, CURRENT_TIMESTAMP(6),
     '{"delivery_type": "digital", "email": "maria.sokolova@example.com", "access": {"days": 180, "starts_at": "2026-05-03"}}',
     'Доступ нужен сразу после оплаты.');

INSERT INTO order_items
    (order_item_id, order_id, product_id, quantity, unit_price, discount_percent)
VALUES
    (1, 1, 1, 1, 8990.00, 0.00),
    (2, 1, 2, 1, 690.00, 0.00),
    (3, 2, 3, 1, 2490.00, 0.00),
    (4, 3, 4, 1, 12900.00, 0.00);

INSERT INTO order_events
    (event_id, order_id, event_type, source_ip, payload)
VALUES
    (1, 1, 'created', INET6_ATON('127.0.0.1'), '{"actor": "system", "status": "new"}'),
    (2, 1, 'paid', INET6_ATON('192.168.10.15'), '{"actor": "payment-gateway", "transaction_id": "pay_1001", "amount": 9680.00}'),
    (3, 3, 'access_granted', INET6_ATON('2001:db8::10'), '{"actor": "learning-platform", "course": "COURSE-MYSQL", "access_days": 180}');
