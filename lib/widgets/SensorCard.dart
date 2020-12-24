import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.fromString(sensorIcon),
                  color: iconColor,
                  size: 32.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                SizedBox(
                  width: 4,
                ),
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
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
          ],
        ),
      ),
    );
  }
}
