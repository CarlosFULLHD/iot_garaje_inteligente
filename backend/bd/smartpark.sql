-- Table: parkings
CREATE TABLE IF NOT EXISTS parkings (
id_par serial NOT NULL PRIMARY KEY,
name varchar(255) NOT NULL,
location varchar(255) NOT NULL,
total_spots int NOT NULL,
created_at timestamp NULL DEFAULT current_timestamp,
updated_at timestamp NULL DEFAULT current_timestamp
);

-- Table: users
CREATE TABLE IF NOT EXISTS users (
id_users serial NOT NULL PRIMARY KEY,
name varchar(255) NOT NULL,
last_name varchar(255) NOT NULL,
email varchar(255) NOT NULL UNIQUE,
password varchar(255) NOT NULL,
pin_code varchar(8) NOT NULL UNIQUE,
created_at timestamp NULL DEFAULT current_timestamp,
updated_at timestamp NULL DEFAULT current_timestamp
);

-- Table: vehicles
CREATE TABLE IF NOT EXISTS vehicles (
id_vehicles serial NOT NULL PRIMARY KEY,
users_id int NOT NULL REFERENCES users(id_users) ON DELETE CASCADE,
license_plate varchar(255) NOT NULL UNIQUE,
car_branch varchar(255) NOT NULL,
car_model varchar(255) NOT NULL ,
car_color varchar(255) NOT NULL ,
car_manufacturing_date varchar(255) NOT NULL default '',
created_at timestamp NULL DEFAULT current_timestamp,
updated_at timestamp NULL DEFAULT current_timestamp
);

-- Table: roles
CREATE TABLE IF NOT EXISTS roles (
id_role serial NOT NULL PRIMARY KEY,
user_role varchar(75) NOT NULL,
description varchar(255) NOT NULL,
status smallint NOT NULL,
created_at timestamp NOT NULL
);

