import 'dart:async';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class TBMMapSubtab extends StatefulWidget {
  @override
  _TBMMapSubtabState createState() => _TBMMapSubtabState();
}

class _TBMMapSubtabState extends State<TBMMapSubtab> with WidgetsBindingObserver {
  Future<bool> tabDataLoaded;
  Timer timer;
  MapShapeLayer mapShapeLayer;
  List<AirfieldInventory> airfieldInventory = [];

  Future<bool> loadTabData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<AirChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //must add this and the above to update the time
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<AirChartCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    mapShapeLayer = MapShapeLayer(
      controller: Provider.of<AirChartCN>(context, listen: false).mapShapeLayerController,
      zoomPanBehavior: MapZoomPanBehavior(
        toolbarSettings: MapToolbarSettings(
          position: MapToolbarPosition.bottomRight,
          direction: Axis.vertical,
        ),
      ),
      source: MapShapeSource.network(
        Provider.of<AirChartCN>(context, listen: false).mapShapeSource,
        shapeDataField: Provider.of<AirChartCN>(context, listen: false).shapeDataField,
      ),
      sublayers: [
        MapShapeSublayer(
          source: MapShapeSource.network(
            Provider.of<AirChartCN>(context, listen: false).bmoaShapeSource,
            shapeDataField: "bmoa",
          ),
        )
      ],
      initialMarkersCount: airfieldInventory.length,
      markerTooltipBuilder: (BuildContext context, int i) {
        return Text(
          airfieldInventory[i].name + "\nStatus: " + airfieldInventory[i].status,
          style: TextStyle(
            color: Colors.black,
          ),
        );
      },
      markerBuilder: (BuildContext context, int i) {
        Color markerColor;
        if (airfieldInventory[i].status == "OP") {
          markerColor = Colors.green;
        } else if (airfieldInventory[i].status == "NONOP") {
          markerColor = Colors.red;
        } else if (airfieldInventory[i].status == "LIMOP") {
          markerColor = Colors.amber;
        }

        return MapMarker(
          latitude: airfieldInventory[i].lat,
          longitude: airfieldInventory[i].lon,
          iconColor: markerColor,
        );
      },
    );
    return true;
  }

  Future<bool> refreshTabData() async {
    await Provider.of<AirChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<AirChartCN>(context, listen: false).updateMap();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<AirChartCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    Provider.of<AirChartCN>(context, listen: false).updateMap();
    return true;
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: Provider.of<AirChartCN>(context, listen: false).refreshRate), (timer) {
      refreshTabData();
    });
  }

  @override
  void initState() {
    tabDataLoaded = loadTabData();
    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("timer properly disposed");
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    airfieldInventory = Provider.of<AirChartCN>(context, listen: true).airfieldInventory;

    return FutureBuilder<bool>(
        future: tabDataLoaded,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data != true) {
            return LoadingBouncingLine.circle(backgroundColor: Theme.of(context).indicatorColor);
          } else {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Theme.of(context).primaryColorDark),
                clipBehavior: Clip.hardEdge,
                child: SfMaps(
                  layers: [
                    mapShapeLayer,
                  ],
                ),
              ),
            );
          }
        });
  }
}
