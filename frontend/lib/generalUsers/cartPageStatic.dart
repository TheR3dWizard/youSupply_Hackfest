import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class CartpageStatic extends StatefulWidget {
  const CartpageStatic({super.key});

  @override
  State<CartpageStatic> createState() => _CartpageStaticState();
}

class _CartpageStaticState extends State<CartpageStatic> {
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<dynamic>>(
        future: readCartLocal(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text("Error"));
          }
          print(snapshot.data);
          return Column(
            children: [
              Column(
                children: List.generate(snapshot.data?.length ?? 0, (index) {
                  return ListTile(
                    title: Text(snapshot.data![index]['item']),
                    subtitle: Text(snapshot.data![index]['quantity'].toString()),
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
          );
        }
      ),
    );
  }

  Future<List<Map<String, dynamic>>> readCartLocal() async {
  List<dynamic> cartDynamic = jsonDecode('[{"item": "water bottle", "quantity": 3}, {"item": "flashlight", "quantity": -1}, {"item": "Drinking Water", "quantity": -4}, {"item": "Rice", "quantity": 1}]');
  List<Map<String, dynamic>> cart = cartDynamic.map((item) => item as Map<String, dynamic>).toList();

  return cart;
  }
}

void main() {
  runApp(MaterialApp(home: CartpageStatic()));
}
