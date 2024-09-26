import json
import random

def generate_node(username):
    quantity = random.randint(-10, 10)
    if quantity == 0:
        quantity = 1
    return {
        "xposition": random.randint(-98, 98),
        "yposition": random.randint(-98, 98),
        "itemid": random.choice(["food","clothes"]),
        "quantity": quantity,
        "username": username
    }

def generate_json(num_nodes, username):
    nodelist = [generate_node(username) for _ in range(num_nodes)]
    return json.dumps({"nodelist": nodelist}, indent=4)

if __name__ == "__main__":
    num_nodes = 100  # Change this to generate more or fewer nodes
    username = "john_doe"
    json_data = generate_json(num_nodes, username)
    print(json_data)