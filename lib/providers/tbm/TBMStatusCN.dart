import 'dart:convert';

import 'package:dash/helpers/models.dart';
import 'package:dash/helpers/test_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TBMStatusCN extends ChangeNotifier {
  List<String> navyFleetList = [];
  List<String> vesselCategoryList = [];
  List<String> vesselClassList = [];
  List<NavyFleetInventory> navyFleetInventoryList = [];

  List<TBMInventory> tbmInventoryList = [];
  List<String> tbmTypeList = [];
  List<String> tbmClassList = [];

  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";
  String lang = "en";

  Future<void> updateTBMInventory() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    navyFleetList = [];
    vesselCategoryList = [];
    vesselClassList = [];
    navyFleetInventoryList = [];

    tbmInventoryList = [];
    tbmTypeList = [];
    tbmClassList = [];

    if (configJSON['use_test_data'] == true) {
      // USING TEST DATA
      print("No test data available.");
    } else {
      //USING SERVER DATA

      String url = configJSON['tbm_get'] + "?lang=" + lang;
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var retrievedData = json.decode(response.body)['data'].toList();
        datetime = json.decode(response.body)['datetime'];
        for (var item in retrievedData) {
          if (!tbmTypeList.contains(item['type'])) {
            tbmTypeList.add(item['type']);
          }
          if (!tbmClassList.contains(item['class'])) {
            tbmClassList.add(item['class']);
          }
        }
        tbmTypeList.sort((a, b) => a.compareTo(b));
        tbmClassList.sort((a, b) => a.compareTo(b));
        for (String tbmType in tbmTypeList) {
          TBMInventory tbmInventory = new TBMInventory();
          tbmInventory.tbmType = tbmType;
          tbmInventory.tbmClassStatusList = [];
          for (var item in retrievedData) {
            if (item['type'] == tbmType) {
              TBMClassStatus tbmClassStatus = new TBMClassStatus();
              tbmClassStatus.tbmClass = item['class'];
              tbmClassStatus.mslInit = item['msl_init'];
              tbmClassStatus.mslTotal = item['msl_total'];
              tbmClassStatus.telInit = item['tel_init'];
              tbmClassStatus.telTotal = item['tel_total'];
              tbmInventory.tbmClassStatusList.add(tbmClassStatus);
            }
            tbmInventoryList.add(tbmInventory);
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> pushTBMInventory(int action, int number, String item, String mslType, String mslClass, String apiKey, String user) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    if (configJSON['use_test_data'] == false) {
      String url = configJSON['tbm_post'] + "?lang=" + lang;
      var response = await http.post(url,
          body: jsonEncode(<String, dynamic>{
            'action': action,
            'number': number,
            'item': item,
            'type': mslType,
            'class': mslClass,
            'apiKey': apiKey,
            'user': user,
          }));
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
        updateTBMInventory();
      }
    }
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
