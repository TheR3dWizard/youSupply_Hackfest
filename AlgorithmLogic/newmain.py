import random
from typing import List
from collections import defaultdict


class Node:
    """
    One request per item
    if one person asks for more than one items
    He/She will be associated with more than one nodes
    """

    def __init__(
        self, x_pos: int = 0, y_pos: int = 0, item: str = '', quantity: int = 1
    ):
        self.x_pos = x_pos
        self.y_pos = y_pos
        self.itemtype = item
        self.quantity = quantity
        self.nodetype = ""
        self.associatedsinks = list()
        self.associatedsource = None

        if quantity < 0:
            self.nodetype = "Sink"
        elif quantity > 0:
            self.nodetype = "Source"
        else:
            raise TypeError("Quantity cannot be zero")

    def setsink(self, nodeobject):
        if self.nodetype == "Sink":
            raise TypeError("Cannot associate a sink with other sinks")
        # if self.itemtype == nodeobject.itemtype:
        #     self.associatedsinks.append(nodeobject)

    def setsource(self, sourceobject):
        if self.nodetype == "Source":
            raise TypeError("Cannot associate a source with other sources")
        if self.itemtype == sourceobject.itemtype:
            self.associatedsource = sourceobject

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


def generateNodes(p=0.3, num=5):
    nodes = []

    itemList = ["Water Bottle", "Flashlight", "Canned Food"]

    sinkcounter, sourcecounter = 0, 0

    for _ in range(0, num):
        x = random.randint(0, 5000)
        y = random.randint(0, 5000)
        item = random.choice(itemList)
        if random.random() < p:
            sinkcounter += 1
            quantity = random.randint(-10, -1)
            nodes.append(Node(x, y, item, quantity))
        else:
            sourcecounter += 1
            quantity = random.randint(1, 10)
            nodes.append(Node(x, y, item, quantity))

    return nodes


def createDistanceMatrix(sinks: int, sources: int) -> List[List[int]]:
    distanceMatrix = []
    for _ in range(sinks):
        row = []
        for _ in range(sources):
            row.append(random.randint(1, 10))
        distanceMatrix.append(row)
    return distanceMatrix


class ClusteringObject:
    """
    creates a list of clusters and associates sinks with nearest source
    """

    def __init__(self, system: List[Node]) -> None:
        self.systemofnodes = system
        self.distancematrix = []
        self.extras = []
        self.deficits = []
        self.sourcenodes = [
            node for node in self.systemofnodes if node.nodetype == "Source"
        ]
        self.sinknodes = [
            node for node in self.systemofnodes if node.nodetype == "Sink"
        ]
        self.clusterobject = []

    def getdistance(self, nodeobject1: Node, nodeobject2: Node):
        return (
            (nodeobject1.x_pos - nodeobject2.x_pos) ** 2
            + (nodeobject1.y_pos - nodeobject2.y_pos) ** 2
        ) ** 0.5

    def Cluster(self) -> List[List[Node]]:
        # for sink in self.sinknodes:
        #     mindistance = float('inf')
        #     nearestsource = Node()
        #     for source in self.sourcenodes:
        #         newdistance = self.getdistance(sink,source)
        #         if newdistance < mindistance:
        #             mindistance = newdistance
        #             nearestsource = source

        #     sink.setsink(nearestsource)

        # sourcesinkmap has a list of sinks [values] associated with a source [key]
        sourcesinkmap = defaultdict(list)

        for sink in self.sinknodes:
            mindistance = float("inf")
            nearestsource = Node()
            for source in self.sourcenodes:
                newdistance = self.getdistance(sink, source)
                if newdistance < mindistance:
                    mindistance = newdistance
                    nearestsource = source

            sink.setsource(nearestsource)

            sourcesinkmap[nearestsource].append(sink)

        return sourcesinkmap


# class SystemObject:
#     def __init__(self, listofnodes: List[Node]) -> None:
#         matrixsize

system = generateNodes(p=0.6, num=100)
cluster = ClusteringObject(system)

print(cluster.Cluster())
