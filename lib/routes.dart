import 'package:js/js.dart';
import 'package:my_iot_home/screens/hum_chart_screen.dart';
import 'package:my_iot_home/screens/log_screen.dart';
import 'package:my_iot_home/screens/settings_screen.dart';

import 'package:my_iot_home/screens/temp_chart_screen.dart';
import 'package:my_iot_home/screens/webcam_screen.dart';
import 'package:my_iot_home/screens/dashboard_screen.dart';

getRoutes() {
  return {
    DashboardScreen.route: (context) => DashboardScreen(),
    WebcamScreen.route: (context) => WebcamScreen(),
    TempChartScreen.route: (context) => TempChartScreen(),
    HumChartScreen.route: (context) => HumChartScreen(),
    LogScreen.route: (context) => LogScreen(),
    SettingsScreen.route: (context) => SettingsScreen(),
  };
}
