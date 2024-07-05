import random
import uuid
from typing import List
from collections import defaultdict
from sklearn.cluster import KMeans, SpectralClustering
import matplotlib.pyplot as plt


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

    def __repr__(self):
        return self.__str__()

    def __gtr__(self, other):
        return self.quantity > other.quantity

    def __lt__(self, other):
        return self.quantity < other.quantity


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

    def __init__(self, sourcenode: Node, identifier: str = None) -> None:
        if not identifier:
            self.identifier = str(uuid.uuid4())

        self.centerxpos = sourcenode.x_pos
        self.centerypos = sourcenode.y_pos
        self.sourcenodes = [sourcenode]
        self.associatedsinknodes = []
        self.clustermetric = 0  # TODO: Implement a metric to evaluate the cluster

    def addsink(self, sinknode: Node):
        if sinknode.nodetype != "Sink":
            raise TypeError("Invalid Sink Node")
        self.associatedsinknodes.append(sinknode)

    def addsource(
        self, sourcenode: Node
    ):  # TODO: Update centerxpos, centerypos after adding a source, center -> centroid
        if sourcenode.nodetype != "Source":
            raise TypeError("Invalid Source Node")
        self.sourcenodes.append(sourcenode)

    def tolist(self):
        return self.sourcenodes + self.associatedsinknodes

    def getsinklist(self):
        return self.associatedsinknodes

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
        print(f"Number of Sink Nodes: {len(self.associatedsinknodes)}")


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

    def __init__(
        self, totalnodes: int, pfactor: float, itemlist: List[str] = None
    ) -> None:
        self.numberofnodes = totalnodes
        self.probabilityfactor = pfactor
        if not itemlist:
            self.listofitems = ["Water Bottle", "Flashlight", "Canned Food"]
        else:
            self.listofitems = itemlist
        self.listofpositions = []
        self.listofnodes = []
        self.numberofsinknodes = 0
        self.numberofsourcenodes = 0
        self.clusterlist = []
        self.generatenodes()
        self.createclusters()

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
            self.listofpositions.append((x,y))

    def createclusters(self):
        spc = SpectralClustering(n_clusters=8, random_state=42, affinity='nearest_neighbors')
        spc.fit(self.listofpositions)
        cluster_labels = spc.labels_
        clusters = defaultdict(list)

        for i, label in enumerate(cluster_labels):
            clusters[label].append(self.getnodes()[i])

        for cluster_nodes in clusters.values():
            sourcenode = cluster_nodes[0]
            cluster = Cluster(sourcenode)
            for node in cluster_nodes[1:]:
                if node.nodetype == "Sink":
                    cluster.addsink(node)
                else:
                    cluster.addsource(node)
            self.clusterlist.append(cluster)

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

    def getclusterlist(self):
        return self.clusterlist

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
                f"{item}: Requested {request[item]}, Offered {offer[item]}, all concerning nodes {itemcounter[item]}"
            )

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


class ClusteringObject:
    """
    represents the class that performs clustering on a list of nodes (system)
    (flawed) clustering logic is contained in the .mapsinkstosource()
    .getclusterlist() to return the list after clustering

    TODO: Need logic for grouping clusters together
    TODO: New method that returns avg cluster size to measure cluster efficiency?
    TODO: Do we really need a class for this? or can this be inside the Cluster class itself?
    """

    def __init__(self, systemofnodes: System) -> None:
        self.clusterlist = []
        self.sinknodes = []
        self.sourcenodes = []

        for node in systemofnodes.getnodes():
            if node.nodetype == "Sink":
                self.sinknodes.append(node)
            else:
                self.sourcenodes.append(node)

        for sourcenode in self.sourcenodes:
            self.clusterlist.append(Cluster(sourcenode))

        self.mapsinkstosource()

    def mapsinkstosource(self):
        for sinknode in self.sinknodes:
            mindistance = float("inf")
            nearestsource = None
            for clusterobject in self.clusterlist:
                newdistance = clusterobject.getdistance(sinknode)
                if newdistance < mindistance:
                    mindistance = newdistance
                    nearestsource = clusterobject

            nearestsource.associatedsinknodes.append(sinknode)

    def getclusterlist(self):
        return self.clusterlist


systemobject = System(totalnodes=100, pfactor=0.8)
systemobject.print()

print("\n\n")

# co = ClusteringObject(systemobject)
# clusterlist = co.getclusterlist()

clusterlist = systemobject.getclusterlist()


print("Total number of clusters: ", len(clusterlist))
size = 0
for i in clusterlist:
    size += len(clusterlist)
    i.printcluster()
    print()

print("Total number of nodes",size)
systemobject.plotclusters()