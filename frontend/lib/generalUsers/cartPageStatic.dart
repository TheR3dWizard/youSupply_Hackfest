import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class cartPageStatic extends StatefulWidget {
  const cartPageStatic({super.key});

  @override
  State<cartPageStatic> createState() => _cartPageState();
}

class _cartPageState extends State<cartPageStatic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 225, 255),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: segregateCart(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text("Error"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text("No items in cart",
                      style:
                          TextStyle(color: Color.fromARGB(255, 0, 255, 255))));
            }
            return Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Provide Cart',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 225, 255),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.3, // Adjust the height as needed
                        child: ListView.builder(
                          itemCount: snapshot.data!['provide']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!['provide']![index];
                            return Card(
                              color: Colors.grey[850],
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  item['item'],
                                  style: const TextStyle(
                                      color: Color.fromARGB(225, 0, 225, 255)),
                                ),
                                subtitle: Text(
                                  'Quantity: ${item['quantity']}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(225, 0, 225, 255)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Request Cart',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 225, 255)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.3, // Adjust the height as needed
                        child: ListView.builder(
                          itemCount: snapshot.data!['request']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!['request']![index];
                            return Card(
                              color: Colors.grey[850],
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  item['item'],
                                  style: const TextStyle(
                                      color: Color.fromARGB(225, 0, 225, 255)),
                                ),
                                subtitle: Text(
                                  'Quantity: ${item['quantity'].abs()}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(225, 0, 225, 255)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: const Text("Accept Cart",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                225, 0, 225, 255))),
                                    content: const Text(
                                      "Are you sure you want to accept this cart?",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 255, 255)),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 255, 255)),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            sendcart();

                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Cart accepted successfully"),
                                            ));
                                            emptyCart();
                                            Navigator.pop(context, '/homegu');
                                          },
                                          child: const Text("Accept Cart",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      225, 0, 225, 255)))),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Accept Cart",
                              style: TextStyle(
                                  color: Color.fromARGB(225, 0, 225, 255)),
                            )),
                      )
                    ],
                  ),
                ));
          }),
    );
  }

  Future<Map<String, List<Map<String, dynamic>>>> segregateCart() async {
    List<dynamic> cartDynamic = jsonDecode(
        '[{"item": "Water Bottle", "quantity": 3}, {"item": "Flashlight", "quantity": -1}, {"item": "Blanket", "quantity": -4}, {"item": "First Aid Kit", "quantity": 1}]');
    List<Map<String, dynamic>> cart =
        cartDynamic.map((item) => item as Map<String, dynamic>).toList();

    List<Map<String, dynamic>> provideCart = [];
    List<Map<String, dynamic>> requestCart = [];

    for (var item in cart) {
      if (item['quantity'] > 0) {
        provideCart.add(item);
      } else if (item['quantity'] < 0) {
        requestCart.add(item);
      }
    }

    return {
      'provide': provideCart,
      'request': requestCart,
    };
  }
}

void main() {
  runApp(MaterialApp(home: cartPageStatic()));
}
