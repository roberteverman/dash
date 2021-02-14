import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/helpers/dash_icons.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:dash/providers/air/AircraftStatusCN.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:dash/providers/air/SAMStatusCN.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:dash/tabs/AirTab.dart';
import 'package:dash/tabs/GroundTab.dart';
import 'package:dash/tabs/NavyTab.dart';
import 'package:dash/tabs/SpaceTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    String dashAbout =
        "Dash is a real time order of battle visualization tool. It was created to blah blah blah (insert inspiring stuff). \n\n For a tutorial please click the link below.\n\n (Insert link or video.)";
    String lang = Provider.of<ThemeChanger>(context, listen: true).lang;

    return Scaffold(
      drawer: MediaQuery.of(context).size.width >= 700
          ? null
          : Drawer(
              child: SingleChildScrollView(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Dash.",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                letterSpacing: 10,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: Image.asset(
                              "images/logo_dark.png",
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(color: Colors.transparent),
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Icon(DashIcons.fighter, size: 50),
                      ),
                      onTap: () {
                        _tabController.animateTo(0);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Icon(DashIcons.tank, size: 50),
                      ),
                      onTap: () {
                        _tabController.animateTo(1);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Icon(DashIcons.vessel, size: 50),
                      ),
                      onTap: () {
                        _tabController.animateTo(2);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Icon(DashIcons.missile, size: 50),
                      ),
                      onTap: () {
                        _tabController.animateTo(3);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
      appBar: MediaQuery.of(context).size.width >= 700
          ? null
          : AppBar(
              actions: [
                // IconButton(
                //   padding: EdgeInsets.zero,
                //   icon: Icon(
                //     FontAwesomeIcons.solidHandSpock,
                //     size: 20,
                //   ),
                //   onPressed: () async {
                //     return await showDialog(
                //       barrierDismissible: true,
                //       context: context,
                //       builder: (_) => AlertDialog(
                //         title: Center(
                //           child: Text("About Dash"),
                //         ),
                //         content: Container(width: 400, child: Text(dashAbout)),
                //         actions: [
                //           FlatButton(
                //             child: Text("Word."),
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //           )
                //         ],
                //       ),
                //     );
                //   },
                //   tooltip: "Live Long and Prosper",
                //   color: Theme.of(context).tabBarTheme.labelColor.withOpacity(0.75),
                //   highlightColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //   splashColor: Colors.transparent,
                // ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.refresh,
                    size: 25,
                  ),
                  onPressed: () async {
                    // print(winWidth);
                    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context, listen: false);
                    int currentTab = themeChanger.currentTab;
                    int currentSubtab = themeChanger.currentSubtab;
                    themeChanger.setLoading(true);
                    themeChanger.notifyListeners();
                    //todo: insert conditions for every subtab
                    if (currentTab == 0) {
                      //air
                      if (currentSubtab == 0) {
                        //air charts
                        await Provider.of<AirChartCN>(context, listen: false).updateCharts(themeChanger.lightMode);
                        themeChanger.centralDateTime = Provider.of<AirFieldStatusCN>(context, listen: true).datetime;
                      }
                      if (currentSubtab == 1) {
                        //aircraft
                        await Provider.of<AircraftStatusCN>(context, listen: false).updateAirfieldInventory();
                        themeChanger.centralDateTime = Provider.of<AircraftStatusCN>(context, listen: true).datetime;
                      }
                      if (currentSubtab == 2) {
                        //airfields
                        await Provider.of<AirFieldStatusCN>(context, listen: false).updateAirfieldStatus();
                        themeChanger.centralDateTime = Provider.of<AirFieldStatusCN>(context, listen: true).datetime;
                      }
                      if (currentSubtab == 3) {
                        //SAMs
                        await Provider.of<SAMStatusCN>(context, listen: false).updateSAMStatus();
                        themeChanger.centralDateTime = Provider.of<SAMStatusCN>(context, listen: true).datetime;
                      }
                    }
                    if (currentTab == 1) {
                      //ground
                      if (currentSubtab == 0) {
                        //ground charts
                        await Provider.of<GroundChartCN>(context, listen: false).updateCharts(themeChanger.lightMode);
                        themeChanger.centralDateTime = Provider.of<GroundChartCN>(context, listen: false).datetime;
                      }
                    }
                    if (currentTab == 2) {
                      //navy
                      if (currentSubtab == 0) {
                        //vessels
                        await Provider.of<NavyVesselCN>(context, listen: false).updateNavyInventory();
                        themeChanger.centralDateTime = Provider.of<NavyVesselCN>(context, listen: false).datetime;
                      }
                    }
                    themeChanger.setLoading(false);
                    themeChanger.notifyListeners();
                  },
                  tooltip: "Refresh Data",
                  color: Theme.of(context).tabBarTheme.labelColor.withOpacity(0.75),
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.person,
                    color: Provider.of<ThemeChanger>(context, listen: true).apiKey == "" ? null : Colors.green,
                    size: 25,
                  ),
                  onPressed: () async {
                    String user = "";
                    String pass = "";

                    return await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (_) => Provider.of<ThemeChanger>(context, listen: true).apiKey == ""
                          ? AlertDialog(
                              title: Center(
                                child: Text("Admin Login"),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await themeChanger.loginUser(user, pass);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          user = value;
                                        },
                                        cursorColor: theme.indicatorColor,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: "Username",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          pass = value;
                                        },
                                        obscureText: true,
                                        cursorColor: theme.indicatorColor,
                                        onFieldSubmitted: (value) async {
                                          await themeChanger.loginUser(user, pass);
                                          Navigator.pop(context);
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: "Password",
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : AlertDialog(
                              title: Text("Log out?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Provider.of<ThemeChanger>(context, listen: false).apiKey = "";
                                      Provider.of<ThemeChanger>(context, listen: false).notifyListeners();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Logout")),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                )
                              ],
                            ),
                    );
                  },
                  tooltip: "Admin Login",
                  color: Theme.of(context).tabBarTheme.labelColor.withOpacity(0.75),
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
              ],
              centerTitle: true,
              title: Text(
                "Dash.",
                style: TextStyle(fontWeight: FontWeight.w100, letterSpacing: 10, fontSize: 40),
              ),
            ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width < 700 ? 0 : 130, //the width of the left side tab
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    // Logo Area
                    height: 175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 13, left: 5),
                          child: Text(
                            "Dash.",
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, letterSpacing: 4),
                          ),
                        ),
                        Container(
                          width: 110,
                          child: Image.asset(
                            "images/logo_dark.png",
                          ),
                        )
                      ],
                    ),
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                width: 400, //the *height* of the vertical TabBar
                                child: TabBar(
                                  onTap: (i) {
                                    Provider.of<ThemeChanger>(context, listen: false).currentTab = i;
                                  },
                                  controller: _tabController,
                                  indicatorColor: theme.colorScheme.onBackground,
                                  tabs: [
                                    AltDashTabLabel(iconData: DashIcons.fighter),
                                    // DashTabLabel(text: "ground"),
                                    AltDashTabLabel(iconData: DashIcons.tank),
                                    // DashTabLabel(text: "sea"),
                                    AltDashTabLabel(iconData: DashIcons.vessel),
                                    AltDashTabLabel(iconData: DashIcons.missile),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 75,
                    color: theme.scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
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
                    height: MediaQuery.of(context).size.width < 700 ? 0 : 60,
                    child: MediaQuery.of(context).size.width < 700
                        ? null
                        : Row(
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
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                          Container(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            SizedBox(width: 5),
                                            Tooltip(
                                              message: "언어바꾸기",
                                              child: MaterialButton(
                                                padding: EdgeInsets.zero,
                                                minWidth: 0,
                                                hoverColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onPressed: () {
                                                  if (Provider.of<ThemeChanger>(context, listen: false).lang == "en") {
                                                    Provider.of<ThemeChanger>(context, listen: false).lang = "kor";
                                                    Provider.of<AirChartCN>(context, listen: false).lang = "kor";
                                                    Provider.of<AircraftStatusCN>(context, listen: false).lang = "kor";
                                                    Provider.of<AirFieldStatusCN>(context, listen: false).lang = "kor";
                                                    Provider.of<ThemeChanger>(context, listen: false).notifyListeners();
                                                    Provider.of<AirChartCN>(context, listen: false).notifyListeners();
                                                    Provider.of<AircraftStatusCN>(context, listen: false).notifyListeners();
                                                    Provider.of<AirFieldStatusCN>(context, listen: false).notifyListeners();
                                                  } else {
                                                    Provider.of<ThemeChanger>(context, listen: false).lang = "en";
                                                    Provider.of<AirChartCN>(context, listen: false).lang = "en";
                                                    Provider.of<AircraftStatusCN>(context, listen: false).lang = "en";
                                                    Provider.of<AirFieldStatusCN>(context, listen: false).lang = "en";
                                                    Provider.of<ThemeChanger>(context, listen: false).notifyListeners();
                                                    Provider.of<AirChartCN>(context, listen: false).notifyListeners();
                                                    Provider.of<AircraftStatusCN>(context, listen: false).notifyListeners();
                                                    Provider.of<AirFieldStatusCN>(context, listen: false).notifyListeners();
                                                  }
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Provider.of<ThemeChanger>(context, listen: true).lang == "kor"
                                                      ? Text(
                                                          "En",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        )
                                                      : Text(
                                                          "한",
                                                          style: TextStyle(
                                                            locale: Locale.fromSubtags(languageCode: "ko"),
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                  radius: 13,
                                                ),
                                              ),
                                            ),
                                            // IconButton(
                                            //   padding: EdgeInsets.zero,
                                            //   icon: Icon(
                                            //     DashIcons.kor,
                                            //     size: 20,
                                            //   ),
                                            //   onPressed: () {},
                                            //   tooltip: "Change Language",
                                            //   color: Theme.of(context).tabBarTheme.labelColor.withOpacity(0.75),
                                            //   highlightColor: Colors.transparent,
                                            //   hoverColor: Colors.transparent,
                                            //   splashColor: Colors.transparent,
                                            // ),
                                            // IconButton(
                                            //   padding: EdgeInsets.zero,
                                            //   icon: Icon(
                                            //     FontAwesomeIcons.solidHandSpock,
                                            //     size: 20,
                                            //   ),
                                            //   onPressed: () async {
                                            //     return await showDialog(
                                            //       barrierDismissible: true,
                                            //       context: context,
                                            //       builder: (_) => AlertDialog(
                                            //         title: Center(
                                            //           child: Text("About Dash"),
                                            //         ),
                                            //         content: Container(width: 400, child: Text(dashAbout)),
                                            //         actions: [
                                            //           FlatButton(
                                            //             child: Text("Word."),
                                            //             onPressed: () {
                                            //               Navigator.pop(context);
                                            //             },
                                            //           )
                                            //         ],
                                            //       ),
                                            //     );
                                            //   },
                                            //   tooltip: "Live Long and Prosper",
                                            //   color: Theme.of(context).tabBarTheme.labelColor.withOpacity(0.75),
                                            //   highlightColor: Colors.transparent,
                                            //   hoverColor: Colors.transparent,
                                            //   splashColor: Colors.transparent,
                                            // ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.refresh,
                                                size: 25,
                                              ),
                                              onPressed: () async {
                                                // print(winWidth);
                                                ThemeChanger themeChanger = Provider.of<ThemeChanger>(context, listen: false);
                                                int currentTab = themeChanger.currentTab;
                                                int currentSubtab = themeChanger.currentSubtab;
                                                themeChanger.setLoading(true);
                                                themeChanger.notifyListeners();
                                                //todo: insert conditions for every subtab
                                                if (currentTab == 0) {
                                                  //air
                                                  if (currentSubtab == 0) {
                                                    //air charts
                                                    await Provider.of<AirChartCN>(context, listen: false).updateCharts(themeChanger.lightMode);
                                                    themeChanger.centralDateTime = Provider.of<AirFieldStatusCN>(context, listen: false).datetime;
                                                  }
                                                  if (currentSubtab == 1) {
                                                    //aircraft
                                                    await Provider.of<AircraftStatusCN>(context, listen: false).updateAirfieldInventory();
                                                    themeChanger.centralDateTime = Provider.of<AircraftStatusCN>(context, listen: false).datetime;
                                                  }
                                                  if (currentSubtab == 2) {
                                                    //airfields
                                                    await Provider.of<AirFieldStatusCN>(context, listen: false).updateAirfieldStatus();
                                                    themeChanger.centralDateTime = Provider.of<AirFieldStatusCN>(context, listen: false).datetime;
                                                  }
                                                  if (currentSubtab == 3) {
                                                    //SAMs
                                                    await Provider.of<SAMStatusCN>(context, listen: false).updateSAMStatus();
                                                    themeChanger.centralDateTime = Provider.of<SAMStatusCN>(context, listen: true).datetime;
                                                  }
                                                }
                                                if (currentTab == 1) {
                                                  //ground
                                                  if (currentSubtab == 0) {
                                                    //ground charts
                                                    await Provider.of<GroundChartCN>(context, listen: false).updateCharts(themeChanger.lightMode);
                                                    themeChanger.centralDateTime = Provider.of<GroundChartCN>(context, listen: false).datetime;
                                                  }
                                                }
                                                if (currentTab == 2) {
                                                  //navy
                                                  if (currentSubtab == 0) {
                                                    //vessels
                                                    await Provider.of<NavyVesselCN>(context, listen: false).updateNavyInventory();
                                                    themeChanger.centralDateTime = Provider.of<NavyVesselCN>(context, listen: false).datetime;
                                                  }
                                                }
                                                themeChanger.setLoading(false);
                                                themeChanger.notifyListeners();
                                              },
                                              tooltip: "Refresh Data",
                                              color: Theme.of(context).tabBarTheme.labelColor.withOpacity(0.75),
                                              highlightColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.person,
                                                color: Provider.of<ThemeChanger>(context, listen: true).apiKey == "" ? null : Colors.green,
                                                size: 25,
                                              ),
                                              onPressed: () async {
                                                String user = "";
                                                String pass = "";

                                                return await showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (_) => Provider.of<ThemeChanger>(context, listen: true).apiKey == ""
                                                      ? AlertDialog(
                                                          title: Center(
                                                            child: Text("Admin Login"),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () async {
                                                                await themeChanger.loginUser(user, pass);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                "Submit",
                                                                style: TextStyle(
                                                                  color: Colors.green,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          content: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                width: 300,
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                                                                  child: TextFormField(
                                                                    onChanged: (value) {
                                                                      user = value;
                                                                    },
                                                                    cursorColor: theme.indicatorColor,
                                                                    decoration: InputDecoration(
                                                                      prefixIcon: Icon(Icons.person),
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(50),
                                                                        borderSide: BorderSide.none,
                                                                      ),
                                                                      hintText: "Username",
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 300,
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                                                                  child: TextFormField(
                                                                    onChanged: (value) {
                                                                      pass = value;
                                                                    },
                                                                    obscureText: true,
                                                                    cursorColor: theme.indicatorColor,
                                                                    onFieldSubmitted: (value) async {
                                                                      await themeChanger.loginUser(user, pass);
                                                                      Navigator.pop(context);
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      prefixIcon: Icon(Icons.lock),
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(50),
                                                                        borderSide: BorderSide.none,
                                                                      ),
                                                                      hintText: "Password",
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : AlertDialog(
                                                          title: Text("Log out?"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Provider.of<ThemeChanger>(context, listen: false).apiKey = "";
                                                                Provider.of<ThemeChanger>(context, listen: false).notifyListeners();
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                "Logout",
                                                                style: TextStyle(color: Colors.green),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                );
                                              },
                                              tooltip: "Admin Login",
                                              color: Theme.of(context).tabBarTheme.labelColor.withOpacity(0.75),
                                              highlightColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  Provider.of<ThemeChanger>(context, listen: true).centralDateTime,
                                                  maxLines: 2,
                                                  minFontSize: 0,
                                                  maxFontSize: 20,
                                                  wrapWords: true,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  stepGranularity: 0.1,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ), //Right area of search bar
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

class AltDashTabLabel extends StatelessWidget {
  const AltDashTabLabel({this.iconData});
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Tab(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 100,
              child: Icon(
                iconData,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
