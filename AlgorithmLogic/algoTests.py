import satisfactionAlgos as sa
from random import randint,random
import matplotlib.pyplot as plt

distsBankers = []
distsMST = []
numNodesList = []

for i in range(100):
    p = random()
    numNodes = randint(5,100)
    nodes = sa.generateNodes(p,numNodes)
    nodes = sa.getFeasible(nodes)
    if(not nodes[0]):
        continue
    nodes = nodes[1]
    sa.printCluster(nodes)
    distsBankers.append(sa.satisfaction_nocheck(nodes))
    distsMST.append(sa.satisfactionMST_nocheck(nodes))
    numNodesList.append(numNodes)
    print("Finished iteration\n")

plt.figure(figsize=(10, 6))
plt.scatter(numNodesList, distsBankers, label='Banker\'s Algorithm Distances', alpha=0.5)
plt.scatter(numNodesList, distsMST, label='MST Distances', alpha=0.5)

plt.title('Comparison of Banker\'s Algorithm and MST Distances')
plt.xlabel('Number of Nodes')
plt.ylabel('Distances')
plt.legend()
plt.grid(True)
plt.show()


