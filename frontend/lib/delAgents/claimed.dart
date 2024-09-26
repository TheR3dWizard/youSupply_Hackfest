import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';
import 'package:frontend/utilities/apiFunctions.dart';
import 'completed_routes.dart';

class ClaimedRoutes extends StatefulWidget {
  final int pathIndex;

  const ClaimedRoutes({
    Key? key,
    required this.pathIndex,
  }) : super(key: key);

  @override
  _ClaimedRoutesState createState() => _ClaimedRoutesState();
}

class _ClaimedRoutesState extends State<ClaimedRoutes> {
  late Future<List<Tuple>> _pathTuplesFuture;
  late List<bool> _completedStatus;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _pathTuplesFuture = loadPathsTuple(widget.pathIndex).then((pathTuples) {
      _completedStatus = List<bool>.filled(pathTuples.length, false);
      return pathTuples;
    });
  }

  void _markNextAsCompleted() {
    setState(() {
      if (_completedCount < _completedStatus.length) {
        _completedStatus[_completedCount] = true;
        _completedCount++;
      }

      // Navigate to the completed routes page when all are completed
      if (_completedCount == _completedStatus.length) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompletedRoutes(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Claimed Routes',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Tuple>>(
        future: _pathTuplesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Tuple>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<Tuple> pathTuples = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: pathTuples.length,
                      itemBuilder: (context, index) {
                        Tuple currentTuple = pathTuples[index];
                        bool isCompleted = _completedStatus[index];

                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display only the start location
                              Text(
                                currentTuple.startLoc,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                              Text(
                                currentTuple.resources,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white60,
                                ),
                              ),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: isCompleted
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          'Completed',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // "Mark as Completed" button at the bottom
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _completedCount < _completedStatus.length
                        ? _markNextAsCompleted
                        : null, // Disable button when all are completed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 255, 255),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: Text(
                      'Mark as Completed',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
