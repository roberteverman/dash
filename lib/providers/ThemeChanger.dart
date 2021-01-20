import 'package:dash/helpers/themes.dart';
import 'package:flutter/material.dart';

class ThemeChanger extends ChangeNotifier {
  ThemeData themeData = dashDarkTheme;
  bool lightMode = false;
  bool isLoading = false;
  int currentTab = 0;
  int currentSubtab = 0;
  String centralDateTime = "";

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
}
