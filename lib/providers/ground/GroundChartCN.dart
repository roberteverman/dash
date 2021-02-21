import 'dart:convert';

import 'package:dash/helpers/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class GroundChartCN extends ChangeNotifier {
  String displayParent = "ARMY COMMAND";
  GroundUnitStatus parentStatus;
  List<GroundUnitStatus> childrenStatus = [];

  List<Marker> markers = [];
  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";
  String mapServerURL;
  String lang = "en";
  List<String> visitedUnits = [];
  List<Widget> breadCrumbs = [];
  String wmsLayer = "";
  String mowURL = "";
  String mapShapeSource = "";
  String shapeDataField = "";
  MapShapeLayer mapShapeLayer;
  MapShapeLayerController mapShapeLayerController = MapShapeLayerController();

  Future<void> updateCharts(bool lightMode) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate'];
    mapServerURL = lightMode ? configJSON['map_light'] : configJSON['map_dark'];
    wmsLayer = configJSON['wms_layer'];
    mapShapeSource = configJSON['map_shape_source'];
    shapeDataField = configJSON['shape_data_field'];
    mowURL = configJSON['mow_url'];

    if (configJSON['use_test_data'] == true) {
      // USING TEST DATA
      print("No Test Data to Load");
    } else {
      //USING SERVER DATA

      String url = configJSON['ground_chart_get'] + "?lang=" + lang + "&unit=" + displayParent;
      var response = await http.get(url);
      if (response.statusCode == 200) {
        childrenStatus = [];
        breadCrumbs = [];
        var retrievedData = json.decode(response.body)['data'];
        datetime = json.decode(response.body)['datetime'];
        parentStatus = GroundUnitStatus.fromJson(retrievedData);
        for (var item in retrievedData['subordinate'].toList()) {
          childrenStatus.add(GroundUnitStatus.fromJson(item));
        }
        markers = List<Marker>.generate(
          childrenStatus.length,
          (index) => Marker(
            point: LatLng(childrenStatus[index].lat, childrenStatus[index].lon),
            // builder: (ctx) => Image.network(childrenStatus[index].symbol),
            builder: (ctx) => Tooltip(
              message: childrenStatus[index].name,
              child: Image.asset("images/SymbolServer.png"), //todo set up so that image from network works
            ),
          ),
        )..add(
            Marker(
              point: LatLng(parentStatus.lat, parentStatus.lon),
              builder: (ctx) => Container(
                child: Tooltip(
                  message: parentStatus.name,
                  child: Image.asset("images/SymbolServer.png"),
                ),
              ),
            ),
          );
        breadCrumbs.add(
          IconButton(
            icon: Icon(
              Icons.home,
              color: lightMode ? Colors.black : Colors.white,
            ),
            onPressed: () {
              displayParent = "ARMY COMMAND";
              visitedUnits = [];
              updateCharts(lightMode);
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        );
        for (int i = 0; i < visitedUnits.length; i++) {
          breadCrumbs.add(
            Text(
              "/",
              style: TextStyle(
                color: lightMode ? Colors.black : Colors.white,
              ),
            ),
          );
          breadCrumbs.add(
            TextButton(
              style: ButtonStyle(padding: null),
              child: Text(
                visitedUnits[i],
                style: TextStyle(
                  color: lightMode ? Colors.black : Colors.white,
                ),
              ),
              onPressed: () {
                displayParent = visitedUnits[i];
                for (int j = 0; j < visitedUnits.length; j++) {
                  if (j > i) {
                    visitedUnits.removeAt(j);
                  }
                }
                mapShapeLayerController.notifyListeners();
                updateCharts(lightMode);
              },
            ),
          );
        }
      } else {
        visitedUnits.removeAt(visitedUnits.length - 1);
        displayParent = visitedUnits[visitedUnits.length - 1];
        Fluttertoast.showToast(
          msg: "No Subordinate Units",
          webBgColor: "#dc2a2a",
          timeInSecForIosWeb: 3,
          webPosition: "right",
        );
      }
    }
    mapShapeLayer = MapShapeLayer(
      controller: mapShapeLayerController,
      zoomPanBehavior: MapZoomPanBehavior(
        toolbarSettings: MapToolbarSettings(
          position: MapToolbarPosition.bottomRight,
          direction: Axis.vertical,
        ),
      ),
      // showDataLabels: true,
      source: MapShapeSource.network(
        mapShapeSource,
        shapeDataField: shapeDataField,
        // shapeDataField: "ADM1_EN",
      ),
      initialMarkersCount: childrenStatus.length + 1,
      markerTooltipBuilder: (BuildContext context, int i) {
        if (i == childrenStatus.length) {
          return Text(
            parentStatus.name + "\nStrength: " + parentStatus.strength.toString() + "%",
            style: TextStyle(
              color: Colors.black,
            ),
          );
        } else {
          return Text(
            childrenStatus[i].name + "\nStrength: " + childrenStatus[i].strength.toString() + "%",
            style: TextStyle(
              color: Colors.black,
            ),
          );
        }
      },
      markerBuilder: (BuildContext context, int i) {
        if (i == childrenStatus.length) {
          return MapMarker(
            latitude: parentStatus.lat,
            longitude: parentStatus.lon,
            child: Image.asset("images/SymbolServer.png"), //todo set up so that image from network works
          );
        } else {
          return MapMarker(
            latitude: childrenStatus[i].lat,
            longitude: childrenStatus[i].lon,
            child: Image.asset("images/SymbolServer.png"), //todo set up so that image from network works
          );
        }
      },
    );

    mapShapeLayerController.clearMarkers();
    for (int i = 0; i < childrenStatus.length + 1; i++) {
      mapShapeLayerController.insertMarker(i);
    }
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void clearMarkers() {
    markers = [];
    notifyListeners();
  }
}
