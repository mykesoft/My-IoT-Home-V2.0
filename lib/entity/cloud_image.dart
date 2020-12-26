import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';

class CloudImage {
  var date; //imported String and turned in Date
  String url;
  String dateStr;
  String DDMMYYYY;
  String HHMMSS;

  //constructor
  CloudImage({@required date, @required url}) {
    var splittedDayTime = date.split("_");
    print(splittedDayTime);
    var splittedDayMonthYear = splittedDayTime[0].split("-");
    print(splittedDayMonthYear);
    var day = int.parse(splittedDayMonthYear[0]);
    var month = int.parse(splittedDayMonthYear[1]);
    var year = int.parse(splittedDayMonthYear[2]);

    var splittedHourMinuteSecond = splittedDayTime[1].split(":");
    print(splittedHourMinuteSecond);
    var hour = int.parse(splittedHourMinuteSecond[0]);
    var minute = int.parse(splittedHourMinuteSecond[1]);
    var second = int.parse(splittedHourMinuteSecond[2]);

    this.date = (DateTime(year, month, day, hour, minute, second));

    this.DDMMYYYY = formatDate(this.date, [dd, ' ', MM, ' ', yyyy]).toString();
    this.HHMMSS =
        formatDate(this.date, ['At ', HH, ':', nn, ':', ss]).toString();
    print('hhmmss: ' + this.HHMMSS);
    this.dateStr = formatDate(
        this.date, [dd, ' ', MM, ' ', yyyy, ' at ', HH, ':', nn, ':', ss]);
    print(dateStr);
    this.url = url;
  }

  DateTime getDate() {
    return this.date;
  }

  String getUrl() {
    return this.url;
  }

  String getDateStr() {
    return this.dateStr;
  }
// List mesi = [
//   'Gennaio',
//   'Febbraio',
//   'Marzo',
//   'Aprile',
//   'Maggio',
//   'Giugno',
//   'Luglio',
//   'Agosto',
//   'Settembre',
//   'Ottobre',
//   'Novembre',
//   'Dicembre'
// ];
}
