import 'dart:convert';

import 'package:circular_menu/circular_menu.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/helpers/test_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

class AirChartCN extends ChangeNotifier {
  List<AirfieldStatus> airfieldStatus = [];
  List<AirfieldInventory> airfieldInventory = [];
  List<String> airfieldList = [];
  List<int> airDivisionList = [];
  List<Marker> markers = [];
  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";
  String wmsServerURL;
  String wmsLayer;
  int numOpAfld = 0;
  int numLimopAfld = 0;
  int numNonopAfld = 0;
  int numOpAircraft = 0;
  int totalAircraft = 0;

  Future<void> updateCharts(bool lightMode) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate'];
    wmsServerURL = configJSON['wms_server'];
    wmsLayer = lightMode ? configJSON['wms_layer_light'] : configJSON['wms_layer_dark'];

    airfieldStatus = [];
    airfieldInventory = [];
    airfieldList = [];
    airDivisionList = [];

    if (configJSON['use_test_data'] == true) {
      // USING TEST DATA
      datetime = testAirfieldData['datetime'];
      for (int i = 0; i < testAirfieldData['airfield_data'].length; i++) {
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
      String url = configJSON['air_chart_get'];
      var response = await http.get(url); //grab data from server
      if (response.statusCode == 200) {
        var retrievedData = json.decode(response.body)['airfield_data'].toList();
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
        retrievedData = json.decode(response.body)['aircraft_data'].toList();
        for (int i = 0; i < retrievedData.length; i++) {
          //populate airfieldInventory list with response data
          AirfieldInventory newEntry = AirfieldInventory.fromJson(retrievedData[i]);
          airfieldInventory.add(newEntry);
        }
      }
    }
    numOpAfld = airfieldStatus.where((afld) => afld.status == "OP").length;
    numLimopAfld = airfieldStatus.where((afld) => afld.status == "LIMOP").length;
    numNonopAfld = airfieldStatus.where((afld) => afld.status == "NONOP").length;
    //count total and operational number of aircraft
    totalAircraft = 0;
    numOpAircraft = 0;
    for (int i = 0; i < airfieldInventory.length; i++) {
      for (int j = 0; j < airfieldInventory[i].aircraft.length; j++) {
        totalAircraft += airfieldInventory[i].aircraft[j]['total'];
        numOpAircraft += airfieldInventory[i].aircraft[j]['operational'];
      }
    }
    notifyListeners();
  }

  void getExtendedAirfieldMarkers() {
    markers = List<Marker>.generate(
      airfieldStatus.length,
      (index) => extendedAirfieldStatusMarker(
        lat: airfieldStatus[index].lat,
        lon: airfieldStatus[index].lon,
        tooltip: airfieldStatus[index].name,
        afldStatus: airfieldStatus[index].status,
        rw: airfieldStatus[index].rw,
        tw: airfieldStatus[index].tw,
        ugf: airfieldStatus[index].ugf,
        pol: airfieldStatus[index].pol,
        ms: airfieldStatus[index].ms,
        rf: airfieldStatus[index].rf,
      ),
    );
    notifyListeners();
  }

  void getAirfieldMarkers() {
    markers = List<Marker>.generate(
      airfieldStatus.length,
      (index) => airfieldStatusMarker(
        lat: airfieldStatus[index].lat,
        lon: airfieldStatus[index].lon,
        tooltip: airfieldStatus[index].name,
        afldStatus: airfieldStatus[index].status,
      ),
    );
  }

  void getAircraftStrengthMarkers() {
    markers = [];
    double factor = 800;
    for (int i = 0; i < airfieldInventory.length; i++) {
      int total = 0;
      String toolTip = airfieldInventory[i].name + " (" + airfieldInventory[i].status + "):\n";
      for (int j = 0; j < airfieldInventory[i].aircraft.length; j++) {
        total += airfieldInventory[i].aircraft[j]['operational'];
        toolTip += airfieldInventory[i].aircraft[j]['type'] +
            " : " +
            airfieldInventory[i].aircraft[j]['operational'].toString() +
            " / " +
            airfieldInventory[i].aircraft[j]['total'].toString() +
            "\n";
      }
      toolTip += "\n Total Aircraft: " + total.toString();
      markers.add(
        aircraftStatusMarker(
          lat: airfieldInventory[i].lat,
          lon: airfieldInventory[i].lon,
          tooltip: toolTip,
          afldStatus: airfieldInventory[i].status,
          size: (total / numOpAircraft) * factor,
          // size: factor,
        ),
      );
    }
  }

  void clearMarkers() {
    markers = [];
    notifyListeners();
  }
}

