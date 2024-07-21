CREATE DATABASE hackfest;

USE hackfest;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    contact_number VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL,
    userrole ENUM('delagent', 'client') DEFAULT 'client',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

INSERT INTO users (username, contact_number, password, userrole, latitude, longitude) VALUES
('JohnDoe', '1234567890', 'password123', 'client', 37.774929, -122.419416),
('JaneDoe', '0987654321', 'securePass456', 'delagent', 34.052234, -118.243685),
('MikeSmith', '5555555555', 'mySuperPass789', 'client', 40.712776, -74.005974);

