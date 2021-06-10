import 'dart:async';

import 'package:dash/charts/ground/GroundSubCommandHealthChart.dart';
import 'package:dash/charts/ground/GroundSubCommandHealthChart2.dart';
import 'package:dash/components/ChartCard.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class GroundChartSubtab2 extends StatefulWidget {
  @override
  _GroundChartSubtab2State createState() => _GroundChartSubtab2State();
}

class _GroundChartSubtab2State extends State<GroundChartSubtab2> {
  Future<bool> tabDataLoaded;
  Timer timer;
  MapShapeLayer mapShapeLayer;
  double winWidth;
  double leftSideTabWidth;
  double parentWidth;
  int numCardsPerRow = 2; //number of charts in one row
  double padding = 15; //if update, also update in AirChartCN
  double chartCardDims;
  ScrollController scrollController = new ScrollController();

  Future<bool> loadTabData() async {
    await Provider.of<GroundChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    mapShapeLayer = MapShapeLayer(
      controller: Provider.of<GroundChartCN>(context, listen: false).mapShapeLayerController,
      zoomPanBehavior: MapZoomPanBehavior(
        enablePinching: false,
        toolbarSettings: MapToolbarSettings(
          position: MapToolbarPosition.bottomRight,
          direction: Axis.vertical,
        ),
      ),
      // showDataLabels: true,
      // source: MapShapeSource.network(
      //   Provider.of<GroundChartCN>(context, listen: false).mapShapeSource,
      //   shapeDataField: Provider.of<GroundChartCN>(context, listen: false).shapeDataField,
      //   // shapeDataField: "ADM1_EN",
      // ),
      source: MapShapeSource.asset('korea_penninsula.json', shapeDataField: "ADMIN"),
      initialMarkersCount: Provider.of<GroundChartCN>(context, listen: false).childrenStatus.length + 1,
      markerTooltipBuilder: (BuildContext context, int i) {
        if (i == Provider.of<GroundChartCN>(context, listen: false).childrenStatus.length) {
          return Text(
            Provider.of<GroundChartCN>(context, listen: false).parentStatus.name +
                "\nStrength: " +
                Provider.of<GroundChartCN>(context, listen: false).parentStatus.strength.toString() +
                "%",
            style: TextStyle(
              color: Colors.black,
            ),
          );
        } else {
          return Text(
            Provider.of<GroundChartCN>(context, listen: false).childrenStatus[i].name +
                "\nStrength: " +
                Provider.of<GroundChartCN>(context, listen: false).childrenStatus[i].strength.toString() +
                "%",
            style: TextStyle(
              color: Colors.black,
            ),
          );
        }
      },
      markerBuilder: (BuildContext context, int i) {
        if (i == Provider.of<GroundChartCN>(context, listen: false).childrenStatus.length) {
          return MapMarker(
            latitude: Provider.of<GroundChartCN>(context, listen: false).parentStatus.lat,
            longitude: Provider.of<GroundChartCN>(context, listen: false).parentStatus.lon,
            child: Provider.of<GroundChartCN>(context, listen: false).useSymbolURL
                ? Image.network(Provider.of<GroundChartCN>(context, listen: false).childrenStatus[i].symbol)
                : Image.asset("images/SymbolServer.png"),
          );
        } else {
          return MapMarker(
            latitude: Provider.of<GroundChartCN>(context, listen: false).childrenStatus[i].lat,
            longitude: Provider.of<GroundChartCN>(context, listen: false).childrenStatus[i].lon,
            child: Provider.of<GroundChartCN>(context, listen: false).useSymbolURL
                ? Image.network(Provider.of<GroundChartCN>(context, listen: false).childrenStatus[i].symbol)
                : Image.asset("images/SymbolServer.png"),
          );
        }
      },
    );
    return true;
  }

