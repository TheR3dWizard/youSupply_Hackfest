import heapq
from math import sqrt
import random as r
import itertools

class node:
    def __init__(self,x_pos: int, y_pos:int ,item: str,quantity:int):
        self.x_pos = x_pos
        self.y_pos = y_pos
        self.item = item
        self.quantity = quantity

    def __str__(self):
        return "Node at: " + str(self.x_pos) + "," + str(self.y_pos) + " with " + str(self.quantity) + " " + self.item

    def __repr__(self):
        return self.__str__()
    
    def __gtr__(self,other):
        return self.quantity > other.quantity
    
    def __lt__(self,other):
        return self.quantity < other.quantity

       
itemList = ["Water Bottle","Flashlight","Canned Food"]
freepool = []

def generateNodes(p = 0.3,num = 10):
    nodes = []
    for i in range(0,num):
        x = r.randint(0,5000)
        y = r.randint(0,5000)
        item = r.choice(itemList)
        if r.random() < p:
            quantity = r.randint(-10,-1)
        else:
            quantity = r.randint(1,10)
        nodes.append(node(x,y,item,quantity))
    return nodes

def printCluster(nodes: list):
    sinks = []
    sources = []
    for i in nodes:
        print(i)
        if i.quantity < 0:
            sinks.append(i)
        else:
            sources.append(i)
    print("Number of sources:",len(sources))
    print("Number of sinks:",len(sinks))
    
#placeholder to simulate distance matrix from API
def generateDistanceMatrix(nodes: list):
    matrix = []
    for i in nodes:
        row = []
        for j in nodes:
            row.append(sqrt((j.x_pos - i.x_pos)**2 + (j.y_pos - i.y_pos)**2))
        matrix.append(row)
    return matrix

def distance(node1: node,node2: node,dtMatrix: list):
    return dtMatrix[node1][node2]

def feasibile(nodes: list):
    resources = {}
    for i in nodes:
        if i.item in resources:
            resources[i.item] += i.quantity
        else:
            resources[i.item] = i.quantity

    for i in resources:
        if resources[i] < 0:
            return False

    # print("feasible")
    return True

def getFeasible(nodes: list):

    sinks = []
    sources = []
    for i in nodes:
        if i.quantity < 0:
            sinks.append(i)
        else:
            sources.append(i)


    resources = {}
    deficits = []
    excesses = []
    def getClusterState():
        
        for i in nodes:
            if i.item in resources:
                resources[i.item] += i.quantity
            else:
                resources[i.item] = i.quantity

        for i in resources:
            if resources[i] < 0:
                deficits.extend([x for x in nodes if x.item == i and x.quantity < 0])
            else :
                excesses.append((i,resources[i]))
    getClusterState()
    
        
    print("Deficits:",deficits)
    print("Removing sinks to get feasible cluster")
    while(not feasibile(nodes)):
        victim = r.choice(deficits)
        print(f"Moving {victim} to free pool")
        freepool.append(victim)
        deficits.remove(victim)
        nodes.remove(victim)
        sinks.remove(victim)
        if sinks == []:
            return (False,"No feasible solution possible")

    def removeSource(sources,victim):
        nodes.remove(victim)
        sources.remove(victim)
        if(feasibile(nodes)):
            print(f"Moving {victim} to free pool")
            freepool.append(victim)
            return removeSource(sources,r.choice(sources))
        else:
            nodes.append(victim)
            sources.append(victim)
            return nodes

    

    #system to remove sources without random selection
    #maybe based on the difference between sum of sources and sinks in each resource type
    print("Removing sources to get optimal cluster")
    resources = {}
    deficits = []
    excesses = []
    getClusterState()
    print(f"Excesses: {excesses}")
    for i in excesses:
        group = [x for x in nodes if x.item == i[0] and x.quantity > 0]
        group.sort(key=lambda x: x.quantity,reverse=True)
        excess = i[1]
        while excess > 0 and group != []:
            victim = group.pop()
            if excess - victim.quantity < 0:
                continue
            excess -= victim.quantity
            print(f"Moving {victim} to free pool")
            freepool.append(victim)
            nodes.remove(victim)
            sources.remove(victim)

    resources = {}
    deficits = []
    excesses = []
    getClusterState()
    print("Excesses:",excesses)


    return (True,nodes)


