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

CREATE TABLE resources (
    resource_id CHAR(36) PRIMARY KEY,
    resource_name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50) NOT NULL
);

INSERT INTO resources (resource_id, resource_name, resource_type) VALUES ('c8b1d27f-e9c4-4c28-a7db-332daba4ac42', 'First Aid Kit', 'Medical');
INSERT INTO resources (resource_id, resource_name, resource_type) VALUES ('9fdb9531-29d9-41e6-aeb3-5e1fdf79c867', 'Water Bottles', 'Supplies');
INSERT INTO resources (resource_id, resource_name, resource_type) VALUES ('6674ea86-9340-4a81-bf7a-d583b054f7a0', 'Blankets', 'Shelter');
INSERT INTO resources (resource_id, resource_name, resource_type) VALUES ('619d8b87-a67c-4769-bbf0-839715a3603d', 'Flashlights', 'Supplies');
INSERT INTO resources (resource_id, resource_name, resource_type) VALUES ('754788e4-a944-44d3-ad80-f3e5c6a8b689', 'Food Packages', 'Supplies');

CREATE TABLE clusters (
    cluster_id CHAR(36) PRIMARY KEY,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

INSERT INTO clusters (cluster_id, latitude, longitude) VALUES ('44128509-e819-4dbe-965e-1e188ef44050', 37.774929, -122.419418);
INSERT INTO clusters (cluster_id, latitude, longitude) VALUES ('4d138cf0-9b41-4447-b11b-8f704d633ead', 40.712776, -74.005974);
INSERT INTO clusters (cluster_id, latitude, longitude) VALUES ('0211b363-decd-4b8f-bba2-0827ce397fa3', 34.052235, -118.243683);
INSERT INTO clusters (cluster_id, latitude, longitude) VALUES ('d8826fe1-04ec-4496-b908-3b8cec3f5f33', 51.507351, -0.127758);
INSERT INTO clusters (cluster_id, latitude, longitude) VALUES ('a4556046-d142-4474-afad-62bee3ecfd7a', 48.856613, 2.352222);

CREATE TABLE requests (
    request_id CHAR(36) PRIMARY KEY,
    resource_id CHAR(36),
    cluster_id CHAR(36),
    username VARCHAR(50),
    quantity INT,
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id),
    FOREIGN KEY (cluster_id) REFERENCES clusters(cluster_id),
    FOREIGN KEY (username) REFERENCES users(username)
);

INSERT INTO requests (request_id, resource_id, cluster_id, username, quantity) VALUES 
('0cf780ca-5b7d-4f12-aa0c-047c3ab2c3e4', '6674ea86-9340-4a81-bf7a-d583b054f7a0', '0211b363-decd-4b8f-bba2-0827ce397fa3', 'JohnDoe', 50),
('c9d81ffe-e238-41f8-8169-1679e25e7a8f', '754788e4-a944-44d3-ad80-f3e5c6a8b689', '44128509-e819-4dbe-965e-1e188ef44050', 'JaneDoe', 30),
('f3a2bfb8-26b5-44c0-848e-da40749bb967', '6674ea86-9340-4a81-bf7a-d583b054f7a0', '4d138cf0-9b41-4447-b11b-8f704d633ead', 'MikeSmith', 20),
('29437e02-8b27-4a5f-99e0-8a02144743ee', '754788e4-a944-44d3-ad80-f3e5c6a8b689', 'a4556046-d142-4474-afad-62bee3ecfd7a', 'abca', 40),
('4e91f029-fd81-444b-b374-222c47def861', 'c8b1d27f-e9c4-4c28-a7db-332daba4ac42', 'd8826fe1-04ec-4496-b908-3b8cec3f5f33', 'abc', 60);