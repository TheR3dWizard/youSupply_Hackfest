import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart'; // Make sure this import is valid and required

class settings extends StatelessWidget {
  const settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
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
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
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
              const SizedBox(height: 10),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),

              // Add settings options
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.white70),
                title: const Text(
                  'Change Location',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Add your onTap code here
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white70),
                title: const Text(
                  'Notification Settings',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Add your onTap code here
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.white70),
                title: const Text(
                  'Help',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Add your onTap code here
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white70),
                title: const Text(
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
