import 'package:flutter/material.dart';

class DashTab extends StatelessWidget {
  const DashTab({this.contentTabLabels, this.contentTabs});
  final List<Widget> contentTabLabels;
  final List<Widget> contentTabs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: contentTabLabels.length,
      child: Column(
        children: [
          Container(
            width: (contentTabLabels.length * 100).toDouble(),
            child: TabBar(
              physics: NeverScrollableScrollPhysics(),
              tabs: contentTabLabels,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: contentTabs,
            ),
          ),
        ],
      ),
    );
  }
}
