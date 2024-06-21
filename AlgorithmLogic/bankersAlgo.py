from math import sqrt
import random as r

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

       
itemList = ["Water Bottle","Flashlight","Canned Food"]
freepool = []

def generateNodes(p = 0.3,num = 10):
    nodes = []
    for i in range(0,num):
        x = r.randint(0,100)
        y = r.randint(0,100)
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
    

def generateDistanceMatrix(nodes: list):
    matrix = []
    for i in nodes:
        row = []
        for j in nodes:
            row.append(sqrt((j.x_pos - i.x_pos)**2 + (j.y_pos - i.y_pos)**2))
        matrix.append(row)
    return matrix

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
    if not feasibile(nodes):
        for i in nodes:
            if i.item in resources:
                resources[i.item] += i.quantity
            else:
                resources[i.item] = i.quantity

        for i in resources:
            if resources[i] < 0:
                deficits.extend([x for x in nodes if x.item == i and x.quantity < 0])
    
        
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

    print("Removing sources to get optimal cluster")
    nodes = removeSource(sources,r.choice(sources))

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

    for i in nodes:
        if i.quantity > 0:
            sources.append(i)
        else:
            sinks.append(i)

    available = {}

    def check(node):
        if node.item in available:
            if available[node.item] > node.quantity:
                available[node.item] -= node.quantity
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
        if i.item in available:
            available[i.item] += i.quantity
        else:
            available[i.item] = i.quantity
        print("Taken from",i)
        for j in sinks:
            if check(j):      
                distance += dtMatrix[sources.index(i)][sinks.index(j)]
                sinks.remove(j)
                print("Satisfied",j)

    # # Find the remaining unsatisfied sinks
    # unsatisfied_sinks = sinks

    # # Find the nearest source for each unsatisfied sink
    # for sink in unsatisfied_sinks:
    #     nearest_source = min(sources, key=lambda source: dtMatrix[sources.index(source)][sinks.index(sink)])
    #     distance += dtMatrix[sources.index(nearest_source)][sinks.index(sink)]
    #     print("Satisfied", sink, "from", nearest_source)
    #     sources.remove(nearest_source)

    print("Total distance:", distance)

    # print("Total distance:",distance)

    


nodes = generateNodes(0.5,50)
print("Initial Cluster:")
printCluster(nodes)

satisfaction(nodes)


