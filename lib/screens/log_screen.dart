import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:my_iot_home/entity/log_lines.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LogScreen extends StatefulWidget {
  static String route = "log_screen";

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  String LogText = "";
  String LogTextUrl = "";
  bool LogRetrivered = false;
  var logLinesArr = [];
  int linesToShowInsideWidges = 5;
  int maxControllerLines = 0;
  int showedlines = 0;

  Future<String> getLogfileUrl(String fullPath) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(fullPath)
        .getDownloadURL();

    print("URL: " + downloadURL);
    return downloadURL;
  }

  String LogFileName = '';

  // ignore: missing_return
  Future<String> getLogFileName() async {
    String target = '';

    var dbRef =
        await FirebaseDatabase.instance.reference().child("LastLogFileName");
    dbRef.once().then((DataSnapshot snapshot) {
      target = snapshot.value.toString();
      print("name 1 is: " + target);
      return target;
    });
  }

  Future<dynamic> getLogFileText(int controllerOfLines) async {
    String target = '';

    var dbRef =
        await FirebaseDatabase.instance.reference().child("LastLogFileName");
    dbRef.once().then((DataSnapshot snapshot) async {
      LogFileName = snapshot.value.toString();
      print("LogFileName: " + LogFileName);

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('logfiles')
          .child(LogFileName);

      LogTextUrl = (await ref.getDownloadURL()).toString();

      print("Got File");

      Uint8List downloadedData = await ref.getData();

      LogText = utf8.decode(downloadedData).toString();

      LineSplitter ls = new LineSplitter();
      List<String> lines = ls.convert(LogText);

      LogLines tempLogLine;
      List logLinesDescription = [];
      var logLinesDateStr = [];

      maxControllerLines = lines.length;

      for (var x = lines.length - 1 - showedlines;
          x > lines.length - 1 - linesToShowInsideWidges - showedlines;
          x--) {
        print("Line $x is: " + lines[x]);
        if (lines[x] != "") {
          print("x is $x");
          print("Legth of lines is: " + lines.length.toString());

          tempLogLine = new LogLines(line: lines[x]);

          var description = tempLogLine.getDescription();
          logLinesDescription.add(description);

          var dateStr = tempLogLine.getDateStr();
          logLinesDateStr.add(dateStr);
        }
      }

      for (var x = showedlines; x < linesToShowInsideWidges; x++) {
        var elementListLogLine = [logLinesDateStr[x], logLinesDescription[x]];
        logLinesArr.add(elementListLogLine.toList());
      }

      print(logLinesArr);

      setState(() {
        showedlines = linesToShowInsideWidges;
        logLinesArr;
        LogRetrivered = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLogFileText(linesToShowInsideWidges);
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(debug: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Log File Text'),
      ),
      body: (LogRetrivered == true)
          ? Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        height: 80,
                        width: 350,
                        child: RaisedButton(
                          onPressed: () async {
                            final status = await Permission.storage.request();
                            if (status.isGranted) {
                              final externalDir =
                                  await getExternalStorageDirectory();

                              FlutterDownloader.enqueue(
                                url: LogTextUrl,
                                savedDir: externalDir.path,
                                fileName: LogFileName,
                                showNotification:
                                    true, // show download progress in status bar (for Android)
                                openFileFromNotification:
                                    true, // click on notification to open downloaded file (for Android)
                              );
                            } else {
                              print("Permission Denied");
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text('Download',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white)),
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            children: logLinesArr
                                .map((item) => ListTile(
                                      title: Text(item[0]),
                                      subtitle: Text(item[1]),
                                    ))
                                .toList()),
                      ),
                      Container(
                        height: 80,
                        width: 350,
                        child: RaisedButton(
                          onPressed: () {
                            var nLinesToAdd = 10;
                            if ((linesToShowInsideWidges + nLinesToAdd) <=
                                maxControllerLines) {
                              setState(() {
                                linesToShowInsideWidges += nLinesToAdd;
                                getLogFileText(linesToShowInsideWidges);
                              });
                            } else {
                              print("Over Max Controller Log Lines!");
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text('Add lines!',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white)),
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(height: 20),
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
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white)),
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loading(
                    indicator: BallSpinFadeLoaderIndicator(),
                    size: 30.0,
                    color: Colors.pinkAccent,
                  ),
                ],
              ),
              /*  child: Container(
                child: Column(children: [


                ]),
              ),*/
            ),
    );
  }
}
