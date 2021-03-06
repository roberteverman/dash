import 'dart:async';

import 'package:dash/charts/navy/NavyCDCMGauge.dart';
import 'package:dash/charts/navy/NavyLandingGauge.dart';
import 'package:dash/charts/navy/NavySubmarineGauge.dart';
import 'package:dash/charts/navy/NavySurfaceGauge.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class NavyChartSubtab extends StatefulWidget {
  @override
  _NavyChartSubtabState createState() => _NavyChartSubtabState();
}

class _NavyChartSubtabState extends State<NavyChartSubtab> {
  Future<bool> tabDataLoaded;
  Timer timer;
  MapShapeLayer mapShapeLayer;
  double winWidth;
  double leftSideTabWidth;
  double parentWidth;
  int numCardsPerRow = 4; //number of charts in one row
  double padding = 15; //if update, also update in AirChartCN
  double chartCardDims;
  ScrollController scrollController = new ScrollController();

  Future<bool> loadTabData() async {
    await Provider.of<NavyVesselCN>(context, listen: false).updateCharts();
    mapShapeLayer = MapShapeLayer(
      controller: Provider.of<NavyVesselCN>(context, listen: false).mapShapeLayerController,
      zoomPanBehavior: MapZoomPanBehavior(
        toolbarSettings: MapToolbarSettings(
          position: MapToolbarPosition.bottomRight,
          direction: Axis.vertical,
        ),
      ),
      source: MapShapeSource.network(
        Provider.of<NavyVesselCN>(context, listen: false).mapShapeSource,
        shapeDataField: Provider.of<NavyVesselCN>(context, listen: false).shapeDataField,
      ),
      initialMarkersCount: Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList.length,
      markerTooltipBuilder: (BuildContext context, int i) {
        return Text(
          Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].navcom +
              "\nStatus: " +
              Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].status,
          style: TextStyle(
            color: Colors.black,
          ),
        );
      },
      markerBuilder: (BuildContext context, int i) {
        Color markerColor;
        if (Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].status == "OP") {
          markerColor = Colors.green;
        } else if (Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].status == "NONOP") {
          markerColor = Colors.red;
        } else if (Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].status == "LIMOP") {
          markerColor = Colors.amber;
        }

        return MapMarker(
          latitude: Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].lat,
          longitude: Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].lon,
          iconColor: markerColor,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: markerColor),
              ),
              onTap: !Provider.of<ThemeChanger>(context, listen: false).navyAdmin
                  ? () {}
                  : () async {
                      return await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Center(
                            child: Text(
                              "Change overall status of \n" + Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].navcom,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: Text("OP"),
                                  color: Colors.green,
                                  onPressed: !Provider.of<ThemeChanger>(context, listen: false).navyAdmin
                                      ? null
                                      : () async {
                                          await Provider.of<NavyVesselCN>(context, listen: false).pushNavcomStatus(
                                            Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].be,
                                            "status",
                                            "OP",
                                            Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                            Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                          );
                                          Navigator.pop(context);
                                        },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    "LIMOP",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  color: Colors.yellow,
                                  onPressed: !Provider.of<ThemeChanger>(context, listen: false).navyAdmin
                                      ? null
                                      : () async {
                                          await Provider.of<NavyVesselCN>(context, listen: false).pushNavcomStatus(
                                            Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].be,
                                            "status",
                                            "LIMOP",
                                            Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                            Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                          );
                                          Navigator.pop(context);
                                        },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: Text("NONOP"),
                                  color: Colors.red,
                                  onPressed: !Provider.of<ThemeChanger>(context, listen: false).navyAdmin
                                      ? null
                                      : () async {
                                          await Provider.of<NavyVesselCN>(context, listen: false).pushNavcomStatus(
                                            Provider.of<NavyVesselCN>(context, listen: false).navcomStatusList[i].be,
                                            "status",
                                            "NONOP",
                                            Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                            Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                          );
                                          Navigator.pop(context);
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
            ),
          ),
        );
      },
    );
    return true;
  }

  Future<bool> refreshTabData() async {
    await Provider.of<NavyVesselCN>(context, listen: false).updateCharts();
    Provider.of<NavyVesselCN>(context, listen: false).updateCharts();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<NavyVesselCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    Provider.of<NavyVesselCN>(context, listen: false).updateCharts();
    return true;
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: Provider.of<NavyVesselCN>(context, listen: false).refreshRate), (timer) {
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
    ThemeData theme = Theme.of(context);

    winWidth = MediaQuery.of(context).size.width;
    leftSideTabWidth = winWidth < 700 ? 0 : 130;
    parentWidth = winWidth - (leftSideTabWidth + 30);
    chartCardDims = (((parentWidth * ((1 - 0) * 2)) / numCardsPerRow - (padding * 2)) / 2 - 20);

    return FutureBuilder<bool>(
      future: tabDataLoaded,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data != true) {
          return LoadingBouncingLine.circle(backgroundColor: theme.indicatorColor);
        } else {
          return Provider.of<ThemeChanger>(context, listen: true).isLoading
              ? LoadingBouncingLine.circle(backgroundColor: theme.indicatorColor)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30, right: 30 / 2, top: 30, bottom: 30),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorDark),
                                padding: EdgeInsets.all(20),
                                child: SfMaps(
                                  layers: [
                                    mapShapeLayer,
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: DraggableScrollbar.semicircle(
                                controller: scrollController,
                                backgroundColor: theme.primaryColorLight,
                                heightScrollThumb: 30,
                                alwaysVisibleScrollThumb: true,
                                child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(left: 25 / 2, right: 25, top: 25, bottom: 25),
                                        child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorDark),
                                            child: Wrap(
                                              spacing: 15,
                                              runSpacing: 15,
                                              children: [
                                                Container(
                                                  width: chartCardDims,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorLight),
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: NavySubmarineGauge(
                                                      chartCardDims: chartCardDims,
                                                      padding: padding,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: chartCardDims,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorLight),
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: NavySurfaceGauge(
                                                      chartCardDims: chartCardDims,
                                                      padding: padding,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: chartCardDims,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorLight),
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: NavyLandingGauge(
                                                      chartCardDims: chartCardDims,
                                                      padding: padding,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: chartCardDims,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorLight),
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: NavyCDCMGauge(
                                                      chartCardDims: chartCardDims,
                                                      padding: padding,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    })),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        }
      },
    );
  }
}
