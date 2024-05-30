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
name varchar(75) NOT NULL,
last_name varchar(75) NOT NULL,
email varchar(30) NOT NULL UNIQUE,
password varchar(255) NOT NULL,
pin_code varchar(6) NOT NULL UNIQUE,
created_at timestamp NULL DEFAULT current_timestamp,
updated_at timestamp NULL DEFAULT current_timestamp
);

-- Table: vehicles
CREATE TABLE IF NOT EXISTS vehicles (
id_vehicles serial NOT NULL PRIMARY KEY,
user_id int NOT NULL REFERENCES users(id_users) ON DELETE CASCADE,
license_plate varchar(255) NOT NULL UNIQUE,
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
user_id INT REFERENCES users(id_user) ON DELETE CASCADE,
vehicle_id INT REFERENCES vehicles(id_vehicle) ON DELETE CASCADE,
spot_id INT REFERENCES spots(id_spot) ON DELETE CASCADE,
scheduled_entry TIMESTAMP NOT NULL,
scheduled_exit TIMESTAMP NOT NULL,
actual_entry TIMESTAMP,
actual_exit TIMESTAMP,
status VARCHAR(50) NOT NULL,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


