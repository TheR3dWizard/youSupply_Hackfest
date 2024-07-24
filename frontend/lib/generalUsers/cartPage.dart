import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<dynamic>>(
        future: readCart(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text("Error"));
          }
          
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
}

void main() {
  runApp(MaterialApp(home: Cartpage()));
}
