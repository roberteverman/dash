import 'package:flutter/material.dart';

class ChartCard extends StatelessWidget {
  ChartCard({this.height, this.width, this.padding, this.child});
  final double height;
  final double width;
  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(30)),
        child: child,
      ),
    );
  }
}
