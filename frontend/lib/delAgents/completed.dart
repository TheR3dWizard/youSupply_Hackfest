import 'package:flutter/material.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Completed Delivery',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TaskCard(
            startCoordinates: '11.02515575743, 11.03250471757',
            endCoordinates: '11.03250471757, 11.01614298699',
            items: 10,
            itemType: 'water',
            status: 'Completed',
          ),
          TaskCard(
            startCoordinates: '11.03250471757, 11.01614298699',
            endCoordinates: '11.02515575743, 11.03250471757',
            items: 5,
            itemType: 'food',
            status: 'Completed',
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String startCoordinates;
  final String endCoordinates;
  final int items;
  final String itemType;
  final String status;

  TaskCard({
    required this.startCoordinates,
    required this.endCoordinates,
    required this.items,
    required this.itemType,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$startCoordinates -> $endCoordinates',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            '$items $itemType to collect',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              status,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
