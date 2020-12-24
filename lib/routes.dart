import 'package:my_iot_home/screens/webcam_screen.dart';
import 'package:my_iot_home/screens/dashboard_screen.dart';

getRoutes() {
  return {
    DashboardScreen.route: (context) => DashboardScreen(),
    WebcamScreen.route: (context) => WebcamScreen(),
  };
}
