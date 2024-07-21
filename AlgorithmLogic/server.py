from flask import Flask
from algorithm import System, Cluster, Node
from flask import request

centralsystemobject = System(distancelimit=5)

app = Flask(__name__)

@app.route('/')
def home():
	return 'this API will be used to natively interact with the algorithm logic'

@app.route('/add/node', methods=['POST'])
def addrequest():
    body = request.get_json()

    if set(body.keys()) != {'xposition', 'yposition', 'itemtype', 'quantity'}:
        return 'Invalid request body', 400
    
    newnode = Node(x_pos=body['xposition'], y_pos=body['yposition'], item=body['itemtype'], quantity=body['quantity'])
    centralsystemobject.addrequest(newnode)
    
    return centralsystemobject.stats()


@app.route('/get/stats')
def stats():
    return centralsystemobject.stats()

if __name__ == '__main__':
	app.run(port=6969)