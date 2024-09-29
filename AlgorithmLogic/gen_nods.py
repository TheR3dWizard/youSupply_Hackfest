import json
import random

topleft = 11.025692, 76.934398
topright = 11.028895, 77.026408
bottomleft = 10.962681, 76.945122
bottomrigth = 10.965884, 77.037132

# # generate random latitude and longitude from above rectangle limits
# def generate_node():
#     return {
#         "latitude": random.uniform(bottomleft[0], topleft[0]),
#         "longitude": random.uniform(bottomleft[1], bottomrigth[1]),
#         "itemid": random.choice(["food","clothes"]),
#         "quanti   ty": random.randint(1, 10)
#     }


def generate_node(username):
    quantity = random.randint(-10, 10)
    if quantity == 0:
        quantity = 1
    return {
        "xposition": random.uniform(bottomleft[0], topleft[0]),
        "yposition": random.uniform(bottomleft[1], bottomrigth[1]),
        "itemid": random.choice(["food","clothes"]),
        "quantity": quantity,
        "username": username
    }

def generate_json(num_nodes, username):
    nodelist = [generate_node(username) for _ in range(num_nodes)]
    return json.dumps({"nodelist": nodelist}, indent=4)

if __name__ == "__main__":
    num_nodes = 200  # Change this to generate more or fewer nodes
    username = "john_doe"
    json_data = generate_json(num_nodes, username)
    print(json_data)