from chromadb import Client
from chromadb.config import Settings
from chromadb.api import Collection

# Initialize the ChromaDB client
client = Client(Settings())

# Create or get a collection
collection_name = "pathobjects"
if collection_name not in client.list_collections():
    collection = client.create_collection(collection_name)
else:
    collection = client.get_collection(collection_name)

query_vector = [20.989979, 53.004152]
neighbors = collection.query(query_vector)  # Get the 1 nearest neighbor

print("Nearest neighbor(s):", neighbors)
