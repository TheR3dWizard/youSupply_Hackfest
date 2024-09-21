import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/settings.dart';
import 'package:frontend/utilities/customWidgets.dart';
import 'package:frontend/utilities.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

// This is the type used by the popup menu below.
enum DeliveryMenu { History, Settings, ProfileView, Logout }

class homePageDel extends StatelessWidget {
  homePageDel({Key? key}) : super(key: key);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.025155757439432, 77.00250346910578),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    DeliveryMenu? selectedMenu;

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PopupMenuButton<DeliveryMenu>(
                onSelected: (DeliveryMenu result) {
                  selectedMenu = result;
                  // Handle navigation or other actions based on the selected menu item
                  switch (selectedMenu) {
                    case DeliveryMenu.History:
                      break;
                    case DeliveryMenu.Settings:
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => settings()));
                    case DeliveryMenu.ProfileView:
                      Navigator.pushNamed(context, '/profile');
                      break;
                    case DeliveryMenu.Logout:
                      Navigator.pushNamed(context, '/');
                      break;
                    default:
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<DeliveryMenu>>[
                  const PopupMenuItem<DeliveryMenu>(
                    value: DeliveryMenu.History,
                    child: ListTile(
                      leading: Icon(Icons.history),
                      title: Text('History'),
                    ),
                  ),
                  const PopupMenuItem<DeliveryMenu>(
                    value: DeliveryMenu.Settings,
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ),
                  const PopupMenuItem<DeliveryMenu>(
                    value: DeliveryMenu.ProfileView,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile View'),
                    ),
                  ),
                  const PopupMenuItem<DeliveryMenu>(
                    value: DeliveryMenu.Logout,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                child: Icon(
                  Icons.menu,
                  size: 40,
                  color: Color.fromRGBO(0, 224, 255, 1),
                ),
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
                //map container
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                SizedBox(height: 10),
                Option(label: 'Available Routes', route: '/available'),
                Option(label: 'Accepted Route', route: '/accepted'),
                Option(label: 'Completed Delivery ', route: '/completed'),
                Option(label: 'Completed Routes', route: '/completed_routes'),
                //SizedBox(height: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: homePageDel(),
  ));
}
