import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:my_iot_home/entity/cloud_image.dart';
import 'package:http/http.dart' as http;

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
