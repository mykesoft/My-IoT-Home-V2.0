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
        CloudImage temp = (CloudImage(date: ref.fullPath, url: retriveredUrl));
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

class RenderImages extends StatelessWidget {
  const RenderImages({
    Key key,
    @required this.imagesArr,
  }) : super(key: key);

  final List<CloudImage> imagesArr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var item in imagesArr)
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: FutureBuilder(
              // Paste your image URL inside the htt.get method as a parameter
              future: http.get(item.url),
              builder: (BuildContext context,
                  AsyncSnapshot<http.Response> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start.');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 120),
                      child: Column(
                        children: [
                          Loading(
                            indicator: BallSpinFadeLoaderIndicator(),
                            size: 30.0,
                            color: Colors.pinkAccent,
                          ),
                        ],
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    // when we get the data from the http call, we give the bodyBytes to Image.memory for showing the image
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      elevation: 5,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.DDMMYYYY,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    item.HHMMSS,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Image.memory(snapshot.data.bodyBytes),
                          ]),
                        ),
                      ),
                    );
                }
                return null; // unreachable
              },
            ),
          ),
      ],
    );
  }
}
