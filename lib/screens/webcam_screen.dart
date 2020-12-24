import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_iot_home/entity/sensor.dart';
import 'package:my_iot_home/screens/dashboard_screen.dart';
import 'package:my_iot_home/services/push_notification_service.dart';
import 'package:my_iot_home/widgets/SensorCard.dart';

class WebcamScreen extends StatefulWidget {
  static String route = "webcam_screen";

  @override
  _WebcamScreenState createState() => _WebcamScreenState();
}

class _WebcamScreenState extends State<WebcamScreen> {

  final referenceDatabaseDHT11 = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Webcam images'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: referenceDatabaseDHT11.onValue,
                  builder: (context, snap) {
                    if (snap.hasData &&
                        !snap.hasError &&
                        snap.data.snapshot.value != null) {
//taking the data snapshot.
                      DataSnapshot snapshot = snap.data.snapshot;
                      var jsonSnapshot = snapshot.value;

                      Sensor sensorObj = new Sensor(jsonSnapshot);

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [ RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Dashboard',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white)),
                            color: Colors.pinkAccent,
                          ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
