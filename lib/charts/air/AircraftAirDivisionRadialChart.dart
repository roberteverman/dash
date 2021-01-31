import 'package:dash/components/ChartCard.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AircraftAirDivisionRadialChart extends StatefulWidget {
  AircraftAirDivisionRadialChart({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  _AircraftAirDivisionRadialChartState createState() => _AircraftAirDivisionRadialChartState();
}

class _AircraftAirDivisionRadialChartState extends State<AircraftAirDivisionRadialChart> {
  List<ChartData> dataSource;

  @override
  Widget build(BuildContext context) {
    dataSource = List<ChartData>.generate(4, (index) {
      List<AirfieldInventory> airDivisionData =
          Provider.of<AirChartCN>(context, listen: true).airfieldInventory.where((element) => element.airdiv == 4 - index).toList();
      int totalOperational = 0;
      int totalAircraft = 0;
      for (AirfieldInventory item in airDivisionData) {
        for (var aircraft in item.aircraft) {
          totalOperational += aircraft['operational'];
          totalAircraft += aircraft['total'];
        }
      }
      return new ChartData(x: (4 - index).toString() + "AD", y: (totalOperational / totalAircraft) * 100, total: totalAircraft, op: totalOperational);
    });

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
              "Aircraft by Air Division",
              style: TextStyle(
                fontSize: widget.chartCardDims / 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            Flexible(
              // child: Container(),
              child: SfCircularChart(
                tooltipBehavior: TooltipBehavior(enable: true, format: "point.x: point.y% OP"),
                palette: List<Color>.generate(5, (index) => Colors.white),
                series: [
                  RadialBarSeries(
                    animationDuration: 0,
                    maximumValue: 100,
                    gap: '3%',
                    radius: '100%',
                    innerRadius: '30%',
                    dataSource: dataSource,
                    cornerStyle: CornerStyle.bothCurve,
                    xValueMapper: (data, _) {
                      return data.x;
                    },
                    yValueMapper: (data, _) => data.y,
                    dataLabelMapper: (data, _) => data.x,
                    enableSmartLabels: true,
                    trackOpacity: 0,
                    enableTooltip: true,
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: widget.chartCardDims / 15,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData({this.x, this.y, this.op, this.total});
  final String x;
  final double y;
  final int op;
  final int total;
}
