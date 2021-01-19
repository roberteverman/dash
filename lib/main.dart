import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:dash/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

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
      home: Home(),
      theme: Provider.of<ThemeChanger>(context, listen: true).themeData,
    );
  }
}