-- ============================================================
-- BuildSmart Complete Seed Data - Sri Lanka (ALL FIXES APPLIED)
-- ============================================================

USE buildsmart;

-- ============================================================
-- 1. USERS
-- ============================================================

INSERT IGNORE INTO users (full_name, email, password, phone, role, status) VALUES 
('System Admin', 'admin@buildsmart.lk', '$2a$12$IDb4GNDiKTi4aEvxZw2FYOaRXVdFEdn70Hebsr70QWxQRPhcwCKHe', '0770000000', 'admin', 'active'),
('Kamal Perera', 'kamal.perera@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0771234567', 'homeowner', 'active'),
('Samanthi Rathnayake', 'samanthi.rathnayake@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0712345678', 'homeowner', 'active'),
('Gamini Silva', 'gamini.silva@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0753456789', 'homeowner', 'active'),
('Chandrika Fernando', 'chandrika.fernando@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0784567890', 'homeowner', 'active'),
('Sunil Jayasinghe', 'sunil.jayasinghe@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0775678901', 'homeowner', 'active'),
('Nirmala Wickramasinghe', 'nirmala.wickramasinghe@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0716789012', 'homeowner', 'active'),
('Ranjith Bandara', 'ranjith.bandara@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0757890123', 'homeowner', 'active'),
('Deepani Gunawardena', 'deepani.gunawardena@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0788901234', 'homeowner', 'active'),
('Anura Dissanayake', 'anura.dissanayake@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0779012345', 'homeowner', 'active'),
('Kumari Weerasinghe', 'kumari.weerasinghe@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0710123456', 'homeowner', 'active'),
('Priyantha Rathnayake', 'priyantha.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0771122334', 'worker', 'active'),
('Hettige Gunasekara', 'hettige.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0712233445', 'worker', 'pending'),
('Wijaya Wickramasinghe', 'wijaya.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0753344556', 'worker', 'active'),
('Sunanda Perera', 'sunanda.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0784455667', 'worker', 'active'),
('Kusal De Silva', 'kusal.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0775566778', 'worker', 'pending'),
('Nimal Jayasinghe', 'nimal.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0716677889', 'worker', 'active'),
('Rukmani Thilakarathne', 'rukmani.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0757788990', 'worker', 'active'),
('Bandula Seneviratne', 'bandula.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0788899001', 'worker', 'pending'),
('Chathura Ranasinghe', 'chathura.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0779900112', 'worker', 'active'),
('Lakshmi Fernando', 'lakshmi.worker@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0710011223', 'worker', 'active'),
('Ravi Perera', 'ravi.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0772233445', 'hardware_owner', 'active'),
('Chandana Wickramasinghe', 'chandana.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0713344556', 'hardware_owner', 'pending'),
('Gamage Seneviratne', 'gamage.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0754455667', 'hardware_owner', 'active'),
('Sunil Fernando', 'sunil.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0785566778', 'hardware_owner', 'active'),
('Silva Rathnayake', 'silva.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0776677889', 'hardware_owner', 'pending'),
('Wijaya Bandara', 'wijaya.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0717788990', 'hardware_owner', 'active'),
('Perera Gunawardena', 'perera.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0758899001', 'hardware_owner', 'active'),
('Saman Kumara', 'saman.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0789900112', 'hardware_owner', 'pending'),
('Rathna Jayawardena', 'rathna.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0770011223', 'hardware_owner', 'active'),
('Lankapura Rajapaksa', 'lankapura.hardware@email.com', '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS', '0711122334', 'hardware_owner', 'active');

-- ============================================================
-- 2. WORKER PROFILES
-- ============================================================

