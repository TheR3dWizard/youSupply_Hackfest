import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  List<Map<String, dynamic>> _cart = [];

  @override
  void initState() {
    super.initState();
    readCart().then(
      (value) => {_cart = value},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListView.builder(
            itemCount: _cart.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_cart[index]['item']),
                subtitle: Text(_cart[index]['quantity'].toString()),
              );
            },
          ),
          OutlinedButton(
              onPressed: () {
                sendcart();
              },
              child: const Text("Accept Cart"))
        ],
      ),
    );
  }
}
