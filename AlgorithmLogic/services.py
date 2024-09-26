import requests
from typing import List
from dotenv import load_dotenv
import os
from pprint import pprint
from math import sin, cos, sqrt, atan2, radians
import psycopg2

load_dotenv()

if os.name == "posix":
    __import__('pysqlite3')
    import sys
    sys.modules['sqlite3'] = sys.modules.pop('pysqlite3')

from chromadb import Client
from chromadb.config import Settings
from chromadb.api import Collection
class DatabaseObject:
    def __init__(self) -> None:
        self.connection = psycopg2.connect(
            dbname="hackfest",
            user="rootuser",
            password="rootroot",
            host="127.0.0.1",
            port=5432,
        )
        self.cursor = self.connection.cursor()

    def create_user(self, username: str, contact_number: str, password: str, userrole: str = 'client', latitude: float = None, longitude: float = None):
        query = """
        INSERT INTO users (username, contact_number, password, userrole, latitude, longitude)
        VALUES (%s, %s, %s, %s, %s, %s)
        RETURNING UserID
        """
        self.cursor.execute(query, (username, contact_number, password, userrole, latitude, longitude))
        self.connection.commit()
        return self.cursor.fetchone()[0]



    def create_resource(self, resource_id: str, resource_name: str, resource_type: str):
        query = """
        INSERT INTO resources (resource_id, resource_name, resource_type)
        VALUES (%s, %s, %s)
        """
        self.cursor.execute(query, (resource_id, resource_name, resource_type))
        self.connection.commit()

    def create_cart_entry(self, cart_id: int, resource_id: str, quantity: int, is_request: bool):
        query = """
        INSERT INTO CartEntries (CartID, resource_id, quantity, isRequest)
        VALUES (%s, %s, %s, %s)
        """
        self.cursor.execute(query, (cart_id, resource_id, quantity, is_request))
        self.connection.commit()


    def create_route_assignment(self, userid: int, routeid: int, routestatus: str = 'ASSIGNED', completedstep: int = 0):
        query = """
        INSERT INTO RouteAssignments (UserID, RouteID, RouteStatus, CompletedStep)
        VALUES (%s, %s, %s, %s)
        """
        self.cursor.execute(query, (userid, routeid, routestatus, completedstep))
        self.connection.commit()

    def create_cluster(self, cluster_id: str, latitude: float, longitude: float):
        query = """
        INSERT INTO clusters (cluster_id, latitude, longitude)
        VALUES (%s, %s, %s)
        """
        self.cursor.execute(query, (cluster_id, latitude, longitude))
        self.connection.commit()

    def create_node(self, 
                    node_id: str, 
                    resource_id: str, 
                    quantity: int, 
                    username: str, 
                    latitude: float, 
                    longitude: float, 
                    status: str = 'FREE', 
                    action: str = 'PICKUP', 
                    cluster_id:str="cluster1"
                    ):
        query = """
        INSERT INTO Nodes (node_id, resource_id, cluster_id, quantity, username, latitude, longitude, status, action)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        print(query.format(node_id, resource_id, cluster_id, quantity, username, latitude, longitude, status, action))
        self.cursor.execute(query, (node_id, resource_id, cluster_id, quantity, username, latitude, longitude, status, action))
        self.connection.commit()

    def create_route_step(self, route_id: int, step_id: int, node_id: str):
        query = """
        INSERT INTO RouteSteps (RouteID, StepID, NodeID)
        VALUES (%s, %s, %s)
        """
        self.cursor.execute(query, (route_id, step_id, node_id))
        self.connection.commit()

    def getNode(self, nodeid: str):
        query = f"SELECT * FROM nodes WHERE node_id='{nodeid}'"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def getAllNodes(self):
        query = "SELECT * FROM nodes"
        self.cursor.execute(query)
        return self.cursor.fetchall()
    
    def getNode(self, nodeid: str):
        query = f"SELECT * FROM nodes WHERE node_id='{nodeid}'"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def getresourcename(self, resourceid: str):
        query = f"SELECT resource_name FROM resources WHERE resource_id='{resourceid}'"
        self.cursor.execute(query)
        return self.cursor.fetchone()[0]

    def insertrequest(
        self,
        requestid: str,
        resourceid: str,
        clusterid: str,
        username: str,
        quantity: int,
        newlat: float,
        newlon: float,
    ):
        # check if clusterid is present in the cluster database
        # if not present, insert it

        query = f"SELECT * FROM clusters WHERE cluster_id='{clusterid}'"
        self.cursor.execute(query)
        result = self.cursor.fetchall()
        if not result:
            self.createcluster(clusterid, 0, 0)

        self.updateclustercentroid(clusterid, newlat, newlon)

        query = f"INSERT INTO requests (request_id, resource_id, cluster_id, username, quantity) VALUES ('{requestid}', '{resourceid}', '{clusterid}', '{username}', {quantity})"
        self.cursor.execute(query)
        self.connection.commit()

    def updaterequestquantity(self, requestid: str, quantity: int):
        query = (
            f"UPDATE requests SET quantity={quantity} WHERE request_id='{requestid}'"
        )
        self.cursor.execute(query)
        self.connection.commit()

    def removerequest(self, requestid: str):
        query = f"DELETE FROM requests WHERE request_id='{requestid}'"
        self.cursor.execute(query)
        self.connection.commit()

    def createcluster(self, clusterid: str, lat: float, lon: float):
        query = f"INSERT INTO clusters (cluster_id, latitude, longitude) VALUES ('{clusterid}', {lat}, {lon})"
        self.cursor.execute(query)
        self.connection.commit()

    def updateclustercentroid(self, clusterid, newlat, newlon):
        query = f"UPDATE clusters SET latitude = {newlat}, longitude = {newlon} WHERE id = {clusterid}"
        try:
            for result in self.connection.cmd_query_iter(query):
                pass  # Iterate through results to ensure all queries are executed
            self.connection.commit()
        except:
            self.connection.rollback()
            raise
        

    def removecluster(self, clusterid: str):
        query = f"DELETE FROM clusters WHERE cluster_id='{clusterid}'"
        self.cursor.execute(query)
        self.connection.commit()

    def insertresource(self, resourceid: str, resourcename: str, resourcetype: str):
        query = f"INSERT INTO resources (resource_id, resource_name, resource_type) VALUES ('{resourceid}', '{resourcename}', '{resourcetype}')"
        self.cursor.execute(query)
        self.connection.commit()

    def removeresource(self, resourceid: str):
        query = f"DELETE FROM resources WHERE resource_id='{resourceid}'"
        self.cursor.execute(query)
        self.connection.commit()
    
    def insertpath(self, pathid: str, pathobject: str):
        query = f"INSERT INTO pathstore (path_id, pathjson) VALUES ('{pathid}', \"{pathobject}\")"
        self.cursor.execute(query)
        self.connection.commit()
    
    def removepath(self, pathid: str):
        query = f"DELETE FROM pathstore WHERE path_id='{pathid}'"
        self.cursor.execute(query)
        self.connection.commit()
    
    def truncatepath(self):
        query = f"TRUNCATE TABLE pathstore"
        self.cursor.execute(query)
        self.connection.commit()
    
    def insert_user(
        self,
        userid: int,
        username: str,
        contact_number: str,
        password: str,
        userrole: str = 'user',  
        latitude: float = None,
        longitude: float = None
    ):
        query = f"INSERT INTO users (UserID, username, contact_number, password, userrole, latitude, longitude) VALUES ({userid}, '{username}', '{contact_number}', '{password}', '{userrole}', {latitude}, {longitude})"
        self.cursor.execute(query)
        self.connection.commit()

    
    def create_delivery_volunteer(
        self,
        userid: int,
        cur_latitude: float,
        cur_longitude: float
    ):
       
        query = f"SELECT * FROM users WHERE UserID = {userid} AND userrole = 'delvol'"
        self.cursor.execute(query)
        result = self.cursor.fetchall()

       
        if not result:
            raise ValueError(f"UserID {userid} does not exist or is not a delivery agent.")
        
       
        query = f"INSERT INTO DeliveryVolunteers (UserID, cur_latitude, cur_longitude) VALUES ({userid}, {cur_latitude}, {cur_longitude})"
        self.cursor.execute(query)
        self.connection.commit()

    def create_general_user(
        self,
        userid: int,
        cartid: int = None
    ):
       
        query = f"SELECT * FROM users WHERE UserID = {userid} AND userrole = 'user'"
        self.cursor.execute(query)
        result = self.cursor.fetchall()

        if not result:
            raise ValueError(f"UserID {userid} does not exist or is not a user.")


        if cartid:
            query = f"SELECT * FROM CartEntries WHERE CartID = {cartid}"
            self.cursor.execute(query)
            result = self.cursor.fetchall()

          
            if not result:
                raise ValueError(f"CartID {cartid} does not exist.")
        
       
        query = f"INSERT INTO GeneralUsers (UserID, cartid) VALUES ({userid}, {cartid})"
        self.cursor.execute(query)
        self.connection.commit()

    def getresourceid(self, resourcename: str):
        query = f"SELECT resource_id FROM resources WHERE resource_name = '{resourcename}'"
        self.cursor.execute(query)
        return self.cursor.fetchone()[0]
    
    def getlocfordelagent(self, userid: int):
        query = f"SELECT cur_latitude, cur_longitude FROM DeliveryVolunteers WHERE UserID = {userid}"
        self.cursor.execute(query)
        return self.cursor.fetchone()
    
    def getrouteid(self, userid: int):
        query = f"SELECT RouteID FROM RouteAssignments WHERE UserID = {userid}"
        self.cursor.execute(query)
        return self.cursor.fetchone()[0]
    
    def getsteps(self, routeid: int):
        query = f"SELECT * FROM RouteSteps WHERE RouteID = {routeid} ORDER BY StepID"
        self.cursor.execute(query)
        return self.cursor.fetchall()
    
    def getcompletedstep(self, routeid: int):
        query = f"SELECT CompletedStep FROM RouteAssignments WHERE RouteID = {routeid}"
        self.cursor.execute(query)
        return self.cursor.fetchone()[0]
    
    def markstep(self, username: str):
        userID = self.getuserid(username)
        routeid = self.getrouteid(userid)
        completedstep = self.getcompletedstep(routeid)
        query = f"UPDATE RouteAssignments SET CompletedStep = {completedstep + 1} WHERE RouteID = {routeid}"
        self.cursor.execute(query)
        self.connection.commit()
        return completedstep + 1
    
    def getuserid(self, username: str):
        query = f"SELECT UserID FROM users WHERE username = '{username}'"
        self.cursor.execute(query)
        return self.cursor.fetchone()[0]
    
    def getallnodeids(self):
        query = "SELECT node_id FROM Nodes"
        self.cursor.execute(query)
        return self.cursor.fetchall()
    

class GoogleAPI:
    def __init__(self):
        self.api_key = os.getenv("GOOGLE_API_KEY")

    def get_distance_matrix(
        self, listoforigins: List[List[float]], listofdestinations: List[List[float]]
    ):
        endpoint = "https://maps.googleapis.com/maps/api/distancematrix/json"

        origins = "|".join([",".join(map(str, origin)) for origin in listoforigins])
        destinations = "|".join(
            [",".join(map(str, destination)) for destination in listofdestinations]
        )

        params = {"origins": origins, "destinations": destinations, "key": self.api_key}

        response = requests.get(endpoint, params=params)

        if response.status_code != 200:
            raise Exception(f"Error making request: {response.status_code}")

        distance_matrix = response.json()

        if "rows" not in distance_matrix or not distance_matrix["rows"]:
            raise Exception("No rows found in response")

        return distance_matrix

    def returndistancebetweentwopoints(
        self, origin: List[float], destination: List[float]
    ):
        endpoint = "https://maps.googleapis.com/maps/api/distancematrix/json"

        params = {
            "origins": f"{origin[0]},{origin[1]}",
            "destinations": f"{destination[0]},{destination[1]}",
            "key": self.api_key,
        }

        response = requests.get(endpoint, params=params)

        if response.status_code != 200:
            raise Exception(f"Error making request: {response.status_code}")

        distance_matrix = response.json()

        try:
            output = {
                "distance": distance_matrix["rows"][0]["elements"][0]["distance"]["text"],
                "duration": distance_matrix["rows"][0]["elements"][0]["duration"]["text"],
            }
        except KeyError:
            # print(distance_matrix)
            # print(origin, destination)
            return {
                "distance": "1000 km",
                "duration": "3.1 mins",
            }

        return output

    def geocodecoordinatestoaddress(self, coordinatelist:List[float]):
        endpoint = "https://maps.googleapis.com/maps/api/geocode/json"
        print("Attempting to geocode coordinates", coordinatelist)

        params = {
            "key": self.api_key,
            "latlng": f"{coordinatelist[0]},{coordinatelist[1]}",
        }

        response = requests.get(endpoint, params=params)
        if response.status_code != 200:
            raise Exception(f"Error making request: {response.status_code}")

        return response.json()['results'][0]['formatted_address'][:26]

class MathFunctions:
    def __init__(self) -> None:
        self.earthradius = 6373.0
    
    def euclideandistance(self, point1: List[float], point2: List[float]):
        return ((point1[0] - point2[0]) ** 2 + (point1[1] - point2[1]) ** 2) ** 0.5
    
    def distancebetweentwopoints(self, origin: List[float], destination: List[float]):
        orglat, orglon = origin
        destlat, destlon = destination
        
        orglat = radians(orglat)
        orglon = radians(orglon)
        destlat = radians(destlat)
        destlon = radians(destlon)
        
        dlon = destlon - orglon
        dlat = destlat - orglat
        
        a = sin(dlat / 2) ** 2 + cos(orglat) * cos(destlat) * sin(dlon / 2) ** 2
        c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return self.earthradius * c

class ChromaDBAgent:
    def __init__(self) -> None:
        self.client = Client(Settings())
        self.collection_name = "node_objects"
        if self.collection_name not in self.client.list_collections():
            self.collection = self.client.create_collection(self.collection_name)
        else:
            self.collection = self.client.get_collection(self.collection_name)
    
    #error here
    def insertnodeobject(self, nodeobjectid: str, nodeobject):
        vectorobject = {
            "id": nodeobjectid,
            "vector": [nodeobject.x_pos,nodeobject.y_pos]
        }
        
        self.collection.upsert(vectorobject["id"], vectorobject["vector"])
    

    def getnearestneighbors(self, coordinates, kval=5):
        return self.collection.query(coordinates, n_results=kval)['ids']

    def clearindex(self):
        self.client.delete_collection(self.collection_name)
        self.collection = self.client.create_collection(self.collection_name)
    
    # select and display all the vectors in the collection
    def getallvectors(self):
        return self.collection.get()['ids']
    
    def deletevector(self, vectorid):
        self.collection.delete(id=vectorid)
    
    def deletevector(self, vectorid):
        self.collection.delete(id=vectorid)
    
    def numberofvectors(self):
        return len(self.collection.get()['ids'])

    def whatallcollectionhas(self):
        return dir(self.collection)

    def whatallclienthas(self):
        return dir(self.client)


if __name__ == "__main__":
    gmapi = GoogleAPI()
    mf = MathFunctions()
    
    print(gmapi.returndistancebetweentwopoints([10.990018, 76.002040],[10.991982, 77.008117]))
    print(mf.distancebetweentwopoints([10.990018, 76.002040],[10.991982, 77.008117]))


dbschema = '''
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
CREATE TABLE DeliveryVolunteers(
    UserID INT PRIMARY KEY,
    cur_latitude DECIMAL(10, 8),
    cur_longitude DECIMAL(11, 8),
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);
CREATE TABLE resources (
    resource_id CHAR(36) PRIMARY KEY,
    resource_name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50)
);
CREATE TABLE CartEntries(
    CartID INT UNIQUE,
    resource_id CHAR(36),
    quantity INT,
    isRequest BOOLEAN,
    PRIMARY KEY (CartID, resource_id),
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);
CREATE TABLE GeneralUsers(
    UserID INT PRIMARY KEY,
    cartid INT,
    FOREIGN KEY (cartid) REFERENCES CartEntries(CartID),
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);
CREATE TABLE RouteAssignments(
    UserID INT,
    RouteID INT PRIMARY KEY,
    RouteStatus routestatus DEFAULT 'ASSIGNED',
    CompletedStep INT,
    FOREIGN KEY (UserID) REFERENCES DeliveryVolunteers(UserID)
);
CREATE TABLE clusters (
    cluster_id CHAR(36) PRIMARY KEY,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);
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