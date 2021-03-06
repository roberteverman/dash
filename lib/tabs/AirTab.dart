import 'package:dash/components/DashTab.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:dash/tabs/air/AirChartSubtab.dart';
import 'package:dash/tabs/air/AirChartSubtab2.dart';
import 'package:dash/tabs/air/AirMapSubtab.dart';
import 'package:dash/tabs/air/SAMSubtab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'air/AircraftSubtab.dart';
import 'air/AirfieldSubtab.dart';

class AirTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Icon(Icons.bar_chart)),
        // Tab(child: Icon(Icons.location_pin)),
        Tab(child: Text("Aircraft")),
        Tab(child: Text("Airfields")),
        Tab(child: Text("SAMs")),
      ],
      contentTabs: [
        AirChartSubtab2(),
        // AirMapSubtab(),
        AircraftSubtab(),
        AirfieldSubtab(),
        SAMSubtab(),
      ],
    );
  }
}
