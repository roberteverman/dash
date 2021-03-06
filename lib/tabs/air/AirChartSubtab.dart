import 'dart:async';

import 'package:dash/charts/air/AirDualChart.dart';
import 'package:dash/charts/air/AircraftAirDivisionRadialChart.dart';
import 'package:dash/charts/air/AircraftTypeBarChart.dart';
import 'package:dash/charts/air/AircraftTypeRadarChart.dart';
import 'package:dash/charts/air/AirfieldStatusDoughnutChart.dart';
import 'package:dash/charts/air/AircraftStrengthGauge.dart';
import 'package:dash/components/ChartCard.dart';
import 'package:dash/components/navy/NavyFleetCommandCard.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class AirChartSubtab extends StatefulWidget {
  @override
  _AirChartSubtabState createState() => _AirChartSubtabState();
}

class _AirChartSubtabState extends State<AirChartSubtab> {
  List<String> navyFleetList = [];
  List<Widget> navyFleetCards = [];
  //////
  List<Widget> airCharts;
  double winWidth;
  double leftSideTabWidth;
  double parentWidth;
  int numCardsPerRow = 4; //number of charts in one row
  double padding = 10; //if update, also update in AirChartCN
  bool vertical = false;
  double mapHeight;
  double chartCardDims;
  double dividerX = 690;
  List<Widget> _tiles = [];

  Future<bool> tabDataLoaded;
  Timer timer;

  ScrollController scrollController = new ScrollController();

  Future<bool> loadTabData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<AirChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //must add this and the above to update the time
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<AirChartCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    /////
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<NavyVesselCN>(context, listen: false).updateNavyInventory();
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //must add this and the above to update the time
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<NavyVesselCN>(context, listen: false).datetime;
    navyFleetList = Provider.of<NavyVesselCN>(context, listen: false).navyFleetList;
    navyFleetCards = List.generate(
      navyFleetList.length,
      (index) => NavyFleetCommandCard(navyFleet: navyFleetList[index]),
    );
    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners

    return true;
  }

  Future<bool> refreshTabData() async {
    await Provider.of<AirChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
    Provider.of<AirChartCN>(context, listen: false).updateMap();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<AirChartCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    //////
    await Provider.of<NavyVesselCN>(context, listen: false).updateNavyInventory();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<NavyVesselCN>(context, listen: false).datetime;
    navyFleetList = Provider.of<NavyVesselCN>(context, listen: false).navyFleetList;
    navyFleetCards = List.generate(
      navyFleetList.length,
      (index) => NavyFleetCommandCard(navyFleet: navyFleetList[index]),
    );

    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners

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
    winWidth = MediaQuery.of(context).size.width;
    vertical = winWidth < 1000 ? true : false;
    leftSideTabWidth = winWidth < 700 ? 0 : 130;
    parentWidth = winWidth - (leftSideTabWidth + 30);
    numCardsPerRow = vertical ? 2 : 4;
    chartCardDims = vertical
        ? (((parentWidth * (1 * 2)) / numCardsPerRow - (padding * 2)) / 2 - 30)
        : (((parentWidth * ((1 - 0) * 2)) / numCardsPerRow - (padding * 2)) / 2 - 20);

    return FutureBuilder<bool>(
      future: tabDataLoaded,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data != true) {
          return LoadingBouncingLine.circle(backgroundColor: Theme.of(context).indicatorColor);
        } else {
          void _onReorder(int oldIndex, int newIndex) {
            setState(() {
              Widget row = _tiles.removeAt(oldIndex);
              _tiles.insert(newIndex, row);
            });
          }

          _tiles = <Widget>[
            AircraftStrengthGauge(
              chartCardDims: chartCardDims,
              padding: padding,
            ),
            AirfieldStatusDoughnutChart(
              chartCardDims: chartCardDims,
              padding: padding,
            ),
            AircraftTypeBarChart(
              chartCardDims: chartCardDims,
              padding: padding,
            ),
            AircraftTypeRadarChart(
              chartCardDims: chartCardDims,
              padding: padding,
            ),
            AircraftAirDivisionRadialChart(
              chartCardDims: chartCardDims,
              padding: padding,
            ),
          ];

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
                      return Container(
                        padding: EdgeInsets.only(left: 35, right: 35, top: 25),
                        child: vertical
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [_tiles[0], _tiles[1]],
                                      ),
                                      _tiles[2],
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _tiles[3],
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [_tiles[4], _tiles[5]],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [_tiles[0], _tiles[1]],
                                      ),
                                      _tiles[2],
                                    ],
                                  ),
                                  _tiles[3],
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [_tiles[4], _tiles[5]],
                                  )
                                ],
                              ),
                      );
                    },
                  ),
                );
        }
      },
    );
  }
}
