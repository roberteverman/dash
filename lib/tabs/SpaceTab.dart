import 'package:dash/components/DashTab.dart';
import 'package:flutter/material.dart';

class SpaceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Icon(Icons.bar_chart)),
        Tab(child: Text("BMOAs")),
        Tab(child: Text("Missiles")),
      ],
      contentTabs: [
        Center(child: Text("Space Charts View")),
        Center(child: Text("BMOAs View")),
        Center(child: Text("Missiles View")),
      ],
    );
  }
}
