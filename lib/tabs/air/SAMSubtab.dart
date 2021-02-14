import 'dart:async';
import 'package:dash/components/air/SAMTypeCard.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/SAMStatusCN.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class SAMSubtab extends StatefulWidget {
  @override
  _SAMSubtabState createState() => _SAMSubtabState();
}

class _SAMSubtabState extends State<SAMSubtab> {
  List<int> airDivisionList = [];
  List<Widget> airDivisionCards = [];

  List<String> samTypeList = [];
  List<Widget> samTypeCards = [];

  Future<bool> tabDataLoaded;
  Timer timer;
  ScrollController scrollController = new ScrollController();

  Future<bool> loadTabData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<SAMStatusCN>(context, listen: false).updateSAMStatus();
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //must add this and the above to update the time
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<SAMStatusCN>(context, listen: false).datetime;
    // airDivisionList = Provider.of<SAMStatusCN>(context, listen: false).airDivisionList;
    // airDivisionCards = List.generate(
    //   airDivisionList.length,
    //   (index) => SAMTypeCard(airDivision: airDivisionList[index]),
    // );

    samTypeList = Provider.of<SAMStatusCN>(context, listen: false).samTypeList;
    samTypeCards = List.generate(
      samTypeList.length,
      (index) => SAMTypeCard(samType: samTypeList[index]),
    );

    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    return true;
  }

  Future<bool> refreshTabData() async {
    await Provider.of<SAMStatusCN>(context, listen: false).updateSAMStatus();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<SAMStatusCN>(context, listen: false).datetime;
    // airDivisionList = Provider.of<SAMStatusCN>(context, listen: false).airDivisionList;
    // airDivisionCards = List.generate(
    //   airDivisionList.length,
    //   (index) => SAMTypeCard(airDivision: airDivisionList[index]),
    // );

    samTypeList = Provider.of<SAMStatusCN>(context, listen: false).samTypeList;
    samTypeCards = List.generate(
      samTypeList.length,
      (index) => SAMTypeCard(samType: samTypeList[index]),
    );

    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    return true;
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: Provider.of<SAMStatusCN>(context, listen: false).refreshRate), (timer) {
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
                    crossAxisCount: MediaQuery.of(context).size.width < 800 ? 1 : 2,
                    itemCount: samTypeCards.length,
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) => samTypeCards[index],
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
