import 'package:flutter/material.dart';
import 'package:frontend/newdelAgent/homePageDel.dart';
import 'package:frontend/utilities.dart';
import 'package:frontend/utilities/integrationFunctions.dart';
import 'package:frontend/newdelAgent/completed_routes.dart';

class AcceptedRoutes extends StatefulWidget {
  final int pathIndex;

  const AcceptedRoutes({
    super.key,
    required this.pathIndex,
  });

  @override
  _AcceptedRoutesState createState() => _AcceptedRoutesState();
}

class _AcceptedRoutesState extends State<AcceptedRoutes> {
  late Future<List<RouteStep>> _acceptedPathStepsFuture;
  late List<bool> _completedStatus;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    // Load the accepted path steps
    _acceptedPathStepsFuture =
        viewAcceptedPath(widget.pathIndex.toString()).then((pathSteps) {
      _completedStatus = List<bool>.filled(pathSteps.length, false);
      return pathSteps;
    });
  }

  void _markNextAsCompleted() {
    setState(() {
      if (_completedCount < _completedStatus.length) {
        _completedStatus[_completedCount] = true;
        _completedCount++;
      }

      if (_completedCount == _completedStatus.length) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              markStep();
              return homePageDel();
            },
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
        title: const Text(
          'Accepted Routes',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<RouteStep>>(
        future: _acceptedPathStepsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<RouteStep>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<RouteStep> acceptedPathSteps = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: acceptedPathSteps.length,
                      itemBuilder: (context, index) {
                        RouteStep currentStep = acceptedPathSteps[index];
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
                              Text(
                                currentStep.Location,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                currentStep.resources,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: isCompleted
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: const Text(
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _completedCount < _completedStatus.length
                        ? _markNextAsCompleted
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 255, 255),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    child: const Text(
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
