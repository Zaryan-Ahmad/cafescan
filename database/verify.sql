-- ============================================================
-- CafeScan Database Verification
-- Run this AFTER schema.sql to confirm everything is correct
-- ============================================================

USE cafescan;

SELECT 'CATEGORIES' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL
SELECT 'MENU_ITEMS',  COUNT(*) FROM menu_items
UNION ALL
SELECT 'TABLES',      COUNT(*) FROM tables
UNION ALL
SELECT 'USERS',       COUNT(*) FROM users
UNION ALL
SELECT 'ANALYTICS',   COUNT(*) FROM analytics;

-- Should see:
-- CATEGORIES  4
-- MENU_ITEMS  8
-- TABLES      12
-- USERS       2
-- ANALYTICS   8

-- Preview menu
SELECT item_code, name, price, category_code FROM menu_items ORDER BY category_code;