INSERT INTO workers (user_id, nic, profession, experience, skills, daily_rate, district, profile_photo, about) VALUES 
((SELECT user_id FROM users WHERE email='priyantha.worker@email.com'), '881234567V', 'Mason', 12, 'Bricklaying, Plastering, Tiling, Concrete Work', 3500.00, 'Colombo', 'priyantha_mason.jpg', 'Experienced mason with over 12 years in residential construction.'),
((SELECT user_id FROM users WHERE email='hettige.worker@email.com'), '791234568V', 'Carpenter', 15, 'Woodwork, Roof Trusses, Door Frames, Cabinetry', 4000.00, 'Kandy', 'hettige_carpenter.jpg', 'Master carpenter with 15 years of traditional and modern carpentry.'),
((SELECT user_id FROM users WHERE email='wijaya.worker@email.com'), '831234569V', 'Electrician', 8, 'Wiring, Switchboards, Lighting, Solar Panel Installation', 3200.00, 'Colombo', 'wijaya_electrician.jpg', 'Certified electrician with 8 years experience in residential and commercial electrical work.'),
((SELECT user_id FROM users WHERE email='sunanda.worker@email.com'), '751234570V', 'Plumber', 10, 'Water Supply, PVC Pipes, Bathroom Fittings, Water Tanks', 2800.00, 'Gampaha', 'sunanda_plumber.jpg', 'Highly skilled plumber with 10 years of experience in residential plumbing.'),
((SELECT user_id FROM users WHERE email='kusal.worker@email.com'), '861234571V', 'Painter', 6, 'Interior Painting, Exterior Painting, Wallpaper, Texture Finish', 2500.00, 'Colombo', 'kusal_painter.jpg', 'Professional painter with 6 years of experience in both interior and exterior painting.'),
((SELECT user_id FROM users WHERE email='nimal.worker@email.com'), '781234572V', 'Tiler', 9, 'Floor Tiles, Wall Tiles, Bathroom Tiling, Mosaic', 3000.00, 'Colombo', 'nimal_tiler.jpg', 'Specialized tiler with 9 years experience in residential and commercial tiling.'),
((SELECT user_id FROM users WHERE email='rukmani.worker@email.com'), '741234573V', 'Mason', 14, 'Foundation, Brickwork, Concrete, Plastering', 3600.00, 'Kandy', 'rukmani_mason.jpg', 'Senior mason with 14 years experience in high-quality foundation work and structural masonry.'),
((SELECT user_id FROM users WHERE email='bandula.worker@email.com'), '841234574V', 'Electrician', 11, 'Industrial Wiring, Automation, Security Systems', 3800.00, 'Gampaha', 'bandula_electrician.jpg', 'Advanced electrician with 11 years experience in industrial wiring and automation.'),
((SELECT user_id FROM users WHERE email='chathura.worker@email.com'), '821234575V', 'Carpenter', 7, 'Furniture Making, Cabinet Work, Door Installation', 3200.00, 'Colombo', 'chathura_carpenter.jpg', 'Skilled carpenter with 7 years experience in custom furniture and fine woodworking.'),
((SELECT user_id FROM users WHERE email='lakshmi.worker@email.com'), '761234576V', 'Plumber', 13, 'Commercial Plumbing, Water Pumps, Hot Water Systems', 3400.00, 'Kandy', 'lakshmi_plumber.jpg', 'Master plumber with 13 years experience in commercial plumbing and water pump systems.');

-- ============================================================
-- 3. HARDWARE SHOPS
-- ============================================================

