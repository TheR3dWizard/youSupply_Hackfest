from flask import Flask
from algorithm import System, Path, Node, PathComputationObject, Cluster
from flask import request,jsonify
from services import DatabaseObject, ChromaDBAgent
import json
from pprint import pprint
from typing import List

def read_json_file(file_path):
    with open(file_path, "r") as file:
        data = json.load(file)
    return data

computepathobject = PathComputationObject()
centralsystemobject = System(distancelimit=5)
databaseobject = DatabaseObject()
chromadbagent = ChromaDBAgent()
masterpathlist: List[Path] = list()
centralsystemobject.addrequest(Node(x_pos=40.646984, y_pos=-73.789450, item="Flashlight", quantity=1))
centralsystemobject.addrequest(Node(x_pos=42.646984, y_pos=-73.789450, item="Flashlight", quantity=-1))

app = Flask(__name__)


@app.route("/")
def home():
    return "this API will be used to natively interact with the algorithm logic"


@app.route("/add/node", methods=["POST"])
def addrequest():
    body = request.get_json()
    '''
    new body format
    {
        "nodelist": [
            {
                "xposition": 1,
                "yposition": 1,
                "itemid": "Flashlight",
                "quantity": 1,
                "username": "JohnDoe"
            },
            {
                "xposition": 1,
                "yposition": 1,
                "itemid": "Flashlight",
                "quantity": -1,
                "username": "JohnDoe"
            }
        ]
    }
    '''
    for node in body["nodelist"]:
        newnode = Node(
            x_pos=node["xposition"],
            y_pos=node["yposition"],
            item=node["itemid"],
            quantity=node["quantity"],
        )
        
        updatedcluster = centralsystemobject.addrequest(newnode)
    
        databaseobject.insertrequest(
            requestid=newnode.identifier,
            resourceid=node["itemid"],
            clusterid=updatedcluster.identifier,
            username=node["username"],
            quantity=node["quantity"],
            newlat=updatedcluster.centerxpos,
            newlon=updatedcluster.centerxpos,
        )
    
    return centralsystemobject.stats()

@app.route("/assortment/serve", methods=["GET"])
def serveassortment():
    body = request.get_json()
    xposition, yposition = body["xposition"], body["yposition"]
    
    return chromadbagent.getnearestneighbors([xposition, yposition], kval=100)

@app.route('/assortment/obtain', methods=["GET"])
def obtainassortment():
    body = request.get_json()
    nodelist = body["nodelist"]
    
    masternodeslist = centralsystemobject.getnodes()
    assortednodeslist: List[Node] = []
    
    for node in masternodeslist:
        if node and node.identifier in nodelist:
            assortednodeslist.append(node)
    
    # TODO AKASH: check if distancelimit = inf is fine
    pathsystem = System(distancelimit=float('inf'), listofnodes=assortednodeslist)
    
    # TODO AKASH: check if we can do setSystem mutiple times on the 
    # same object with every time a different system
    computepathobject.setSystem(pathsystem)
    paths = computepathobject.getPaths()
    
    # TODO AKASH: formart the paths properly
    return paths.constructdatabaseobject()

@app.route("/obtain/paths", methods=["GET"])
def getpaths():
    body = request.get_json()
    pathobject = body["pathobject"]
    agentid = body["agentid"]
    
    # TODO AKASH: correct the below line, like adding agent id
    databaseobject.insertpath(pathobject.identifier, pathobject.constructdatabaseobject())
    nodeslist: List[Node] = body["nodeslist"]
    for node in nodeslist:
        chromadbagent.deletevector(node.identifier)
        
    return pathobject.identifier
@app.route("/sample/paths", methods=["POST"])
def getpaths():
    body = request.get_json()
    return read_json_file("samplepaths.json")

from flask import jsonify, request

@app.route("/get/paths", methods=["POST"])
def getactualpaths():
    body = request.get_json()

    nearestids = chromadbagent.getnearestneighbors([body["xposition"], body["yposition"]])  #gets nearest paths not nodes
    nearestpaths: List[Path] = list()
    if len(nearestids) == 0:
        return {
            "message": "No paths returned from the database"
        }
    
    masterpathlist = computepathobject.getPaths()
    if not masterpathlist:
        return {
            "message": "No paths in the masterpathlist"
        }

    for path in masterpathlist:
        if path and path.identifier in nearestids[0]:
            nearestpaths.append(path)
    
    if len(nearestpaths) == 0:
        return {
            "message": "No paths matched the nearest neighbors"
        }
    exportlist = []
    
    for path in nearestpaths:
        exportlist.append(path.constructdatabaseobject())
    
    return computepathobject.formatpathoutput(exportlist)


@app.route("/get/stats")
def stats():
    return centralsystemobject.stats()

@app.route("/get/db/stats", methods=["GET"])
def dbstats():
    return chromadbagent.getallvectors()

@app.route("/get/computepaths",methods=["GET"])
def computepaths():
    body = request.get_json()
    latitude = body["latitude"]
    longitude = body["longitude"]

    nearestnodeids = chromadbagent.getnearestneighbors([latitude, longitude])  #should get nearest nodes
    nearestnodes = list()
    if len(nearestnodeids) == 0:
        return {
            "message": "No nodes returned from the database"
        }
    
    for i in nearestnodeids:
        nearestnodes.append(databaseobject.getNodeObject(i))
    
    computepathobject.setCluster(nearestnodes)
    paths =  computepathobject.getPaths()
    


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=4160)
