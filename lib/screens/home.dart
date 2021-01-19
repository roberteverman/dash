import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/tabs/AirTab.dart';
import 'package:dash/tabs/GroundTab.dart';
import 'package:dash/tabs/SeaTab.dart';
import 'package:dash/tabs/SpaceTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dash/helpers/themes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    final theme = Theme.of(context);
    double winWidth = MediaQuery.of(context).size.width;
    double winHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Row(
          children: [
            Container(
              width: 130, //the width of the left side tab
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    // Logo Area
                    height: 100,
                    child: Center(
                        child: Text(
                      "Dash.",
                      style: TextStyle(fontSize: 30),
                    )),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(35),
                          bottomRight: Radius.circular(35),
                        ),
                        color: theme.primaryColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              width: 200, //the *height* of the vertical TabBar
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: theme.colorScheme.onBackground,
                                tabs: [
                                  DashTabLabel(text: "air"),
                                  DashTabLabel(text: "ground"),
                                  DashTabLabel(text: "sea"),
                                  DashTabLabel(text: "space"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 40,
                    color: theme.scaffoldBackgroundColor,
                    child: Row(
                      children: [
                        Text("Dark"),
                        Switch(
                          value: themeChanger.lightMode,
                          onChanged: (val) {
                            themeChanger.lightMode = val;
                            if (val) {
                              themeChanger.setTheme(dashLightTheme);
                            } else {
                              themeChanger.setTheme(dashDarkTheme);
                            }
                          },
                        ),
                        Text("Light"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    // Top bar area
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(), //Left area of search bar
                        ),
                        Container(
                          //Search bar area
                          width: winWidth / 2,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              cursorColor: theme.indicatorColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search_rounded),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Search...",
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("All"),
                                    Container(width: 10),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                    Container(width: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(), //Right area of search bar
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        AirTab(),
                        GroundTab(),
                        SeaTab(),
                        SpaceTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashTabLabel extends StatelessWidget {
  const DashTabLabel({this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        child: Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 10),
              Icon(Icons.star),
              Container(width: 10),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
