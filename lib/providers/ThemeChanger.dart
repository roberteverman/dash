import 'package:dash/helpers/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class ThemeChanger extends ChangeNotifier {
  ThemeData themeData = dashDarkTheme;
  bool lightMode = false;
  bool isLoading = false;
  int currentTab = 0;
  int currentSubtab = 0;
  String centralDateTime = "";
  String apiKey = "";
  bool airAdmin = false;
  bool groundAdmin = false;
  bool seaAdmin = false;
  bool spaceAdmin = false;

  getTheme() => themeData;

  setTheme(ThemeData theme) {
    themeData = theme;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  setLoading(bool setIsLoading) async {
    isLoading = setIsLoading;
  }

  Future<void> loginUser(String username, String pwd) async {
    try {
      String configString = await rootBundle.loadString('config/config.json');
      Map configJSON = json.decode(configString);
      String url = configJSON['validate_user'];
      url = url + "?username=" + username + "&pwd=" + pwd;
      var response = await http.get(url);
      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Error!",
          webBgColor: "#dc2a2a",
          timeInSecForIosWeb: 3,
          webPosition: "right",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Success!",
          webBgColor: "#28A228",
          timeInSecForIosWeb: 3,
          webPosition: "right",
        );
        var body = json.decode(response.body);
        apiKey = body['key'];
        airAdmin = body['air'];
        groundAdmin = body['ground'];
        seaAdmin = body['sea'];
        spaceAdmin = body['space'];
      }
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error!",
        webBgColor: "#dc2a2a",
        timeInSecForIosWeb: 3,
        webPosition: "right",
      );
      print(e);
    }
  }
}
