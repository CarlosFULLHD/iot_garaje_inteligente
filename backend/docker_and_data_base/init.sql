CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       email VARCHAR(255) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       keypad_code VARCHAR(6) UNIQUE NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicles (
                          id SERIAL PRIMARY KEY,
                          user_id INT NOT NULL,
                          license_plate VARCHAR(255) UNIQUE NOT NULL,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE parkings (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          location VARCHAR(255) NOT NULL,
                          total_spots INT NOT NULL,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE spots (
                       id SERIAL PRIMARY KEY,
                       parking_id INT NOT NULL,
                       spot_number VARCHAR(255) NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (parking_id) REFERENCES parkings(id)
);

CREATE TABLE reservations (
                              id SERIAL PRIMARY KEY,
                              user_id INT NOT NULL,
                              vehicle_id INT NOT NULL,
                              spot_id INT NOT NULL,
                              scheduled_entry TIMESTAMP NOT NULL,
                              scheduled_exit TIMESTAMP NOT NULL,
                              actual_entry TIMESTAMP,
                              actual_exit TIMESTAMP,
                              status VARCHAR(255) NOT NULL,
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (user_id) REFERENCES users(id),
                              FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
                              FOREIGN KEY (spot_id) REFERENCES spots(id)
);
