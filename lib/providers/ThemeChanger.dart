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
  String currentUser = "";
  String apiKey = "";
  bool airAdmin = false;
  bool groundAdmin = false;
  bool navyAdmin = false;
  bool spaceAdmin = false;
  String lang = "en";

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
        //todo check if there is an API key, if empty do not log in
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
        currentUser = username;
        apiKey = body['key'];
        airAdmin = body['air'];
        groundAdmin = body['ground'];
        navyAdmin = body['sea'];
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
