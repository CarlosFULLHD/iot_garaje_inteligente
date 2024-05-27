-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-05-26 02:15:45.829

-- tables
-- Table: parking
CREATE TABLE parking (
                         id int  NOT NULL,
                         name varchar(255)  NOT NULL,
                         location varchar(255)  NOT NULL,
                         total_space int  NOT NULL,
                         total_rows int  NOT NULL,
                         total_columns int  NOT NULL,
                         created_at timestamp  NULL DEFAULT current_timestamp,
                         updated_at timestamp  NULL DEFAULT current_timestamp,
                         CONSTRAINT parkings_pk PRIMARY KEY (id)
);

-- Table: reservation
CREATE TABLE reservation (
                             id int  NOT NULL,
                             vehicles_id int  NOT NULL,
                             space_id int  NOT NULL,
                             keypad_code varchar(6)  NOT NULL,
                             CONSTRAINT reservations_pk PRIMARY KEY (id)
);

-- Table: rol
CREATE TABLE rol (
                     id int  NOT NULL,
                     name varchar(255)  NOT NULL,
                     description varchar(255)  NOT NULL,
                     CONSTRAINT rol_pk PRIMARY KEY (id)
);

-- Table: space
CREATE TABLE space (
                       id int  NOT NULL,
                       parking_id int  NOT NULL,
                       space_number varchar(255)  NOT NULL,
                       rows_number int  NOT NULL,
                       columns_number int  NOT NULL,
                       status int  NOT NULL,
                       created_at timestamp  NULL DEFAULT current_timestamp,
                       updated_at timestamp  NULL DEFAULT current_timestamp,
                       CONSTRAINT spots_pk PRIMARY KEY (id)
);

-- Table: user
CREATE TABLE "user" (
                        id int  NOT NULL,
                        name varchar(255)  NOT NULL,
                        last_name varchar(255)  NOT NULL,
                        email varchar(255)  NOT NULL,
                        password varchar(255)  NOT NULL,
                        created_at timestamp  NULL DEFAULT current_timestamp,
                        updated_at timestamp  NULL DEFAULT current_timestamp,
                        rol_id int  NOT NULL,
                        CONSTRAINT AK_0 UNIQUE (email) NOT DEFERRABLE  INITIALLY IMMEDIATE,
                        CONSTRAINT users_pk PRIMARY KEY (id)
);

-- Table: vehicle
CREATE TABLE vehicle (
                         id int  NOT NULL,
                         user_id int  NOT NULL,
                         license_plate varchar(255)  NOT NULL,
                         branch varchar(255)  NOT NULL,
                         model varchar(255)  NOT NULL,
                         created_at timestamp  NULL DEFAULT current_timestamp,
                         updated_at timestamp  NULL DEFAULT current_timestamp,
                         CONSTRAINT AK_2 UNIQUE (license_plate) NOT DEFERRABLE  INITIALLY IMMEDIATE,
                         CONSTRAINT vehicles_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: reservation_space (table: reservation)
ALTER TABLE reservation ADD CONSTRAINT reservation_space
    FOREIGN KEY (space_id)
        REFERENCES space (id)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: reservation_vehicle (table: reservation)
ALTER TABLE reservation ADD CONSTRAINT reservation_vehicle
    FOREIGN KEY (vehicles_id)
        REFERENCES vehicle (id)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: space_parking (table: space)
ALTER TABLE space ADD CONSTRAINT space_parking
    FOREIGN KEY (parking_id)
        REFERENCES parking (id)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: user_rol (table: user)
ALTER TABLE "user" ADD CONSTRAINT user_rol
    FOREIGN KEY (rol_id)
        REFERENCES rol (id)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: vehicule_user (table: vehicle)
ALTER TABLE vehicle ADD CONSTRAINT vehicule_user
    FOREIGN KEY (user_id)
        REFERENCES "user" (id)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.