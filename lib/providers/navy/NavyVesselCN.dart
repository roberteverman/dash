import 'dart:convert';

import 'package:dash/helpers/models.dart';
import 'package:dash/helpers/test_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NavyVesselCN extends ChangeNotifier {
  List<String> navyFleetList = [];
  List<String> vesselCategoryList = [];
  List<String> vesselClassList = [];

  List<NavyFleetInventory> navyFleetInventoryList = [];

  List<AirfieldInventory> airfieldInventory = [];
  List<String> airfieldList = [];
  List<int> airDivisionList = [];
  List<String> aircraftList = [];
  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";
  String lang = "en";

  Future<void> updateNavyInventory() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    navyFleetList = [];
    vesselCategoryList = [];
    vesselClassList = [];
    navyFleetInventoryList = [];

    airfieldInventory = [];
    airfieldList = [];
    airDivisionList = [];
    aircraftList = [];

    if (configJSON['use_test_data'] == true) {
      // USING TEST DATA
      print("No test data available.");
    } else {
      //USING SERVER DATA
      String url2 = configJSON['navy_get'] + "?lang=" + lang;
      var response2 = await http.get(url2);
      if (response2.statusCode == 200) {
        var retrievedData = json.decode(response2.body)['data'].toList();
        datetime = json.decode(response2.body)['datetime'];
        //make three lists containing unique values for fleet, category and class
        for (var item in retrievedData) {
          if (!navyFleetList.contains(item['fleet'])) {
            navyFleetList.add(item['fleet']);
          }
          if (!vesselCategoryList.contains(item['category'])) {
            vesselCategoryList.add(item['category']);
          }
          for (var vessel in item['vessels']) {
            if (!vesselClassList.contains(vessel['class'])) {
              vesselClassList.add(vessel['class']);
            }
          }
        }
        //create list of NavyFleetInventory objects for each fleet
        for (String fleet in navyFleetList) {
          NavyFleetInventory navyFleetInventory = new NavyFleetInventory();
          navyFleetInventory.fleet = fleet;
          navyFleetInventory.navyVesselCategoryList = [];
          for (var item in retrievedData) {
            if (item['fleet'] == fleet) {
              NavyVesselCategory navyVesselCategory = new NavyVesselCategory();
              navyVesselCategory.category = item['category'];
              navyVesselCategory.vesselClassStatusList = [];
              for (var vessel in item['vessels']) {
                NavyVesselClassStatus navyVesselClassStatus = new NavyVesselClassStatus.fromJSON(vessel);
                navyVesselCategory.vesselClassStatusList.add(navyVesselClassStatus);
              }
              navyFleetInventory.navyVesselCategoryList.add(navyVesselCategory);
            }
          }
          navyFleetInventoryList.add(navyFleetInventory);
        }
      }
    }
    notifyListeners();
  }

  Future<void> pushNavyInventory(int action, int number, String item, String fleet, String category, String apiKey, String user) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    if (configJSON['use_test_data'] == false) {
      String url = configJSON['navy_post'] + "?lang=" + lang;
      var response = await http.post(url,
          body: jsonEncode(<String, dynamic>{
            'action': action,
            'number': number,
            'item': item,
            'fleet': fleet,
            'category': category,
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
        updateNavyInventory();
      }
    }
  }

  Future<void> pushAirfieldInventory(int action, int number, String item, String origin, String destination, String apiKey, String user) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    if (configJSON['use_test_data'] == false) {
      String url = configJSON['aircraft_post'] + "?lang=" + lang;
      var response = await http.post(url,
          body: jsonEncode(<String, dynamic>{
            'action': action,
            'number': number,
            'item': item,
            'origin': origin, //todo make be number instead of afld name
            'destination': destination, //todo make be number instead of afld name
            'key': apiKey,
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
        updateNavyInventory();
      }
    }
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
