import 'package:flutter/material.dart';

class CompletedRoutes extends StatelessWidget {
  const CompletedRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Completed Routes',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          routeCard(
            coordinates: '11.025155757439432,77.0025...',
            distance: '5.0 km',
          ),
          routeCard(
            coordinates: '11.025155757439432,77.0025...',
            distance: '5.0 km',
          ),
          // Add more route cards as needed
        ],
      ),
    );
  }

  Widget routeCard({required String coordinates, required String distance}) {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      coordinates,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.directions, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Pickup within $distance',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400], // background color
                //onPrimary: Colors.white, // text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