INSERT INTO hardware_shops (user_id, shop_name, owner_name, business_registration_number, address, district, phone, logo, opening_hours, delivery_available, description) VALUES 
((SELECT user_id FROM users WHERE email='ravi.hardware@email.com'), 'Ravi Hardware Centre', 'Ravi Perera', 'BR-2024-001', '123 Main Street, Bambalapitiya', 'Colombo', '0772233445', 'ravi_hardware.jpg', '8:00 AM - 7:00 PM', 1, 'One of Colombo\'s leading hardware suppliers with quality materials at competitive prices.'),
((SELECT user_id FROM users WHERE email='chandana.hardware@email.com'), 'Chandana Building Stores', 'Chandana Wickramasinghe', 'BR-2024-002', '456 Kandy Road, Kurunegala', 'Kandy', '0713344556', 'chandana_stores.jpg', '8:00 AM - 6:00 PM', 0, 'Quality building materials at wholesale prices with specialization in roofing and steel.'),
((SELECT user_id FROM users WHERE email='gamage.hardware@email.com'), 'Gamage Hardware & Tools', 'Gamage Seneviratne', 'BR-2024-003', '789 Galle Road, Moratuwa', 'Colombo', '0754455667', 'gamage_hardware.jpg', '7:30 AM - 6:30 PM', 1, 'Over 20 years in hardware industry. Specialized in power tools and equipment rental.'),
((SELECT user_id FROM users WHERE email='sunil.hardware@email.com'), 'Lanka Building Centre', 'Sunil Fernando', 'BR-2024-004', '321 High Street, Negombo', 'Gampaha', '0785566778', 'lanka_building.jpg', '8:00 AM - 8:00 PM', 1, 'Largest building materials supplier in Gampaha with complete range and same-day delivery.'),
((SELECT user_id FROM users WHERE email='silva.hardware@email.com'), 'Silva Hardware Mart', 'Silva Rathnayake', 'BR-2024-005', '654 A, Kandy Road, Matale', 'Kandy', '0776677889', 'silva_hardware.jpg', '8:30 AM - 6:00 PM', 0, 'Your trusted hardware partner in Matale specializing in cement, sand, and bricks.'),
((SELECT user_id FROM users WHERE email='wijaya.hardware@email.com'), 'Wijaya Traders', 'Wijaya Bandara', 'BR-2024-006', '987 Galle Road, Kalutara', 'Colombo', '0717788990', 'wijaya_traders.jpg', '7:00 AM - 7:00 PM', 1, 'One-stop shop for all construction needs with specialization in plumbing and electrical.'),
((SELECT user_id FROM users WHERE email='perera.hardware@email.com'), 'Perera Building Supplies', 'Perera Gunawardena', 'BR-2024-007', '147 Nugegoda Road, Nugegoda', 'Colombo', '0758899001', 'perera_supplies.jpg', '8:00 AM - 6:00 PM', 1, 'Quality building materials at affordable prices specializing in tiles and bathroom fittings.'),
((SELECT user_id FROM users WHERE email='saman.hardware@email.com'), 'Saman Hardware Emporium', 'Saman Kumara', 'BR-2024-008', '258 Kurunegala Road, Kiribathgoda', 'Gampaha', '0789900112', 'saman_hardware.jpg', '8:30 AM - 6:30 PM', 0, 'Specialized in paint, finishes, and decorative materials for modern homes.'),
((SELECT user_id FROM users WHERE email='rathna.hardware@email.com'), 'Rathna Hardware Stores', 'Rathna Jayawardena', 'BR-2024-009', '369 High Level Road, Maharagama', 'Colombo', '0770011223', 'rathna_stores.jpg', '7:30 AM - 6:30 PM', 1, 'Trusted hardware supplier for over 15 years with complete range and expert advice.'),
((SELECT user_id FROM users WHERE email='lankapura.hardware@email.com'), 'Lankapura Hardware & Supplies', 'Lankapura Rajapaksa', 'BR-2024-010', '741 Colombo Road, Gampaha', 'Gampaha', '0711122334', 'lankapura_hardware.jpg', '8:00 AM - 7:00 PM', 1, 'Leading hardware supplier in Gampaha specializing in roofing, cement, and steel.');

-- ============================================================
-- 4. MATERIAL PRICES (FIXED - using direct shop_id values)
-- ============================================================

