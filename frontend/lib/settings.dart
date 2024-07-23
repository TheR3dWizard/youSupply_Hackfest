import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart'; // Make sure this import is valid and required

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
                  backgroundImage: AssetImage('assets/profile.png'),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 2.0,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white70,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Add settings options
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.white70),
                title: Text(
                  'Change Location',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Add your onTap code here
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.white70),
                title: Text(
                  'Notification Settings',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Add your onTap code here
                },
              ),
              ListTile(
                leading: Icon(Icons.help, color: Colors.white70),
                title: Text(
                  'Help',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Add your onTap code here
                },
              ),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.white70),
                title: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Add your onTap code here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
