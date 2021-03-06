import 'package:dash/providers/ThemeChanger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashTab extends StatefulWidget {
  const DashTab({this.contentTabLabels, this.contentTabs});
  final List<Widget> contentTabLabels;
  final List<Widget> contentTabs;

  @override
  _DashTabState createState() => _DashTabState();
}

class _DashTabState extends State<DashTab> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: widget.contentTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.contentTabLabels.length,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (widget.contentTabLabels.length * 100).toDouble(),
                child: TabBar(
                  controller: _tabController,
                  onTap: (i) {
                    Provider.of<ThemeChanger>(context, listen: false).currentSubtab = i;
                  },
                  physics: NeverScrollableScrollPhysics(),
                  tabs: widget.contentTabLabels,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: widget.contentTabs,
            ),
          ),
        ],
      ),
    );
  }
}
