-- ============================================================
-- FIX SCRIPT: Run this in MySQL to fix admin login and duplicate data
-- ============================================================

USE buildsmart;

-- Fix admin password (admin123)
UPDATE users 
SET password = '$2a$10$QI9n/NClrAiDmMnrwP21l.AVHJ2H.D9AmTHKgSC/94IPmO4hSRVEa'
WHERE email = 'admin@buildsmart.lk';

-- Fix all seed user passwords to password123
UPDATE users 
SET password = '$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS'
WHERE email != 'admin@buildsmart.lk';

-- Remove duplicate hardware_shops (keep only first 10)
DELETE FROM hardware_shops WHERE shop_id > 10;

-- Remove duplicate workers (keep only first 10)  
DELETE FROM workers WHERE worker_id > 10;

SELECT 'Done! Admin: admin@buildsmart.lk / admin123 | Users: password123' AS result;
