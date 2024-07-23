from flask import Flask
from algorithm import System, Cluster, Node
from flask import request
from services import DatabaseObject
import json

def read_json_file(file_path):
    with open(file_path, "r") as file:
        data = json.load(file)
    return data

centralsystemobject = System(distancelimit=5)
databaseobject = DatabaseObject()

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

    databaseobject.insertrequest(
        requestid=newnode.identifier,
        resourceid=body["itemid"],
        clusterid=updatedcluster.identifier,
        username=body["username"],
        quantity=body["quantity"],
        newlat=updatedcluster.centerxpos,
        newlon=updatedcluster.centerxpos,
    )

    return centralsystemobject.stats()

@app.route("/sample/paths", methods=["POST"])
def getpaths():
    body = request.get_json()
    return read_json_file("samplepaths.json")
    

@app.route("/get/stats")
def stats():
    return centralsystemobject.stats()


if __name__ == "__main__":
    app.run(port=6969)
