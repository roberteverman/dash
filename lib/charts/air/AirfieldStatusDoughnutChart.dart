import 'package:flutter/material.dart';
import 'package:dash/components/ChartCard.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AirfieldStatusDoughnutChart extends StatelessWidget {
  AirfieldStatusDoughnutChart({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = [
      ChartData(
        'OP',
        Provider.of<AirChartCN>(context, listen: true).numOpAfld.toDouble(),
        (Provider.of<AirChartCN>(context, listen: true).numOpAfld / Provider.of<AirChartCN>(context, listen: true).airfieldList.length * 100)
                .toStringAsFixed(1) +
            "%",
        Colors.green,
      ),
      ChartData(
        'LIMOP',
        Provider.of<AirChartCN>(context, listen: true).numLimopAfld.toDouble(),
        (Provider.of<AirChartCN>(context, listen: true).numLimopAfld / Provider.of<AirChartCN>(context, listen: true).airfieldList.length * 100)
                .toStringAsFixed(1) +
            "%",
        Colors.yellow,
      ),
      ChartData(
        'NONOP',
        Provider.of<AirChartCN>(context, listen: true).numNonopAfld.toDouble(),
        (Provider.of<AirChartCN>(context, listen: true).numNonopAfld / Provider.of<AirChartCN>(context, listen: true).airfieldList.length * 100)
                .toStringAsFixed(1) +
            "%",
        Colors.red,
      ),
    ];

    return ChartCard(
      width: chartCardDims,
      height: chartCardDims,
      padding: padding,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Airfield Status",
              style: TextStyle(
                fontSize: chartCardDims / 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            Expanded(
              child: SfCircularChart(
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    animationDuration: 0,
                    radius: "100%",
                    innerRadius: "45%",
                    explode: true,
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataLabelMapper: (ChartData data, _) => data.label,
                    enableSmartLabels: true,
                    dataLabelSettings: DataLabelSettings(
                      textStyle: TextStyle(fontSize: chartCardDims / 15),
                      showZeroValue: false,
                      isVisible: true,
                    ),
                  )
                ],
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                      height: chartCardDims / 18,
                      width: chartCardDims / 18,
                    ),
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                    Text(
                      "OP",
                      style: TextStyle(fontSize: chartCardDims / 18),
                    ),
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(5)),
                      height: chartCardDims / 18,
                      width: chartCardDims / 18,
                    ),
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                    Text(
                      "LIMOP",
                      style: TextStyle(fontSize: chartCardDims / 18),
                    ),
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                      height: chartCardDims / 18,
                      width: chartCardDims / 18,
                    ),
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                    Text(
                      "NONOP",
                      style: TextStyle(fontSize: chartCardDims / 18),
                    ),
                    SizedBox(
                      width: chartCardDims / 30,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.label, [this.color]);
  final String x;
  final double y;
  final Color color;
  final String label;
}
