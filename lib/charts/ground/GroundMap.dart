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
                // tileSize: 512,
                // wmsOptions: WMSTileLayerOptions(
                //   // layers: ['0'],
                //   baseUrl: Provider.of<GroundChartCN>(context, listen: true).mapServerURL,
                //   layers: [Provider.of<GroundChartCN>(context, listen: true).wmsLayer],
                //   crs: Epsg4326(),
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
