import 'package:flutter/material.dart';

ThemeData dashDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
  primaryColorDark: Color.fromRGBO(37, 37, 37, 1),
  primaryColor: Color.fromRGBO(47, 47, 47, 1),
  primaryColorLight: Color.fromRGBO(70, 70, 70, 1),
  indicatorColor: Colors.white,
  accentColor: Colors.white,
  tabBarTheme: TabBarTheme().copyWith(
    labelColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme().copyWith(
    fillColor: Color.fromRGBO(47, 47, 47, 1),
  ),
);

ThemeData dashLightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
    primaryColorDark: Color.fromRGBO(223, 226, 235, 1),
    primaryColor: Color.fromRGBO(223, 226, 235, 1),
    primaryColorLight: Color.fromRGBO(242, 245, 250, 1),
    accentColor: Colors.black,
    tabBarTheme: TabBarTheme().copyWith(
      labelColor: Colors.black,
    ));