def satisfaction(nodes):

    distance = 0
    dtMatrix = generateDistanceMatrix(nodes)

    nodes = getFeasible(nodes)
    
    if(not nodes[0]):
        print(nodes[1])
        return

    nodes = nodes[1]
    print("Feasible Cluster:")
    printCluster(nodes)

    sources = []
    sinks = []
    resGroup = {} #grouping resources by item

    for i in nodes:
        if i.quantity > 0:
            sources.append(i)
            if i.item not in resGroup:
                resGroup[i.item] = []
        else:
            sinks.append(i)
            if i.item in resGroup:
                resGroup[i.item].append(i)
            else:
                resGroup[i.item] = [i]

    #sort the resources by quantity
    #TODO find a better way to score the nodes, based on all the factors such as distance, quantity, etc
    for i in resGroup:
        resGroup[i].sort(key=lambda x: x.quantity)
    # sources.sort(key=lambda x: x.quantity,reverse=True)
    available = {}

    def check(node: node):
        if node.item in available:
            if available[node.item] >= abs(node.quantity):
                return True
            else:
                return False
        else:
            return False


    #main logic
    #gives one solution but there is no guarantee that it is the best solution
    #maybe use backtracking or branch and bound to find the best solution

    print("Solution:")
    for i in sources:
        if sinks == []:
            break
        if i.item in available:
            available[i.item] += i.quantity
        else:
            available[i.item] = i.quantity
        print("Taken from",i)
        for j in resGroup[i.item][:]:
            if check(j):      
                available[j.item] -= abs(j.quantity)
                distance += dtMatrix[sources.index(i)][resGroup[i.item].index(j)]
                sinks.remove(j)
                resGroup[i.item].remove(j)
                print("Satisfied",j)

    print()
    for i in available:
        print(f"Remaining {i} in available pool: {available[i]}")
    print()
    
    if sinks == []:
        print("All sinks satisfied")
    else :
        print(f"Unsatisfied sinks: {sinks}")
    print(f"Distance {distance}")


    # # Find the remaining unsatisfied sinks
    # unsatisfied_sinks = sinks

    # # Find the nearest source for each unsatisfied sink
    # for sink in unsatisfied_sinks:
    #     nearest_source = min(sources, key=lambda source: dtMatrix[sources.index(source)][sinks.index(sink)])
    #     distance += dtMatrix[sources.index(nearest_source)][sinks.index(sink)]
    #     print("Satisfied", sink, "from", nearest_source)
    #     sources.remove(nearest_source)

    return distance
    # print("Total distance:",distance)

#usable upto 15-20 nodes (7-9 sources)
def satisfactionTSP(nodes):

    distance = 0
    dtMatrix = generateDistanceMatrix(nodes)

    nodes = getFeasible(nodes)
    
    if(not nodes[0]):
        print(nodes[1])
        return

    nodes = nodes[1]
    print("Feasible Cluster:")
    printCluster(nodes)

    sources = []
    sinks = []
    resGroup = {} #grouping resources by item

    for i in nodes:
        if i.quantity > 0:
            sources.append(i)
            if i.item not in resGroup:
                resGroup[i.item] = []
        else:
            sinks.append(i)
            if i.item in resGroup:
                resGroup[i.item].append(i)
            else:
                resGroup[i.item] = [i]

    #sort the resources by quantity
    #TODO find a better way to score the nodes, based on all the factors such as distance, quantity, etc
    for i in resGroup:
        resGroup[i].sort(key=lambda x: x.quantity)
    # sources.sort(key=lambda x: x.quantity,reverse=True)
    available = {}

    def check(node):
        if node.item in available:
            if available[node.item] >= abs(node.quantity):
                available[node.item] -= abs(node.quantity)
                return True
            else:
                return False
        else:
            return False
        
    #15 nodes is about 1 trillion calculations
    def tsp(nodes:list, dtMatrix, sources):
        # Create a list of all possible permutations of the sources
        permutations = itertools.permutations(sources)

        # Initialize variables to store the best path and its distance
        best_path = None
        best_distance = float('inf')

        # Create a priority queue to store the partial paths
        queue = []

        # Iterate through each permutation
        for permutation in permutations:
            # Calculate the total distance of the current permutation
            total_distance = 0
            for i in range(len(permutation) - 1):
                source1 = permutation[i]
                source2 = permutation[i + 1]
                total_distance += dtMatrix[nodes.index(source1)][nodes.index(source2)]

            # Check if the current permutation has a shorter distance than the best path
            if total_distance < best_distance:
                # Add the partial path to the priority queue
                heapq.heappush(queue, (total_distance, [permutation]))

        # Branch and bound algorithm
        while queue:
            # Get the partial path with the smallest distance
            current_distance, current_path = heapq.heappop(queue)

            # Check if the current path is complete
            if len(current_path) == len(sources):
                # Update the best path and its distance if necessary
                if current_distance < best_distance:
                    best_path = current_path
                    best_distance = current_distance
            else:
                # Generate all possible extensions of the current path
                extensions = [source for source in sources if source not in current_path]

                # Calculate the lower bound for each extension
                lower_bounds = []
                for extension in extensions:
                    lower_bound = current_distance + dtMatrix[nodes.index(current_path[0][-1])][nodes.index(extension)]
                    lower_bounds.append(lower_bound)

                # Sort the extensions based on their lower bounds
                sorted_extensions = [extension for _, extension in sorted(zip(lower_bounds, extensions))]

                # Add the sorted extensions to the priority queue
                for extension in sorted_extensions:
                    extended_path = current_path + [extension]
                    extended_distance = current_distance + dtMatrix[nodes.index(current_path[0][-1])][nodes.index(extension)]
                    heapq.heappush(queue, (extended_distance, extended_path))

        # Print the best path and its distance
        print("Best Path:", best_path)
        print("Best Distance:", best_distance)
        return best_path[0]

    path = tsp(nodes, dtMatrix, sources)
    for i in path:
        if sinks == []:
            break
        if i.item in available:
            available[i.item] += i.quantity
        else:
            available[i.item] = i.quantity
        print("Taken from",i)
        for j in resGroup[i.item][:]:
            if check(j):      
                distance += dtMatrix[sources.index(i)][resGroup[i.item].index(j)]
                sinks.remove(j)
                resGroup[i.item].remove(j)
                print("Satisfied",j)
    
    if sinks == []:
        print("All sinks satisfied")
    else :
        print("Not all sinks satisfied")
    print(f"Distance {distance}")

    return distance

