import 'package:flutter/material.dart';
import 'settings.dart'; // Import the settings page

class profile extends StatelessWidget {
  const profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Profile',
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
              const SizedBox(height: 20),

              // Add more profile details here
              const Text(
                'Email',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'sreeraghavan@microsoft.com', // Replace with actual email
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '+123 456 7890', // Replace with actual phone number
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Address',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '123 Main Street, Coimbatore, India', // Replace with actual address
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const settings()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      letterSpacing: 1.5,
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
