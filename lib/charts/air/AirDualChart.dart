import 'package:dash/components/ChartCard.dart';
import 'package:flutter/material.dart';

class AirDualChart extends StatelessWidget {
  AirDualChart({this.chartOne, this.chartTwo});
  final chartOne;
  final chartTwo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        chartOne,
        chartTwo,
      ],
    );
  }
}
