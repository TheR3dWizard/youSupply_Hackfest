import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/utilities/apiFunctions.dart';
import 'package:frontend/utilities/integrationFunctions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AcceptedRoutes extends StatefulWidget {
  const AcceptedRoutes({super.key});

  @override
  _AcceptedRoutesState createState() => _AcceptedRoutesState();
}

class _AcceptedRoutesState extends State<AcceptedRoutes> {
  late Future<List<RouteStep>> _acceptedPathFuture;
  late List<bool> _completedStatus;
  bool _isLoading = false;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    // Load accepted path steps when the widget is initialized
    _acceptedPathFuture = viewAcceptedPath("1"); // Use key if needed
  }

  // Mark the next step as completed and update the UI
  void _markNextAsCompleted() async {
    setState(() {
      _isLoading = true;
    });

    await markStep(); // Marks the step on the server

    setState(() {
      if (_completedCount < _completedStatus.length) {
        _completedStatus[_completedCount] = true;
        _completedCount++;
      }
      _isLoading = false;
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.025155757439432, 77.00250346910578),
    zoom: 10.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Routes'),
        backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<RouteStep>>(
        future: _acceptedPathFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<RouteStep>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<RouteStep> pathSteps = snapshot.data!;
            _completedStatus = List<bool>.filled(pathSteps.length, false);

            return Column(
              children: [
                // Map Container
                FutureBuilder<Set<Marker>>(
                  future: setMarkers(1), // Load markers if needed
                  builder: (context, markerSnapshot) {
                    return FutureBuilder<Set<Polyline>>(
                      future: setPolylines(1), // Load polylines if needed
                      builder: (context, polylineSnapshot) {
                        if (markerSnapshot.connectionState ==
                                ConnectionState.waiting ||
                            polylineSnapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (markerSnapshot.hasError ||
                            polylineSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${markerSnapshot.error}'));
                        }

                        return SizedBox(
                          height: 200,
                          child: GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            markers: markerSnapshot.data ?? {},
                            polylines: polylineSnapshot.data ?? {},
                          ),
                        );
                      },
                    );
                  },
                ),
                // Routes List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: pathSteps.length,
                      itemBuilder: (context, index) {
                        RouteStep currentStep = pathSteps[index];
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
                              Align(
                                alignment: Alignment.bottomRight,
                                child: isCompleted
                                    ? const Text(
                                        'Completed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
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
                if (_completedCount < _completedStatus.length && !_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _markNextAsCompleted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                      child: const Text(
                        'Mark as Completed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
