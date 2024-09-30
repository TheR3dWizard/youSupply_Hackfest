import 'package:flutter/material.dart';

class popUp extends StatelessWidget {
  const popUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              Icon(Icons.shopping_cart),
              Icon(Icons.settings)
            ],
          ),
        )
    );
  }
}