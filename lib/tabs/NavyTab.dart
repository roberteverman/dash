import 'package:dash/components/DashTab.dart';
import 'package:dash/tabs/navy/NavyVesselSubtab.dart';
import 'package:flutter/material.dart';

class SeaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        // Tab(child: Icon(Icons.bar_chart)),
        // Tab(child: Text("Ports")),
        Tab(child: Text("Vessels")),
      ],
      contentTabs: [
        // Center(child: Text("Navy Charts View")),
        // Center(child: Text("Ports View")),
        VesselSubtab(),
      ],
    );
  }
}
