import 'package:dash/components/DashTab.dart';
import 'package:flutter/material.dart';

class GroundTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Icon(Icons.bar_chart)),
        Tab(child: Text("LRA")),
        Tab(child: Text("Armor")),
        Tab(child: Text("Infantry")),
      ],
      contentTabs: [
        Center(child: Text("Ground Charts View")),
        Center(child: Text("LRA View")),
        Center(child: Text("Armor View")),
        Center(child: Text("Infantry View")),
      ],
    );
  }
}
