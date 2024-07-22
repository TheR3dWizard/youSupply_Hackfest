import uuid
from typing import List
from collections import defaultdict
import matplotlib.pyplot as plt
import pprint
from services import GoogleAPI
import numpy as np



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
        return f"{self.x_pos},{self.y_pos},{self.itemtype},{self.quantity};"

    def __gtr__(self, other):
        return self.quantity > other.quantity

    def __lt__(self, other):
        return self.quantity < other.quantity


class Path:
    def __init__(self, path: List[Node], distance: float) -> None:
        self.path = path
        self.distance = distance
        self.identifier = str(uuid.uuid4())

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

        # TODO KEERTHI
        # create a numpy array called allnodes hint: use self.allnodes during declaration

        # TODO KEERTHI
        # create a ConvexHull object for this cluster like self.convexhullobject 
        # initalize it to the empty numpy array created previously 
        # try incremental = True param in ConvexHull

    def addnode(self, newnode: Node):
        # TODO KERTHI repalce the below two lines with a trigger to update centroid 
        self.centerypos = (self.centerypos + newnode.y_pos) / 2
        self.centerxpos = (self.centerxpos + newnode.x_pos) / 2
        
        if newnode.nodetype == "Source":
            self.sourcenodes.append(newnode)
        elif newnode.nodetype == "Sink":
            self.sinknodes.append(newnode)
        else:
            raise TypeError("Invalid Node Type")   
        # TODO KERTHI
        # extract the xposition and yposition from the Node object and append it to the all nodes array     
        
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

    # TODO KEERTHI
    # create a function update centroid that essentially gets the vertices from the convexhull object 
    # and recomputes the centroid 
    # after recomputing it updates the value to the centerxpos and centerypos variables of the class
    #                           self.centerxpos  and  self.centerypos
    # hint: create function as def updatecentroid(self):

    # also check if the below function would work

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
        for i in self.inventory:
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

        for deficit, nodes in deficits:
            while deficit < 0:
                node = min(nodes, key=lambda x: x.quantity)

                deficit -= node.quantity
                nodes.remove(node)
                self.removesink(node)
                freepool.append(node)

        for excess, nodes in excesses:
            while excess > 0:
                node = max(nodes, key=lambda x: x.quantity)
                if excess - node.quantity >= 0:
                    excess -= node.quantity
                    nodes.remove(node)
                    self.removesource(node)
                    freepool.append(node)
        # TODO: write functionality to change a half excess node into a full excess and fitting node
        # if deficit is -3, and sink is -5, then sink should be converted to a -2 node and freepool should have a -3 node

        self.updateinventory()
        return freepool

    def getpath(self, curpos: Node = None) -> List[Node]:
        distance = 0
        visited = set()
        available = defaultdict(int)
        path = []

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
            return googleapi.returndistancebetweentwopoints(
                [self.centerxpos, self.centerypos], [nodeobject.x_pos, nodeobject.y_pos]
            )

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
    def __init__(self, distancelimit) -> None:
        self.identifier = str(uuid.uuid4())
        self.threshold = distancelimit
        self.listofitems = set()

        self.numberofnodes: int = 0
        self.listofnodes: List[Node] = []

        self.clusterlist: List[Cluster] = []
        self.numberofclusters: int = 0

        self.freepool: List[Node] = []

    def addrequest(self, node: Node) -> Cluster:
        self.listofitems.add(node.itemtype)
        self.listofnodes.append(node)
        self.numberofnodes = 0

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
        for cluster in self.clusterlist:
            self.freepool += cluster.getfeasible()
        return System(listofnodes=self.freepool)

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
