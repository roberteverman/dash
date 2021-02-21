import 'package:circular_menu/circular_menu.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class AirMap2 extends StatefulWidget {
  @override
  _AirMap2State createState() => _AirMap2State();
}

class _AirMap2State extends State<AirMap2> {
  MapController mapController;
  List<Marker> markers;
  int selectedIndex;
  bool keySelected = false;
  double keyX = 15;
  double keyY = 15;
  bool showComponents = false;

  @override
  void initState() {
    super.initState();
    mapController = new MapController();
  }

  @override
  Widget build(BuildContext context) {
    List<AirfieldInventory> airfieldInventoryList = Provider.of<AirChartCN>(context, listen: false).airfieldInventory;

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Theme.of(context).primaryColorDark),
      clipBehavior: Clip.hardEdge,
      child: SfMaps(
        layers: [
          // MapTileLayer(
          //   urlTemplate: Provider.of<AirChartCN>(context, listen: true).mapServerURL,
          // )
          MapShapeLayer(
            zoomPanBehavior: MapZoomPanBehavior(
              toolbarSettings: MapToolbarSettings(
                position: MapToolbarPosition.bottomRight,
                direction: Axis.vertical,
              ),
            ),
            // showDataLabels: true,
            source: MapShapeSource.network(
              Provider.of<AirChartCN>(context, listen: false).mapShapeSource,
              shapeDataField: Provider.of<AirChartCN>(context, listen: false).shapeDataField,
              // shapeDataField: "ADM1_EN",
            ),
            initialMarkersCount: airfieldInventoryList.length,
            markerTooltipBuilder: (BuildContext context, int i) {
              return Text(
                airfieldInventoryList[i].name + "\nStatus: " + airfieldInventoryList[i].status,
                style: TextStyle(
                  color: Colors.black,
                ),
              );
            },
            markerBuilder: (BuildContext context, int i) {
              Color markerColor;
              if (airfieldInventoryList[i].status == "OP") {
                markerColor = Colors.green;
              } else if (airfieldInventoryList[i].status == "NONOP") {
                markerColor = Colors.red;
              } else if (airfieldInventoryList[i].status == "LIMOP") {
                markerColor = Colors.amber;
              }

              return MapMarker(
                latitude: airfieldInventoryList[i].lat,
                longitude: airfieldInventoryList[i].lon,
                iconColor: markerColor,
                // child: Icon(
                //   Icons.airplanemode_on,
                //   color: markerColor,
                // ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget keyStatus({
  String text,
  String iconText,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: 10,
        ),
        textAlign: TextAlign.left,
      ),
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            iconText,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ],
  );
}

Marker airfieldStatusMarker({
  double lat,
  double lon,
  String tooltip,
  Color status,
}) {
  return Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(lat, lon),
    builder: (ctx) => Tooltip(
      message: tooltip,
      waitDuration: Duration(milliseconds: 600),
      verticalOffset: 35,
      child: CircularMenu(
        toggleButtonSize: 15,
        toggleButtonPadding: 5,
        toggleButtonColor: status,
        radius: 35,
        startingAngleInRadian: 0,
        endingAngleInRadian: 5.2,
        items: [
          CircularMenuItem(
              icon: Icons.local_gas_station,
              iconSize: 8,
              badgeLabel: "R/W",
              badgeColor: Colors.green,
              badgeTextStyle: TextStyle(fontSize: 5, color: Colors.white),
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
              icon: Icons.local_gas_station,
              iconSize: 8,
              badgeLabel: "T/W",
              badgeColor: Colors.red,
              badgeTextStyle: TextStyle(fontSize: 5, color: Colors.white),
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
              icon: Icons.local_gas_station,
              iconSize: 8,
              badgeLabel: "UGF",
              badgeColor: Colors.yellow,
              badgeTextStyle: TextStyle(fontSize: 5, color: Colors.black),
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
              icon: Icons.local_gas_station,
              iconSize: 8,
              badgeLabel: "POL",
              badgeColor: Colors.red,
              badgeTextStyle: TextStyle(fontSize: 5, color: Colors.white),
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
              icon: Icons.local_gas_station,
              iconSize: 8,
              badgeLabel: "MS",
              badgeColor: Colors.yellow,
              badgeTextStyle: TextStyle(fontSize: 5, color: Colors.black),
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
              icon: Icons.local_gas_station,
              iconSize: 8,
              badgeLabel: "RF",
              badgeColor: Colors.green,
              badgeTextStyle: TextStyle(fontSize: 5, color: Colors.white),
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
