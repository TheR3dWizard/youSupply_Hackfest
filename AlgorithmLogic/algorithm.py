import uuid
from typing import List
from collections import defaultdict
import matplotlib.pyplot as plt
import pprint
from services import GoogleAPI
import numpy as np
from scipy.spatial import ConvexHull, QhullError


class Node:
    """
    represents a request from a user for one item type
    if user a needs more than one item type, then there will be multiple nodes
    """

    def __init__(
        self, x_pos: int = 0, y_pos: int = 0, item: str = "", quantity: int = 1
    ):
        self.identifier = str(uuid.uuid4())
        self.x_pos = x_pos
        self.y_pos = y_pos
        self.itemtype = item
        self.quantity = quantity
        self.nodetype = ""

        if quantity < 0:
            self.nodetype = "Sink"
        elif quantity > 0:
            self.nodetype = "Source"
        else:
            raise TypeError("Quantity cannot be zero")

    def __str__(self):
        return (
            "Node at: "
            + str(self.x_pos)
            + ","
            + str(self.y_pos)
            + " with "
            + str(self.quantity)
            + " "
            + self.itemtype
        )

    def getdistance(self, other: "Node") -> float:
        return (
            (self.x_pos - other.x_pos) ** 2 + (self.y_pos - other.y_pos) ** 2
        ) ** 0.5

    def __repr__(self):
        return str({
            "itemtype": self.itemtype,
            "quantity": self.quantity,
            "latitude": self.x_pos,
            "longitude": self.y_pos
        })

    def export(self) -> dict:
        return {
            "itemtype": self.itemtype,
            "quantity": self.quantity,
            "latitude": self.x_pos,
            "longitude": self.y_pos
        }
    def __gtr__(self, other):
        return self.quantity > other.quantity

    def __lt__(self, other):
        return self.quantity < other.quantity


class Path:
    def __init__(self, path: List[Node], distance: float) -> None:
        self.identifier = str(uuid.uuid4())
        self.path = path
        self.distance = distance
        self.identifier = str(uuid.uuid4())
        self.xposition = path[0].x_pos
        self.yposition = path[0].y_pos

    def __repr__(self):
        return str({
            "pathidentifier": self.identifier,
            "distance": self.distance,
            "inwords": "Yet to be updated"
        })
    
    def export(self):
        return {
            "pathidentifier": self.identifier,
            "distance": self.distance,
            "inwords": "Yet to be updated"
        }
        
    def getPath(self):
        return self.path

    def getDistance(self):
        return self.distance

    def plotpath(self):
        pprint.pprint(self.path)
        x = [node.x_pos for node in self.path]
        y = [node.y_pos for node in self.path]
        start_node = self.path[0]
        end_node = self.path[-1]
        plt.plot(x, y, "-o")
        plt.plot(start_node.x_pos, start_node.y_pos, "go", label="Start Node")
        plt.plot(end_node.x_pos, end_node.y_pos, "ro", label="End Node")
        plt.xlabel("X Position")
        plt.ylabel("Y Position")
        plt.title("Path")
        plt.legend()
        print(f"Number of nodes in path: {len(self.path)}")
        plt.show()

    def constructdatabaseobject(self) -> dict:
        preliminaryinfodict = self.export()
        nodeinformation = []
        
        for node in self.path:
            nodeinformation.append(node.export())
        
        return {
            "pathinformation": preliminaryinfodict,
            "nodeinformation": nodeinformation
        }
        
        
        

