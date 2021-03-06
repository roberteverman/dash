import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dash/components/air/AirfieldStatusChip.dart';

class AirfieldStatusCard extends StatelessWidget {
  const AirfieldStatusCard({this.airfieldStatus});
  final AirfieldStatus airfieldStatus;

  @override
  Widget build(BuildContext context) {
    Color airfieldStatusColor;
    switch (airfieldStatus.status) {
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
            key: PageStorageKey<String>(airfieldStatus.name),
            title: SizedBox(
              child: Center(
                child: AutoSizeText(
                  airfieldStatus.name,
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
                                  "Change overall status of \n" + airfieldStatus.name,
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
                                              await Provider.of<AirFieldStatusCN>(context, listen: false).pushAirfieldStatus(
                                                airfieldStatus.be,
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
                                              await Provider.of<AirFieldStatusCN>(context, listen: false).pushAirfieldStatus(
                                                airfieldStatus.be,
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
                                              await Provider.of<AirFieldStatusCN>(context, listen: false).pushAirfieldStatus(
                                                airfieldStatus.be,
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
                          text: airfieldStatus.status,
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
                  children: List<AirfieldStatusChip>.generate(
                    airfieldStatus.components.length,
                    (index) => AirfieldStatusChip(
                      text: airfieldStatus.components[index]['display'].toString().toUpperCase(),
                      tooltip: airfieldStatus.components[index]['name'] + "\nStatus: " + airfieldStatus.components[index]['status'],
                      status: airfieldStatus.components[index]['status'],
                      parentAirfield: airfieldStatus.components[index]['status'],
                      field: airfieldStatus.components[index]['display'],
                      be: airfieldStatus.be,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
