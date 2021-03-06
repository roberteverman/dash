import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/components/air/SAMStatusChip.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/SAMStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SAMStatusCard extends StatelessWidget {
  const SAMStatusCard({this.samStatus});
  final SAMStatus samStatus;

  @override
  Widget build(BuildContext context) {
    Color airfieldStatusColor;
    switch (samStatus.status) {
      case "OP":
        {
          airfieldStatusColor = Colors.green;
        }
        break;

      case "NONOP":
        {
          airfieldStatusColor = Colors.red;
        }
        break;

      case "LIMOP":
        {
          airfieldStatusColor = Colors.yellow;
        }
        break;

      default:
        {
          airfieldStatusColor = Colors.white;
        }
        break;
    }

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 0, bottom: 5.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            maintainState: true,
            key: PageStorageKey<String>(samStatus.name),
            title: SizedBox(
              child: Center(
                child: AutoSizeText(
                  samStatus.name,
                  maxLines: 2,
                  minFontSize: 10,
                  maxFontSize: 15,
                  wrapWords: true,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  stepGranularity: 0.1,
                  textAlign: TextAlign.center,
                  // style: TextStyle(
                  //   fontWeight: FontWeight.w600,
                  // ),
                ),
              ),
            ),
            subtitle: SizedBox(
              child: Center(
                child: TextButton(
                  onPressed: !Provider.of<ThemeChanger>(context, listen: true).airAdmin
                      ? () {}
                      : () async {
                          return await showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Center(
                                child: Text(
                                  "Change overall status of \n" + samStatus.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Text("OP"),
                                      color: Colors.green,
                                      onPressed: !Provider.of<ThemeChanger>(context, listen: true).airAdmin
                                          ? null
                                          : () async {
                                              await Provider.of<SAMStatusCN>(context, listen: false).pushSAMStatus(
                                                samStatus.be,
                                                "status",
                                                "OP",
                                                Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                                Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                              );
                                              Navigator.pop(context);
                                            },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Text(
                                        "LIMOP",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      color: Colors.yellow,
                                      onPressed: !Provider.of<ThemeChanger>(context, listen: true).airAdmin
                                          ? null
                                          : () async {
                                              await Provider.of<SAMStatusCN>(context, listen: false).pushSAMStatus(
                                                samStatus.be,
                                                "status",
                                                "LIMOP",
                                                Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                                Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                              );
                                              Navigator.pop(context);
                                            },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Text("NONOP"),
                                      color: Colors.red,
                                      onPressed: !Provider.of<ThemeChanger>(context, listen: true).airAdmin
                                          ? null
                                          : () async {
                                              await Provider.of<SAMStatusCN>(context, listen: false).pushSAMStatus(
                                                samStatus.be,
                                                "status",
                                                "NONOP",
                                                Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                                Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                              );
                                              Navigator.pop(context);
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: Theme.of(context).accentColor, fontWeight: FontWeight.w100),
                      children: <TextSpan>[
                        TextSpan(text: "Status: "),
                        TextSpan(
                          text: samStatus.status,
                          style: TextStyle(fontWeight: FontWeight.bold, color: airfieldStatusColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 1000 ? 5 : 0),
                child: Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    children: List<SAMStatusChip>.generate(
                        samStatus.components.length,
                        (index) => SAMStatusChip(
                              text: samStatus.components[index]['display'].toString().toUpperCase(),
                              tooltip: samStatus.components[index]['name'] + "\nStatus: " + samStatus.components[index]['status'],
                              status: samStatus.components[index]['status'],
                              parentAirfield: samStatus.components[index]['name'],
                              field: samStatus.components[index]['display'],
                              be: samStatus.be,
                            ))
                    // [
                    //   SAMStatusChip(
                    //     text: "RDR",
                    //     tooltip: "Radar\nStatus: " + samStatus.rdr,
                    //     status: samStatus.rdr,
                    //     parentAirfield: samStatus.name,
                    //     field: "rdr",
                    //     be: samStatus.be,
                    //   ),
                    //   SAMStatusChip(
                    //     text: "RCB",
                    //     tooltip: "Radar Control Bunker\nStatus: " + samStatus.rcb,
                    //     status: samStatus.rcb,
                    //     parentAirfield: samStatus.name,
                    //     field: "rcb",
                    //     be: samStatus.be,
                    //   ),
                    //   SAMStatusChip(
                    //     text: "LCB",
                    //     tooltip: "Launch Control Bunker\nStatus: " + samStatus.lcb,
                    //     status: samStatus.lcb,
                    //     parentAirfield: samStatus.name,
                    //     field: "lcb",
                    //     be: samStatus.be,
                    //   ),
                    //   SAMStatusChip(
                    //     text: "C2B",
                    //     tooltip: "Command Control Bunker\nStatus: " + samStatus.c2b,
                    //     status: samStatus.c2b,
                    //     parentAirfield: samStatus.name,
                    //     field: "c2b",
                    //     be: samStatus.be,
                    //   ),
                    // ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
