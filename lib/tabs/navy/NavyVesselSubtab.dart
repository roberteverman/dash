import 'dart:async';
import 'package:dash/components/navy/NavyFleetCommandCard.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class NavyVesselSubtab extends StatefulWidget {
  @override
  _NavyVesselSubtabState createState() => _NavyVesselSubtabState();
}

class _NavyVesselSubtabState extends State<NavyVesselSubtab> {
  Future<bool> tabDataLoaded;
  Timer timer;
  ScrollController scrollController = new ScrollController();
  List<String> navyFleetList = [];
  List<Widget> navyFleetCards = [];

  Future<bool> loadTabData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<NavyVesselCN>(context, listen: false).updateVesselInventory();
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //this gives error sometimes
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<NavyVesselCN>(context, listen: false).datetime;
    navyFleetList = Provider.of<NavyVesselCN>(context, listen: false).navyFleetList;
    navyFleetCards = List.generate(
      navyFleetList.length,
      (index) => NavyFleetCommandCard(
        navyFleet: navyFleetList[index],
        description: "Vessel",
      ),
    );
    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //this gives error sometimes
    return true;
  }

  Future<bool> refreshTabData() async {
    await Provider.of<NavyVesselCN>(context, listen: false).updateVesselInventory();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<NavyVesselCN>(context, listen: false).datetime;
    navyFleetList = Provider.of<NavyVesselCN>(context, listen: false).navyFleetList;
    navyFleetCards = List.generate(
      navyFleetList.length,
      (index) => NavyFleetCommandCard(
        navyFleet: navyFleetList[index],
        description: "Vessel",
      ),
    );
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
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
    timer.cancel();
    print("timer properly disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount;

    if (MediaQuery.of(context).size.width < 825) {
      crossAxisCount = 1;
    } else if (MediaQuery.of(context).size.width < 1050) {
      crossAxisCount = 1;
    } else if (MediaQuery.of(context).size.width < 1400) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }

    return FutureBuilder(
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
                  child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                    crossAxisCount: crossAxisCount,
                    itemCount: navyFleetCards.length,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) => navyFleetCards[index],
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    addAutomaticKeepAlives: false, //this is a MUST or else timers will stack on top of timers
                  ),
                );
        }
      },
    );
  }
}
