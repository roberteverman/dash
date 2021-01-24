import 'dart:async';
import 'package:dash/components/air/AircraftDivisionCard.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AircraftStatusCN.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class AircraftSubtab extends StatefulWidget {
  @override
  _AircraftSubtabState createState() => _AircraftSubtabState();
}

class _AircraftSubtabState extends State<AircraftSubtab> {
  List<int> airDivisionList = [];
  List<Widget> airDivisionCards = [];
  Future<bool> tabDataLoaded;
  Timer timer;
  ScrollController scrollController = new ScrollController();

  Future<bool> loadTabData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<AircraftStatusCN>(context, listen: false).updateAirfieldInventory();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<AircraftStatusCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //must add this and the above to update the time
    airDivisionList = Provider.of<AircraftStatusCN>(context, listen: false).airDivisionList;
    airDivisionCards = List.generate(
      airDivisionList.length,
      (index) => AircraftDivisionCard(airDivision: airDivisionList[index]),
    );
    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    return true;
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: Provider.of<AircraftStatusCN>(context, listen: false).refreshRate), (timer) {
      loadTabData();
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
                  child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                    crossAxisCount: crossAxisCount,
                    itemCount: airDivisionCards.length,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) => airDivisionCards[index],
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                  ),
                );
        }
      },
    );
  }
}
