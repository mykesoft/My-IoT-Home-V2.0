import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_iot_home/routes.dart';
import 'package:my_iot_home/screens/dashboard_screen.dart';
import 'package:my_iot_home/services/push_notification_service.dart';

//final FirebaseApp app = FirebaseApp(
//  options: FirebaseOptions(
//    appId: "1:1018553108194:android:f38e4651f455226fbe80bb",
//    apiKey: "AIzaSyCFvP5QOtNI0V9CQ3VH5a-p1KTb0gMHw-s",
//    databaseURL: "https://myiothome-d3d7c.firebaseio.com",
////for iOS is needed      gcmSenderID: ,
//  ),
//);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(int.parse("0xff5d80fe")),
        accentColor: Color(int.parse("0xff82b1ff")),
      ),
      initialRoute: DashboardScreen.route,
      routes: getRoutes(),
    );
  }
}
