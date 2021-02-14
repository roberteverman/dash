import 'package:dash/components/DashTab.dart';
import 'package:flutter/material.dart';

class SpaceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        Tab(child: Text("TBMs")),
      ],
      contentTabs: [
        Center(child: Text("TBM View")),
      ],
    );
  }
}
