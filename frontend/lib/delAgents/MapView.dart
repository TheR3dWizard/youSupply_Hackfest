import 'dart:async';
import 'package:frontend/utilities/apiFunctions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapView extends StatefulWidget {
  final int pathIndex;

  const MapView({
    super.key,
    required this.pathIndex,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late Future<List<Tuple>> _pathTuplesFuture;
  late List<bool> _completedStatus;
  final bool _acceptPressed = false;

  @override
  void initState() {
    super.initState();
    _pathTuplesFuture = loadPathsTuple(widget.pathIndex);
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.025155757439432, 77.00250346910578),
    zoom: 10.4746,
  );

  PolylinePoints polylinePoints = PolylinePoints();
  final List<Polyline> polyline = [];
  List<LatLng> routeCoords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<Tuple> pathTuples = snapshot.data!;
            _completedStatus = List<bool>.filled(pathTuples.length, false);
            print('Path Tuples: $pathTuples'); // Debug print
            return Column(
              children: [
                // Map Container
                FutureBuilder<Set<Marker>>(
                  future: setMarkers(widget.pathIndex),
                  builder: (context, snapshot) {
                    return FutureBuilder(
                      future: setPolylines(widget.pathIndex),
                      builder: (context, snapshot2) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot2.connectionState ==
                                ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError || snapshot2.hasError) {
                          print(snapshot.error);
                          print(snapshot2.error);
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || !snapshot2.hasData) {
                          return const Center(child: Text('No data available'));
                        }
                        return SizedBox(
                          height: 200,
                          child: GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            markers: snapshot.data ?? {},
                            polylines: snapshot2.data!,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
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
                                    Text(
                                      currentTuple.startLoc,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      currentTuple.resources,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Acceptance'),
                              content: const Text(
                                  'Are you sure you want to accept?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ClaimedRoutes(
                                    //         pathIndex: widget.pathIndex),
                                    //   ),
                                    // );
                                  },
                                  child: const Text('Accept'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        shape: const ContinuousRectangleBorder(),
                        minimumSize: const Size(450, 25),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
