import 'package:flutter/material.dart';

class ColorConstants {
  const ColorConstants._();

  static const blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff2E3192),
      Color(0xff1BFFFF),
    ],
  );
  static const pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffee0a67),
      Color(0xfffea1be),
    ],
  );
  static const purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff552585),
      Color(0xffb589d6),
    ],
  );
  static const amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffff705f),
      Color(0xfffeb47b),
    ],
  );
  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff053d00),
      Color(0xff00ff77),
    ],
  );

  static const darkPinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff61045f),
      Color(0xffaa076b),
    ],
  );

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xff5EABFA),
      Color(0xff0552A0),
    ],
  );

  static const secondaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xffFFA560),
      Color(0xffFFCE4D),
    ],
  );


  static final simpleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Colors.blue,
      Colors.blue.shade100
    ],
  );
}
