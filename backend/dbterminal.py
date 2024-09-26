from dotenv import load_dotenv
import os
import psycopg2



load_dotenv()

url = os.getenv("DB_URL")
print(url)

connection = psycopg2.connect(url)
cursor = connection.cursor()

SCHEMA = '''
CREATE TYPE userrole AS ENUM ('delagent', 'client');
CREATE TYPE routestatus AS ENUM ('ASSIGNED', 'COMPLETED');
CREATE TYPE node_status AS ENUM ('FREE', 'INPATH', 'SATISFIED');
CREATE TYPE action AS ENUM ('PICKUP', 'DROP');
CREATE TABLE users (
    UserID SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    contact_number VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL,
    userrole userrole DEFAULT 'client',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

INSERT INTO users (username, contact_number, password, userrole, latitude, longitude) VALUES 
('john_doe', '123456789', 'password123', 'client', 40.712776, -74.005974),
('jane_smith', '0987654321', 'password456', 'delagent', 34.052235, -118.243683),
('alice_jones', '5555555555', 'password789', 'client', 37.774929, -122.419418),
('bob_brown', '123456789', 'password123', 'client', 40.712776, -74.005974),

CREATE TABLE DeliveryVolunteers(
    UserID INT PRIMARY KEY,
    cur_latitude DECIMAL(10, 8),
    cur_longitude DECIMAL(11, 8),
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

INSERT INTO DeliveryVolunteers (UserID, cur_latitude, cur_longitude) VALUES
((SELECT UserID FROM users WHERE username = 'jane_smith'), 34.052235, -118.243683);

CREATE TABLE resources (
    resource_id CHAR(36) PRIMARY KEY,
    resource_name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50)
);

INSERT INTO resources (resource_id, resource_name, resource_type) VALUES
('1', 'food', 'grocery'),
('2', 'clothes', 'apparel'),
('3', 'toys', 'children');

CREATE TABLE CartEntries(
    CartID INT UNIQUE,
    resource_id CHAR(36),
    quantity INT,
    isRequest BOOLEAN,
    PRIMARY KEY (CartID, resource_id),
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);

INSERT INTO CartEntries (CartID, resource_id, quantity, isRequest) VALUES
(1, '1', 5, TRUE),
(1, '2', 10, TRUE),
(2, '3', 2, TRUE);

CREATE TABLE GeneralUsers(
    UserID INT PRIMARY KEY,
    cartid INT,
    FOREIGN KEY (cartid) REFERENCES CartEntries(CartID),
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

INSERT INTO GeneralUsers (UserID, cartid) VALUES 
((SELECT UserID FROM users WHERE username = 'john_doe'), 1),
((SELECT UserID FROM users WHERE username = 'alice_jones'), 2),
((SELECT UserID FROM users WHERE username = 'bob_brown'), NULL);


CREATE TABLE RouteAssignments(
    UserID INT,
    RouteID INT PRIMARY KEY,
    RouteStatus routestatus DEFAULT 'ASSIGNED',
    CompletedStep INT,
    FOREIGN KEY (UserID) REFERENCES DeliveryVolunteers(UserID)
);

INSERT INTO RouteAssignments (UserID, RouteID, RouteStatus, CompletedStep) VALUES
((SELECT UserID FROM users WHERE username = 'jane_smith'), 1, 'ASSIGNED', 0);

CREATE TABLE clusters (
    cluster_id CHAR(36) PRIMARY KEY,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

INSERT INTO clusters (cluster_id, latitude, longitude) VALUES
('cluster1', 34.052235, -118.243683),
('cluster2', 34.052240, -118.243680);

CREATE TABLE Nodes (
    node_id CHAR(36) PRIMARY KEY,
    resource_id CHAR(36),
    cluster_id CHAR(36),
    quantity INT,
    username VARCHAR(50),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    status node_status DEFAULT 'FREE',
    action action DEFAULT 'PICKUP',
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id),
    FOREIGN KEY (cluster_id) REFERENCES clusters(cluster_id),
    FOREIGN KEY (username) REFERENCES users(username)
);

create TABLE RouteSteps(
    RouteID INT,
    StepID INT,
    NodeID CHAR(36),
    PRIMARY KEY (RouteID, StepID),
    FOREIGN KEY (RouteID) REFERENCES RouteAssignments(RouteID),
    FOREIGN KEY (NodeID) REFERENCES Nodes(node_id)
);


'''

# Insert some users into the users table
insert_users_query = '''
INSERT INTO users (username, contact_number, password, userrole, latitude, longitude) VALUES
('john_doe', '1234567890', 'password123', 'client', 40.712776, -74.005974),
('jane_smith', '0987654321', 'password456', 'delagent', 34.052235, -118.243683),
('alice_jones', '5555555555', 'password789', 'client', 37.774929, -122.419418);
'''

# Insert corresponding entries into DeliveryVolunteers and GeneralUsers tables
insert_volunteers_query = '''
INSERT INTO DeliveryVolunteers (UserID, cur_latitude, cur_longitude) VALUES
((SELECT UserID FROM users WHERE username = 'jane_smith'), 34.052235, -118.243683);
'''

insert_general_users_query = '''
INSERT INTO GeneralUsers (UserID, cartid) VALUES
((SELECT UserID FROM users WHERE username = 'john_doe'), NULL),
((SELECT UserID FROM users WHERE username = 'alice_jones'), NULL);
'''

# cursor.execute(insert_users_query)
# cursor.execute(insert_volunteers_query)
# cursor.execute(insert_general_users_query)
# Insert some nodes near the delivery volunteers
insert_nodes_query = '''
INSERT INTO Nodes (node_id, resource_id, cluster_id, quantity, username, latitude, longitude, status, action) VALUES
('node1', '1', 'cluster1', 10, 'jane_smith', 34.052235, -118.243683, 'FREE', 'PICKUP'),
('node2', '1', 'cluster1', 5, 'jane_smith', 34.052240, -118.243680, 'FREE', 'DROP');
'''

import json
import random

def generate_node(username):
    return {
        "xposition": random.randint(0, 100),
        "yposition": random.randint(0, 100),
        "itemid": random.choice(["food","clothes"]),
        "quantity": random.randint(-10, 10),
        "username": username
    }

def generate_json(num_nodes, username):
    nodelist = [generate_node(username) for _ in range(num_nodes)]
    return json.dumps({"nodelist": nodelist}, indent=4)

if __name__ == "__main__":
    num_nodes = 100  # Change this to generate more or fewer nodes
    username = "john_doe"
    json_data = generate_json(num_nodes, username)
    print(json_data)

    # Insert some resources into the resources table
    select_resources_query = '''
    SELECT * FROM resources;
    '''

    cursor.execute(select_resources_query)
    resources = cursor.fetchall()
    for resource in resources:
        print(resource)

    # cursor.execute(insert_nodes_query)
    connection.commit()
    cursor.close()
    connection.close()
