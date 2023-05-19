import 'package:flutter/material.dart';
import 'package:the_hub_flutter/widgets/home/drawer/Drawer_list_tile.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.homePage,
    required this.onProfilTap,
    required this.onSignOutTap,
  });

  final Widget homePage;
  final void Function()? onProfilTap;
  final void Function()? onSignOutTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              // home list tile
              DrawerListTile(
                icon: Icons.home,
                text: "HOME",
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => homePage),
                  (route) => false,
                ),
              ),

              // profil list tile
              DrawerListTile(
                icon: Icons.person,
                text: "PROFIL",
                onTap: onProfilTap,
              ),
            ],
          ),

          // logout button
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: DrawerListTile(
              icon: Icons.logout,
              text: "LOGOUT",
              onTap: onSignOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