def satisfactionMST(nodes):

    distance = 0
    dtMatrix = generateDistanceMatrix(nodes)

    nodes = getFeasible(nodes)
    
    if(not nodes[0]):
        print(nodes[1])
        return

    nodes = nodes[1]
    print("Feasible Cluster:")
    printCluster(nodes)

    sources = []
    sinks = []
    resGroup = {} #grouping resources by item

    for i in nodes:
        if i.quantity > 0:
            sources.append(i)
            if i.item not in resGroup:
                resGroup[i.item] = []
        else:
            sinks.append(i)
            if i.item in resGroup:
                resGroup[i.item].append(i)
            else:
                resGroup[i.item] = [i]

    #sort the resources by quantity
    #TODO find a better way to score the nodes, based on all the factors such as distance, quantity, etc
    for i in resGroup:
        resGroup[i].sort(key=lambda x: x.quantity)
    # sources.sort(key=lambda x: x.quantity,reverse=True)
    available = {}

    def check(node):
        if node.item in available:
            if available[node.item] >= abs(node.quantity):
                available[node.item] -= abs(node.quantity)
                return True
            else:
                return False
        else:
            return False
        
    def minimumSpanningTree(nodes, dtMatrix, sources):
        # Create a set to store the visited nodes
        visited = set()

        # Create a priority queue to store the edges
        edges = []

        # Add the first source node to the visited set
        visited.add(sources[0])

        # Add the edges connected to the first source node to the priority queue
        for i in range(1, len(sources)):
            heapq.heappush(edges, (dtMatrix[nodes.index(sources[0])][nodes.index(sources[i])], sources[0], sources[i]))

        # Initialize variables to store the minimum spanning tree
        mst = []
        mst_distance = 0

        # Iterate until all nodes are visited or all edges are processed
        while len(visited) < len(sources) and edges:
            # Pop the edge with the minimum weight from the priority queue
            weight, source, sink = heapq.heappop(edges)

            # Check if the sink node is already visited
            if sink not in visited:
                # Add the edge to the minimum spanning tree
                mst.append((source, sink))
                mst_distance += weight

                # Add the sink node to the visited set
                visited.add(sink)

                # Add the edges connected to the sink node to the priority queue
                for i in range(len(sources)):
                    if sources[i] not in visited:
                        heapq.heappush(edges, (dtMatrix[nodes.index(sink)][nodes.index(sources[i])], sink, sources[i]))

        return mst, mst_distance

    mst, mst_distance = minimumSpanningTree(nodes, dtMatrix, sources)

    path = [mst[0][0]]
    for i in mst:
        path.append(i[1])

    for i in path:
        if sinks == []:
            break
        if i.item in available:
            available[i.item] += i.quantity
        else:
            available[i.item] = i.quantity
        print("Taken from",i)
        for j in resGroup[i.item][:]:
            if check(j):      
                distance += dtMatrix[sources.index(i)][resGroup[i.item].index(j)]
                sinks.remove(j)
                resGroup[i.item].remove(j)
                print("Satisfied",j)
    
    print("Excesses:",available)
    if sinks == []:
        print("All sinks satisfied")
    else :
        print(f"Unsatisfied sinks: {sinks}")
    print(f"Distance {distance}")

    return distance

nodes = generateNodes(0.7,500)
print("Initial Cluster:")
printCluster(nodes)

# satisfactionDjikstra(nodes)

distBankers = satisfaction(nodes)
# disTSP = satisfactionTSP(nodes)
disMST = satisfactionMST(nodes)
print(f"\nBankers Algo: {distBankers}")
# print(f"Djikstra Algo: {disTSP}")
print(f"MST Algo: {disMST}")
