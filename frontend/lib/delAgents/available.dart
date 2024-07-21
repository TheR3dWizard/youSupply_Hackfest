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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: Container(
                  height: 300,
                  width: 410,
                  // decoration: BoxDecoration(
                    
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: Text("map"),
                  
                  color: Colors.grey,
                ),
              ),
              Deliveries(fromLoc: "Chennai", toLoc: "Coimbatore", item: "Water Bottles", quantity: "50", status: "Pending"),
Deliveries(fromLoc: "Madurai", toLoc: "Tiruchirapalli", item: "Rice", quantity: "100 kg", status: "Delivered"),
Deliveries(fromLoc: "Salem", toLoc: "Tirunelveli", item: "Medicine", quantity: "30 packs", status: "In Transit"),
Deliveries(fromLoc: "Erode", toLoc: "Kancheepuram", item: "Water Bottles", quantity: "40", status: "Pending"),
Deliveries(fromLoc: "Vellore", toLoc: "Ramanathapuram", item: "Rice", quantity: "75 kg", status: "Delivered"),
Deliveries(fromLoc: "Nagercoil", toLoc: "Dindigul", item: "Medicine", quantity: "20 packs", status: "In Transit"),
Deliveries(fromLoc: "Tiruppur", toLoc: "Karur", item: "Water Bottles", quantity: "60", status: "Pending"),
Deliveries(fromLoc: "Thanjavur", toLoc: "Cuddalore", item: "Rice", quantity: "85 kg", status: "Delivered"),
Deliveries(fromLoc: "Tiruvallur", toLoc: "Dharmapuri", item: "Medicine", quantity: "25 packs", status: "In Transit"),
Deliveries(fromLoc: "Kanyakumari", toLoc: "Pudukkottai", item: "Water Bottles", quantity: "70", status: "Pending"),

        
            ],
          ),
        
        ),
      )

    );
  }
}