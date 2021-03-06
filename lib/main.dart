import 'dart:html';

import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:dash/providers/air/AircraftStatusCN.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:dash/providers/air/SAMStatusCN.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:dash/providers/tbm/TBMStatusCN.dart';
import 'package:dash/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChanger>(create: (context) => ThemeChanger()),
        ChangeNotifierProvider<AirFieldStatusCN>(create: (context) => AirFieldStatusCN()),
        ChangeNotifierProvider<AircraftStatusCN>(create: (context) => AircraftStatusCN()),
        ChangeNotifierProvider<AirChartCN>(create: (context) => AirChartCN()),
        ChangeNotifierProvider<GroundChartCN>(create: (context) => GroundChartCN()),
        ChangeNotifierProvider<NavyVesselCN>(create: (context) => NavyVesselCN()),
        ChangeNotifierProvider<SAMStatusCN>(create: (context) => SAMStatusCN()),
        ChangeNotifierProvider<TBMStatusCN>(create: (context) => TBMStatusCN()),
      ],
      child: new MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dash.",
      home: Home(),
      theme: Provider.of<ThemeChanger>(context, listen: true).themeData..textTheme.apply(fontFamily: 'NotoSansKR'),
    );
  }
}
