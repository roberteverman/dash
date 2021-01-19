import 'package:dash/components/DashTab.dart';
import 'package:flutter/material.dart';

class SeaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Icon(Icons.bar_chart)),
        Tab(child: Text("NAVCOMs")),
        Tab(child: Text("Ports")),
        Tab(child: Text("Vessels")),
        Tab(child: Text("Subs")),
      ],
      contentTabs: [
        Center(child: Text("Navy Charts View")),
        Center(child: Text("Navy Commands View")),
        Center(child: Text("Ports View")),
        Center(child: Text("Vessels View")),
        Center(child: Text("Submarines View")),
      ],
    );
  }
}
