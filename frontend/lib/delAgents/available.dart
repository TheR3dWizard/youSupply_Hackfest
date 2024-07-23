import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class DeliveryDetails {
  final String fromLoc;
  final double distanceFromDelAgent;

  const DeliveryDetails({
    required this.fromLoc,
    required this.distanceFromDelAgent,
  });
}

class available extends StatefulWidget {
  final DeliveryDetails? deliveryDetails;

  const available({
    super.key,
    this.deliveryDetails,
  });

  @override
  State<available> createState() => _AvailableState();
}

class _AvailableState extends State<available> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Available Deliveries',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: Container(
                  height: 300,
                  width: 410,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Map",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
