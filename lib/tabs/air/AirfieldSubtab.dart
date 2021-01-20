import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class AirfieldSubtab extends StatefulWidget {
  @override
  _AirfieldSubtabState createState() => _AirfieldSubtabState();
}

class _AirfieldSubtabState extends State<AirfieldSubtab> {
  List<int> airDivisionList = [];
  List<Widget> airDivisionCards = [];
  Future<bool> tabDataLoaded;
  Timer timer;

  Future<bool> loadTabData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<AirFieldStatusCN>(context, listen: false).updateAirfieldStatus();
    Provider.of<ThemeChanger>(context, listen: false).centralDateTime = Provider.of<AirFieldStatusCN>(context, listen: false).datetime;
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //must add this and the above to update the time
    airDivisionList = Provider.of<AirFieldStatusCN>(context, listen: false).airDivisionList;
    airDivisionCards = List.generate(
      airDivisionList.length,
      (index) => AirDivisionCard(airDivision: airDivisionList[index]),
    );
    Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    Provider.of<ThemeChanger>(context, listen: false).notifyListeners(); //don't forget to notify listeners
    return true;
  }

  void startTimer() {
    timer = new Timer.periodic(Duration(seconds: Provider.of<AirFieldStatusCN>(context, listen: false).refreshRate), (timer) {
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
    return FutureBuilder<bool>(
      future: tabDataLoaded,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data != true) {
          return LoadingBouncingLine.circle(backgroundColor: Theme.of(context).indicatorColor);
        } else {
          return Provider.of<ThemeChanger>(context, listen: true).isLoading
              ? LoadingBouncingLine.circle(backgroundColor: Theme.of(context).indicatorColor)
              : Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: MediaQuery.of(context).size.width < 700 ? 1 : 2,
                    itemCount: airDivisionCards.length,
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

class AirDivisionCard extends StatelessWidget {
  const AirDivisionCard({this.airDivision});
  final int airDivision;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String airDivisionString;

    List<AirfieldStatus> airfieldStatusList = Provider.of<AirFieldStatusCN>(context, listen: true).airfieldStatus;

    List<Widget> airfieldStatusCards = List.generate(
      airfieldStatusList.where((element) => element.airdiv == airDivision).toList().length,
      (index) => AirfieldStatusCard(
        airfieldStatus: airfieldStatusList.where((element) => element.airdiv == airDivision).toList()[index],
      ),
    );

    switch (airDivision % 10) {
      case 1:
        airDivisionString = airDivision.toString() + "st Air Division";
        break;
      case 2:
        airDivisionString = airDivision.toString() + "nd Air Division";
        break;
      case 3:
        airDivisionString = airDivision.toString() + "rd Air Division";
        break;
      default:
        airDivisionString = airDivision.toString() + "th Air Division";
        break;
    }

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorDark),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              airDivisionString,
              style: TextStyle(fontSize: 15),
            ),
            StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                crossAxisCount: 2,
                itemCount: airfieldStatusCards.length,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemBuilder: (_, index) => airfieldStatusCards[index],
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1)),
          ],
        ),
      ),
    );
  }
}

class AirfieldStatusCard extends StatelessWidget {
  const AirfieldStatusCard({this.airfieldStatus});
  final AirfieldStatus airfieldStatus;

  @override
  Widget build(BuildContext context) {
    Color airfieldStatusColor;
    switch (airfieldStatus.status) {
      case "OP":
        {
          airfieldStatusColor = Colors.green;
        }
        break;

      case "NONOP":
        {
          airfieldStatusColor = Colors.red;
        }
        break;

      case "LIMOP":
        {
          airfieldStatusColor = Colors.yellow;
        }
        break;

      default:
        {
          airfieldStatusColor = Colors.white;
        }
        break;
    }

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 0, bottom: 5.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: SizedBox(
              child: Center(
                child: AutoSizeText(
                  airfieldStatus.name + " Airfield",
                  maxLines: 2,
                  minFontSize: 10,
                  maxFontSize: 15,
                  wrapWords: true,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  stepGranularity: 0.1,
                  textAlign: TextAlign.center,
                  // style: TextStyle(
                  //   fontWeight: FontWeight.w600,
                  // ),
                ),
              ),
            ),
            subtitle: SizedBox(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: Theme.of(context).accentColor),
                    children: <TextSpan>[
                      TextSpan(text: "Status: "),
                      TextSpan(
                        text: airfieldStatus.status,
                        style: TextStyle(fontWeight: FontWeight.bold, color: airfieldStatusColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            children: <Widget>[
              Row(
                children: [
                  Spacer(),
                  Expanded(child: StatusChip(text: "R/W", tooltip: "Runway\nStatus: " + airfieldStatus.rw, status: airfieldStatus.rw)),
                  SizedBox(width: 10),
                  Expanded(child: StatusChip(text: "T/W", tooltip: "Taxiway\nStatus: " + airfieldStatus.tw, status: airfieldStatus.tw)),
                  SizedBox(width: 10),
                  Expanded(
                      child: StatusChip(text: "UGF", tooltip: "Underground Facility\nStatus: " + airfieldStatus.ugf, status: airfieldStatus.ugf)),
                  Spacer(),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Spacer(),
                  Expanded(child: StatusChip(text: "POL", tooltip: "Petroleum and Oil\nStatus: " + airfieldStatus.pol, status: airfieldStatus.pol)),
                  SizedBox(width: 10),
                  Expanded(child: StatusChip(text: "MS", tooltip: "Munition Storage\nStatus: " + airfieldStatus.ms, status: airfieldStatus.ms)),
                  SizedBox(width: 10),
                  Expanded(child: StatusChip(text: "RF", tooltip: "Repair Facility\nStatus: " + airfieldStatus.rf, status: airfieldStatus.rf)),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  StatusChip({this.tooltip, this.text, this.status});
  final String tooltip;
  final String text;
  final String status;

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color color;

    switch (status) {
      case "OP":
        {
          textColor = Colors.white;
          color = Colors.green;
        }
        break;

      case "NONOP":
        {
          textColor = Colors.white;
          color = Colors.red;
        }
        break;

      case "LIMOP":
        {
          textColor = Colors.black;
          color = Colors.yellow;
        }
        break;

      default:
        {
          textColor = Colors.black;
          color = Colors.white;
        }
        break;
    }

    return Tooltip(
      preferBelow: false,
      message: tooltip,
      waitDuration: Duration(milliseconds: 500),
      child: Chip(
        label: Container(
          width: 30,
          child: Center(
            child: AutoSizeText(
              text,
              minFontSize: 0,
              stepGranularity: 0.1,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ),
        backgroundColor: color,
      ),
    );
  }
}
