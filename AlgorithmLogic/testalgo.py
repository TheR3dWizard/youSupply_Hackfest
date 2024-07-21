import numpy as np
from scipy.spatial import ConvexHull, QhullError
import matplotlib.pyplot as plt
import uuid
from collections import defaultdict
import random
from typing import List
from sklearn.cluster import KMeans
import pprint

class Node:
    def __init__(self, x_pos: int = 0, y_pos: int = 0, item: str = "", quantity: int = 1):
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
        return f"Node at: {self.x_pos},{self.y_pos} with {self.quantity} {self.itemtype}"

    def getdistance(self, other: "Node") -> float:
        return ((self.x_pos - other.x_pos) ** 2 + (self.y_pos - other.y_pos) ** 2) ** 0.5

    def __repr__(self):
        return f"{self.x_pos},{self.y_pos},{self.itemtype},{self.quantity};"

    def __gt__(self, other):
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
    def __init__(self, centerx=0, centery=0, distancelimit=6) -> None:
        self.identifier = str(uuid.uuid4())
        self.centerxpos = centerx
        self.centerypos = centery
        self.sourcenodes = []
        self.sinknodes = []
        self.path: Path = None
        self.subpaths: List[Path] = []
        self.inventory = defaultdict(int)
        self.clustermetric = 0
        self.allnodes = np.empty((0, 2), float)
        self.convexhullobject = None
        self.distancelimit = distancelimit

    def addnode(self, newnode: Node):
        self.allnodes = np.append(self.allnodes, [[newnode.x_pos, newnode.y_pos]], axis=0)
        self.updatecentroid()
        
        if newnode.nodetype == "Source":
            self.sourcenodes.append(newnode)
        elif newnode.nodetype == "Sink":
            self.sinknodes.append(newnode)
        else:
            raise TypeError("Invalid Node Type")

    def can_add_point(self, point):
        if len(self.allnodes) == 0:
            return True
        centroid = np.array([self.centerxpos, self.centerypos])
        return np.linalg.norm(centroid - point) <= self.distancelimit

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
            return self.getallnodes()

        self.updateinventory()
        freepool = []
        deficits = []
        excesses = []
        for i in self.inventory:
            if self.inventory[i] < 0:
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

        self.updateinventory()
        return freepool

    def getpath(self, curpos: Node = None) -> List[Node]:
        distance = 0
        visited = set()
        available = defaultdict(int)
        path = []

        closest = lambda node, possibilities: min(
            [(node.getdistance(_), _) for _ in possibilities if _ not in visited],
            key=lambda x: x[0],
        )

        current = self.sourcenodes[0]
        visited.add(current)
        path.append(current)

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
            nonlocal previndex, prevdistance
            for i in available:
                if available[i] != 0:
                    return
            print("Creating subpath")
            self.subpaths.append(Path(path[previndex:], distance - prevdistance))
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

    def getallnodes(self):
        return self.sourcenodes + self.sinknodes

    def getnodesofitem(self, itemtype: str):
        return [node for node in self.sourcenodes + self.sinknodes if node.itemtype == itemtype]

    def getsourcenodes(self):
        return self.sourcenodes

    def print(self):
        print(
            f"Cluster centered at {self.centerxpos},{self.centerypos} contains {len(self.sourcenodes)} sources and {len(self.sinknodes)} sinks."
        )

    def getstats(self):
        self.updateinventory()
        pprint.pprint(self.inventory)
        print(f"Total number of nodes: {self.getnumberofnodes()}")
        self.print()

    def clumsyprint(self):
        for source in self.sourcenodes:
            print(
                f"Source node at {source.x_pos},{source.y_pos} with {source.itemtype}: {source.quantity}"
            )
        for sink in self.sinknodes:
            print(
                f"Sink node at {sink.x_pos},{sink.y_pos} with {sink.itemtype}: {sink.quantity}"
            )

class System:
    def __init__(self, distancelimit=6):
        self.distancelimit = distancelimit
        self.listofnodes = []
        self.clusterlist = []
        self.freepool = []

    def addrequest(self, node: Node):
        for cluster in self.clusterlist:
            if cluster.can_add_point(np.array([node.x_pos, node.y_pos])):
                cluster.addnode(node)
                break
        else:
            new_cluster = Cluster(distancelimit=self.distancelimit)
            new_cluster.addnode(node)
            self.clusterlist.append(new_cluster)

    def plotclusters(self):
        colors = ["r", "g", "b", "y"]
        for idx, cluster in enumerate(self.clusterlist):
            x = [node.x_pos for node in cluster.tolist()]
            y = [node.y_pos for node in cluster.tolist()]
            plt.scatter(x, y, c=colors[idx % len(colors)], label=f"Cluster {idx+1}")
            plt.scatter(cluster.centerxpos, cluster.centerypos, c="k", marker="x")
        plt.xlabel("X Position")
        plt.ylabel("Y Position")
        plt.title("Clusters")
        plt.legend()
        plt.show()

    def stats(self):
        num_sources = sum(1 for node in self.listofnodes if node.nodetype == "Source")
        num_sinks = sum(1 for node in self.listofnodes if node.nodetype == "Sink")
        total_quantity = sum(node.quantity for node in self.listofnodes)

        cluster_stats = [(cluster.centerxpos, cluster.centerypos, cluster.tolist()) for cluster in self.clusterlist]

        return {
            "Number of Nodes": len(self.listofnodes),
            "Number of Sources": num_sources,
            "Number of Sinks": num_sinks,
            "Total Quantity": total_quantity,
            "Cluster Stats": cluster_stats,
        }

    def print(self):
        print("System Summary:")
        stats = self.stats()
        pprint.pprint(stats)

    def clumsyprint(self):
        print("Detailed System Information:")
        for idx, cluster in enumerate(self.clusterlist):
            print(f"Cluster {idx+1}:")
            cluster.clumsyprint()
        print("\nFree Pool Nodes:")
        for node in self.freepool:
            print(node)



if __name__ == "__main__":
    system = System(distancelimit=2)

    nodes = [
        Node(1, 1, "ItemA", 5),
        Node(1.5, 1.5, "ItemA", 3),
        Node(5, 5, "ItemB", -3),
        Node(5.5, 5.5, "ItemB", -2),
        Node(9, 9, "ItemA", 4),
        Node(9.5, 9.5, "ItemA", 2),
        Node(13, 13, "ItemB", -4),
        Node(13.5, 13.5, "ItemB", -1),
        Node(1, 5, "ItemA", 1),
        Node(5, 1, "ItemB", -1)
    ]

    for node in nodes:
        system.addrequest(node)

    print("System Summary:")
    system.print()

    print("\nDetailed Cluster Information:")
    system.clumsyprint()

    system.plotclusters()

    