class Cluster:
    """
    represents a group of nodes with one or more source and multiple sinks
    maintains a list of sources and sinks, and a metric to evaluate the cluster
    parameters centerxpos, centerypos represent some common 'center' while having multiple sources
    contains methods to
        - add sinks and sources
        - compute distance between provided node and centroid of the cluster
        - getter functions for class attributes
        - print function

    TODO: Implement a metric to evaluate the cluster

    """

    def __str__(self):
        return f"Cluster with the nodes {self.sourcenodes + self.sinknodes}"

    def __repr__(self):
        return self.__str__()

    def __init__(self, centerx=0, centery=0, usegooglemapsapi=False) -> None:
        self.identifier = str(uuid.uuid4())
        self.centerxpos = centerx
        self.centerypos = centery
        self.sourcenodes = []
        self.sinknodes = []
        self.path: Path = None
        self.subpaths: List[Path] = []
        self.inventory = defaultdict(int)
        self.usegooglemapsapi = usegooglemapsapi
        self.clustermetric = 0  # TODO: Implement a metric to evaluate the cluster
        self.allnodes = np.empty((0, 2))
        self.convexhullobject = None
        
    def addnode(self, newnode: Node):
        # self.allnodes.append([newnode.x_pos, newnode.y_pos])
        self.allnodes = np.vstack([self.allnodes, [newnode.x_pos, newnode.y_pos]]) 
        self.updatecentroid()
        
        if newnode.nodetype == "Source":
            self.sourcenodes.append(newnode)
        elif newnode.nodetype == "Sink":
            self.sinknodes.append(newnode)
        else:
            raise TypeError("Invalid Node Type")   
        
    def removesource(self, sourcenode: Node):
        if sourcenode in self.sourcenodes:
            self.sourcenodes.remove(sourcenode)
        else:
            raise ValueError("Node not in cluster")

    def removesink(self, sinknode: Node):
        if sinknode in self.sinknodes:
            self.sinknodes.remove(sinknode)
        else:
            raise ValueError("Node not in cluster")

    def updatecentroid(self):
        if len(self.allnodes) > 2:
            try:
                self.convexhullobject = ConvexHull(self.allnodes)
                hull_points = self.allnodes[self.convexhullobject.vertices]
                self.centerxpos, self.centerypos = self.polygon_centroid(hull_points)
            except QhullError:
                self.centerxpos, self.centerypos = np.mean(self.allnodes, axis=0)
        else:
            self.centerxpos, self.centerypos = np.mean(self.allnodes, axis=0)

    def polygon_centroid(self, points):
        if len(points) == 1:
            return points[0]
        x = points[:, 0]
        y = points[:, 1]
        a = np.sum(x[:-1] * y[1:] - x[1:] * y[:-1]) / 2
        cx = np.sum((x[:-1] + x[1:]) * (x[:-1] * y[1:] - x[1:] * y[:-1])) / (6 * a)
        cy = np.sum((y[:-1] + y[1:]) * (x[:-1] * y[1:] - x[1:] * y[:-1])) / (6 * a)
        return np.array([cx, cy])
    '''
    For a more accurate calculation of the centroid after adding each new node, you would need to keep track of the total number of nodes and use that in your calculation. Here's a corrected approach in pseudocode:

    1. Initialize `total_nodes` to 1 (assuming the first node is the starting point).
    2. For each new node added:
    - Increment `total_nodes` by 1.
    - Update centerxpos to (centerxpos * (total_nodes - 1) + newnode.x_pos) / total_nodes.
    - Update centerypos to (centerypos * (total_nodes - 1) + newnode.y_pos) / total_nodes.

    This method ensures that each node is weighted appropriately in the calculation of the centroid.
    '''

    def updateinventory(self):
        self.inventory = defaultdict(int)
        for i in self.sourcenodes:
            self.inventory[i.itemtype] += i.quantity
        for i in self.sinknodes:
            self.inventory[i.itemtype] += i.quantity

    def getfeasible(self) -> List[Node]:
        if self.sinknodes == [] or self.sourcenodes == []:
            return self.getallnodes()

        self.updateinventory()
        freepool = []
        deficits = []
        excesses = []
        ivnlen = len(self.inventory)
        dfclen = len(deficits)
        excenlen = len(excesses)
        counter = 0
        for i in self.inventory:
            print(f"Invetory checking {counter} of {ivnlen}")
            counter += 1
            if self.inventory[i] < 0:
                # TYPE: (QUANTITY, [NODES])
                deficits.append(
                    [self.inventory[i], [_ for _ in self.sinknodes if _.itemtype == i]]
                )
            elif self.inventory[i] > 0:
                excesses.append(
                    [
                        self.inventory[i],
                        [_ for _ in self.sourcenodes if _.itemtype == i],
                    ]
                )
        
        counter = 0
        
        for deficit, nodes in deficits:
            print(f"Deficit checking {counter} of {dfclen}")
            while deficit < 0:
                node = min(nodes, key=lambda x: x.quantity)

                deficit -= node.quantity
                nodes.remove(node)
                self.removesink(node)
                freepool.append(node)

        counter = 0
        for excess, nodes in excesses:
            print(f"Excess checking {counter} of {excenlen}")
            while excess > 0 and nodes:
                node = max(nodes, key=lambda x: x.quantity)
                if excess - node.quantity >= 0:
                    excess -= node.quantity
                    nodes.remove(node)
                    self.removesource(node)
                    freepool.append(node)
                else:
                    break
        # TODO: write functionality to change a half excess node into a full excess and fitting node
        # if deficit is -3, and sink is -5, then sink should be converted to a -2 node and freepool should have a -3 node

        print("Feasible pool created")
        self.updateinventory()
        print("Updated Inventory")
        return freepool

    def getpath(self, curpos: Node = None) -> List[Node]:
        self.subpaths = list()
        distance = 0
        visited = set()
        available = defaultdict(int)
        path = []

        if len(self.sourcenodes) == 0 or len(self.sinknodes) == 0:
            return []
        
        # function to get the closest node
        closest = lambda node, possibilities: min(
            [(node.getdistance(_), _) for _ in possibilities if _ not in visited],
            key=lambda x: x[0],
        )

        # TODO: make the first node the closest source node to the curpos
        current = self.sourcenodes[0]
        visited.add(current)
        path.append(current)

        # function to check if a node can be satisfied
        def check(node: Node):
            if node.itemtype in available:
                if available[node.itemtype] >= abs(node.quantity):
                    return True
                else:
                    return False
            return False

        previndex = 0
        prevdistance = 0

        def createsubpath():
            nonlocal previndex, prevdistance  # Add nonlocal keyword to access outer scope variables
            for i in available:
                if available[i] != 0:
                    return
            print("Creating subpath")
            self.subpaths.append(Path(path[previndex:], distance - prevdistance))
            # self.subpaths[-1].plotpath()
            previndex = len(path)
            prevdistance = distance

        while len(visited) < self.getnumberofnodes():
            available[current.itemtype] += current.quantity
            createsubpath()
            possiblesinks = [
                node for node in self.sinknodes if node not in visited and check(node)
            ]
            if not possiblesinks:
                possiblesources = [
                    node for node in self.sourcenodes if node not in visited
                ]
                nextdistance, next = closest(current, possiblesources)
            else:
                nextdistance, next = closest(current, possiblesinks)
            distance += nextdistance
            visited.add(next)
            path.append(next)
            current = next

        self.path = Path(path, distance)

    def plotallpaths(self):
        self.getpath()
        print("Main Path")
        self.path.plotpath()
        print("Subpaths")
        for subpath in self.subpaths:
            subpath.plotpath()

    def plotpath(self):
        self.getpath()
        self.path.plotpath()

    def tolist(self):
        return self.sourcenodes + self.sinknodes

    def getnumberofnodes(self):
        return len(self.sourcenodes) + len(self.sinknodes)

    def getsinklist(self):
        return self.sinknodes

    def getallnodes(self):
        return self.sourcenodes + self.sinknodes

    def getsourcelist(self):
        return self.sourcenodes

    def getdistance(self, nodeobject: Node) -> int:
        if self.usegooglemapsapi:
            googleapi = GoogleAPI()
            return float(googleapi.returndistancebetweentwopoints(
                [self.centerxpos, self.centerypos], [nodeobject.x_pos, nodeobject.y_pos]
            )['distance'][:-3])

        return (
            abs(nodeobject.x_pos - self.centerxpos) ** 2
            + abs(nodeobject.y_pos - self.centerypos) ** 2
        ) ** 0.5

    def getcenter(self):
        return self.centerxpos, self.centerypos

    def printcluster(self) -> None:
        print(f"Cluster Identifier: {self.identifier}")
        print(f"Cluster centered at {self.centerxpos}, {self.centerypos}")
        print(f"Number of Source Nodes: {len(self.sourcenodes)}")
        print(f"Number of Sink Nodes: {len(self.sinknodes)}\n")

    def getstats(self) -> dict:
        statslist = dict()
        statslist["Cluster Identifier"] = self.identifier
        statslist["Number of Source Nodes"] = len(self.sourcenodes)
        statslist["Number of Sink Nodes"] = len(self.sinknodes)
        statslist["Center"] = (self.centerxpos, self.centerypos)

        return statslist


