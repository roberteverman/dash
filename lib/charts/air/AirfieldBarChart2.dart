import 'package:dash/components/ChartCard.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AirfieldBarChart2 extends StatelessWidget {
  AirfieldBarChart2({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  Widget build(BuildContext context) {
    List<String> airfieldList = Provider.of<AirChartCN>(context, listen: true).airfieldList;
    List<AirfieldInventory> airfieldInventory = Provider.of<AirChartCN>(context, listen: true).airfieldInventory;

    List<ChartData> chartData = List<ChartData>.generate(
      airfieldList.length,
      (index) {
        int op = 0;
        int total = 0;
        for (AirfieldInventory airfield in airfieldInventory) {
          if (airfield.name == airfieldList[index]) {
            for (dynamic aircraft in airfield.aircraft) {
              op += aircraft['operational'];
              total += aircraft['total'];
            }
          }
        }
        return ChartData(
          type: airfieldList[index],
          op: op,
          total: total,
        );
      },
    );

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(30)),
      height: airfieldInventory.length.toDouble() * 25,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Aircraft by Airfield",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            Flexible(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                isTransposed: true,
                primaryXAxis: CategoryAxis(
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                  labelStyle: TextStyle(
                    fontSize: 12,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: false,
                  minimum: 0,
                  maximum: 1,
                ),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, String>(
                    animationDuration: 0,
                    borderWidth: 0,
                    trackBorderWidth: 0,
                    dataSource: chartData,
                    isTrackVisible: true,
                    color: Colors.white,
                    xValueMapper: (ChartData data, _) => data.type,
                    yValueMapper: (ChartData data, _) => (data.op / data.total),
                    dataLabelMapper: (ChartData data, _) => (data.op.toString() + "/" + data.total.toString()),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(fontSize: 12),
                      labelAlignment: ChartDataLabelAlignment.bottom,
                    ),
                    width: .8,
                    spacing: 2,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData({this.type, this.op, this.total});
  final String type;
  final int op;
  final int total;
}
