import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_iot_home/screens/hum_chart_screen.dart';
import 'package:my_iot_home/screens/temp_chart_screen.dart';
import 'package:my_iot_home/screens/webcam_screen.dart';

class SensorCard extends StatefulWidget {
  const SensorCard({
    Key key,
    @required this.sensorIcon,
    @required this.iconColor,
    @required this.sensorValue,
    @required this.sensorType,
    this.valueColor,
  }) : super(key: key);

  final Color iconColor;
  final String sensorIcon;
  final String sensorType;
  final String sensorValue;
  final Color valueColor;

  @override
  _SensorCardState createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  final databaseRef =
      FirebaseDatabase.instance.reference(); //database reference object

  void ToggleGarageLigth(String sensorVal) async {
    int newVal;

    if (sensorVal == "ON")
      newVal = 0;
    else
      newVal = 1;

    print("test");
    databaseRef.child('GarageLightState').set(newVal);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: (widget.sensorType == "Temperature" ||
                      widget.sensorType == "Humidity" ||
                      widget.sensorType == "Camera")
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.64,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.fromString(widget.sensorIcon),
                            color: widget.iconColor,
                            size: 28.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.sensorType,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'Comfortaa',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.sensorValue,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'Orbitron',
                              color: widget.valueColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                (widget.sensorType == "Temperature" ||
                        widget.sensorType == "Humidity" ||
                        widget.sensorType == "Camera" ||
                        (widget.sensorType == "Garage Light" &&
                            widget.sensorValue != "DOWN"))
                    ? Container(
                        height: 60,
                        width: 60,
                        child: FlatButton(
                          onPressed: () => {
                            (widget.sensorType == "Temperature")
                                ? Navigator.pushNamed(
                                    context,
                                    TempChartScreen.route,
                                  )
                                : (widget.sensorType == "Humidity")
                                    ? Navigator.pushNamed(
                                        context,
                                        HumChartScreen.route,
                                      )
                                    : (widget.sensorType == "Camera")
                                        ? Navigator.pushNamed(
                                            context,
                                            WebcamScreen.route,
                                          )
                                        : (widget.sensorType == "Garage Light")
                                            ? ToggleGarageLigth(
                                                widget.sensorValue)
                                            /*FirebaseDatabase.instance
                                                .reference()
                                                .push()
                                                .set({
                                                'GarageLightState': 1
                                              })*/ //database reference object

                                            : null
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: (widget.sensorType == "Temperature" ||
                                  widget.sensorType == "Humidity")
                              ? Colors.blueAccent
                              : (widget.sensorType == "Camera")
                                  ? Colors.pinkAccent
                                  : (widget.sensorType == "Garage Light")
                                      ? Colors.blueGrey[800]
                                      : Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: Icon(
                            (widget.sensorType == "Temperature" ||
                                    widget.sensorType == "Humidity")
                                ? Icons.show_chart
                                : (widget.sensorType == "Camera")
                                    ? Icons.photo
                                    : (widget.sensorType == "Garage Light" &&
                                            widget.sensorValue == "ON")
                                        ? MdiIcons.lightbulbOn
                                        : MdiIcons.lightbulb,
                            size: 46,
                            color: (widget.sensorType == "Garage Light" &&
                                    widget.sensorValue == "ON")
                                ? Colors.yellowAccent
                                : Colors.white,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
