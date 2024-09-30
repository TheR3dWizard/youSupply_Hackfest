import 'package:flutter/material.dart';
import 'package:frontend/settings.dart';
import 'package:frontend/utilities.dart';
import 'package:frontend/utilities/customWidgets.dart';

// This is the type used by the popup menu below.
enum GUMenu { History, Settings, ProfileView, Logout }

class homePageGU extends StatelessWidget {
  const homePageGU({super.key});

  @override
  Widget build(BuildContext context) {
    GUMenu? selectedMenu;

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PopupMenuButton<GUMenu>(
                onSelected: (GUMenu result) {
                  selectedMenu = result;
                  // Handle navigation or other actions based on the selected menu item
                  switch (selectedMenu) {
                    case GUMenu.History:
                      // Navigate to '/history' or perform related action
                      break;
                    case GUMenu.Settings:
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const settings()));
                      // Navigate to '/settings' or perform related action
                      break;
                    case GUMenu.ProfileView:
                      Navigator.pushNamed(context, '/profile');
                      // Navigate to '/profile' or perform related action
                      break;
                    case GUMenu.Logout:
                      Navigator.pushNamed(context, '/');
                      // Navigate to '/logout' or perform related action
                      break;
                    default:
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<GUMenu>>[
                  const PopupMenuItem<GUMenu>(
                    value: GUMenu.History,
                    child: ListTile(
                      leading: Icon(Icons.history),
                      title: Text('History'),
                    ),
                  ),
                  const PopupMenuItem<GUMenu>(
                    value: GUMenu.Settings,
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ),
                  const PopupMenuItem<GUMenu>(
                    value: GUMenu.ProfileView,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile View'),
                    ),
                  ),
                  const PopupMenuItem<GUMenu>(
                    value: GUMenu.Logout,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                child: const Icon(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 225, 255),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile.png',
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Select(
                    label: 'Request',
                    icon: Icons.add_shopping_cart_rounded,
                    onpressed: () {
                      Navigator.pushNamed(context, '/request');
                    },
                    route: '/request',
                  ),
                  const SizedBox(width: 20),
                  Select(
                    label: 'Provide',
                    icon: Icons.volunteer_activism_rounded,
                    route: '/provide',
                    onpressed: () {
                      Navigator.pushNamed(context, '/provide');
                    },
                  ),
                  const SizedBox(width: 20),
                  Select(
                    label: 'Cart',
                    icon: Icons.card_travel,
                    route: '/cartstatic',
                    onpressed: () {
                      Navigator.pushNamed(context, '/cartstatic');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: homePageGU(),
  ));
}
