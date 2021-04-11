import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_iot_home/screens/dashboard_screen.dart';
import 'package:my_iot_home/screens/log_screen.dart';
import 'package:my_iot_home/screens/settings_screen.dart';
import 'package:my_iot_home/widgets/custom_list_tile.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                Colors.blueAccent,
                Colors.pinkAccent,
              ]),
            ),
            child: Container(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'images/logo.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Manage My IoT Home',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Comfortaa',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomListTitle(
              Icons.dashboard_outlined,
              'Dashboard',
              () => {
                    Navigator.pushNamed(
                      context,
                      DashboardScreen.route,
                    )
                  }),
          CustomListTitle(
              Icons.insert_drive_file_rounded,
              'Log File',
              () => {
                    Navigator.pushNamed(
                      context,
                      LogScreen.route,
                    )
                  }),
          CustomListTitle(
              Icons.settings,
              'Settings',
              () => {
                    Navigator.pushNamed(
                      context,
                      SettingsScreen.route,
                    )
                  }),
        ],
      ),
    );
  }
}