Marker aircraftStatusMarker({
  double lat,
  double lon,
  String tooltip,
  String afldStatus,
  double size,
}) {
  Color getBGColor(String status) {
    switch (status) {
      case "OP":
        {
          return Colors.green;
        }
        break;

      case "NONOP":
        {
          return Colors.red;
        }
        break;

      case "LIMOP":
        {
          return Colors.yellow;
        }
        break;

      default:
        {
          return Colors.black;
        }
        break;
    }
  }

  return Marker(
    width: size,
    height: size,
    point: LatLng(lat, lon),
    builder: (ctx) => Tooltip(
      textStyle: TextStyle(
        fontSize: 13,
        color: Colors.black,
      ),
      message: tooltip,
      waitDuration: Duration(milliseconds: 600),
      verticalOffset: 25,
      child: Container(
        decoration: BoxDecoration(
          color: getBGColor(afldStatus),
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

Marker airfieldStatusMarker({
  double lat,
  double lon,
  String tooltip,
  String afldStatus,
}) {
  Color getBGColor(String status) {
    switch (status) {
      case "OP":
        {
          return Colors.green;
        }
        break;

      case "NONOP":
        {
          return Colors.red;
        }
        break;

      case "LIMOP":
        {
          return Colors.yellow;
        }
        break;

      default:
        {
          return Colors.black;
        }
        break;
    }
  }

  return Marker(
    width: 25.0,
    height: 25.0,
    point: LatLng(lat, lon),
    builder: (ctx) => Tooltip(
      message: tooltip,
      waitDuration: Duration(milliseconds: 600),
      verticalOffset: 25,
      child: Container(
        decoration: BoxDecoration(
          color: getBGColor(afldStatus),
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

Marker extendedAirfieldStatusMarker({
  double lat,
  double lon,
  String tooltip,
  String afldStatus,
  String rw,
  String tw,
  String ugf,
  String pol,
  String ms,
  String rf,
}) {
  Color getBGColor(String status) {
    switch (status) {
      case "OP":
        {
          return Colors.green;
        }
        break;

      case "NONOP":
        {
          return Colors.red;
        }
        break;

      case "LIMOP":
        {
          return Colors.yellow;
        }
        break;

      default:
        {
          return Colors.black;
        }
        break;
    }
  }

  Color getTxtColor(String status) {
    switch (status) {
      case "OP":
        {
          return Colors.white;
        }
        break;

      case "NONOP":
        {
          return Colors.white;
        }
        break;

      case "LIMOP":
        {
          return Colors.black;
        }
        break;

      default:
        {
          return Colors.white;
        }
        break;
    }
  }

  return Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(lat, lon),
    builder: (ctx) => Tooltip(
      message: tooltip,
      waitDuration: Duration(milliseconds: 600),
      verticalOffset: 35,
      child: CircularMenu(
        toggleButtonAnimatedIconData: AnimatedIcons.menu_close,
        toggleButtonSize: 15,
        toggleButtonPadding: 5,
        toggleButtonColor: getBGColor(afldStatus),
        toggleButtonIconColor: getTxtColor(afldStatus),
        radius: 35,
        startingAngleInRadian: 0,
        endingAngleInRadian: 5.2,
        items: [
          CircularMenuItem(
              icon: Icons.circle,
              iconSize: 8,
              badgeLabel: "R/W",
              badgeColor: getBGColor(rw),
              badgeTextStyle: TextStyle(fontSize: 5, color: getTxtColor(rw)),
              badgeBottomOffet: 10,
              badgeLeftOffet: 10,
              badgeRightOffet: 10,
              badgeTopOffet: 10,
              color: Colors.transparent,
              iconColor: Colors.transparent,
              badgeRadius: 8,
              enableBadge: true,
              onTap: () {}),
          CircularMenuItem(
              icon: Icons.circle,
              iconSize: 8,
              badgeLabel: "T/W",
              badgeColor: getBGColor(tw),
              badgeTextStyle: TextStyle(fontSize: 5, color: getTxtColor(tw)),
              badgeBottomOffet: 10,
              badgeLeftOffet: 10,
              badgeRightOffet: 10,
              badgeTopOffet: 10,
              color: Colors.transparent,
              iconColor: Colors.transparent,
              badgeRadius: 8,
              enableBadge: true,
              onTap: () {}),
          CircularMenuItem(
              icon: Icons.circle,
              iconSize: 8,
              badgeLabel: "UGF",
              badgeColor: getBGColor(ugf),
              badgeTextStyle: TextStyle(fontSize: 5, color: getTxtColor(ugf)),
              badgeBottomOffet: 10,
              badgeLeftOffet: 10,
              badgeRightOffet: 10,
              badgeTopOffet: 10,
              color: Colors.transparent,
              iconColor: Colors.transparent,
              badgeRadius: 8,
              enableBadge: true,
              onTap: () {}),
          CircularMenuItem(
              icon: Icons.circle,
              iconSize: 8,
              badgeLabel: "POL",
              badgeColor: getBGColor(pol),
              badgeTextStyle: TextStyle(fontSize: 5, color: getTxtColor(pol)),
              badgeBottomOffet: 10,
              badgeLeftOffet: 10,
              badgeRightOffet: 10,
              badgeTopOffet: 10,
              color: Colors.transparent,
              iconColor: Colors.transparent,
              badgeRadius: 8,
              enableBadge: true,
              onTap: () {}),
          CircularMenuItem(
              icon: Icons.circle,
              iconSize: 8,
              badgeLabel: "MS",
              badgeColor: getBGColor(ms),
              badgeTextStyle: TextStyle(fontSize: 5, color: getTxtColor(ms)),
              badgeBottomOffet: 10,
              badgeLeftOffet: 10,
              badgeRightOffet: 10,
              badgeTopOffet: 10,
              color: Colors.transparent,
              iconColor: Colors.transparent,
              badgeRadius: 8,
              enableBadge: true,
              onTap: () {}),
          CircularMenuItem(
              icon: Icons.circle,
              iconSize: 8,
              badgeLabel: "RF",
              badgeColor: getBGColor(rf),
              badgeTextStyle: TextStyle(fontSize: 5, color: getTxtColor(rf)),
              badgeBottomOffet: 10,
              badgeLeftOffet: 10,
              badgeRightOffet: 10,
              badgeTopOffet: 10,
              color: Colors.transparent,
              iconColor: Colors.transparent,
              badgeRadius: 8,
              enableBadge: true,
              onTap: () {}),
        ],
      ),
    ),
  );
}
