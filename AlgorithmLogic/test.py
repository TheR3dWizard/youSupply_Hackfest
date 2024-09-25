from dotenv import load_dotenv
import os
import psycopg2
from typing import List
if os.name == "posix":
    __import__('pysqlite3')
    import sys
    sys.modules['sqlite3'] = sys.modules.pop('pysqlite3')

from services import ChromaDBAgent
from algorithm import Node
from random import random,randrange



agent = ChromaDBAgent()
nodes:List[Node] = []
n = 100  # specify the number of nodes you want to create

for _ in range(n):
    x_pos = randrange(-90,90)
    y_pos = randrange(-180,180)
    node = Node(x_pos,y_pos)
    nodes.append(node)

for node in nodes:
    id = random()
    agent.insertnodeobject(f'{id}',[node.x_pos,node.y_pos])

neighbors = agent.getnearestneighbors([50,50],5)
print(neighbors)