import 'dart:convert';

import 'package:dash/helpers/models.dart';
import 'package:dash/helpers/test_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AirFieldStatusCN extends ChangeNotifier {
  List<AirfieldStatus> airfieldStatus = [];
  List<String> airfieldList = [];
  List<int> airDivisionList = [];
  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";

  Future<void> updateAirfieldStatus() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    airfieldStatus = [];
    airfieldList = [];
    airDivisionList = [];

    if (configJSON['use_test_data'] == true) {
      // USING TEST DATA
      datetime = testAirfieldData['datetime'];
      for (int i = 0; i < testAirfieldData['data'].length; i++) {
        //populate airfieldStatus list with test data
        AirfieldStatus newEntry = AirfieldStatus.fromJson(testAirfieldData['data'][i]);
        airfieldStatus.add(newEntry);
      }
      for (AirfieldStatus airfield in airfieldStatus) {
        if (!airfieldList.contains(airfield.name)) {
          //create unique list of airfields
          airfieldList.add(airfield.name);
        }
        if (!airDivisionList.contains(airfield.airdiv)) {
          //create unique list of Air Divisions
          airDivisionList.add(airfield.airdiv);
        }
        airDivisionList.sort(); //alphabetize everything
        airfieldStatus.sort((a, b) => a.name.compareTo(b.name));
      }
    } else {
      //USING SERVER DATA
      String url = configJSON['airfield_get'];
      var response = await http.get(url); //grab data from server
      if (response.statusCode == 200) {
        var retrievedData = json.decode(response.body)['data'].toList();
        datetime = json.decode(response.body)['datetime'];
        for (int i = 0; i < retrievedData.length; i++) {
          //populate airfieldStatus list with response data
          AirfieldStatus newEntry = AirfieldStatus.fromJson(retrievedData[i]);
          airfieldStatus.add(newEntry);
        }
        for (AirfieldStatus airfield in airfieldStatus) {
          if (!airfieldList.contains(airfield.name)) {
            //create unique list of airfields
            airfieldList.add(airfield.name);
          }
          if (!airDivisionList.contains(airfield.airdiv)) {
            //create unique list of Air Divisions
            airDivisionList.add(airfield.airdiv);
          }
          airDivisionList.sort(); //alphabetize everything
          airfieldStatus.sort((a, b) => a.name.compareTo(b.name));
        }
      }
    }
    notifyListeners();
  }
}
