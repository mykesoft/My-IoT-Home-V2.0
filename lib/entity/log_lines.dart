import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';

class LogLines {
  String line;
  String description;
  String dateStr;

  //constructor
  LogLines({@required line}) {
    this.line = line;
    this.description = line.substring(25);
    print("this description: " + this.description);

    var splittedDayTime = line.substring(0, line.indexOf(';') - 4);
    splittedDayTime = splittedDayTime.split(" ");

    var splittedYearMonthDay = splittedDayTime[0].split("-");

    var year = int.parse(splittedYearMonthDay[0]);
    var month = int.parse(splittedYearMonthDay[1]);
    var day = int.parse(splittedYearMonthDay[2]);

    var splittedHourMinuteSecond = splittedDayTime[1].split(":");

    var hour = int.parse(splittedHourMinuteSecond[0]);
    var minute = int.parse(splittedHourMinuteSecond[1]);
    var second = int.parse(splittedHourMinuteSecond[2]);

    var date = (DateTime(year, month, day, hour, minute, second));

    var dateStr = formatDate(
        date, [dd, ' ', MM, ' ', yyyy, ' at ', HH, ':', nn, ':', ss]);

    this.dateStr = dateStr;
    print(this.dateStr);
  }

  String getDateStr() {
    return this.dateStr;
  }

  String getDescription() {
    return this.description;
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
