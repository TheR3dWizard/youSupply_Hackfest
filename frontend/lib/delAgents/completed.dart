import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class completed extends StatelessWidget {
  const completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black
      ,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Completed Deliveries',
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