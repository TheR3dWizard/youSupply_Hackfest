import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class settings extends StatelessWidget {
  const settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Settings',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('/Users/pramo/Desktop/youSupply_Hackfest/frontend/assets/profile.png'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Center the Row content
                  children: <Widget>[
                    Text(
                      'Sreeraghavan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 2.0,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white70,
                       color: Colors.white70,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.edit,
                    size: 20,
                    color: Colors.white70,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