-- Table: roles_has_users
CREATE TABLE IF NOT EXISTS roles_has_users (
id_role_us serial NOT NULL PRIMARY KEY,
status smallint NOT NULL,
created_at timestamp NOT NULL,
roles_id_role int NOT NULL REFERENCES roles(id_role) ON DELETE CASCADE,
users_id_users int NOT NULL REFERENCES users(id_users) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS spots (
id_spots serial NOT NULL PRIMARY KEY,
parking_id int NOT NULL REFERENCES parkings(id_par) ON DELETE CASCADE,
spot_number INT NOT NULL UNIQUE,
status SMALLINT NOT NULL DEFAULT 1, -- 1 para disponible, 0 para ocupado
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reservations (
id_reservation SERIAL PRIMARY KEY,
users_id INT REFERENCES users(id_users) ON DELETE CASCADE,
vehicles_id INT REFERENCES vehicles(id_vehicles) ON DELETE CASCADE,
spots_id INT REFERENCES spots(id_spots) ON DELETE CASCADE,
scheduled_entry TIMESTAMP NOT NULL,
scheduled_exit TIMESTAMP NOT NULL,
actual_entry TIMESTAMP,
actual_exit TIMESTAMP,
status VARCHAR(50) NOT NULL,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- Truncate tables and restart identities
TRUNCATE TABLE reservations, vehicles, spots, parkings, roles_has_users, users, roles RESTART IDENTITY CASCADE;

-- Insert roles
INSERT INTO roles (user_role, description, status, created_at) VALUES
('ADMIN', 'Administrator role', 1, CURRENT_TIMESTAMP),
('USER', 'User role', 1, CURRENT_TIMESTAMP);

-- Insert users
INSERT INTO users (name, last_name, email, password, pin_code, created_at, updated_at) VALUES
('Carlos', 'Nina', 'carlos.nina@ucb.edu.bo', 'password_hash1', '1234', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Maria', 'Lopez', 'maria.lopez@ucb.edu.bo', 'password_hash2', '5678', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Juan', 'Perez', 'juan.perez@ucb.edu.bo', 'password_hash3', '9012', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ana', 'Torres', 'ana.torres@ucb.edu.bo', 'password_hash4', '3456', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert roles for users
INSERT INTO roles_has_users (roles_id_role, users_id_users, status, created_at) VALUES
(1, 1, 1, CURRENT_TIMESTAMP),  -- Carlos Nina as ADMIN
(2, 1, 1, CURRENT_TIMESTAMP),  -- Carlos Nina as USER
(2, 2, 1, CURRENT_TIMESTAMP),  -- Maria Lopez as USER
(2, 3, 1, CURRENT_TIMESTAMP),  -- Juan Perez as USER
(2, 4, 1, CURRENT_TIMESTAMP);  -- Ana Torres as USER

-- Insert parkings
INSERT INTO parkings (name, location, total_spots, created_at, updated_at) VALUES
('Parking Central', 'Obrajes Calle 8', 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Parking Norte', 'Obrajes Calle 2', 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert spots for Parking Central
INSERT INTO spots (parking_id, spot_number, status, created_at, updated_at) VALUES
(1, 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 2, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 3, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 4, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 5, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 6, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 7, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 8, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert spots for Parking Norte
INSERT INTO spots (parking_id, spot_number, status, created_at, updated_at) VALUES
(2, 9, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 11, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 12, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 13, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 14, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 15, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 16, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert vehicles
INSERT INTO vehicles (license_plate, users_id, car_branch, car_model, car_color, car_manufacturing_date, created_at, updated_at) VALUES
('ABC123', 1, 'Toyota', 'Corolla', 'Red', 2018, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Carlos Nina
('DEF456', 2, 'Honda', 'Civic', 'Blue', 2019, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Maria Lopez
('GHI789', 3, 'Ford', 'Focus', 'Black', 2020, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Juan Perez
('JKL012', 4, 'Chevrolet', 'Malibu', 'White', 2017, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- Ana Torres

-- Insert reservations
INSERT INTO reservations (users_id, vehicles_id, spots_id, scheduled_entry, scheduled_exit, actual_entry, actual_exit, status, created_at, updated_at) VALUES
-- Carlos Nina
(1, 1, 1, '2024-05-31 08:00:00', '2024-05-31 10:00:00', '2024-05-31 08:10:00', '2024-05-31 10:05:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 1, 2, '2024-05-31 12:00:00', '2024-05-31 14:00:00', '2024-05-31 12:05:00', '2024-05-31 13:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
-- Maria Lopez
(2, 2, 3, '2024-05-31 09:00:00', '2024-05-31 12:00:00', '2024-05-31 09:10:00', '2024-05-31 12:05:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, 4, '2024-05-31 15:00:00', '2024-05-31 17:00:00', '2024-05-31 15:05:00', '2024-05-31 17:10:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
-- Juan Perez
(3, 3, 5, '2024-05-31 11:00:00', '2024-05-31 13:00:00', '2024-05-31 11:15:00', '2024-05-31 13:05:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 3, 6, '2024-05-31 14:00:00', '2024-05-31 16:00:00', '2024-05-31 14:10:00', '2024-05-31 16:05:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
-- Ana Torres
(4, 4, 7, '2024-05-31 08:30:00', '2024-05-31 10:30:00', '2024-05-31 08:35:00', '2024-05-31 10:25:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 4, 8, '2024-05-31 13:00:00', '2024-05-31 15:00:00', '2024-05-31 13:10:00', '2024-05-31 14:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
-- Additional data for today, May 31, 2024
-- Random reservations to generate peak hours and frequent users data
(1, 1, 1, '2024-05-31 11:00:00', '2024-05-31 12:00:00', '2024-05-31 11:05:00', '2024-05-31 11:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, 2, '2024-05-31 14:00:00', '2024-05-31 15:00:00', '2024-05-31 14:05:00', '2024-05-31 14:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 3, 3, '2024-05-31 09:00:00', '2024-05-31 11:00:00', '2024-05-31 09:10:00', '2024-05-31 10:50:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 4, 4, '2024-05-31 16:00:00', '2024-05-31 18:00:00', '2024-05-31 16:05:00', '2024-05-31 17:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 1, 5, '2024-05-31 08:00:00', '2024-05-31 09:00:00', '2024-05-31 08:10:00', '2024-05-31 08:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, 6, '2024-05-31 10:00:00', '2024-05-31 11:00:00', '2024-05-31 10:05:00', '2024-05-31 10:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 3, 7, '2024-05-31 12:00:00', '2024-05-31 13:00:00', '2024-05-31 12:10:00', '2024-05-31 12:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 4, 8, '2024-05-31 14:00:00', '2024-05-31 15:00:00', '2024-05-31 14:10:00', '2024-05-31 14:55:00', 'COMPLETED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