class System:
    """
    represents the whole list of requests raised
    currently generates a list of requests of length totalnodes based on some pfactor and given list of items
    additionally this class also contains getter functions for class attributes
    plus two print methods:
        - print() : prints concise information about the system
        - clumsyprint() : prints extra information about the system

    TODO: getfeasible can be modification of print function, check itemcounter, offer and request hashmaps
    """

    def __str__(self):
        return f"System with {self.numberofnodes} nodes"

    def __repr__(self):
        return self.__str__()

    # can be initialized with a list of nodes or generate based on a probability factor
    def __init__(self, distancelimit, listofnodes:List[Node] = []) -> None:
        
        self.identifier = str(uuid.uuid4())
        self.threshold = distancelimit
        self.listofitems = ["Water Bottle", "Flashlight", "Canned Food"]

        self.numberofnodes: int = len(listofnodes)
        self.listofnodes: List[Node] = listofnodes
        self.listofpositions = (
            [
                (x,y)
                for x,y in zip(
                    [node.x_pos for node in listofnodes],
                    [node.y_pos for node in listofnodes],
                )
            ]
        )
        
        self.sourcenodes = list()
        self.sinknodes = list()
        self.numberofsourcenodes = 0
        self.numberofsinknodes = 0
        
        for node in self.listofnodes:
            if node.nodetype == "Source":
                self.sourcenodes.append(node)
                self.numberofsourcenodes += 1
            else:
                self.sinknodes.append(node)
                self.numberofsinknodes += 1
                
        
        self.clusterlist: List[Cluster] = []
        self.numberofclusters: int = 0

        self.freepool: List[Node] = []

    def addrequest(self, node: Node) -> Cluster:
        self.listofitems.append(node.itemtype)
        self.listofnodes.append(node)
        self.numberofnodes += 1
        
        if node.nodetype == "Sink":
            self.numberofsinknodes += 1
        else:
            self.numberofsourcenodes += 1

        if not self.numberofclusters:
            newcluster = Cluster(centerx=node.x_pos, centery=node.y_pos)
            newcluster.addnode(node)
            self.clusterlist.append(newcluster)
            self.numberofclusters += 1
            return newcluster

        distances = [cluster.getdistance(node) for cluster in self.clusterlist]
        minindex = distances.index(min(distances))
        if min(distances) <= self.threshold:
            self.clusterlist[minindex].addnode(node)
            return self.clusterlist[minindex]
        else:
            newcluster = Cluster(centerx=node.x_pos, centery=node.y_pos)
            newcluster.addnode(node)
            self.clusterlist.append(newcluster)
            self.numberofclusters += 1
            print(f"New Cluster Created: {newcluster.identifier}")
            return newcluster
    
    def betterremovenode(self, node: Node):
        self.listofnodes.remove(node)

        for cluster in self.clusterlist:
            if node.nodetype == "Sink" and node in cluster.getsinklist():
                cluster.removesink(node)
                self.numberofsinknodes -= 1
                return
            elif node.nodetype == "Source" and node in cluster.getsourcelist():
                cluster.removesource(node)
                self.numberofsourcenodes -= 1
                return
    
    def removeNode(self, node: Node):
        self.listofnodes.remove(node)
        if node.nodetype == "Sink":
            self.numberofsinknodes -= 1
        else:
            self.numberofsourcenodes -= 1
    
    def removePath(self, path: Path):
        for cluster in self.clusterlist:
            if path in cluster.subpaths:
                cluster.removepath(path)
        for node in path.path:
            self.removeNode(node)
    
    # TODO AKASH: check if this function needs to return a new System or if changes can be modified in place
    def reconstructsystem(self):
        print("Reconstructing the system")
        newsystem = System(distancelimit=self.threshold, listofnodes=[])
        print(f"New System from {self.listofnodes}")
        
        # for node in self.listofnodes:
            # print(node)
        
        for node in self.listofnodes:
            newsystem.addrequest(node)
        
        return newsystem

    def stats(self) -> dict:
        statslist = dict()

        statslist["Number of Nodes"] = self.numberofnodes
        statslist["Number of Clusters"] = self.numberofclusters
        statslist["Number of Items"] = len(self.listofitems)

        ClusterStats = []
        for cluster in self.clusterlist:
            ClusterStats.append(cluster.getstats())
        statslist["Cluster Stats"] = ClusterStats
        return statslist

    def createfreepool(self):
        clen = len(self.clusterlist)
        counter = 0
        for cluster in self.clusterlist:
            print(f"Cluster {counter} of {clen}")
            counter += 1
            self.freepool += cluster.getfeasible()
        print("Freepool created")
        return System(listofnodes=self.freepool, distancelimit=self.threshold)

    def isfeasiblesystem(self):
        return self.numberofsinknodes != 0 and self.numberofsourcenodes != 0

    def plotclusters(self):
        plt.figure(figsize=(10, 10))
        for cluster in self.clusterlist:
            x = [node.x_pos for node in cluster.tolist()]
            y = [node.y_pos for node in cluster.tolist()]
            plt.scatter(x, y)
        plt.show()

    def getnodes(self):
        return self.listofnodes

    def getnumberofsinknodes(self):
        return self.numberofsinknodes

    def getnumberofsourcenodes(self):
        return self.numberofsourcenodes

    def getnumberofnodes(self):
        return self.getnumberofsinknodes() + self.getnumberofsourcenodes()

    def getclusterslist(self):
        return self.clusterlist

    def getfreepool(self):
        return self.freepool

    def print(self):
        itemcounter = dict()
        offer = dict()
        request = dict()

        for node in self.listofnodes:
            if node.nodetype == "Sink":
                request[node.itemtype] = request.get(node.itemtype, 0) + node.quantity

            if node.nodetype == "Source":
                offer[node.itemtype] = offer.get(node.itemtype, 0) + node.quantity

            itemcounter[node.itemtype] = itemcounter.get(node.itemtype, 0) + 1

        print(f"Total Source Nodes: {self.numberofsourcenodes}")
        print(f"Total Sink Nodes: {self.numberofsinknodes}")

        for item in itemcounter:
            try:
                print(
                    f"{item}: Requested {request[item]}, Offered {offer[item]}, all concerning nodes {itemcounter[item]}"
                )
            except KeyError:
                print(
                    f"{item}: Requested {request[item]}, Offered 0, all concerning nodes {itemcounter[item]}"
                )

        for cluster in self.clusterlist:
            cluster.printcluster()

    def clumsyprint(self):
        itemcounter = dict()
        offer = dict()
        request = dict()

        for node in self.listofnodes:
            if node.nodetype == "Sink":
                request[node.itemtype] = request.get(node.itemtype, 0) + node.quantity

            if node.nodetype == "Source":
                offer[node.itemtype] = offer.get(node.itemtype, 0) + node.quantity

            itemcounter[node.itemtype] = itemcounter.get(node.itemtype, 0) + 1


        print(f"Total Source Nodes: {self.numberofsourcenodes}")
        print(f"Total Sink Nodes: {self.numberofsinknodes}")

        for item in itemcounter:
            print(
                f"{item}: Requested {request[item]}, Offered {offer[item]}, all concerning nodes {itemcounter[item]}"
            )
            print(f"Total number of nodes related to {item} is {itemcounter[item]}")
            print(f"Request total for {item} is {request[item]}")
            print(f"Offer total for {item} is {offer[item]}")

