import random
import uuid
from typing import List, Optional
from collections import defaultdict
from sklearn.cluster import KMeans, SpectralClustering
import matplotlib.pyplot as plt
import pprint


class Node:
    """
    represents a request from a user for one item type
    if user a needs more than one item type, then there will be multiple nodes
    """

    def __init__(
        self, x_pos: int = 0, y_pos: int = 0, item: str = "", quantity: int = 1
    ):
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

    TODO: Finalize centerxpos and centerypos
    TODO: Implement a metric to evaluate the cluster

    """

    def __str__(self):
        return f"Cluster with the nodes {self.sourcenodes + self.sinknodes}"

    def __repr__(self):
        return self.__str__()

    def __init__(self, identifier: str = None) -> None:
        if not identifier:
            self.identifier = str(uuid.uuid4())

        # TODO: figure out some way to get center of the cluster @OKeerthiKuttan
        self.centerxpos = 0
        self.centerypos = 0
        self.sourcenodes = []
        self.sinknodes = []
        self.path: Path = None
        self.subpaths: List[Path] = []
        self.inventory = defaultdict(int)
        self.clustermetric = 0  # TODO: Implement a metric to evaluate the cluster

    def addsink(self, sinknode: Node):
        if sinknode.nodetype != "Sink":
            raise TypeError("Invalid Sink Node")
        self.sinknodes.append(sinknode)

    def addsource(
        self, sourcenode: Node
    ):  # TODO: Update centerxpos, centerypos after adding a source, center -> centroid
        if sourcenode.nodetype != "Source":
            raise TypeError("Invalid Source Node")
        self.sourcenodes.append(sourcenode)

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

    def updateinventory(self):
        self.inventory = defaultdict(int)
        for i in self.sourcenodes:
            self.inventory[i.itemtype] += i.quantity
        for i in self.sinknodes:
            self.inventory[i.itemtype] += i.quantity

    def getfeasible(self) -> List[Node]:
        if self.sinknodes == [] or self.sourcenodes == []:
            freepool = self.getallnodes()
            self.sinknodes == []
            self.sourcenodes == []

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

        if self.sinknodes == [] or self.sourcenodes == []:
            freepool = self.getallnodes()
            self.sinknodes == []
            self.sourcenodes == []



        for excess, nodes in excesses:
            while excess > 0:
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

        if self.sinknodes == [] or self.sourcenodes == []:
            freepool = self.getallnodes()
            self.sinknodes == []
            self.sourcenodes == []

        self.updateinventory()
        return freepool

    def getpath(self, curpos: Node = None) -> List[Node]:
        distance = 0
        visited = set()
        available = defaultdict(int)
        path = []

        if self.sinknodes == [] or self.sourcenodes == []:
            return path

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
        if self.path == []:
            return
        print("Main Path")
        self.path.plotpath()
        print("Subpaths")
        for subpath in self.subpaths:
            subpath.plotpath()

    def plotpath(self):
        self.getpath()
        self.path.plotpath()

    def removepath(self,path:Path):
        self.subpaths.remove(path)
        for node in path.path:
            if node.nodetype == "Sink":
                self.removesink(node)
            else:
                self.removesource(node)

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
        return (
            abs(nodeobject.x_pos - self.centerxpos) ** 2
            + abs(nodeobject.y_pos - self.centerypos) ** 2
        ) ** 0.5

    def printcluster(self) -> None:
        print(f"Cluster Identifier: {self.identifier}")
        print(f"Cluster centered at {self.centerxpos}, {self.centerypos}")
        print(f"Number of Source Nodes: {len(self.sourcenodes)}")
        print(f"Number of Sink Nodes: {len(self.sinknodes)}\n")


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
    def __init__(
        self,
        totalnodes: int = 100,
        pfactor: float = 0.5,
        itemlist: List[str] = None,
        listofnodes: List[Node] = None,
    ) -> None:
        self.numberofnodes = len(listofnodes) if listofnodes else totalnodes
        self.probabilityfactor = pfactor
        if not itemlist:
            self.listofitems = ["Water Bottle", "Flashlight", "Canned Food"]
        else:
            self.listofitems = itemlist
        self.listofpositions = (
            [
                (x, y)
                for x, y in zip(
                    [node.x_pos for node in listofnodes],
                    [node.y_pos for node in listofnodes],
                )
            ]
            if listofnodes
            else []
        )
        self.listofnodes = listofnodes if listofnodes else []
        self.sourcenodes = (
            [_ for _ in listofnodes if _.nodetype == "Source"] if listofnodes else []
        )
        self.sinknodes = (
            [_ for _ in listofnodes if _.nodetype == "Sink"] if listofnodes else []
        )
        self.numberofsinknodes = (
            len([_ for _ in listofnodes if _.nodetype == "Sink"]) if listofnodes else 0
        )
        self.numberofsourcenodes = (
            len([_ for _ in listofnodes if _.nodetype == "Source"])
            if listofnodes
            else 0
        )
        self.clusterlist: List[Cluster] = []
        self.freepool: List[Node] = []
        if not listofnodes:
            self.generatenodes()

    def addNode(self, node: Node):
        self.listofnodes.append(node)
        if node.nodetype == "Sink":
            self.numberofsinknodes += 1
        else:
            self.numberofsourcenodes += 1

    

    def removeNode(self, node: Node):
        self.listofnodes.remove(node)
        if node.nodetype == "Sink":
            self.numberofsinknodes -= 1
        else:
            self.numberofsourcenodes -= 1
    
    #function to remove a path from a system in case the path is saitisfied
    def removePath(self, path: Path):
        for cluster in self.clusterlist:
            if path in cluster.subpaths:
                cluster.removepath(path)
        for node in path.path:
            self.removeNode(node)


    def generatenodes(self) -> None:
        for _ in range(0, self.numberofnodes):
            x = random.randint(0, 5000)
            y = random.randint(0, 5000)
            item = random.choice(self.listofitems)
            if random.random() < self.probabilityfactor:
                self.numberofsinknodes += 1
                quantity = random.randint(-10, -1)
                self.listofnodes.append(Node(x, y, item, quantity))
            else:
                self.numberofsourcenodes += 1
                quantity = random.randint(1, 10)
                self.listofnodes.append(Node(x, y, item, quantity))
            self.listofpositions.append((x, y))

    def spectralclustering(self, num_points: int = 50):
        spc = SpectralClustering(
            n_clusters=self.getnumberofnodes() // num_points if self.getnumberofnodes() // num_points != 0 else 1,
            random_state=42,
            affinity="nearest_neighbors",
        )
        spc.fit(self.listofpositions)
        cluster_labels = spc.labels_
        clusters = defaultdict(list)

        for i, label in enumerate(cluster_labels):
            clusters[label].append(self.getnodes()[i])
        print()
        for cluster_nodes in clusters.values():
            cluster = Cluster()
            for node in cluster_nodes:
                if node.nodetype == "Sink":
                    cluster.addsink(node)
                else:
                    cluster.addsource(node)
            self.clusterlist.append(cluster)

    def changeSytemtoCluster(self):
        cluster = Cluster()
        for node in self.listofnodes:
            if node.nodetype == "Sink":
                cluster.addsink(node)
            else:
                cluster.addsource(node)
        self.clusterlist.append(cluster)

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

    def plotsystem(self):
        plt.figure(figsize=(10, 10))
        
        x_source = [node.x_pos for node in self.sourcenodes]
        y_source = [node.y_pos for node in self.sourcenodes]
        x_sink = [node.x_pos for node in self.sinknodes]
        y_sink = [node.y_pos for node in self.sinknodes]
        plt.scatter(x_source, y_source, color='blue', label='Source')
        plt.scatter(x_sink, y_sink, color='red', label='Sink')
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
            print(
                    f'''{item}: Requested {request[item] if item in request else 0}, 
Offered {offer[item] if item in offer else 0}, 
all concerning nodes {itemcounter[item]}'''
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


class Solution:
    def __init__(self, system: System = None) -> None:
        self.system = system if system else System(totalnodes=100, pfactor=0.4)
        if not self.system.isfeasiblesystem():
            print("System is not feasible")
            return
        self.system.spectralclustering(num_points=100)
        self.system.print()
        self.freepoolsystem = self.system.createfreepool()
        self.system.plotclusters()
        if self.freepoolsystem.isfeasiblesystem():
            self.nextSol = Solution(self.freepoolsystem)
        for cluster in self.system.clusterlist:
            cluster.plotallpaths()

    def getallpaths(self):
        paths = []
        for cluster in self.system.clusterlist:
            # cluster.getpath()
            paths.append(cluster.subpaths)
        return paths

#uncomment the following lines to test the code
# sol = Solution()
# paths = sol.getallpaths()

#the class that will be used by the backend (fully abstracted) 
class Algorithm:
    def __init__(self) -> None:
        self.system: System = System(totalnodes=0)
        self.freepoolsystem = None
        self.paths = []

    #function to set the system, will be called by the backend only when initializing the system
    #after initialization, the system will be set by the addNode function only and should not be called again
    def setSystem(self, system: System) -> None:
        self.system = system
        if not self.system.isfeasiblesystem():
            raise ValueError("System does not contain sinks or sources and is not feasible")
        
        #implement distance based clustering here
        # self.system.plotsystem()

        self.system.spectralclustering(num_points=75)
        self.system.plotclusters()
        #this function just changes the clusterlist to one cluster containing all the nodes
        # self.system.changeSytemtoCluster()
        #figure out what to do with the freepool system
        #possible solutions:
        #1) maybe create a new system 
        #2) change it from a system into just a list of nodes
        #3) change addNode to add a node to the freepool system and not the main system
        self.freepoolsystem = self.system.createfreepool()
        self.system.plotclusters()

        for cluster in self.system.clusterlist:
            cluster.getpath()
            self.paths.append([cluster.path,cluster.subpaths])

    #function to add a node to the system
    #will automatically set the system and recalculate all paths
    def addNode(self, node: Node) -> None:
        self.system.addNode(node)
        self.setSystem(self.system)

    #function to be called when a path is satisfied
    def removePath(self, path: Path) -> None:
        self.paths.remove(path)
        self.system.removePath(path)

    #function to get all the paths
    def getPaths(self) -> List[Path]:
        return self.paths
    
    #TODO: functionality to handle paths in the different layers (available, in progress, completed) with no inconsistencies
    # probably the hardest thing :)


alg = Algorithm()
alg.setSystem(System(totalnodes= 500,pfactor = 0.8))
paths = alg.getPaths()

for mainpath,subpaths in paths:
    print("Main Path")
    mainpath.plotpath()
    for subpath in subpaths:
        print("Subpath")
        subpath.plotpath()