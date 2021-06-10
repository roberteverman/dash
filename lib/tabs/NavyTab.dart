import 'package:dash/components/DashTab.dart';
import 'package:dash/tabs/navy/NavyCDCMSubtab.dart';
import 'package:dash/tabs/navy/NavyChartSubtab.dart';
import 'package:dash/tabs/navy/NavySubSubtab.dart';
import 'package:dash/tabs/navy/NavyVesselSubtab.dart';
import 'package:flutter/material.dart';

class SeaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Icon(Icons.bar_chart)),
        Tab(child: Text("Subs")),
        Tab(child: Text("Vessel")),
        Tab(child: Text("CDCM")),
      ],
      contentTabs: [
        NavyChartSubtab(),
        NavySubSubtab(),
        NavyVesselSubtab(),
        NavyCDCMSubtab(),
      ],
    );
  }
}
