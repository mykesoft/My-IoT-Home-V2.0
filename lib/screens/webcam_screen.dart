import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:my_iot_home/entity/cloud_image.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:my_iot_home/widgets/render_images.dart';

class WebcamScreen extends StatefulWidget {
  static String route = "webcam_screen";

  @override
  _WebcamScreenState createState() => _WebcamScreenState();
}

class _WebcamScreenState extends State<WebcamScreen> {
  final referenceDatabaseDHT11 = FirebaseDatabase.instance.reference();
  List<CloudImage> imagesArr = [];
  bool imagesRetrivered = false;

  Future<String> getUrlImage(String fullPath) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(fullPath)
        .getDownloadURL();

    print("URL: " + downloadURL);
    return downloadURL;
  }

  Future<String> listCloudImages() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .list(firebase_storage.ListOptions(maxResults: 100));
    int cont = 0;
    result.items.forEach((firebase_storage.Reference ref) async {
      print("image name: " + ref.fullPath);

      String retriveredUrl = await getUrlImage(ref.fullPath);
      setState(() {
        retriveredUrl;
        //Ad CloudImage obj to list of objs
        if (!retriveredUrl.contains("log")) {
          CloudImage temp =
              (CloudImage(date: ref.fullPath, url: retriveredUrl));
          print('url image: ' + temp.getUrl());
          print("cont: " + cont.toString());
          cont++;
          imagesArr.add(temp);
          print('there are" ' + imagesArr.length.toString() + " images");

          imagesArr.sort((a, b) => a.getDate().compareTo(b.getDate()));

          print("dati");
          for (int i = 0; i < imagesArr.length; i++) {
            print(imagesArr[i].getDateStr());
          }

          //ordinato dal più recente al più datato
          imagesArr = imagesArr.reversed.toList();

          imagesRetrivered = true;
        }
      });
      // Image.network(downloadURL);
    });

    // result.prefixes.forEach((firebase_storage.Reference ref) {
    //   print('Found directory: $ref');
    // });
  }

  @override
  void initState() {
    super.initState();
    listCloudImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Webcam images'),
      ),
      body: (imagesRetrivered == true)
          ? Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RenderImages(imagesArr: imagesArr),
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
