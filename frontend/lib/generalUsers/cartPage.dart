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
          Column(
            children: List.generate(_cart.length, (index) {
              return ListTile(
                title: Text(_cart[index]['item']),
                subtitle: Text(_cart[index]['quantity'].toString()),
              );
            }),
          ),
          OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Accept Cart"),
                      content: const Text(
                          "Are you sure you want to accept this cart?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              sendcart();
                              Navigator.pop(context);
                            },
                            child: const Text("Accept Cart"))
                      ],
                    );
                  },
                );
              },
              child: const Text("Accept Cart"))
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Cartpage()));
}
