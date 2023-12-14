import 'package:flutter/material.dart';

void httpLogging(String name, String value) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    debugPrint("${tsdate.year.toString()}-${tsdate.month.toString().length == 1 ? "0" : ""}${tsdate.month.toString()}-${tsdate.day.toString().length == 1 ? "0" : ""}${tsdate.day.toString()} ${tsdate.hour.toString().length == 1 ? "0" : ""}${tsdate.hour.toString()}:${tsdate.minute.toString().length == 1 ? "0" : ""}${tsdate.minute.toString()}:${tsdate.second.toString().length == 1 ? "0" : ""}${tsdate.second.toString()}.${tsdate.millisecond.toString()} $name : $value");
    // debugPrint();
}