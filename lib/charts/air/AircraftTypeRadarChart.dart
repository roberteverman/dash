import 'dart:math';

import 'package:dash/components/ChartCard.dart';
import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';

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
    var features = ["Fighter", "Bomber", "Transport", "Other", "Helo"];

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
            SizedBox(height: 10),
            Flexible(
              // child: Container(),
              child: RadarChart(
                strokeColor: Colors.white,
                labelColor: Colors.white,
                fillColor: Colors.white,
                chartRadiusFactor: 0.85,
                textScaleFactor: 0.08,
                labelWidth: 100,
                animate: false,
                values: [75, 52, 66, 73, 92],
                labels: features,
                maxValue: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadarVertex extends StatelessWidget with PreferredSizeWidget {
  final double radius;
  final Widget text;
  final Offset textOffset;

  RadarVertex({
    this.radius,
    this.text,
    this.textOffset,
  });

  @override
  Size get preferredSize => Size.fromRadius(radius);

  @override
  Widget build(BuildContext context) {
    Widget tree = Transform.translate(
      offset: textOffset,
      child: Container(child: text),
    );
    return tree;
  }
}
