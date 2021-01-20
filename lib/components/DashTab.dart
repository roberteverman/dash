import 'package:dash/providers/ThemeChanger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (contentTabLabels.length * 100).toDouble(),
                child: TabBar(
                  onTap: (i) {
                    Provider.of<ThemeChanger>(context, listen: false).currentSubtab = i;
                  },
                  physics: NeverScrollableScrollPhysics(),
                  tabs: contentTabLabels,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: contentTabs,
            ),
          ),
        ],
      ),
    );
  }
}
