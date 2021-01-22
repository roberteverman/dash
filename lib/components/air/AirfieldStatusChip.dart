import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AirfieldStatusChip extends StatelessWidget {
  AirfieldStatusChip({this.tooltip, this.text, this.status, this.parentAirfield, this.field});
  final String tooltip;
  final String text;
  final String status;
  final String parentAirfield;
  final String field;

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color color;

    switch (status) {
      case "OP":
        {
          textColor = Colors.white;
          color = Colors.green;
        }
        break;

      case "NONOP":
        {
          textColor = Colors.white;
          color = Colors.red;
        }
        break;

      case "LIMOP":
        {
          textColor = Colors.black;
          color = Colors.yellow;
        }
        break;

      default:
        {
          textColor = Colors.black;
          color = Colors.white;
        }
        break;
    }

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Tooltip(
        preferBelow: false,
        message: tooltip,
        waitDuration: Duration(milliseconds: 500),
        child: GestureDetector(
          onTap: !Provider.of<ThemeChanger>(context, listen: true).airAdmin
              ? null
              : () async {
                  //todo implement only if logged in
                  return await showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Center(
                        child: Text(
                          "Change status of " + parentAirfield + " " + tooltip.split('\n')[0],
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
                                      await Provider.of<AirFieldStatusCN>(context, listen: false)
                                          .pushAirfieldStatus(parentAirfield, field, "OP", Provider.of<ThemeChanger>(context, listen: false).apiKey);
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
                                          parentAirfield, field, "LIMOP", Provider.of<ThemeChanger>(context, listen: false).apiKey);
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
                                          parentAirfield, field, "NONOP", Provider.of<ThemeChanger>(context, listen: false).apiKey);
                                      Navigator.pop(context);
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
          child: Chip(
            label: Container(
              width: 30,
              child: Center(
                child: AutoSizeText(
                  text,
                  minFontSize: 0,
                  stepGranularity: 0.1,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ),
            ),
            backgroundColor: color,
          ),
        ),
      ),
    );
  }
}
