import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:my_iot_home/entity/sensor.dart';
import 'package:my_iot_home/screens/Webcam_screen.dart';
import 'package:my_iot_home/services/push_notification_service.dart';
import 'package:my_iot_home/widgets/sensor_card.dart';
import 'package:my_iot_home/widgets/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 1) {
      print('Notification ON');
      PushNotificationService().initialise(context);
      PushNotificationService().subscribeAlertNotification(context);
    } else {
      PushNotificationService().unsubscribeAlertNotification(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: MenuDrawer(),
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
                            SizedBox(height: 10),
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
                            /*(sensorObj.getWebcamIsDown() == 1)
                                ?*/
                            Container(
                              child: Column(
                                children: [
                                  SensorCard(
                                    sensorIcon: 'camera',
                                    iconColor: Colors.black87,
                                    sensorType: 'Camera',
                                    sensorValue:
                                        (sensorObj.getWebcamIsDown() == 1)
                                            ? "DOWN"
                                            : "OK",
                                    valueColor:
                                        (sensorObj.getWebcamIsDown() == 1)
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ],
                              ),
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
                              sensorIcon: 'home-lightbulb',
                              iconColor: Colors.black,
                              sensorType: 'Garage Light',
                              sensorValue:
                                  (sensorObj.getWaterLevelIsDown() == 1)
                                      ? "DOWN"
                                      : (sensorObj.getGarageLightState() == 1)
                                          ? "ON"
                                          : "OFF",
                              valueColor: (sensorObj.getWaterLevelIsDown() == 1)
                                  ? Colors.orange
                                  : Colors.black,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Loading(
                          indicator: BallSpinFadeLoaderIndicator(),
                          size: 30.0,
                          color: Colors.pinkAccent,
                        ),
                      );
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
