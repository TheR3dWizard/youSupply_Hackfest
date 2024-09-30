import 'package:flutter/material.dart';

class CompletedRoutes extends StatelessWidget {
  const CompletedRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
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
        padding: const EdgeInsets.all(8),
        children: [
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
                    const Icon(Icons.location_pin, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      coordinates,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.directions, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Pickup within $distance',
                      style: const TextStyle(
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
              child: const Text(
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
