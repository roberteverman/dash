import 'dart:convert';

import 'package:dash/helpers/models.dart';
import 'package:dash/helpers/test_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AircraftStatusCN extends ChangeNotifier {
  List<AirfieldInventory> airfieldInventory = [];
  List<String> airfieldList = [];
  List<String> airfieldBEList = [];
  Map<String, String> airfieldBEMap = {};
  List<int> airDivisionList = [];
  List<String> aircraftList = [];
  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";
  String lang = "en";

  Future<void> updateAirfieldInventory() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    airfieldInventory = [];
    airfieldList = [];
    airDivisionList = [];
    aircraftList = [];

    if (configJSON['use_test_data'] == true) {
      // USING TEST DATA
      datetime = testAirfieldInventory['datetime'];
      for (int i = 0; i < testAirfieldInventory['data'].length; i++) {
        //populate airfieldInventory list with test data
        AirfieldInventory newEntry = AirfieldInventory.fromJson(testAirfieldInventory['data'][i]);
        airfieldInventory.add(newEntry);
      }
      for (AirfieldInventory airfield in airfieldInventory) {
        if (!airfieldList.contains(airfield.name)) {
          //create unique list of airfields
          airfieldList.add(airfield.name);
        }
        if (!airDivisionList.contains(airfield.airdiv)) {
          //create unique list of Air Divisions
          airDivisionList.add(airfield.airdiv);
        }
        airDivisionList.sort(); //alphabetize everything
        airfieldInventory.sort((a, b) => a.name.compareTo(b.name));
      }
    } else {
      //USING SERVER DATA
      String url = configJSON['aircraft_get'] + "?lang=" + lang;
      var response = await http.get(url); //grab data from server
      if (response.statusCode == 200) {
        var retrievedData = json.decode(response.body)['data'].toList();
        datetime = json.decode(response.body)['datetime'];
        for (int i = 0; i < retrievedData.length; i++) {
          //populate airfieldInventory list with response data
          AirfieldInventory newEntry = AirfieldInventory.fromJson(retrievedData[i]);
          airfieldInventory.add(newEntry);
          for (int j = 0; j < newEntry.aircraft.length; j++) {
            if (!aircraftList.contains(newEntry.aircraft[j]['type'])) {
              //Create unique list of aircraft types
              aircraftList.add(newEntry.aircraft[j]['type']);
            }
          }
          aircraftList.sort((a, b) => a.compareTo(b));
        }
        for (AirfieldInventory airfield in airfieldInventory) {
          //todo add more than initial of zero aircraft
          if (!airfieldList.contains(airfield.name)) {
            //create unique list of airfields
            airfieldList.add(airfield.name);
            airfieldBEList.add(airfield.be);
            airfieldBEMap[airfield.name] = airfield.be;
          }
          if (!airDivisionList.contains(airfield.airdiv)) {
            //create unique list of Air Divisions
            airDivisionList.add(airfield.airdiv);
          }
          airDivisionList.sort(); //alphabetize everything
          airfieldInventory.sort((a, b) => a.name.compareTo(b.name));
        }
      }
    }
    notifyListeners();
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
        updateAirfieldInventory();
      }
    }
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
