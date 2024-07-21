import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';


class accepted extends StatefulWidget {
  const accepted({super.key});

  @override
  State<accepted> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<accepted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black
      ,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Accepted Deliveries',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      
    );
  }
}