-- ============================================================
-- BuildSmart Database Schema  (Java / MySQL version)
-- House Construction Planning & Resource Finder System
--
-- Instructions:
--   1. Open MySQL Workbench or phpMyAdmin.
--   2. Run this entire script.
--   3. The script is idempotent ΓÇö safe to re-run
--      (uses IF NOT EXISTS / INSERT IGNORE).
--
-- Notes:
--   ΓÇó Column names stay snake_case in the DB.
--   ΓÇó Java models map them to camelCase via getters/setters.
--   ΓÇó Passwords are stored as BCrypt hashes (60 chars).
--   ΓÇó Images are stored as MEDIUMBLOB (max 16MB per field).
--     They are served via /img?type=worker|shop|review&id=N
-- ============================================================

-- ----- Create & select the schema -----
CREATE DATABASE IF NOT EXISTS buildsmart
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE buildsmart;

-- ============================================================
-- TABLE: users
-- Base table for all roles ΓÇö stores login credentials.
-- OOP note: mirrors the abstract User class in Java.
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id    INT           AUTO_INCREMENT PRIMARY KEY,
    full_name  VARCHAR(150)  NOT NULL,
    email      VARCHAR(150)  NOT NULL UNIQUE,
    password   VARCHAR(255)  NOT NULL,           -- BCrypt hash (60 chars)
    phone      VARCHAR(20)   DEFAULT NULL,
    role       ENUM('homeowner','worker','hardware_owner','admin') NOT NULL,
    status     ENUM('active','pending','rejected') NOT NULL DEFAULT 'active',
    created_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: workers
