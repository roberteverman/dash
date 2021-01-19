import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class AirfieldSubtab extends StatefulWidget {
  @override
  _AirfieldSubtabState createState() => _AirfieldSubtabState();
}

class _AirfieldSubtabState extends State<AirfieldSubtab> with AutomaticKeepAliveClientMixin {
  List<int> airDivisionList = [];
  List<Widget> airDivisionCards = [];

  @override
  void initState() {
    if (Provider.of<AirFieldStatusCN>(context, listen: false).airfieldStatus.length == 0) {
      loadData();
    }
    super.initState();
  }

  void loadData() async {
    Provider.of<ThemeChanger>(context, listen: false).setLoading(true);
    await Provider.of<AirFieldStatusCN>(context, listen: false).updateAirfieldStatus();
    airDivisionList = Provider.of<AirFieldStatusCN>(context, listen: false).airDivisionList;
    airDivisionCards = List.generate(
      airDivisionList.length,
      (index) => AirDivisionCard(airDivision: airDivisionList[index]),
    );
    setState(() {
      Provider.of<ThemeChanger>(context, listen: false).setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Provider.of<AirFieldStatusCN>(context, listen: true).loading == true
        ? LoadingBouncingLine.circle(backgroundColor: Theme.of(context).indicatorColor)
        : Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: airDivisionCards.length,
              itemBuilder: (BuildContext context, int index) => airDivisionCards[index],
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
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
            title: Column(
              children: [
                Text(
                  airfieldStatus.name + " Airfield",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Status:  ',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      airfieldStatus.status,
                      style: TextStyle(fontSize: 13, color: airfieldStatusColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
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
            child: Text(
              text,
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
