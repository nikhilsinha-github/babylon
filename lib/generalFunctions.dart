import 'package:flutter/material.dart';

class GenFunc {
  getDuration(int dur) {
    String hr = ((dur / 60).floor()).toString();
    String min = (dur % 60).toString();
    return Text(
      hr + "hr " + min + "min",
      style: TextStyle(
        fontFamily: 'Montserrat-Bold',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
