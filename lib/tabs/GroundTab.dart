import 'dart:html';
import 'package:dash/components/DashTab.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:dash/tabs/ground/GroundChartSubtab.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';

class GroundTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashTab(
      contentTabLabels: [
        // Tab(child: Icon(Icons.bar_chart)),
        Tab(child: Text("Ground")),
        // Tab(child: Text("Armor")),
        // Tab(child: Text("Infantry")),
      ],
      contentTabs: [
        GroundChartSubtab(),
        // Center(
        //   // child: Expanded(
        //   //   child: EasyWebView(
        //   //     src: "https://flutter.dev",
        //   //     onLoaded: () {
        //   //       print("loaded");
        //   //     },
        //   //     key: ValueKey("1"),
        //   //   ),
        //   // ),
        //   child: Text("Ground Chart View"),
        // ),
        // Center(child: Text("LRA View")),
        // Center(child: Text("Armor View")),
        // Center(child: Text("Infantry View")),
      ],
    );
  }
}
