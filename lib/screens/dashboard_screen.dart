import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_iot_home/entity/sensor.dart';
import 'package:my_iot_home/screens/Webcam_screen.dart';
import 'package:my_iot_home/services/push_notification_service.dart';
import 'package:my_iot_home/widgets/SensorCard.dart';

class DashboardScreen extends StatefulWidget {
  static String route = "control_screen";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final referenceDatabaseDHT11 = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    startFirebase();
  }

  // See FCM
  startFirebase() async {
    print('verify not');
    //final prefs = await SharedPreferences.getInstance();
    //final key = 'notification';
    //final value = prefs.getInt(key) ?? 0;
    //if (value == 1) {
    print('Notification ON');
    PushNotificationService().initialise(context);
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
                          children: [
                            SensorCard(
                              sensorIcon: 'thermometer',
                              iconColor: Colors.red,
                              sensorType: 'Temperature',
                              sensorValue: (sensorObj.getDHT11IsDown() == 1)
                                  ? "DOWN"
                                  : sensorObj.getTemperature(),
                              valueColor: (sensorObj.getDHT11IsDown() == 1)
                                  ? Colors.orange
                                  : Colors.black,
                            ),
                            SizedBox(height: 10),
                            SensorCard(
                              sensorIcon: 'water',
                              iconColor: Colors.lightBlueAccent,
                              sensorType: 'Humidity',
                              sensorValue: (sensorObj.getDHT11IsDown() == 1)
                                  ? "DOWN"
                                  : sensorObj.getHumidity(),
                              valueColor: (sensorObj.getDHT11IsDown() == 1)
                                  ? Colors.orange
                                  : Colors.black,
                            ),
                            SizedBox(height: 10),
                            SensorCard(
                              sensorIcon: 'homeFlood',
                              iconColor: Colors.black87,
                              sensorType: 'Garage flooding',
                              sensorValue:
                                  (sensorObj.getWaterLevelIsDown() == 1)
                                      ? "DOWN"
                                      : sensorObj.getWaterLevel(),
                              valueColor: (sensorObj.getWaterLevelIsDown() == 1)
                                  ? Colors.orange
                                  : (sensorObj.getWaterLevel() == 'HIGH')
                                      ? Colors.red
                                      : Colors.green,
                            ),
                            SizedBox(height: 10),
                            SensorCard(
                              sensorIcon: 'motionSensor',
                              iconColor: Colors.black87,
                              sensorType: 'Motion sensor',
                              sensorValue: (sensorObj.getPirIsDown() == 1)
                                  ? "DOWN"
                                  : sensorObj.getMotionSersor(),
                              valueColor: (sensorObj.getPirIsDown() == 1)
                                  ? Colors.orange
                                  : (sensorObj.getMotionSersor() == 'DETECTED')
                                      ? Colors.red
                                      : Colors.green,
                            ),
                            (sensorObj.getWebcamIsDown() == 1)
                                ? Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        SensorCard(
                                          sensorIcon: 'camera',
                                          iconColor: Colors.black87,
                                          sensorType: 'Camera',
                                          sensorValue: "DOWN",
                                          valueColor: Colors.orange,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 20),
                            RaisedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  WebcamScreen.route,
                                );
                              },
                              child: const Text('Webcam Images',
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
