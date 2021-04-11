import 'package:flutter/material.dart';
import 'package:my_iot_home/screens/dashboard_screen.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  static String route = "SettingsScreen_screen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color subtitleColor = Colors.grey;
  bool _notification = false;

  @override
  void initState() {
    super.initState();
    checkNotificationSetting();
  }

  checkNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 0) {
      setState(() {
        _notification = false;
      });
    } else {
      setState(() {
        _notification = true;
      });
    }
  }

  saveNotificationSetting(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = val ? 1 : 0;
    prefs.setInt(key, value);
    if (value == 1) {
      setState(() {
        _notification = true;
      });
    } else {
      setState(() {
        _notification = false;
//        PushNotificationService().unsubscribeWpNotification(context);
      });
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DashboardScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
        ),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Card(
                  elevation: 8,
                  child: Image(
                    image: AssetImage('images/logo.png'),
                    height: 150,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Text(
                  "My IoT Home \n V2.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.6, color: subtitleColor, fontSize: 18),
                ),
              ),
              Divider(
                height: 10,
                thickness: 2,
              ),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: Text('App'),
                  ),
                  /*NOTIFICATION TOGGLE*/
                  ListTile(
                    leading: Icon(
                      Icons.notifications_none,
                      color: Colors.orange,
                      size: 40,
                    ),
                    title: Text('Notifications'),
                    subtitle: Text(
                      "Set your Notifications preference",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Switch(
                        activeColor: Colors.pinkAccent,
                        onChanged: (val) async {
                          await saveNotificationSetting(val);
                        },
                        value: _notification),
                  ),
                  /*end notification */
                ],
              ),
              SizedBox(height: 20),
              Divider(
                height: 10,
                thickness: 2,
              ),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Contacts'),
                  ),
                  InkWell(
                    onTap: () async {
                      const url = 'mailto:support@myiothome.it';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.mail_outline,
                        color: Colors.pinkAccent,
                        size: 40,
                      ),
                      title: Text(
                        "support@myiothome.it",
                      ),
                      subtitle: Text(
                        "Click, to send an email!",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      const url = 'tel://3212345678';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Colors.green,
                        size: 40,
                      ),
                      title: Text(
                        "Support: 3212345678",
                      ),
                      subtitle: Text(
                        "Click, to call for support!",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
