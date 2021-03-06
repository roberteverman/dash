import 'package:dash/components/DashTab.dart';
import 'package:dash/tabs/tbm/TBMSubtab.dart';
import 'package:dash/tabs/tbm/TBMMapSubtab.dart';
import 'package:flutter/material.dart';

class SpaceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Text("TBMs")),
        // Tab(child: Icon(Icons.location_pin)),
      ],
      contentTabs: [
        TBMSubtab(),
        // TBMMapSubtab(),
      ],
    );
  }
}
