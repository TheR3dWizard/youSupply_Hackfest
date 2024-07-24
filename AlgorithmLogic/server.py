from flask import Flask
from algorithm import System, Cluster, Node, PathComputationObject
from flask import request,jsonify
from services import DatabaseObject, ChromaDBAgent
import json

def read_json_file(file_path):
    with open(file_path, "r") as file:
        data = json.load(file)
    return data

computepathobject = PathComputationObject()
centralsystemobject = System(distancelimit=5)
databaseobject = DatabaseObject()
chromadbagent = ChromaDBAgent()

centralsystemobject.addrequest(Node(x_pos=1, y_pos=1, item="Flashlight", quantity=1))
centralsystemobject.addrequest(Node(x_pos=1, y_pos=1, item="Flashlight", quantity=-1))

app = Flask(__name__)


@app.route("/")
def home():
    return "this API will be used to natively interact with the algorithm logic"


@app.route("/add/node", methods=["POST"])
def addrequest():
    body = request.get_json()

    newnode = Node(
        x_pos=body["xposition"],
        y_pos=body["yposition"],
        item=body["itemid"],
        quantity=body["quantity"],
    )
    updatedcluster = centralsystemobject.addrequest(newnode)
    
    computepathobject.setSystem(centralsystemobject)
    
    databaseobject.insertrequest(
        requestid=newnode.identifier,
        resourceid=body["itemid"],
        clusterid=updatedcluster.identifier,
        username=body["username"],
        quantity=body["quantity"],
        newlat=updatedcluster.centerxpos,
        newlon=updatedcluster.centerxpos,
    )

    recomputedpaths = computepathobject.getPaths()
    
    chromadbagent.clearindex()
    
    for path in recomputedpaths:
        if not path:
            continue
        print(path)
        chromadbagent.insertpathobject(path.identifier, [path.xposition, path.yposition])
    
    return centralsystemobject.stats()

@app.route("/sample/paths", methods=["POST"])
def getpaths():
    body = request.get_json()
    return read_json_file("samplepaths.json")

from flask import jsonify, request

@app.route("/get/paths", methods=["POST"])
def getactualpaths():
    body = request.get_json()

    return chromadbagent.getnearestneighbors([body["xposition"], body["yposition"]])


@app.route("/get/stats")
def stats():
    return centralsystemobject.stats()

@app.route("/get/db/stats", methods=["GET"])
def dbstats():
    return chromadbagent.getallvectors()


if __name__ == "__main__":
    app.run(port=6969)
