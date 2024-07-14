import 'package:flutter/material.dart';

class homePageGU extends StatelessWidget {
  const homePageGU({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:  <Widget>[
              TextButton(
                onPressed: () {},
                child: Icon(
                  Icons.menu,
                  size: 40,
                  color: Color.fromRGBO(0, 224, 255, 1),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Welcome to youSupply!',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: homePageGU(),
  ));
}