class PathComputationObject:
    def __init__(self) -> None:
        self.system = None
        self.freepoolsystem = None
        self.paths = []

    #function to set the system, will be called by the backend only when initializing the system
    #after initialization, the system will be set by the addNode function only and should not be called again
    def setSystem(self, targetsystem: System) -> None:
        self.system = targetsystem
        if not targetsystem.isfeasiblesystem():
            raise ValueError("System does not contain sinks or sources and is not feasible")
        
        print("Attempting reconstruction of the system")
        self.system = targetsystem.reconstructsystem()
        #figure out what to do with the freepool system
        #possible solutions:
        #1) maybe create a new system 
        #2) change it from a system into just a list of nodes
        #3) change addNode to add a node to the freepool system and not the main system
        print("Reconstruction successful, creating freepool system")
        self.freepoolsystem = self.system.createfreepool()
        print("Freepool system created, extracting all paths")
        self.paths = []
        for cluster in self.system.clusterlist:
            cluster.getpath()
            self.paths.append(cluster.path)
        print("All paths extracted")

    #function to add a node to the system
    #will automatically set the system and recalculate all paths
    def addNode(self, node: Node) -> None:
        self.system.addrequest(node)
        print("Passing the below system to the system setter")
        print(self.system.stats())
        try:
            self.setSystem(self.system)
        except ValueError as e:
            print("Could not set the system")

    #function to be called when a path is satisfied
    def removePath(self, path: Path) -> None:
        self.paths.remove(path)
        self.system.removePath(path)

    #function to get all the paths
    def getPaths(self) -> List[Path]:
        return self.paths
    
    #TODO: functionality to handle paths in the different layers (available, in progress, completed) with no inconsistencies
    # probably the hardest thing :)

    def formatpathoutput(self, bulkexportobject) -> List[dict]:
        numberofpaths = len(bulkexportobject)
        baseobject = {
            "numberofpaths": numberofpaths
        }
        
        for pathexport in bulkexportobject:
            baseobject[pathexport["pathinformation"]['pathidentifier']] = pathexport
        
        return baseobject