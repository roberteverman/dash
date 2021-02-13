import 'dart:async';

import 'package:dash/charts/air/AirDualChart.dart';
import 'package:dash/charts/ground/GroundMap.dart';
import 'package:dash/charts/air/AircraftAirDivisionRadialChart.dart';
import 'package:dash/charts/air/AircraftAirfieldBarChart.dart';
import 'package:dash/charts/air/AircraftTypeBarChart.dart';
import 'package:dash/charts/air/AircraftTypeRadarChart.dart';
import 'package:dash/charts/air/AirfieldStatusDoughnutChart.dart';
import 'package:dash/charts/air/AircraftStrengthGauge.dart';
import 'package:dash/charts/ground/GroundSubCommandHealthChart.dart';
import 'package:dash/components/ChartCard.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class GroundChartSubtab extends StatefulWidget {
  @override
  _GroundChartSubtabState createState() => _GroundChartSubtabState();
}

class _GroundChartSubtabState extends State<GroundChartSubtab> {
  List<Widget> airCharts;
  double winWidth;
  double leftSideTabWidth;
  double parentWidth;
  int numCardsPerRow = 2; //number of charts in one row
  double mapFactor = .65; //percentage of the window the map should take up
  double padding = 10; //if update, also update in AirChartCN
  bool vertical = false;
  double mapHeight;
  double chartCardDims;
  double dividerX = 690;

  Future<bool> tabDataLoaded;
  Timer timer;

  ScrollController scrollController = new ScrollController();

  Future<bool> loadTabData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<GroundChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //must add this and the above to update the time
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<GroundChartCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    return true;
  }

  Future<bool> refreshTabData() async {
    await Provider.of<GroundChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<GroundChartCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
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
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    winWidth = MediaQuery.of(context).size.width;
    vertical = winWidth < 1000 ? true : false;
    leftSideTabWidth = winWidth < 700 ? 0 : 130;
    parentWidth = winWidth - (leftSideTabWidth + 30);
    chartCardDims = vertical
        ? (((parentWidth * (1 * 2)) / numCardsPerRow - (padding * 2)) / 2 - 30)
        : (((parentWidth * ((1 - mapFactor) * 2)) / numCardsPerRow - (padding * 2)) / 2 - 30);
    mapHeight = winWidth < 700
        ? MediaQuery.of(context).size.height - (winWidth < 700 ? 0 : 60) - 120
        : MediaQuery.of(context).size.height - (winWidth < 700 ? 0 : 60) - 60;
    // mapFactor = (winWidth - 650) / winWidth;

    return FutureBuilder<bool>(
      future: tabDataLoaded,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data != true) {
          return LoadingBouncingLine.circle(backgroundColor: Theme.of(context).indicatorColor);
        } else {
          return Provider.of<ThemeChanger>(context, listen: true).isLoading
              ? LoadingBouncingLine.circle(backgroundColor: Theme.of(context).indicatorColor)
              : DraggableScrollbar.semicircle(
                  controller: scrollController,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  heightScrollThumb: 30,
                  alwaysVisibleScrollThumb: true,
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                              child: Wrap(
                                children: [
                                  Container(
                                    //map container
                                    height: mapHeight - 5,
                                    width: vertical ? parentWidth : parentWidth * (mapFactor),
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(30)),
                                      padding: EdgeInsets.all(20),
                                      child: GroundMap(),
                                    ),
                                  ),
                                  Container(
                                    //charts container
                                    width: vertical ? parentWidth : parentWidth * (1 - mapFactor),
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                    child: Container(
                                      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(30)),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: Provider.of<GroundChartCN>(context, listen: true).breadCrumbs,
                                            // [
                                            //   Text(
                                            //     "Home / ARMY COMMAND / BLAH",
                                            //     style: TextStyle(
                                            //       fontSize: 10,
                                            //     ),
                                            //     textAlign: TextAlign.left,
                                            //   ),
                                            // ],
                                          ),
                                          Text(
                                            Provider.of<GroundChartCN>(context, listen: true).parentStatus.name,
                                            style: TextStyle(
                                              fontSize: chartCardDims / 9,
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
                                            lineHeight: 25,
                                            percent: Provider.of<GroundChartCN>(context, listen: true).parentStatus.strength / 100,
                                            padding: EdgeInsets.symmetric(horizontal: 25),
                                            center: Text(Provider.of<GroundChartCN>(context, listen: true).parentStatus.strength.toString() + "%"),
                                          ),
                                          SizedBox(height: chartCardDims / 10),
                                          Wrap(
                                            children: List<GroundSubCommandHealthChart>.generate(
                                              Provider.of<GroundChartCN>(context, listen: true).childrenStatus.length,
                                              (index) => GroundSubCommandHealthChart(
                                                chartCardDims: chartCardDims,
                                                padding: padding,
                                                percent: Provider.of<GroundChartCN>(context, listen: true).childrenStatus[index].strength / 100,
                                                unit: Provider.of<GroundChartCN>(context, listen: true).childrenStatus[index].name,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            vertical
                                ? Container()
                                : Positioned(
                                    left: parentWidth * mapFactor + 14,
                                    top: mapHeight / 2 - 50,
                                    child: SizedBox(
                                      height: 100,
                                      width: 2,
                                      child: GestureDetector(
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.resizeLeftRight,
                                          child: Container(
                                            color: Colors.white.withOpacity(0.1),
                                          ),
                                        ),
                                        onPanUpdate: (details) {
                                          if (mapFactor + (details.delta.dx / parentWidth) < 0.75 &&
                                              mapFactor + (details.delta.dx / parentWidth) > 0.25) {
                                            setState(() {
                                              mapFactor += (details.delta.dx / parentWidth);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  )
                          ],
                        );
                      }),
                );
        }
      },
    );
  }
}
