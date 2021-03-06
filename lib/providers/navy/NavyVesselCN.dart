import 'dart:convert';

import 'package:dash/helpers/models.dart';
import 'package:dash/helpers/test_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_maps/maps.dart';

class NavyVesselCN extends ChangeNotifier {
  List<String> navyFleetList = [];
  List<String> vesselCategoryList = [];
  List<String> vesselClassList = [];
  int numOpSubmarines = 0;
  int totalSubmarines = 0;
  int numOpSurface = 0;
  int totalSurface = 0;
  int numOpLanding = 0;
  int totalLanding = 0;
  int numOpCDCM = 0;
  int totalCDCM = 0;

  List<NavyFleetInventory> navyFleetInventoryList = [];

  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";
  String lang = "en";

  String mapShapeSource = "";
  String shapeDataField = "";
  MapShapeLayerController mapShapeLayerController = MapShapeLayerController();

  List<NavcomStatus> navcomStatusList = [];

  Future<void> updateCharts() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate'];
    mapShapeSource = configJSON['map_shape_source'];
    shapeDataField = configJSON['shape_data_field'];

    String url = configJSON['navy_chart_get'] + "?lang=" + lang;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var retrievedData = json.decode(response.body)['data'];
      datetime = json.decode(response.body)['datetime'];
      totalSurface = retrievedData['total_combat'];
      numOpSurface = retrievedData['op_combat'];
      totalLanding = retrievedData['total_landing'];
      numOpLanding = retrievedData['op_landing'];
      totalSubmarines = retrievedData['total_sub'];
      numOpSubmarines = retrievedData['op_sub'];
      totalCDCM = retrievedData['total_cdcm'];
      numOpCDCM = retrievedData['op_cdcm'];
    }

    navcomStatusList = [];

    url = configJSON['navy_navcom_get'] + "?lang=" + lang;
    response = await http.get(url);
    if (response.statusCode == 200) {
      var retrievedData = json.decode(response.body)['data'].toList();
      datetime = json.decode(response.body)['datetime'];
      for (int i = 0; i < retrievedData.length; i++) {
        //populate airfieldStatus list with response data
        NavcomStatus newEntry = NavcomStatus.fromJson(retrievedData[i]);
        navcomStatusList.add(newEntry);
      }
    }
    updateMap();
    notifyListeners();
  }

  Future<void> pushNavcomStatus(String item, String field, String status, String apiKey, String user) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    if (configJSON['use_test_data'] == false) {
      String url = configJSON['navy_navcom_post'] + "?lang=" + lang;
      var response = await http.post(url,
          body: jsonEncode(<String, dynamic>{
            'item': item,
            'field': field,
            'status': status,
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
        updateCharts();
        updateMap();
      }
    }
  }

  void updateMap() {
    mapShapeLayerController.clearMarkers();
    for (int i = 0; i < navcomStatusList.length; i++) {
      mapShapeLayerController.insertMarker(i);
    }
    mapShapeLayerController.updateMarkers(List.generate(navcomStatusList.length, (i) => i));
    notifyListeners();
  }

  Future<void> updateVesselInventory() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    navyFleetList = [];
    vesselCategoryList = [];
    vesselClassList = [];
    navyFleetInventoryList = [];

    String url = configJSON['navy_vessel_get'] + "?lang=" + lang;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var retrievedData = json.decode(response.body)['data'].toList();
      datetime = json.decode(response.body)['datetime'];
      //make three lists containing unique values for fleet, category and class
      for (var item in retrievedData) {
        if (!navyFleetList.contains(item['fleet'])) {
          navyFleetList.add(item['fleet']);
        }
        if (!vesselCategoryList.contains(item['category'])) {
          vesselCategoryList.add(item['category']);
        }
        for (var vessel in item['items']) {
          if (!vesselClassList.contains(vessel['item'])) {
            vesselClassList.add(vessel['item']);
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
            for (var site in item['items']) {
              NavyVesselClassStatus navySubClassStatus = new NavyVesselClassStatus.fromJSON(site);
              navyVesselCategory.vesselClassStatusList.add(navySubClassStatus);
            }
            navyFleetInventory.navyVesselCategoryList.add(navyVesselCategory);
          }
        }
        navyFleetInventoryList.add(navyFleetInventory);
      }
    }
    notifyListeners();
  }

  Future<void> updateCDCMInventory() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    navyFleetList = [];
    vesselCategoryList = [];
    vesselClassList = [];
    navyFleetInventoryList = [];

    String url = configJSON['navy_cdcm_get'] + "?lang=" + lang;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var retrievedData = json.decode(response.body)['data'].toList();
      datetime = json.decode(response.body)['datetime'];
      //make three lists containing unique values for fleet, category and class
      for (var item in retrievedData) {
        if (!navyFleetList.contains(item['fleet'])) {
          navyFleetList.add(item['fleet']);
        }
        if (!vesselCategoryList.contains(item['category'])) {
          vesselCategoryList.add(item['category']);
        }
        for (var vessel in item['items']) {
          if (!vesselClassList.contains(vessel['item'])) {
            vesselClassList.add(vessel['item']);
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
            for (var site in item['items']) {
              NavyVesselClassStatus navySubClassStatus = new NavyVesselClassStatus.fromJSON(site);
              navyVesselCategory.vesselClassStatusList.add(navySubClassStatus);
            }
            navyFleetInventory.navyVesselCategoryList.add(navyVesselCategory);
          }
        }
        navyFleetInventoryList.add(navyFleetInventory);
      }
    }
    notifyListeners();
  }

  Future<void> updateSubInventory() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    navyFleetList = [];
    vesselCategoryList = [];
    vesselClassList = [];
    navyFleetInventoryList = [];

    String url = configJSON['navy_sub_get'] + "?lang=" + lang;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var retrievedData = json.decode(response.body)['data'].toList();
      datetime = json.decode(response.body)['datetime'];
      //make three lists containing unique values for fleet, category and class
      for (var item in retrievedData) {
        if (!navyFleetList.contains(item['fleet'])) {
          navyFleetList.add(item['fleet']);
        }
        if (!vesselCategoryList.contains(item['category'])) {
          vesselCategoryList.add(item['category']);
        }
        for (var vessel in item['items']) {
          if (!vesselClassList.contains(vessel['item'])) {
            vesselClassList.add(vessel['item']);
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
            for (var site in item['items']) {
              NavyVesselClassStatus navySubClassStatus = new NavyVesselClassStatus.fromJSON(site);
              navyVesselCategory.vesselClassStatusList.add(navySubClassStatus);
            }
            navyFleetInventory.navyVesselCategoryList.add(navyVesselCategory);
          }
        }
        navyFleetInventoryList.add(navyFleetInventory);
      }
    }
    notifyListeners();
  }

  Future<void> updateNavyInventory() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    navyFleetList = [];
    vesselCategoryList = [];
    vesselClassList = [];
    navyFleetInventoryList = [];

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
          for (var vessel in item['items']) {
            if (!vesselClassList.contains(vessel['item'])) {
              vesselClassList.add(vessel['item']);
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
              for (var vessel in item['items']) {
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

  Future<void> pushNavyInventory(
      String description, int action, int number, String item, String fleet, String category, String apiKey, String user) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    String url;
    if (description == "Submarine") {
      url = configJSON['navy_sub_post'] + "?lang=" + lang;
    } else if (description == "Vessel") {
      url = configJSON['navy_vessel_post'] + "?lang=" + lang;
    } else if (description == "CDCM") {
      url = configJSON['navy_cdcm_post'] + "?lang=" + lang;
    } else {
      url = "";
    }
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
      if (description == "Submarine") {
        updateSubInventory();
      } else if (description == "Vessel") {
        updateVesselInventory();
      } else if (description == "CDCM") {
        updateCDCMInventory();
      } else {
        url = "";
      }
    }
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