-- Ravi Hardware (shop_id = 1)
INSERT INTO material_prices (shop_id, material_id, brand, price, availability) VALUES 
(1, 1, 'Sanstha', 1250.00, 'In Stock'),
(1, 2, 'Local', 850.00, 'In Stock'),
(1, 3, 'CTC', 45.00, 'In Stock'),
(1, 4, 'Lanwa', 185.00, 'In Stock'),
(1, 5, 'Asian Paints', 850.00, 'In Stock');

-- Gamage Hardware (shop_id = 3)
INSERT INTO material_prices (shop_id, material_id, brand, price, availability) VALUES 
(3, 1, 'Sanstha', 1275.00, 'In Stock'),
(3, 3, 'CTC', 47.00, 'In Stock'),
(3, 4, 'Melwa', 190.00, 'Out of Stock'),
(3, 5, 'Jotun', 920.00, 'In Stock');

-- Lanka Building Centre (shop_id = 4)
INSERT INTO material_prices (shop_id, material_id, brand, price, availability) VALUES 
(4, 1, 'UltraTech', 1300.00, 'In Stock'),
(4, 2, 'River', 870.00, 'In Stock'),
(4, 3, 'CTC', 48.00, 'In Stock'),
(4, 6, 'Ceylon Steel', 175.00, 'In Stock'),
(4, 7, 'Rocell', 1850.00, 'In Stock');

-- Wijaya Traders (shop_id = 6)
INSERT INTO material_prices (shop_id, material_id, brand, price, availability) VALUES 
(6, 1, 'Sanstha', 1240.00, 'Out of Stock'),
(6, 2, 'Local', 860.00, 'In Stock'),
(6, 4, 'Lanwa', 188.00, 'In Stock'),
(6, 8, 'Phoenix', 155.00, 'In Stock');

-- Perera Building Supplies (shop_id = 7)
INSERT INTO material_prices (shop_id, material_id, brand, price, availability) VALUES 
(7, 1, 'Ultratech', 1310.00, 'In Stock'),
(7, 3, 'CTC', 50.00, 'In Stock'),
(7, 7, 'Lanka Tiles', 2100.00, 'In Stock'),
(7, 8, 'Phoenix', 160.00, 'In Stock');

-- Rathna Stores (shop_id = 9)
INSERT INTO material_prices (shop_id, material_id, brand, price, availability) VALUES 
(9, 1, 'Sanstha', 1260.00, 'In Stock'),
(9, 2, 'River', 880.00, 'In Stock'),
(9, 4, 'Melwa', 192.00, 'In Stock');

-- ============================================================
-- 5. REVIEWS
-- ============================================================

