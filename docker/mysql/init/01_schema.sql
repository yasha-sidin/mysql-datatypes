SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS mysql_datatypes
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE mysql_datatypes;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_events;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers
(
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_code    CHAR(12)        NOT NULL,
    email          VARCHAR(320)    NOT NULL,
    phone          CHAR(11)        NULL,
    full_name      VARCHAR(160)    NOT NULL,
    birth_date     DATE            NULL,
    loyalty_points INT UNSIGNED    NOT NULL DEFAULT 0,
    rating         TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active      BOOLEAN         NOT NULL DEFAULT TRUE,
    registered_at  TIMESTAMP(6)    NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    preferences    JSON            NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_customers_public_code (public_code),
    UNIQUE KEY uq_customers_email (email),
    CHECK (rating <= 5),
    CHECK (JSON_TYPE(preferences) = 'OBJECT')
) ENGINE = InnoDB;

CREATE TABLE products
(
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    sku              VARCHAR(32)     NOT NULL,
    title            VARCHAR(160)    NOT NULL,
    description      TEXT            NULL,
    category         ENUM ('electronics', 'home', 'books', 'food', 'digital') NOT NULL,
    tags             SET ('fragile', 'discount', 'new', 'digital', 'heavy') NOT NULL DEFAULT '',
    price            DECIMAL(10, 2)  NOT NULL,
    weight_grams     MEDIUMINT UNSIGNED NULL,
    stock_quantity   INT UNSIGNED    NOT NULL DEFAULT 0,
    is_digital       BOOLEAN         NOT NULL DEFAULT FALSE,
    manufactured_year YEAR           NULL,
    attributes       JSON            NOT NULL,
    color            VARCHAR(32) GENERATED ALWAYS AS
        (JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.color'))) STORED,
    created_at       DATETIME(6)     NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uq_products_sku (sku),
    KEY ix_products_category (category),
    KEY ix_products_color (color),
    CHECK (price >= 0),
    CHECK (stock_quantity >= 0),
    CHECK (JSON_TYPE(attributes) = 'OBJECT')
) ENGINE = InnoDB;

CREATE TABLE orders
(
    id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_number       CHAR(14)        NOT NULL,
    customer_id        BIGINT UNSIGNED NOT NULL,
    status             ENUM ('new', 'paid', 'packed', 'shipped', 'completed', 'cancelled') NOT NULL DEFAULT 'new',
    payment_status     ENUM ('waiting', 'paid', 'refunded') NOT NULL DEFAULT 'waiting',
    total_amount       DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    delivery_date      DATE            NULL,
    delivery_time_from TIME            NULL,
    delivery_time_to   TIME            NULL,
    created_at         DATETIME(6)     NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    paid_at            TIMESTAMP(6)    NULL DEFAULT NULL,
    delivery_details   JSON            NOT NULL,
    customer_comment   VARCHAR(500)    NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_orders_order_number (order_number),
    KEY ix_orders_customer_created (customer_id, created_at),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (total_amount >= 0),
    CHECK (delivery_time_to IS NULL OR delivery_time_from IS NULL OR delivery_time_to > delivery_time_from),
    CHECK (JSON_TYPE(delivery_details) = 'OBJECT')
) ENGINE = InnoDB;

CREATE TABLE order_items
(
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id        BIGINT UNSIGNED NOT NULL,
    product_id      BIGINT UNSIGNED NOT NULL,
    quantity        SMALLINT UNSIGNED NOT NULL,
    unit_price      DECIMAL(10, 2)  NOT NULL,
    discount_percent DECIMAL(5, 2)  NOT NULL DEFAULT 0.00,
    line_total      DECIMAL(12, 2) GENERATED ALWAYS AS
        (ROUND(quantity * unit_price * (1 - discount_percent / 100), 2)) STORED,
    PRIMARY KEY (id),
    UNIQUE KEY uq_order_items_order_product (order_id, product_id),
    KEY ix_order_items_product (product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (quantity > 0),
    CHECK (unit_price >= 0),
    CHECK (discount_percent BETWEEN 0 AND 100)
) ENGINE = InnoDB;

CREATE TABLE order_events
(
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id   BIGINT UNSIGNED NOT NULL,
    event_type VARCHAR(40)     NOT NULL,
    source_ip  VARBINARY(16)   NULL,
    payload    JSON            NOT NULL,
    created_at TIMESTAMP(6)    NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY ix_order_events_order_created (order_id, created_at),
    CONSTRAINT fk_order_events_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (JSON_TYPE(payload) = 'OBJECT')
) ENGINE = InnoDB;
