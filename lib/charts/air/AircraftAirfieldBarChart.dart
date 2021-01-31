import 'package:dash/components/ChartCard.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AircraftAirfieldBarChart extends StatefulWidget {
  AircraftAirfieldBarChart({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  _AircraftAirfieldBarChartState createState() => _AircraftAirfieldBarChartState();
}

class _AircraftAirfieldBarChartState extends State<AircraftAirfieldBarChart> {
  Color bottomColor = Colors.white; //Color(0xffffffff)
  Color topColor = Colors.grey; //Color(0xff303030)
  List<BarChartGroupData> barChartData = [];
  List<List<String>> totalToolTips = [];

  @override
  Widget build(BuildContext context) {
    var barsAndTooltips = barGroups(
      airfieldInventory: Provider.of<AirChartCN>(context, listen: true).airfieldInventory,
      bottomColor: bottomColor,
      topColor: topColor,
      width: ((widget.chartCardDims - 10) * 1.5) / Provider.of<AirChartCN>(context, listen: true).airfieldInventory.length,
    );
    barChartData = barsAndTooltips['barChartData'];
    totalToolTips = barsAndTooltips['totalToolTips'];

    return ChartCard(
      height: widget.chartCardDims,
      width: widget.chartCardDims * 2 + widget.padding * 2,
      padding: widget.padding,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Aircraft by Airfield",
              style: TextStyle(
                fontSize: widget.chartCardDims / 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Flexible(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: false,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (_) => TextStyle(color: Colors.white, fontSize: widget.chartCardDims / 18),
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 1:
                            return "1 AD";
                          case 2:
                            return "2 AD";
                          case 3:
                            return "3 AD";
                          case 4:
                            return "4 AD";
                          default:
                            return "";
                        }
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: barChartData,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideVertically: false,
                      fitInsideHorizontally: false,
                      tooltipBgColor: Colors.white.withOpacity(0.75),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String toolTip = totalToolTips[groupIndex][rodIndex];
                        return BarTooltipItem(
                          toolTip,
                          TextStyle(color: Colors.black),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Map<dynamic, dynamic> barGroups({List<AirfieldInventory> airfieldInventory, Color bottomColor, Color topColor, double width}) {
  //Divide up into air division
  List<AirfieldInventory> firstADInventory = airfieldInventory.where((afld) => afld.airdiv == 1).toList();
  List<AirfieldInventory> secondADInventory = airfieldInventory.where((afld) => afld.airdiv == 2).toList();
  List<AirfieldInventory> thirdADInventory = airfieldInventory.where((afld) => afld.airdiv == 3).toList();
  List<AirfieldInventory> fourthADInventory = airfieldInventory.where((afld) => afld.airdiv == 4).toList();

  List<BarChartRodData> firstADBars = [];
  List<BarChartRodData> secondADBars = [];
  List<BarChartRodData> thirdADBars = [];
  List<BarChartRodData> fourthADBars = [];
  List<List<String>> totalToolTips = [];
  List<String> toolTips = [];
  String toolTip = "";

  toolTips = [];
  for (int i = 0; i < firstADInventory.length; i++) {
    //get each airfield
    toolTip = "";
    String airfieldName = firstADInventory[i].name;
    toolTip += airfieldName + ":\n";

    double totalAircraft = 0;
    double totalOperational = 0;
    for (int j = 0; j < firstADInventory[i].aircraft.length; j++) {
      //get each aircraft
      totalAircraft += firstADInventory[i].aircraft[j]['total'];
      totalOperational += firstADInventory[i].aircraft[j]['operational'];
      toolTip += firstADInventory[i].aircraft[j]['type'] + ": " + totalOperational.toString() + " / " + totalAircraft.toString() + "\n";
    }
    toolTips.add(toolTip);
    firstADBars.add(BarChartRodData(
      width: width,
      y: totalAircraft,
      rodStackItems: <BarChartRodStackItem>[
        BarChartRodStackItem(0, totalOperational, bottomColor),
        BarChartRodStackItem(totalOperational, totalAircraft, topColor),
      ],
    ));
  }
  totalToolTips.add(toolTips);

  toolTips = [];
  for (int i = 0; i < secondADInventory.length; i++) {
    //get each airfield
    toolTip = "";
    String airfieldName = secondADInventory[i].name;
    toolTip += airfieldName + ":\n";
    double totalAircraft = 0;
    double totalOperational = 0;
    for (int j = 0; j < secondADInventory[i].aircraft.length; j++) {
      //get each aircraft
      totalAircraft += secondADInventory[i].aircraft[j]['total'];
      totalOperational += secondADInventory[i].aircraft[j]['operational'];
      toolTip += secondADInventory[i].aircraft[j]['type'] + ": " + totalOperational.toString() + " / " + totalAircraft.toString() + "\n";
    }
    toolTips.add(toolTip);
    secondADBars.add(BarChartRodData(
      width: width,
      y: totalAircraft,
      rodStackItems: <BarChartRodStackItem>[
        BarChartRodStackItem(0, totalOperational, bottomColor),
        BarChartRodStackItem(totalOperational, totalAircraft, topColor),
      ],
    ));
  }
  totalToolTips.add(toolTips);

  toolTips = [];
  for (int i = 0; i < thirdADInventory.length; i++) {
    //get each airfield
    toolTip = "";
    String airfieldName = thirdADInventory[i].name;
    toolTip += airfieldName + ":\n";

    double totalAircraft = 0;
    double totalOperational = 0;
    for (int j = 0; j < thirdADInventory[i].aircraft.length; j++) {
      //get each aircraft
      totalAircraft += thirdADInventory[i].aircraft[j]['total'];
      totalOperational += thirdADInventory[i].aircraft[j]['operational'];
      toolTip += thirdADInventory[i].aircraft[j]['type'] + ": " + totalOperational.toString() + " / " + totalAircraft.toString() + "\n";
    }
    toolTips.add(toolTip);
    thirdADBars.add(BarChartRodData(
      width: width,
      y: totalAircraft,
      rodStackItems: <BarChartRodStackItem>[
        BarChartRodStackItem(0, totalOperational, bottomColor),
        BarChartRodStackItem(totalOperational, totalAircraft, topColor),
      ],
    ));
  }
  totalToolTips.add(toolTips);

  toolTips = [];
  for (int i = 0; i < fourthADInventory.length; i++) {
    //get each airfield
    toolTip = "";
    String airfieldName = fourthADInventory[i].name;
    toolTip += airfieldName + ":\n";
    double totalAircraft = 0;
    double totalOperational = 0;
    for (int j = 0; j < fourthADInventory[i].aircraft.length; j++) {
      //get each aircraft
      totalAircraft += fourthADInventory[i].aircraft[j]['total'];
      totalOperational += fourthADInventory[i].aircraft[j]['operational'];
      toolTip += fourthADInventory[i].aircraft[j]['type'] + ": " + totalOperational.toString() + " / " + totalAircraft.toString() + "\n";
    }
    toolTips.add(toolTip);
    fourthADBars.add(BarChartRodData(
      width: width,
      y: totalAircraft,
      rodStackItems: <BarChartRodStackItem>[
        BarChartRodStackItem(0, totalOperational, bottomColor),
        BarChartRodStackItem(totalOperational, totalAircraft, topColor),
      ],
    ));
  }
  totalToolTips.add(toolTips);

  // Provider.of<AirChartCN>(context, listen: false).barToolTips = totalToolTips;

  var result = new Map();
  result['totalToolTips'] = totalToolTips;
  result['barChartData'] = <BarChartGroupData>[
    BarChartGroupData(x: 1, barRods: firstADBars),
    BarChartGroupData(x: 2, barRods: secondADBars),
    BarChartGroupData(x: 3, barRods: thirdADBars),
    BarChartGroupData(x: 4, barRods: fourthADBars)
  ];

  // {'barChartData': <BarChartGroupData>[
  // BarChartGroupData(x: 1, barRods: firstADBars),
  // BarChartGroupData(x: 2, barRods: secondADBars),
  // BarChartGroupData(x: 3, barRods: thirdADBars),
  // BarChartGroupData(x: 4, barRods: fourthADBars)
  // ],'tooltip': totalToolTips}
  return result;
}