  Future<bool> refreshTabData() async {
    await Provider.of<GroundChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<GroundChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<GroundChartCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    Provider.of<GroundChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    return true;
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: Provider.of<GroundChartCN>(context, listen: false).refreshRate), (timer) {
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
    chartCardDims = (((parentWidth * ((1 - .6) * 2)) / numCardsPerRow - (padding * 2)) / 2 - 20);

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
                      flex: 6,
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
                      flex: 4,
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
                                          // padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorDark),
                                          child: Container(
                                            //charts container
                                            // padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                            child: Container(
                                              decoration:
                                                  BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(30)),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: Provider.of<GroundChartCN>(context, listen: true).breadCrumbs,
                                                  ),
                                                  Text(
                                                    Provider.of<GroundChartCN>(context, listen: true).parentStatus.name,
                                                    style: TextStyle(
                                                      fontSize: chartCardDims / 8,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: chartCardDims / 10),
                                                  LinearPercentIndicator(
                                                    progressColor: Provider.of<GroundChartCN>(context, listen: true).parentStatus.strength > 89
                                                        ? Colors.green
                                                        : (Provider.of<GroundChartCN>(context, listen: true).parentStatus.strength > 74
                                                            ? Colors.amber
                                                            : (Provider.of<GroundChartCN>(context, listen: true).parentStatus.strength > 49
                                                                ? Colors.red
                                                                : Colors.black)),
                                                    lineHeight: chartCardDims / 6,
                                                    percent: Provider.of<GroundChartCN>(context, listen: true).parentStatus.strength / 100,
                                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                                    center: Text(
                                                      Provider.of<GroundChartCN>(context, listen: true).parentStatus.strength.toString() + "%",
                                                      style: TextStyle(
                                                        fontSize: chartCardDims / 8,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: chartCardDims / 10),
                                                  Padding(
                                                    padding: EdgeInsets.all(padding),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(30)),
                                                      child: Column(
                                                        children: List<Widget>.generate(
                                                          Provider.of<GroundChartCN>(context, listen: true).childrenStatus.length,
                                                          (index) {
                                                            Color progressColor;
                                                            double percent =
                                                                Provider.of<GroundChartCN>(context, listen: true).childrenStatus[index].strength /
                                                                    100;
                                                            String unit =
                                                                Provider.of<GroundChartCN>(context, listen: true).childrenStatus[index].name;

                                                            if (percent >= .90) {
                                                              progressColor = Colors.green;
                                                            } else if (percent >= .74) {
                                                              progressColor = Colors.amber;
                                                            } else if (percent >= .50) {
                                                              progressColor = Colors.red;
                                                            } else {
                                                              progressColor = Colors.black;
                                                            }

                                                            return MouseRegion(
                                                              cursor: SystemMouseCursors.click,
                                                              child: GestureDetector(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      unit,
                                                                      style: TextStyle(
                                                                        fontSize: chartCardDims / 10,
                                                                        color: Theme.of(context).accentColor,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    LinearPercentIndicator(
                                                                      progressColor: progressColor,
                                                                      lineHeight: chartCardDims / 8,
                                                                      percent: Provider.of<GroundChartCN>(context, listen: true)
                                                                              .childrenStatus[index]
                                                                              .strength /
                                                                          100,
                                                                      padding: EdgeInsets.symmetric(horizontal: chartCardDims / 4),
                                                                      center: Text(
                                                                        (Provider.of<GroundChartCN>(context, listen: true)
                                                                                    .childrenStatus[index]
                                                                                    .strength)
                                                                                .toStringAsFixed(0) +
                                                                            "%",
                                                                        style: TextStyle(
                                                                          fontSize: chartCardDims / 10,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: chartCardDims / 8,
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  Provider.of<GroundChartCN>(context, listen: false).visitedUnits.add(unit);
                                                                  Provider.of<GroundChartCN>(context, listen: false).displayParent = unit;
                                                                  Provider.of<GroundChartCN>(context, listen: false).updateMap();
                                                                  Provider.of<GroundChartCN>(context, listen: false)
                                                                      .updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          // (index) => GroundSubCommandHealthChart2(
                                                          //   chartCardDims: chartCardDims,
                                                          //   padding: padding,
                                                          //   percent:
                                                          //       Provider.of<GroundChartCN>(context, listen: true).childrenStatus[index].strength / 100,
                                                          //   unit: Provider.of<GroundChartCN>(context, listen: true).childrenStatus[index].name,
                                                          // ),
                                                        )..insert(
                                                            0,
                                                            SizedBox(
                                                              height: chartCardDims / 8,
                                                            ),
                                                          ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
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
