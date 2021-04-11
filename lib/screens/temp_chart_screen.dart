import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:my_iot_home/Secrets/secrets.dart';
import 'package:my_iot_home/entity/dht_log_points.dart';
import 'package:my_iot_home/widgets/my_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TempChartScreen extends StatefulWidget {
  static String route = "temp_chart_screen";
  @override
  _TempChartScreenState createState() => _TempChartScreenState();
}

class _TempChartScreenState extends State<TempChartScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  String thingspeak_url_temp_chart =
      'https://thingspeak.com/channels/1352668/charts/1?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&title=Temperature+%5B%C2%B0+C%5D&type=line&api_key=' +
          Secrets.thingspeak_key_write;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Temperature Graph'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 245,
              width: (MediaQuery.of(context).size.width),
              child: WebView(
                initialUrl: thingspeak_url_temp_chart,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController controller) {
                  _controller.complete(controller);
                },
                navigationDelegate: (NavigationRequest _redirectRequest) {
                  return NavigationDecision
                      .prevent; //Blocks all internal html navigation requests.
                },
              ),
            ),
            Container(
              height: 80,
              width: 350,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text('Dashboard',
                    style: TextStyle(fontSize: 22, color: Colors.white)),
                color: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
