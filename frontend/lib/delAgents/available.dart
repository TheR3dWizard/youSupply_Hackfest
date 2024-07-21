import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class available extends StatefulWidget {
  const available({super.key});

  @override
  State<available> createState() => _availableState();
}

class _availableState extends State<available> {
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
        padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 5),
        child: SingleChildScrollView(
        
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
              Deliveries(fromLoc: "fromLoc", toLoc: "toLoc", item: "item", quantity: "quantity", status: "status"),
        
            ],
          ),
        
        ),
      )

    );
  }
}