INSERT INTO reviews (user_id, target_type, target_id, rating, comment, photo, status, review_date) VALUES 
((SELECT user_id FROM users WHERE email='kamal.perera@email.com'), 'worker', 1, 5, 'Excellent work! Priyantha completed my house on time with high quality. Highly recommended.', NULL, 1, DATE_SUB(NOW(), INTERVAL 10 DAY)),
((SELECT user_id FROM users WHERE email='samanthi.rathnayake@email.com'), 'worker', 1, 4, 'Good quality work. Communication could have been better but overall satisfied.', NULL, 1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
((SELECT user_id FROM users WHERE email='gamini.silva@email.com'), 'worker', 3, 5, 'Professional electrician. Did a complete wiring job for my 3-bedroom house. Very satisfied.', NULL, 1, DATE_SUB(NOW(), INTERVAL 15 DAY)),
((SELECT user_id FROM users WHERE email='chandrika.fernando@email.com'), 'worker', 3, 4, 'Good work, arrived on time. Slightly expensive but quality is worth it.', NULL, 1, DATE_SUB(NOW(), INTERVAL 7 DAY)),
((SELECT user_id FROM users WHERE email='sunil.jayasinghe@email.com'), 'worker', 4, 5, 'Best plumber in Colombo! Solved my water pressure issues and installed modern bathroom fittings.', NULL, 1, DATE_SUB(NOW(), INTERVAL 3 DAY)),
((SELECT user_id FROM users WHERE email='nirmala.wickramasinghe@email.com'), 'worker', 6, 5, 'Beautiful tiling work! Very careful and precise. My floors look amazing.', NULL, 1, DATE_SUB(NOW(), INTERVAL 20 DAY)),
((SELECT user_id FROM users WHERE email='ranjith.bandara@email.com'), 'worker', 7, 4, 'Very strong masonry work. My house foundation is solid. Would hire again.', NULL, 1, DATE_SUB(NOW(), INTERVAL 12 DAY)),
((SELECT user_id FROM users WHERE email='deepani.gunawardena@email.com'), 'hardware_shop', 1, 5, 'Ravi Hardware has the best prices in Colombo! Friendly staff and quality materials.', NULL, 1, DATE_SUB(NOW(), INTERVAL 8 DAY)),
((SELECT user_id FROM users WHERE email='anura.dissanayake@email.com'), 'hardware_shop', 3, 4, 'Gamage Hardware has a great selection of tools. Good service but parking is an issue.', NULL, 1, DATE_SUB(NOW(), INTERVAL 6 DAY)),
((SELECT user_id FROM users WHERE email='kumari.weerasinghe@email.com'), 'hardware_shop', 4, 5, 'Lanka Building Centre delivers quickly. Great quality materials for my renovation.', NULL, 1, DATE_SUB(NOW(), INTERVAL 4 DAY));

-- ============================================================
-- 6. WORKER AVAILABILITY (FIXED - uses INSERT IGNORE)
-- ============================================================

INSERT IGNORE INTO worker_availability (worker_id, unavailable_date) VALUES 
(1, '2026-07-05'), (1, '2026-07-12'), (1, '2026-07-19'), (1, '2026-07-26'),
(3, '2026-07-03'), (3, '2026-07-10'), (3, '2026-07-17'), (3, '2026-07-24'),
(4, '2026-07-02'), (4, '2026-07-09'), (4, '2026-07-16'), (4, '2026-07-23'), (4, '2026-07-30'),
(6, '2026-07-04'), (6, '2026-07-11'), (6, '2026-07-18'), (6, '2026-07-25'),
(7, '2026-07-01'), (7, '2026-07-08'), (7, '2026-07-15'), (7, '2026-07-22'), (7, '2026-07-29'),
(9, '2026-07-06'), (9, '2026-07-13'), (9, '2026-07-20'), (9, '2026-07-27'),
(10, '2026-07-07'), (10, '2026-07-14'), (10, '2026-07-21'), (10, '2026-07-28');

-- ============================================================
-- 7. PACKAGE SUGGESTIONS (FIXED - uses INSERT IGNORE)
-- ============================================================

-- Basic Package (Package 1)
INSERT IGNORE INTO package_workers (package_id, worker_id) VALUES 
(1, 1), (1, 3), (1, 4);

INSERT IGNORE INTO package_materials (package_id, material_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 5);

INSERT IGNORE INTO package_shops (package_id, shop_id) VALUES 
(1, 1), (1, 3);

-- Standard Package (Package 2)
INSERT IGNORE INTO package_workers (package_id, worker_id) VALUES 
(2, 1), (2, 3), (2, 4), (2, 6), (2, 7);

INSERT IGNORE INTO package_materials (package_id, material_id) VALUES 
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 7);

INSERT IGNORE INTO package_shops (package_id, shop_id) VALUES 
(2, 1), (2, 3), (2, 4), (2, 6);

-- Premium Package (Package 3)
INSERT IGNORE INTO package_workers (package_id, worker_id) VALUES 
(3, 1), (3, 3), (3, 4), (3, 6), (3, 7), (3, 9), (3, 10);

INSERT IGNORE INTO package_materials (package_id, material_id) VALUES 
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8);

INSERT IGNORE INTO package_shops (package_id, shop_id) VALUES 
(3, 1), (3, 3), (3, 4), (3, 6), (3, 7), (3, 9), (3, 10);
