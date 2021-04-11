import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  Future initialise(context) async {
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
        _fcm.subscribeToTopic('alert');
      });

      //test

      _fcm.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
//      _fcm.onIosSettingsRegistered
//          .listen((IosNotificationSettings settings) {
//        print("Settings registered: $settings");
//      });
    }

    _fcm.subscribeToTopic('alert');

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (message['notification']['title'] != null)
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: ListTile(
                      title: Text(message['notification']['title']),
                      subtitle: Text(message['notification']['body']),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  )
//              : AlertDialog(
//                  content: ListTile(
//                    title: Text(message['data'][0]["message"]),
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text('Ok'),
//                      onPressed: () => Navigator.of(context).pop(),
//                    ),
//                  ],
//                ),
              );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  subscribeAlertNotification(context) async {
    _fcm.subscribeToTopic('alert');
  }

  unsubscribeAlertNotification(context) async {
    _fcm.unsubscribeFromTopic('alert');
  }
}
