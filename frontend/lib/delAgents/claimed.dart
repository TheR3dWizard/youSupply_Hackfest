import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';
import 'package:frontend/utilities/apiFunctions.dart';

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

  @override
  void initState() {
    super.initState();
    _pathTuplesFuture = loadPathsTuple(widget.pathIndex).then((pathTuples) {
      _completedStatus = List<bool>.filled(pathTuples.length, false);
      return pathTuples;
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
                        String nextLocation = index < pathTuples.length - 1
                            ? pathTuples[index + 1].startLoc
                            : 'End';

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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      currentTuple.startLoc,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      nextLocation,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
                                    : ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _completedStatus[index] = true;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 0, 255, 255),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                        ),
                                        child: Text(
                                          'Mark as Completed',
                                          style: TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
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
