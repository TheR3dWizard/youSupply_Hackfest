import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/delAgents/claimed.dart';
import 'package:frontend/utilities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
class MapView extends StatefulWidget {
  final int pathIndex;

  const MapView({
    Key? key,
    required this.pathIndex,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late Future<List<Tuple>> _pathTuplesFuture;
  late List<bool> _completedStatus;
  bool _acceptPressed = false;

  @override
  void initState() {
    super.initState();
    _pathTuplesFuture = loadPathsTuple(widget.pathIndex);
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Map View',
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
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<Tuple> pathTuples = snapshot.data!;
            _completedStatus = List<bool>.filled(pathTuples.length, false);
            print('Path Tuples: $pathTuples'); // Debug print
            return Column(
              children: [
                // Map Container
                FutureBuilder<Set<Marker>>(
                  future: setMarkers(widget.pathIndex),
                  builder: (context,snapshot) {
                    return SizedBox(
                      height: 200,
                      child: GoogleMap(
                        mapType: MapType.hybrid,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    );
                  }
                ),
                // Routes List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: pathTuples.length,
                            itemBuilder: (context, index) {
                              Tuple currentTuple = pathTuples[index];
                              bool isCompleted = _completedStatus[index];
                              String nextLocation =
                                  index < pathTuples.length - 1
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
                                    if (_acceptPressed)
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: isCompleted
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  'Completed',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              )
                                            : OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _completedStatus[index] =
                                                        true;
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 0, 255, 255),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
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
                      ],
                    ),
                  ),
                ),
                if (!_acceptPressed)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClaimedRoutes(pathIndex: widget.pathIndex),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: ContinuousRectangleBorder(),
                        minimumSize: Size(450, 25),
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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




Completer<AndroidMapRenderer?>? _initializedRendererCompleter;
Future<AndroidMapRenderer?> initializeMapRenderer() async {
  if (_initializedRendererCompleter != null) {
    return _initializedRendererCompleter!.future;
  }

  final Completer<AndroidMapRenderer?> completer =
      Completer<AndroidMapRenderer?>();
  _initializedRendererCompleter = completer;

  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform platform = GoogleMapsFlutterPlatform.instance;
  unawaited((platform as GoogleMapsFlutterAndroid)
      .initializeWithRenderer(AndroidMapRenderer.latest)
      .then((AndroidMapRenderer initializedRenderer) =>
          completer.complete(initializedRenderer)));

  return completer.future;
}