-- Extended profile for users with role = 'worker'.
-- OOP note: mirrors the Worker subclass (extends User).
-- Composition: worker_availability entries belong to and die with this worker.
-- ============================================================
CREATE TABLE IF NOT EXISTS workers (
    worker_id          INT            AUTO_INCREMENT PRIMARY KEY,
    user_id            INT            NOT NULL,
    nic                VARCHAR(20)    DEFAULT NULL,
    profession         VARCHAR(100)   DEFAULT NULL,
    experience         INT            NOT NULL DEFAULT 0,       -- years
    skills             VARCHAR(255)   DEFAULT NULL,             -- comma-separated
    daily_rate         DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    district           VARCHAR(60)    DEFAULT NULL,
    profile_photo      MEDIUMBLOB     DEFAULT NULL,             -- raw image binary
    photo_mime         VARCHAR(50)    DEFAULT NULL,             -- MIME type e.g. image/jpeg
    about              TEXT           DEFAULT NULL,
    last_updated       DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                      ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_workers_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: hardware_shops
-- Extended profile for users with role = 'hardware_owner'.
-- OOP note: mirrors the HardwareOwner subclass (extends User).
-- Composition: material_prices belong to and die with this shop.
-- ============================================================
CREATE TABLE IF NOT EXISTS hardware_shops (
    shop_id                     INT            AUTO_INCREMENT PRIMARY KEY,
    user_id                     INT            NOT NULL,
    shop_name                   VARCHAR(150)   NOT NULL,
    owner_name                  VARCHAR(150)   DEFAULT NULL,
    business_registration_number VARCHAR(60)   DEFAULT NULL,
    address                     VARCHAR(255)   DEFAULT NULL,
    district                    VARCHAR(60)    DEFAULT NULL,
    phone                       VARCHAR(20)    DEFAULT NULL,
    logo                        MEDIUMBLOB     DEFAULT NULL,    -- raw image binary
    logo_mime                   VARCHAR(50)    DEFAULT NULL,    -- MIME type e.g. image/png
    opening_hours               VARCHAR(100)   NOT NULL DEFAULT '8:00 AM - 6:00 PM',
    delivery_available          TINYINT(1)     NOT NULL DEFAULT 0,  -- 0=No, 1=Yes
    description                 TEXT           DEFAULT NULL,
    last_updated                DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                               ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_hardware_shops_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: materials
-- Master list of materials managed by the admin.
-- ============================================================
CREATE TABLE IF NOT EXISTS materials (
    material_id   INT          AUTO_INCREMENT PRIMARY KEY,
    material_name VARCHAR(150) NOT NULL,
    category      VARCHAR(100) DEFAULT NULL,
    unit          VARCHAR(30)  DEFAULT NULL       -- e.g. Bag, Kg, Piece, Litre
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: material_prices
-- Per-shop pricing for materials.
-- Composition: a price entry cannot exist without its shop.
-- ============================================================
CREATE TABLE IF NOT EXISTS material_prices (
    price_id     INT            AUTO_INCREMENT PRIMARY KEY,
    shop_id      INT            NOT NULL,
    material_id  INT            NOT NULL,
    brand        VARCHAR(100)   DEFAULT NULL,
    price        DECIMAL(10,2)  NOT NULL,
    availability ENUM('In Stock','Out of Stock') NOT NULL DEFAULT 'In Stock',
    last_updated DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_mp_shop
        FOREIGN KEY (shop_id)     REFERENCES hardware_shops(shop_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mp_material
        FOREIGN KEY (material_id) REFERENCES materials(material_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: construction_packages
-- Preset packages (Basic / Standard / Premium) managed by admin.
-- ============================================================
CREATE TABLE IF NOT EXISTS construction_packages (
    package_id       INT            AUTO_INCREMENT PRIMARY KEY,
    package_name     VARCHAR(50)    NOT NULL,        -- Basic | Standard | Premium
    estimated_budget DECIMAL(12,2)  NOT NULL,
    description      TEXT           DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: package_workers
-- Aggregation: links packages ΓåÆ workers.
-- Deleting a package removes the link, NOT the worker.
-- ============================================================
CREATE TABLE IF NOT EXISTS package_workers (
    id         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    package_id INT NOT NULL,
    worker_id  INT NOT NULL,
    CONSTRAINT fk_pw_package
        FOREIGN KEY (package_id) REFERENCES construction_packages(package_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pw_worker
        FOREIGN KEY (worker_id)  REFERENCES workers(worker_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uq_package_worker (package_id, worker_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: package_materials
-- Aggregation: links packages ΓåÆ materials.
-- ============================================================
CREATE TABLE IF NOT EXISTS package_materials (
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    package_id  INT NOT NULL,
    material_id INT NOT NULL,
    CONSTRAINT fk_pm_package
        FOREIGN KEY (package_id)  REFERENCES construction_packages(package_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pm_material
        FOREIGN KEY (material_id) REFERENCES materials(material_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uq_package_material (package_id, material_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: package_shops
-- Aggregation: links packages ΓåÆ hardware shops.
-- ============================================================
CREATE TABLE IF NOT EXISTS package_shops (
    id         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    package_id INT NOT NULL,
    shop_id    INT NOT NULL,
    CONSTRAINT fk_ps_package
        FOREIGN KEY (package_id) REFERENCES construction_packages(package_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ps_shop
        FOREIGN KEY (shop_id)    REFERENCES hardware_shops(shop_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uq_package_shop (package_id, shop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: reviews
-- Homeowners submit reviews for workers or hardware shops.
-- Association: a homeowner (user) can submit many reviews.
-- ============================================================
CREATE TABLE IF NOT EXISTS reviews (
    review_id   INT         AUTO_INCREMENT PRIMARY KEY,
    user_id     INT         NOT NULL,                    -- homeowner who wrote it
    target_type ENUM('worker','hardware_shop') NOT NULL,
    target_id   INT         NOT NULL,                    -- worker_id or shop_id
    rating      TINYINT     NOT NULL,
    comment     TEXT        DEFAULT NULL,
    photo       MEDIUMBLOB  DEFAULT NULL,                -- raw image binary
    photo_mime  VARCHAR(50) DEFAULT NULL,                -- MIME type e.g. image/jpeg
    status      INT         NOT NULL DEFAULT 0,          -- 0=PENDING, 1=APPROVED, 2=REJECTED
    review_date DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_rating   CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: worker_availability
-- Composition: dates belong to and die with the worker.
-- Only UNAVAILABLE dates are stored (available = everything else).
-- ============================================================
CREATE TABLE IF NOT EXISTS worker_availability (
    availability_id INT  AUTO_INCREMENT PRIMARY KEY,
    worker_id       INT  NOT NULL,
    unavailable_date DATE NOT NULL,
    UNIQUE KEY uq_worker_date (worker_id, unavailable_date),
    CONSTRAINT fk_wa_worker
        FOREIGN KEY (worker_id) REFERENCES workers(worker_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Seed Data
-- ============================================================

-- Default administrator account
-- Email:    admin@buildsmart.lk
-- Password: admin123  (BCrypt hash below ΓÇö generated with BCrypt.hashpw)
-- If login fails, update this row with a freshly generated hash.
INSERT IGNORE INTO users (full_name, email, password, phone, role, status)
VALUES (
    'System Administrator',
    'admin@buildsmart.lk',
    '$2a$12$IDb4GNDiKTi4aEvxZw2FYOaRXVdFEdn70Hebsr70QWxQRPhcwCKHe',
    '0770000000',
    'admin',
    'active'
);

-- Sample materials master list
INSERT IGNORE INTO materials (material_id, material_name, category, unit) VALUES
(1, 'Cement',        'Structural', 'Bag'),
(2, 'Sand',          'Structural', 'Cube'),
(3, 'Bricks',        'Structural', 'Piece'),
(4, 'Steel Bars',    'Structural', 'Kg'),
(5, 'Paint',         'Finishing',  'Litre'),
(6, 'Roofing Sheets','Roofing',    'Piece'),
(7, 'Tiles',         'Finishing',  'Box'),
(8, 'PVC Pipes',     'Plumbing',   'Piece');

-- Sample construction packages
INSERT IGNORE INTO construction_packages (package_id, package_name, estimated_budget, description) VALUES
(1, 'Basic',    3000000.00, 'Suitable for low-budget residential construction (around Rs. 30 Lakhs).'),
(2, 'Standard', 6000000.00, 'Suitable for medium-sized residential projects (around Rs. 60 Lakhs).'),
(3, 'Premium', 10000000.00, 'Suitable for high-quality residential construction (Rs. 100 Lakhs and above).');

-- ============================================================
-- End of script
-- ============================================================
