import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class NavyCDCMGauge extends StatelessWidget {
  NavyCDCMGauge({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "CDCMs",
          style: TextStyle(
            fontSize: chartCardDims / 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(3),
            child: SfRadialGauge(
              enableLoadingAnimation: false,
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 10,
                  minorTicksPerInterval: 3,
                  majorTickStyle: MajorTickStyle(
                    color: Theme.of(context).accentColor,
                    thickness: 2,
                  ),
                  canRotateLabels: false,
                  axisLabelStyle: GaugeTextStyle(
                    fontSize: 10,
                    color: Theme.of(context).accentColor,
                  ),
                  axisLineStyle: AxisLineStyle(
                    cornerStyle: CornerStyle.bothCurve,
                    thickness: chartCardDims / 6500,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Theme.of(context).accentColor,
                  ),
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: Provider.of<NavyVesselCN>(context, listen: true).numOpCDCM /
                          Provider.of<NavyVesselCN>(context, listen: true).totalCDCM *
                          100,
                      enableAnimation: false,
                      needleColor: Theme.of(context).accentColor,
                      needleStartWidth: 0.3,
                      needleEndWidth: chartCardDims / 50,
                      needleLength: .7,
                      knobStyle: KnobStyle(
                        knobRadius: 0.07,
                        color: Theme.of(context).accentColor,
                      ),
                      animationDuration: 5000,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Container(
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (Provider.of<NavyVesselCN>(context, listen: true).numOpCDCM /
                                              Provider.of<NavyVesselCN>(context, listen: true).totalCDCM *
                                              100)
                                          .toStringAsFixed(1) +
                                      '%',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontFamily: 'Courier',
                                    fontSize: chartCardDims / 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Provider.of<NavyVesselCN>(context, listen: true).numOpCDCM.toString() +
                                      '/' +
                                      Provider.of<NavyVesselCN>(context, listen: true).totalCDCM.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontFamily: 'Courier',
                                    fontSize: chartCardDims / 25,
                                    fontWeight: FontWeight.w100,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        angle: 90,
                        positionFactor: .6),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
