import 'package:dash/components/DashTab.dart';
import 'package:flutter/material.dart';

class SpaceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Icon(Icons.bar_chart)),
        Tab(child: Text("TBMs")),
        Tab(child: Text("SAMs")),
      ],
      contentTabs: [
        Center(child: Text("Space Charts View")),
        Center(child: Text("TBM View")),
        Center(child: Text("SAM View")),
      ],
    );
  }
}
