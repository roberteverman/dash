import 'dart:ui';
import 'package:dash/components/ChartCard.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AircraftStrengthGauge extends StatefulWidget {
  AircraftStrengthGauge({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  _AircraftStrengthGaugeState createState() => _AircraftStrengthGaugeState();
}

class _AircraftStrengthGaugeState extends State<AircraftStrengthGauge> {
  @override
  Widget build(BuildContext context) {
    return ChartCard(
      width: widget.chartCardDims,
      height: widget.chartCardDims,
      padding: widget.padding,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              "Aircraft Strength",
              style: TextStyle(
                fontSize: widget.chartCardDims / 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(
              height: 5,
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
                        color: Colors.white70,
                        thickness: 2,
                      ),
                      canRotateLabels: false,
                      axisLabelStyle: GaugeTextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                      axisLineStyle: AxisLineStyle(
                        cornerStyle: CornerStyle.bothCurve,
                        thickness: widget.chartCardDims / 6500,
                        thicknessUnit: GaugeSizeUnit.factor,
                        color: Colors.white70,
                      ),
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: Provider.of<AirChartCN>(context, listen: true).numOpAircraft /
                              Provider.of<AirChartCN>(context, listen: true).totalAircraft *
                              100,
                          enableAnimation: false,
                          needleColor: Theme.of(context).accentColor,
                          needleStartWidth: 0.3,
                          needleEndWidth: widget.chartCardDims / 50,
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
                                      (Provider.of<AirChartCN>(context, listen: true).numOpAircraft /
                                                  Provider.of<AirChartCN>(context, listen: true).totalAircraft *
                                                  100)
                                              .toStringAsFixed(1) +
                                          '%',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontSize: widget.chartCardDims / 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      Provider.of<AirChartCN>(context, listen: true).numOpAircraft.toString() +
                                          '/' +
                                          Provider.of<AirChartCN>(context, listen: true).totalAircraft.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Courier',
                                        fontSize: widget.chartCardDims / 25,
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
        ),
      ),
    );
  }
}
