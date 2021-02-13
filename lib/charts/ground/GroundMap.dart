import 'package:circular_menu/circular_menu.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class GroundMap extends StatefulWidget {
  @override
  _GroundMapState createState() => _GroundMapState();
}

class _GroundMapState extends State<GroundMap> {
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Theme.of(context).primaryColorDark),
          clipBehavior: Clip.hardEdge,
          child: FlutterMap(
            mapController: mapController,
            key: Key(MediaQuery.of(context).size.toString()), //forces rebuild
            options: MapOptions(
              onTap: (coords) {
                print(coords.toString());
              },
              center: LatLng(39.9, 126.7),
              zoom: 7,
              // bounds: LatLngBounds(LatLng(37.5, 124.0), LatLng(43.0, 131.0)),
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: Provider.of<GroundChartCN>(context, listen: true).mapServerURL,
                // wmsOptions: WMSTileLayerOptions(
                //   // baseUrl: 'https://maps.gvs.nga.mil:443/arcgis/services/CanvasMaps/Midnight/MapServer/WmsServer?',
                //   // layers: ['0'],
                //   baseUrl: Provider.of<AirChartCN>(context, listen: true).wmsServerURL,
                //   layers: [Provider.of<AirChartCN>(context, listen: true).wmsLayer],
                // ),
              ),
              MarkerLayerOptions(
                markers: Provider.of<GroundChartCN>(context, listen: true).markers,
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          bottom: 15,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        mapController.move(mapController.center, mapController.zoom + 0.75);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        mapController.move(mapController.center, mapController.zoom - 0.75);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
