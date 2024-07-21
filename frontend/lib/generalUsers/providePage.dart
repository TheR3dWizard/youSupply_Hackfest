import 'package:flutter/material.dart';

class providePage extends StatelessWidget {
  providePage({Key? key}) : super(key: key);

  //should be takenb from the backend
  final List<String> items = [
    'Drinking Water',
    'Rice',
    'Milk',
    'Wheat',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            children: [
              Icon(
                Icons.home,
                size: 40,
                color: Color.fromRGBO(0, 224, 255, 1),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    'Add all the resources you wish to provide',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Item(
                  label1: 'Drinking Water',
                  label2: 'In stock',
                ),
                Item(
                  label1: 'Rice',
                  label2: 'In stock',
                ),
                Item(
                  label1: 'Milk',
                  label2: 'In stock',
                ),
                Item(
                  label1: 'Wheat',
                  label2: 'In stock',
                ),
                SizedBox(height: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final String label1;
  final String label2;

  const Item({
    Key? key,
    required this.label1,
    required this.label2,
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
        constraints: const BoxConstraints(minHeight: 100),
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
        child: Padding(
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
                  color: Colors.lightBlue[400],
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
                      color: Colors.lightBlue,
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
                    onPressed: () {
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
                    },
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(100, 30),
                      shadowColor: Colors.black,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.lightBlue[400],
                    ),
                    child: const Text('Provide'),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      _clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cleared'),
                          duration: Duration(seconds: 3),
                        ),
                      );
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: providePage(),
  ));
}
