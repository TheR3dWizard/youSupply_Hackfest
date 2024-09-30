from flask import Flask
from algorithm import System, Path, Node, PathComputationObject, Cluster
from flask import request
from services import DatabaseObject, ChromaDBAgent
import json
import uuid
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

def getNodeObject(self, nodeid: str):
    result = databaseobject.getNode(nodeid)
    if not result:
        return None
    result = result[0]
    resource_id = result[1]

    resource_name = databaseobject.getresourcename(resource_id)
    return Node(
        x_pos=result[5],
        y_pos=result[6],
        item=resource_name,
        quantity=result[3],
    )


@app.route("/")
def home():
    return "this API will be used to natively interact with the algorithm logic"

#WORKS
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
                "username": "john_doe"
            },
            {
                "xposition": 1,
                "yposition": 1,
                "itemid": "Flashlight",
                "quantity": -1,
                "username": "john_doe"
            }
        ]
    }
    '''


    for node in body["nodelist"]:
        node_obj = Node(
            x_pos=node["xposition"],
            y_pos=node["yposition"],
            item=node["itemid"],
            quantity=node["quantity"]
        )
        nodeid = str(uuid.uuid4())
        chromadbagent.insertnodeobject(nodeid,node_obj)
        resource_id = databaseobject.getresourceid(node["itemid"])
        quantity = node["quantity"]
        username = node["username"]
        latitude = node["xposition"]
        longitude = node["yposition"]
        action = "PICKUP" if quantity > 0 else "DROP"
        databaseobject.create_node(
            node_id=nodeid,
            resource_id=resource_id,
            quantity=quantity,
            username=username,
            latitude=latitude,
            longitude=longitude,
            action=action
        )

    return "Worked"


@app.route("/path/get", methods=["GET"])
def serveassortment():
    example='''
        {
            username :"john_doe"
        }
    '''

    body = request.get_json()
    userid = databaseobject.getuserid(body['username'])
    xposition,yposition = databaseobject.getlocfordelagent(userid)
    
    nodeidlist = chromadbagent.getnearestneighbors([float(xposition), float(yposition)], kval=100)
    
    masternodeslist = centralsystemobject.getnodes()
    assortednodeslist: List[Node] = []
    
    for node in masternodeslist:
        if node and node.identifier in nodeidlist:
            assortednodeslist.append(node)
    
    # TODO AKASH: check if distancelimit = inf is fine
    # pathsystem = System(distancelimit=float('inf'))
    
    # TODO AKASH: check if we can do setSystem mutiple times on the 
    # same object with every time a different system
    computepathobject.setCluster(assortednodeslist)
    paths = computepathobject.getPathsFromCluster()
    
    exampleoutput= '''
    [{
        pathinfo:uuid.uuid4()
        nodes:[
        {
            nodeid
        },
        {},
        {}
        ]
    },
    ]
    '''
    print(paths)
    # TODO AKASH: formart the paths properly
    formatted_paths = []
    for path in paths:
        formatted_path = {
            "pathinfo": str(uuid.uuid4()),
            "nodes": [{"nodeid": node.identifier} for node in path.nodes]
        }
        formatted_paths.append(formatted_path)

    return json.dumps(formatted_paths, indent=4)
    

@app.route("/path/lookup", methods=["GET"])
def getpath():
    exampleinput='''
    {
        username:
    }
    '''
    body = request.get_json()
    route_id = databaseobject.getrouteid(body['userid'])
    steps = databaseobject.getsteps(route_id)
    output = {}
    output["nodes"] = []
    for step in steps:
        nodeid = step[2]
        node = databaseobject.getNodeObject(nodeid)
        output["nodes"].append(node.export())
        output["completed"] = databaseobject.getcompletedstep(route_id)

    return output


@app.route("/path/accept", methods=["POST"])
def acceptpath():

    body = request.get_json()
    '''
    {
        "userid": "JohnDoe",
        nodes: [
            nodeid1,
            nodeid2,
            nodeid3
        ]    
    }
    '''
    userid = body["userid"]
    nodeids = body["nodes"]
    routeid = str(uuid.uuid4())
    databaseobject.create_route_assignment(userid=userid,routeid=routeid)

    step = 0
    for nodeid in nodeids:
        databaseobject.create_route_step(routeid=routeid,nodeid=nodeid,step_id=step)
    return "Worked"

@app.route("/path/markstep",methods=["POST"])
def markstep():
    body = request.get_json()
    '''
    {
        "userid": "JohnDoe",
    }
    '''
    step = databaseobject.markstep(body["userid"])
    return step


@app.route("/sample/paths", methods=["GET"])
def getpaths():
    body = request.get_json()
    return read_json_file("samplepaths.json")



@app.route("/get/stats")
def stats():
    return centralsystemobject.stats()

@app.route("/get/db/stats", methods=["GET"])
def dbstats():
    return chromadbagent.getallvectors()

    


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=4160)
