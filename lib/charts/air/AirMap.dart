import 'package:circular_menu/circular_menu.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class AirMap extends StatefulWidget {
  @override
  _AirMapState createState() => _AirMapState();
}

class _AirMapState extends State<AirMap> {
  MapController mapController;
  List<Marker> markers;
  int selectedIndex;
  bool keySelected = false;
  double keyX = 15;
  double keyY = 15;
  bool showComponents = false;

  @override
  void initState() {
    // TODO: implement initState
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
                urlTemplate: Provider.of<AirChartCN>(context, listen: true).mapServerURL,
                // wmsOptions: WMSTileLayerOptions(
                //   // baseUrl: 'https://maps.gvs.nga.mil:443/arcgis/services/CanvasMaps/Midnight/MapServer/WmsServer?',
                //   // layers: ['0'],
                //   baseUrl: Provider.of<AirChartCN>(context, listen: true).wmsServerURL,
                //   layers: [Provider.of<AirChartCN>(context, listen: true).wmsLayer],
                // ),
              ),
              MarkerLayerOptions(
                markers: Provider.of<AirChartCN>(context, listen: true).markers,
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: keySelected ? 1 : 0.5,
                child: ChoiceChip(
                  label: Tooltip(
                    message: "Key",
                    child: Container(
                      width: 40,
                      child: Icon(
                        FontAwesomeIcons.key,
                        size: 15,
                        color: keySelected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  selected: keySelected,
                  selectedColor: Colors.grey[400],
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        keyX = 15;
                        keyY = 15;
                        keySelected = true;
                      } else {
                        keySelected = false;
                      }
                    });
                  },
                  labelPadding: EdgeInsets.all(0),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Opacity(
                opacity: selectedIndex == 0 ? 1 : 0.5,
                child: ChoiceChip(
                  label: Tooltip(
                    message: "Aircraft Strength",
                    child: Container(
                      width: 40,
                      child: Icon(
                        FontAwesomeIcons.plane,
                        size: 15,
                        color: selectedIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  selected: selectedIndex == 0,
                  selectedColor: Colors.grey[400],
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedIndex = 0;
                        Provider.of<AirChartCN>(context, listen: false).clearMarkers();
                        Provider.of<AirChartCN>(context, listen: false).getAircraftStrengthMarkers();
                        showComponents = false;
                      } else {
                        selectedIndex = null;
                        Provider.of<AirChartCN>(context, listen: false).clearMarkers();
                      }
                    });
                  },
                  labelPadding: EdgeInsets.all(0),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Opacity(
                    opacity: selectedIndex == 1 ? 1 : 0.5,
                    child: ChoiceChip(
                      label: Tooltip(
                        message: "Airfield Status",
                        child: Container(
                          width: 40,
                          child: Icon(
                            FontAwesomeIcons.road,
                            size: 15,
                            color: selectedIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      selected: selectedIndex == 1,
                      selectedColor: Colors.grey[400],
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedIndex = 1;
                            Provider.of<AirChartCN>(context, listen: false).clearMarkers();
                            Provider.of<AirChartCN>(context, listen: false).getAirfieldMarkers();
                          } else {
                            selectedIndex = null;
                            Provider.of<AirChartCN>(context, listen: false).clearMarkers();
                          }
                        });
                      },
                      labelPadding: EdgeInsets.all(0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: selectedIndex == 1,
                    child: Opacity(
                      opacity: showComponents ? 1 : 0.5,
                      child: ChoiceChip(
                        label: Tooltip(
                          message: "Critical Components",
                          child: Container(
                            width: 40,
                            child: Icon(
                              FontAwesomeIcons.sitemap,
                              size: 15,
                              color: showComponents ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        selected: showComponents,
                        selectedColor: Colors.grey[400],
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              showComponents = true;
                              Provider.of<AirChartCN>(context, listen: false).clearMarkers();
                              Provider.of<AirChartCN>(context, listen: false).getExtendedAirfieldMarkers();
                            } else {
                              showComponents = false;
                              Provider.of<AirChartCN>(context, listen: false).clearMarkers();
                              Provider.of<AirChartCN>(context, listen: false).getAirfieldMarkers();
                            }
                          });
                        },
                        labelPadding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                ],
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
        Visibility(
          visible: keySelected,
          child: Positioned(
            top: keyY,
            left: keyX,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  keyX += details.delta.dx;
                  keyY += details.delta.dy;
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.move,
                child: Opacity(
                  opacity: 0.75,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 125,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 15,
                        top: 5,
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Key",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "OP",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "LIMOP",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "NONOP",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: selectedIndex == 0 || showComponents ? 15 : 5),
                          Visibility(
                            visible: showComponents,
                            child: Column(
                              children: [
                                Divider(),
                                SizedBox(height: 5),
                                keyStatus(text: "Runway", iconText: "R/W"),
                                SizedBox(height: 5),
                                keyStatus(text: "Taxiway", iconText: "T/W"),
                                SizedBox(height: 5),
                                keyStatus(text: "Underground\nFacility", iconText: "UGF"),
                                SizedBox(height: 5),
                                keyStatus(text: "Petroleum", iconText: "POL"),
                                SizedBox(height: 5),
                                keyStatus(text: "Munition\nStorage", iconText: "MS"),
                                SizedBox(height: 5),
                                keyStatus(text: "Repair\nFacility", iconText: "R/W"),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: selectedIndex == 0,
                            child: Column(
                              children: [
                                Divider(),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "TOTAL %\nAIRCRAFT",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
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
