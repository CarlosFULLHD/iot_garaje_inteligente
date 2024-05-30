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


TRUNCATE TABLE reservations, vehicles, spots, parkings, roles_has_users, users, roles RESTART IDENTITY CASCADE;


INSERT INTO roles (user_role, description, status, created_at) VALUES
('ADMIN', 'Administrator role', 1, CURRENT_TIMESTAMP),
('USER', 'User role', 1, CURRENT_TIMESTAMP);

INSERT INTO users (name, last_name, email, password, pin_code, created_at, updated_at) VALUES
('Carlos', 'Nina', 'carlos.nina@ucb.edu.bo', 'password_hash1', '1234', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Maria', 'Lopez', 'maria.lopez@ucb.edu.bo', 'password_hash2', '5678', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Juan', 'Perez', 'juan.perez@ucb.edu.bo', 'password_hash3', '9012', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ana', 'Torres', 'ana.torres@ucb.edu.bo', 'password_hash4', '3456', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO roles_has_users (roles_id_role, users_id_users, status, created_at) VALUES
(1, 1, 1, CURRENT_TIMESTAMP),  -- Carlos Nina as ADMIN
(2, 1, 1, CURRENT_TIMESTAMP),  -- Carlos Nina as USER
(2, 2, 1, CURRENT_TIMESTAMP),  -- Maria Lopez as USER
(2, 3, 1, CURRENT_TIMESTAMP),  -- Juan Perez as USER
(2, 4, 1, CURRENT_TIMESTAMP);  -- Ana Torres as USER

INSERT INTO parkings (name, location, total_spots, created_at, updated_at) VALUES
('Parking Central', 'Main St. 123', 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Parking Norte', 'North St. 456', 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Spots for Parking Central
INSERT INTO spots (parking_id, spot_number, status, created_at, updated_at) VALUES
(1, 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 2, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 3, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 4, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 5, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 6, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 7, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 8, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Spots for Parking Norte
INSERT INTO spots (parking_id, spot_number, status, created_at, updated_at) VALUES
(2, 9, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 10, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 11, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 12, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 13, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 14, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 15, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 16, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO vehicles (license_plate, users_id, car_branch, car_model, car_color, car_manufacturing_date, created_at, updated_at) VALUES
('ABC123', 1, 'Toyota', 'Corolla', 'Red', 2018, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Carlos Nina
('DEF456', 2, 'Honda', 'Civic', 'Blue', 2019, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Maria Lopez
('GHI789', 3, 'Ford', 'Focus', 'Black', 2020, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Juan Perez
('JKL012', 4, 'Chevrolet', 'Malibu', 'White', 2017, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- Ana Torres

-- Reservations for each user, assuming one spot per user for simplicity
INSERT INTO reservations (users_id, vehicles_id, spots_id, scheduled_entry, scheduled_exit, status, created_at, updated_at) VALUES
(1, 1, 1, '2024-06-01 08:00:00', '2024-06-01 18:00:00', 'CONFIRMED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Carlos Nina
(2, 2, 2, '2024-06-01 08:00:00', '2024-06-01 18:00:00', 'CONFIRMED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Maria Lopez
(3, 3, 3, '2024-06-01 08:00:00', '2024-06-01 18:00:00', 'CONFIRMED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- Juan Perez
(4, 4, 4, '2024-06-01 08:00:00', '2024-06-01 18:00:00', 'CONFIRMED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- Ana Torres


