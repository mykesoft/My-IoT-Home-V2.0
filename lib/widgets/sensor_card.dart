import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_iot_home/screens/hum_chart_screen.dart';
import 'package:my_iot_home/screens/temp_chart_screen.dart';
import 'package:my_iot_home/screens/webcam_screen.dart';

class SensorCard extends StatelessWidget {
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
              mainAxisAlignment: (sensorType == "Temperature" ||
                      sensorType == "Humidity" ||
                      sensorType == "Camera")
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.fromString(sensorIcon),
                            color: iconColor,
                            size: 28.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            sensorType,
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
                            sensorValue,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'Orbitron',
                              color: valueColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                (sensorType == "Temperature" ||
                        sensorType == "Humidity" ||
                        sensorType == "Camera")
                    ? Container(
                        height: 60,
                        width: 60,
                        child: FlatButton(
                          onPressed: () => {
                            (sensorType == "Temperature")
                                ? Navigator.pushNamed(
                                    context,
                                    TempChartScreen.route,
                                  )
                                : (sensorType == "Humidity")
                                    ? Navigator.pushNamed(
                                        context,
                                        HumChartScreen.route,
                                      )
                                    : Navigator.pushNamed(
                                        context,
                                        WebcamScreen.route,
                                      )
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: (sensorType == "Temperature" ||
                                  sensorType == "Humidity")
                              ? Colors.blueAccent
                              : Colors.pinkAccent,
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: Icon(
                            (sensorType == "Temperature" ||
                                    sensorType == "Humidity")
                                ? Icons.show_chart
                                : Icons.photo,
                            size: 50,
                            color: Colors.white,
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
