# JOIN и WHERE

## 1. INNER JOIN

**Запрос**

```sql
SELECT
    o.order_number,
    c.full_name,
    o.status,
    o.total_amount
FROM orders AS o
INNER JOIN customers AS c
    ON c.id = o.customer_id
ORDER BY o.id;
```

**Зачем запрос**

Показать заказы вместе с покупателями. Такая выборка нужна для страницы заказов в админке: номер заказа сам по себе мало что говорит, а имя покупателя сразу даёт контекст.

**Результат**

![INNER JOIN](snapshots/04-inner-join.png)

## 2. LEFT JOIN

**Запрос**

```sql
SELECT
    o.order_number,
    o.status,
    e.event_type,
    INET6_NTOA(e.source_ip) AS source_ip
FROM orders AS o
LEFT JOIN order_events AS e
    ON e.order_id = o.id
ORDER BY o.id, e.id;
```

**Зачем запрос**

Показать все заказы и связанные с ними события. Если у заказа ещё нет событий, он всё равно попадёт в результат. Так проще найти заказы без технической истории.

**Результат**

![LEFT JOIN](snapshots/05-left-join.png)

## 3. WHERE: оператор `=`

**Запрос**

```sql
SELECT
    order_number,
    status,
    payment_status,
    total_amount
FROM orders
WHERE status = 'paid';
```

**Зачем запрос**

Найти оплаченные заказы. Такая выборка нужна перед упаковкой или передачей заказа в доставку.

**Результат**

![WHERE равно](snapshots/06-where-equals.png)

## 4. WHERE: оператор `BETWEEN`

**Запрос**

```sql
SELECT
    sku,
    title,
    price
FROM products
WHERE price BETWEEN 1000.00 AND 10000.00
ORDER BY price;
```

**Зачем запрос**

Отобрать товары в заданном ценовом диапазоне. Это обычный фильтр каталога: покупатель задаёт бюджет и видит подходящие позиции.

**Результат**

![WHERE BETWEEN](snapshots/07-where-between.png)

## 5. WHERE: оператор `IN`

**Запрос**

```sql
SELECT
    sku,
    title,
    category
FROM products
WHERE category IN ('electronics', 'digital');
```

**Зачем запрос**

Показать товары из нескольких категорий сразу. Такая выборка пригодится для витрины техники и цифровых продуктов.

**Результат**

![WHERE IN](snapshots/08-where-in.png)

## 6. WHERE: оператор `LIKE`

**Запрос**

```sql
SELECT
    full_name,
    email
FROM customers
WHERE email LIKE '%example.com';
```

**Зачем запрос**

Найти покупателей с почтой на конкретном домене. В проекте это может пригодиться для проверки тестовых аккаунтов или анализа корпоративных клиентов.

**Результат**

![WHERE LIKE](snapshots/09-where-like.png)

## 7. WHERE: функция `JSON_CONTAINS`

**Запрос**

```sql
SELECT
    sku,
    title,
    attributes->'$.features' AS features
FROM products
WHERE JSON_CONTAINS(
    JSON_EXTRACT(attributes, '$.features'),
    JSON_QUOTE('mechanical')
);
```

**Зачем запрос**

Найти товары с конкретной характеристикой внутри JSON. Это полезно, когда характеристики у разных категорий отличаются, но по части из них всё равно нужен поиск.

**Результат**

![WHERE JSON_CONTAINS](snapshots/10-where-json-contains.png)
