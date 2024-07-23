import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class requestPage extends StatelessWidget {
  requestPage({Key? key}) : super(key: key);

  final List<dynamic> items = [
    ['Drinking Water', 'assets/water.jpg'],
    ['Flashlight', 'assets/flashlight.jpg'],
    ['Blanket', 'assets/blanket.jpg'],
    ['First Aid Kit', 'assets/firstaidkit.jpg'],
    ['Food Packages', 'assets/foodparcel.jpg']
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cartstatic');
          },
          child: SizedBox(
            width: 100,
            height: 50,
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_checkout_outlined,
                    color: Colors.black),
                Text('View Cart', style: TextStyle(color: Colors.black)),
              ],
            ),
          )),
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        title: Text(
          'Request Resources',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 225, 255),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: const Text(
                  'Resources',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: const Text(
                  'Add all the resources you require',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: items
                    .map((item) => Item(
                          label1: item[0],
                          label2: 'In stock',
                          image: Image.asset(
                            item[1],
                            width: 100,
                            height: 100,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final String label1;
  final String label2;
  final Image image;

  const Item({
    Key? key,
    required this.label1,
    required this.label2,
    required this.image,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) _count--;
    });
  }

  void _clear() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100, minWidth: 200),
        decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
              )
            ]),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label1,
                    style: TextStyle(
                      fontSize: 17,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 225, 255),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    widget.label2,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                      ),
                      IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _decrement,
                          color: Colors.white),
                      Text(
                        '$_count',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 225, 255),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _increment,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          if (_count == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select quantity'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          await addToCart(widget.label1, -1 * _count);
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size(120, 30),
                          shadowColor: Colors.black,
                          foregroundColor: Colors.black,
                          backgroundColor: Color.fromARGB(255, 0, 225, 255),
                        ),
                        child: const Text('Request'),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () async {
                          _clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cleared'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          await addToCart(widget.label1, 0);
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size(100, 30),
                          shadowColor: Colors.black,
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: widget.image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: requestPage(),
  ));
}
