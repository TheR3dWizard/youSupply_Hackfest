import requests
from typing import List
from dotenv import load_dotenv
import os
import mysql.connector
from pinecone.grpc import PineconeGRPC as Pinecone
from pinecone import ServerlessSpec

load_dotenv()


class DatabaseObject:
    def __init__(self) -> None:
        self.connection = mysql.connector.connect(
            host=os.getenv("HOST"),
            user=os.getenv("UNAME"),
            password=os.getenv("PASSWORD"),
            database=os.getenv("DATABASE"),
        )
        self.cursor = self.connection.cursor()

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

    def updateclustercentroid(self, clusterid: str, lat: float, lon: float):
        query = f"UPDATE clusters SET latitude={lat}, longitude={lon} WHERE cluster_id='{clusterid}'"
        self.cursor.execute(query)
        self.connection.commit()

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

        output = {
            "distance": distance_matrix["rows"][0]["elements"][0]["distance"]["text"],
            "duration": distance_matrix["rows"][0]["elements"][0]["duration"]["text"],
        }

        return output

from pinecone.grpc import PineconeGRPC as Pinecone
import os

class VectorDatabaseObject:
    def __init__(self) -> None:
        self.pinecodeobject = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
        self.indexname = "pathobjects"
        self.pathobject = self.pinecodeobject.Index(self.indexname)
    
    def insertpathobject(self, pathobjectid: str, coordinates):
        vectorobject = {
            "id": pathobjectid,
            "values": coordinates
        }
        
        self.pathobject.upsert(vectors=[
        vectorobject
        ])
        
    def removepathobjects(self):
        for ids in self.pathobject.list():
            self.pathobject.delete(ids=ids)
    
    
    # get neerest neighbors by passing the coordinates of the point
    def getnearestneighbors(self, coordinates, kval=5):
        return self.pathobject.query(vector=coordinates, top_k=kval)

    def clearindex(self):
        self.pinecodeobject.delete_index(self.indexname)
        # After deleting the index, recreate it
        self.pinecodeobject.create_index(self.indexname,2,ServerlessSpec(cloud="aws", region="us-east-1"),metric="euclidean")
        self.pathobject = self.pinecodeobject.Index(self.indexname)

vdb = VectorDatabaseObject()
vdb.insertpathobject("1", [1, 1])
vdb.insertpathobject("2", [2, 2])
vdb.insertpathobject("3", [3, 3])
vdb.insertpathobject("4", [4, 4])
vdb.insertpathobject("5", [5, 5])
vdb.insertpathobject("100", [100, 100])
vdb.insertpathobject("200", [200, 200])

print(vdb.getnearestneighbors([1, 1]))