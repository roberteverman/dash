import 'package:charts_flutter/flutter.dart';
import 'package:dash/charts/AirfieldTotalStatusChart.dart';
import 'package:dash/components/ChartCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class AirChartSubtab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      int numCardsPerRow = 3;
                      double padding = 10;

                      return ReorderableWrap(
                        onReorder: (x, y) {
                          print(x.toString() + " " + y.toString());
                        },
                        children: List<ChartCard>.generate(
                            10,
                            (index) => ChartCard(
                                  height: (constraints.maxWidth / numCardsPerRow - (padding * 2)),
                                  width: (constraints.maxWidth / numCardsPerRow - (padding * 2)),
                                  padding: padding,
                                  child: Column(
                                    children: [
                                      Text("Test"),
                                      Flexible(
                                        child: PieChart(
                                          [
                                            Series<LinearSales, dynamic>(
                                              id: "Sales",
                                              displayName: "Hello",
                                              data: [
                                                LinearSales("OP", 100),
                                                LinearSales("NONOP", 50),
                                                LinearSales("LIMOP", 25),
                                              ],
                                              domainFn: (LinearSales sales, _) => sales.label,
                                              measureFn: (LinearSales sales, _) => sales.sales,
                                              colorFn: (LinearSales sales, _) {
                                                if (sales.label == "NONOP") {
                                                  return Color(r: 255, g: 0, b: 0, a: 150);
                                                }
                                                return Color(r: 0, g: 255, b: 0, a: 150);
                                                ;
                                              },
                                              labelAccessorFn: (LinearSales row, _) => '${row.label}\n${row.sales}',
                                            )
                                          ],
                                          animate: false,
                                          defaultRenderer: new ArcRendererConfig(
                                            arcWidth: 60,
                                            arcRendererDecorators: [new ArcLabelDecorator()],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LinearSales {
  final String label;
  final int sales;

  LinearSales(this.label, this.sales);
}
