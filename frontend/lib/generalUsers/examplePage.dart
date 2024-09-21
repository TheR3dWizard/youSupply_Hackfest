import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class examplePage extends StatefulWidget {
  const examplePage({super.key});

  @override
  State<examplePage> createState() => _CartpageStaticState();
}

class _CartpageStaticState extends State<examplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        title: Text(
          'Cart',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 225, 255),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: readCartLocal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text("Error"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No items in cart"));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(item['item']),
                              subtitle: Text('Quantity: ${item['quantity']}'),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
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
                        child: const Text("Accept Cart"),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<List<Map<String, dynamic>>> readCartLocal() async {
    List<dynamic> cartDynamic = jsonDecode(
        '[{"item": "Water Bottle", "quantity": 3}, {"item": "Flashlight", "quantity": -1}, {"item": "Blanket", "quantity": -4}, {"item": "First Aid Kit", "quantity": 1}, {"item": "Food Packages", "quantity": 1}]');
    List<Map<String, dynamic>> cart =
        cartDynamic.map((item) => item as Map<String, dynamic>).toList();

    return cart;
  }
}

void main() {
  runApp(MaterialApp(home: examplePage()));
}
