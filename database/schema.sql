-- ============================================================
-- CafeScan Database Schema
-- Run this file in MySQL Workbench or MySQL CLI
-- Author: Ahmad (Database)
-- ============================================================

-- Create and select the database
CREATE DATABASE IF NOT EXISTS cafescan;
USE cafescan;

-- ─────────────────────────────────────────────
-- TABLE: categories
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
  category_code VARCHAR(10)  PRIMARY KEY,
  category_name VARCHAR(50)  NOT NULL
);

-- ─────────────────────────────────────────────
-- TABLE: menu_items
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS menu_items (
  item_code         VARCHAR(20)    PRIMARY KEY,
  name              VARCHAR(100)   NOT NULL,
  description       VARCHAR(255),
  price             DECIMAL(10,2)  NOT NULL,
  image_url         VARCHAR(500),
  category_code     VARCHAR(10)    NOT NULL,
  availability      ENUM('available','unavailable') DEFAULT 'available',
  FOREIGN KEY (category_code) REFERENCES categories(category_code)
);

-- ─────────────────────────────────────────────
-- TABLE: tables
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tables (
  table_number  INT PRIMARY KEY,
  qr_code_data  VARCHAR(500),
  active_status ENUM('active','inactive') DEFAULT 'inactive'
);

-- ─────────────────────────────────────────────
-- TABLE: users
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  user_id    INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  role       ENUM('staff','owner') NOT NULL,
  username   VARCHAR(50)  NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL
);

-- ─────────────────────────────────────────────
-- TABLE: orders
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
  order_id      INT AUTO_INCREMENT PRIMARY KEY,
  table_number  INT NOT NULL,
  status        ENUM('pending','in-progress','done') DEFAULT 'pending',
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (table_number) REFERENCES tables(table_number)
);

-- ─────────────────────────────────────────────
-- TABLE: order_items
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  order_id    INT NOT NULL,
  item_code   VARCHAR(20) NOT NULL,
  quantity    INT NOT NULL DEFAULT 1,
  FOREIGN KEY (order_id)  REFERENCES orders(order_id),
  FOREIGN KEY (item_code) REFERENCES menu_items(item_code)
);

-- ─────────────────────────────────────────────
-- TABLE: analytics
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS analytics (
  item_code     VARCHAR(20) PRIMARY KEY,
  total_orders  INT DEFAULT 0,
  FOREIGN KEY (item_code) REFERENCES menu_items(item_code)
);

-- ============================================================
-- SEED DATA — Double Shot, Gulberg, Lahore
-- ============================================================

-- Categories
INSERT IGNORE INTO categories (category_code, category_name) VALUES
  ('C1', 'Coffee'),
  ('C2', 'Cold'),
  ('C3', 'Cakes'),
  ('C4', 'All Day');

-- Menu Items
INSERT IGNORE INTO menu_items
  (item_code, name, description, price, image_url, category_code, availability)
VALUES
  ('I001', 'Flat white',    'Double shot, steamed milk',          550.00, NULL, 'C1', 'available'),
  ('I002', 'Cortado',       'Equal parts espresso + milk',        480.00, NULL, 'C1', 'available'),
  ('I003', 'Cappuccino',    'Classic espresso with foamed milk',  450.00, NULL, 'C1', 'available'),
  ('I004', 'Cold brew',     'Slow-steeped cold coffee',           520.00, NULL, 'C2', 'available'),
  ('I005', 'Matcha latte',  'Ceremonial grade matcha',            580.00, NULL, 'C2', 'available'),
  ('I006', 'Croissant',     'Butter, plain',                      320.00, NULL, 'C3', 'available'),
  ('I007', 'Hazelnut cake', 'Moist hazelnut sponge',              480.00, NULL, 'C3', 'available'),
  ('I008', 'Avocado toast', 'Sourdough, chilli flakes, lemon',    650.00, NULL, 'C4', 'available');

-- Tables (12 tables)
INSERT IGNORE INTO tables (table_number, qr_code_data, active_status) VALUES
  (1,  'http://localhost:5173/menu/1',  'inactive'),
  (2,  'http://localhost:5173/menu/2',  'inactive'),
  (3,  'http://localhost:5173/menu/3',  'inactive'),
  (4,  'http://localhost:5173/menu/4',  'inactive'),
  (5,  'http://localhost:5173/menu/5',  'inactive'),
  (6,  'http://localhost:5173/menu/6',  'inactive'),
  (7,  'http://localhost:5173/menu/7',  'inactive'),
  (8,  'http://localhost:5173/menu/8',  'inactive'),
  (9,  'http://localhost:5173/menu/9',  'inactive'),
  (10, 'http://localhost:5173/menu/10', 'inactive'),
  (11, 'http://localhost:5173/menu/11', 'inactive'),
  (12, 'http://localhost:5173/menu/12', 'inactive');

-- Users (passwords are plain for now — Zaryan will hash them)
-- Staff password: staff123 | Owner password: owner123
INSERT IGNORE INTO users (name, role, username, password) VALUES
  ('Staff Member', 'staff', 'staff',  'staff123'),
  ('Cafe Owner',   'owner', 'owner',  'owner123');

-- Analytics seed (start at zero)
INSERT IGNORE INTO analytics (item_code, total_orders) VALUES
  ('I001', 0), ('I002', 0), ('I003', 0), ('I004', 0),
  ('I005', 0), ('I006', 0), ('I007', 0), ('I008', 0);