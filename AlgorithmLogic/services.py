import requests
from pprint import pprint
from typing import List
from dotenv import load_dotenv
import os

load_dotenv()

class GoogleAPI:
    def __init__(self):
        self.api_key = os.getenv('GOOGLE_API_KEY')

    def get_distance_matrix(self, listoforigins: List[List[float]], listofdestinations: List[List[float]]):
        endpoint = 'https://maps.googleapis.com/maps/api/distancematrix/json'
        
        origins = "|".join([",".join(map(str, origin)) for origin in listoforigins])
        destinations = "|".join([",".join(map(str, destination)) for destination in listofdestinations])
        
        params = {
            'origins': origins,
            'destinations': destinations,
            'key': self.api_key
        }
        
        response = requests.get(endpoint, params=params)
        
        if response.status_code != 200:
            raise Exception(f"Error making request: {response.status_code}")
        
        distance_matrix = response.json()
        
        if 'rows' not in distance_matrix or not distance_matrix['rows']:
            raise Exception("No rows found in response")
        
        return distance_matrix

origin = [[37.77264, -122.409915]]
destination = [[37.774929, -122.419416], [37.774929, -122.419416]]

gm = GoogleAPI()
pprint(gm.get_distance_matrix(origin, destination))