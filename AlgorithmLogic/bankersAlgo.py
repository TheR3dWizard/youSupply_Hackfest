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

       
itemList = ["Water Bottle","Flashlight","Canned Food"]

def generateNodes(p = 0.3):
    nodes = []
    for i in range(0,10):
        x = r.randint(0,100)
        y = r.randint(0,100)
        item = r.choice(itemList)
        if r.random() < p:
            quantity = r.randint(-10,-1)
        else:
            quantity = r.randint(1,10)
        nodes.append(node(x,y,item,quantity))
    return nodes

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

    return True

def getFeasible(nodes: list):

    sinks = []
    for i in nodes:
        if i.quantity < 0:
            sinks.append(i)

    while(not feasibile(nodes)):
        victim = r.choice(sinks)
        nodes.remove(victim)
        sinks.remove(victim)
        if sinks == []:
            return (False,"No feasible solution possible")

    return (True,nodes)


def satisfaction(nodes):

    distance = 0
    dtMatrix = generateDistanceMatrix(nodes)

    if not feasibile(nodes):
        nodes = getFeasible(nodes)
    
    if(not nodes[0]):
        print(nodes[1])
        return

    nodes = nodes[1]
    print("Feasible Cluster:")
    for i in nodes:
       print(i)
    print()

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

    # print("Solution:")
    # for i in sources:
    #     if i.item in available:
    #         available[i.item] += i.quantity
    #     else:
    #         available[i.item] = i.quantity
    #     print("Taken from",i)
    #     for j in sinks:
    #         if check(j):      
    #             distance += dtMatrix[sources.index(i)][sinks.index(j)]
    #             sinks.remove(j)
    #             print("Satisfied",j)

    # Find the remaining unsatisfied sinks
    unsatisfied_sinks = sinks

    # Find the nearest source for each unsatisfied sink
    for sink in unsatisfied_sinks:
        nearest_source = min(sources, key=lambda source: dtMatrix[sources.index(source)][sinks.index(sink)])
        distance += dtMatrix[sources.index(nearest_source)][sinks.index(sink)]
        print("Satisfied", sink, "from", nearest_source)
        sources.remove(nearest_source)

    print("Total distance:", distance)

    # print("Total distance:",distance)

    


nodes = generateNodes(0.3)

# while(not feasibile(nodes)):
#     nodes = generateNodes(0.4)

print("Generated Nodes:\n")
for i in nodes:
    print(i)
print()

satisfaction(nodes)


