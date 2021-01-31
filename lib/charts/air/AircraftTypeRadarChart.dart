import 'package:dash/components/ChartCard.dart';
import 'package:flutter/material.dart';

class AircraftTypeRadarChart extends StatefulWidget {
  AircraftTypeRadarChart({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  _AircraftTypeRadarChartState createState() => _AircraftTypeRadarChartState();
}

class _AircraftTypeRadarChartState extends State<AircraftTypeRadarChart> {
  @override
  Widget build(BuildContext context) {
    const ticks = [10, 20, 30, 30, 40];
    var features = ["Fighter", "Bomber", "Transport", "Helo", "Other"];
    var data = [
      [10, 20, 28, 5, 16],
      [15, 1, 4, 14, 23],
    ];

    return ChartCard(
      height: widget.chartCardDims,
      width: widget.chartCardDims,
      padding: widget.padding,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Aircraft by Type",
              style: TextStyle(
                fontSize: widget.chartCardDims / 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            Flexible(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
