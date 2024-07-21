CREATE DATABASE hackfest;

USE hackfest;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    contact_number VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

INSERT INTO users (username, contact_number, password, latitude, longitude)
VALUES
('john_doe', '1234567890', 'password123', 37.774929, -122.419418),
('jane_smith', '0987654321', 'securePass!', 40.712776, -74.005974),
('alice_jones', '5551234567', 'myPassword!', 34.052235, -118.243683),
('bob_brown', '4449876543', 'passw0rd', 51.507351, -0.127758),
('carol_white', '3338765432', 'Qwerty123$', 48.856613, 2.352222);
