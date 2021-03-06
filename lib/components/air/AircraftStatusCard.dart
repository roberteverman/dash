import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/air/AircraftStatusCN.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class AircraftStatusCard extends StatefulWidget {
  const AircraftStatusCard({this.aircraftStatus});
  final AirfieldInventory aircraftStatus;

  @override
  _AircraftStatusCardState createState() => _AircraftStatusCardState();
}

class _AircraftStatusCardState extends State<AircraftStatusCard> {
  @override
  Widget build(BuildContext context) {
    bool formProcessing = false;
    int formSelectionIndex = 0;

    Color airfieldStatusColor;
    switch (widget.aircraftStatus.status) {
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
            key: PageStorageKey<String>(widget.aircraftStatus.name),
            title: SizedBox(
              child: Center(
                child: AutoSizeText(
                  //todo add function to create new inventory
                  widget.aircraftStatus.name,
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
                                  "Change overall status of \n" + widget.aircraftStatus.name,
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
                                              //use the AirfieldStatusCN here since this is updating the Airfield table instead of Aircraft table
                                              await Provider.of<AirFieldStatusCN>(context, listen: false).pushAirfieldStatus(
                                                widget.aircraftStatus.be,
                                                "status",
                                                "OP",
                                                Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                                Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                              );
                                              Provider.of<AircraftStatusCN>(context, listen: false).updateAirfieldInventory(); //no await on purpose
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
                                              //use the AirfieldStatusCN here since this is updating the Airfield table instead of Aircraft table
                                              await Provider.of<AirFieldStatusCN>(context, listen: false).pushAirfieldStatus(
                                                widget.aircraftStatus.be,
                                                "status",
                                                "LIMOP",
                                                Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                                Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                              );
                                              Provider.of<AircraftStatusCN>(context, listen: false).updateAirfieldInventory();
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
                                              //use the AirfieldStatusCN here since this is updating the Airfield table instead of Aircraft table
                                              await Provider.of<AirFieldStatusCN>(context, listen: false).pushAirfieldStatus(
                                                widget.aircraftStatus.be,
                                                "status",
                                                "NONOP",
                                                Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                                Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                              );
                                              Provider.of<AircraftStatusCN>(context, listen: false).updateAirfieldInventory();
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
                          text: widget.aircraftStatus.status,
                          style: TextStyle(fontWeight: FontWeight.bold, color: airfieldStatusColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DataTable(
                    sortColumnIndex: 0,
                    sortAscending: true,
                    columnSpacing: 10,
                    showBottomBorder: true,
                    showCheckboxColumn: false,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Type',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total',
                        ),
                      ),
                    ],
                    rows: List.generate(
                      widget.aircraftStatus.aircraft.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(Text(
                            widget.aircraftStatus.aircraft[index]['type'],
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 12,
                            ),
                          )),
                          DataCell(
                            LinearPercentIndicator(
                              width: 50,
                              lineHeight: 10.0,
                              percent: widget.aircraftStatus.aircraft[index]['operational'] / widget.aircraftStatus.aircraft[index]['total'],
                              animateFromLastPercent: false,
                              backgroundColor: Colors.white24,
                              progressColor: Colors.white,
                              addAutomaticKeepAlive: false,
                            ),
                          ),
                          DataCell(
                            Text(
                              widget.aircraftStatus.aircraft[index]['operational'].toString() +
                                  ' / ' +
                                  widget.aircraftStatus.aircraft[index]['total'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        onSelectChanged: !Provider.of<ThemeChanger>(context, listen: true).airAdmin
                            ? null
                            : (selected) async {
                                int selectedNumber = 1;
                                List<String> selections = ['Destroy', 'Revive', 'Move', 'Add'];
                                String dropdownValue = widget.aircraftStatus.name; //the name of the airfield
                                String aircraftDropdownValue = Provider.of<AircraftStatusCN>(context, listen: false).aircraftList[0];
                                formProcessing = false;
                                String airfield = widget.aircraftStatus.name;
                                List<dynamic> aircraft = widget.aircraftStatus.aircraft;
                                List<bool> chipVisibility = [true, true, true, true];
                                int totalNumber = int.parse(aircraft[index]['total'].toString());
                                int opNumber = int.parse(aircraft[index]['operational'].toString());
                                int maxNumber = totalNumber - opNumber;
                                formSelectionIndex = 0;

                                if (opNumber == 0) {
                                  chipVisibility[2] = false;
                                  chipVisibility[0] = false;
                                  formSelectionIndex = 1;
                                }
                                if (maxNumber == 0) {
                                  //everything is operational
                                  chipVisibility[1] = false;
                                }

                                return await showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (_) => new StatefulBuilder(builder: (_, setState) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Container(
                                          width: 300,
                                          child: Text(
                                            formSelectionIndex == 3
                                                ? "New " + airfield + " Aircraft"
                                                : airfield + " " + aircraft[index]['type'] + 's',
                                            style: TextStyle(fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      content: FittedBox(
                                        child: Container(
                                          width: 300,
                                          child: formProcessing
                                              ? LoadingBouncingLine.circle()
                                              : Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: List<Widget>.generate(4, (int chipIndex) {
                                                        return ChoiceChip(
                                                          selectedColor: Colors.white,
                                                          label: Text(
                                                            selections[chipIndex],
                                                            style: TextStyle(
                                                                color: formSelectionIndex == chipIndex
                                                                    ? Theme.of(context).backgroundColor
                                                                    : Colors.white),
                                                          ),
                                                          selected: formSelectionIndex == chipIndex,
                                                          onSelected: !chipVisibility[chipIndex]
                                                              ? null
                                                              : (bool selected) {
                                                                  setState(() {
                                                                    formSelectionIndex = chipIndex;
                                                                    selectedNumber = 1;
                                                                  });
                                                                },
                                                        );
                                                      }),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("Number to " + selections[formSelectionIndex].toLowerCase() + ":"),
                                                            Expanded(
                                                              child: Container(),
                                                            ),
                                                            IconButton(
                                                              splashRadius: 20,
                                                              icon: Icon(
                                                                Icons.remove_circle,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (selectedNumber > 1) {
                                                                    selectedNumber--;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(width: 20),
                                                            Text(
                                                              selectedNumber.toString(),
                                                              style: TextStyle(fontSize: 30),
                                                            ),
                                                            SizedBox(width: 20),
                                                            IconButton(
                                                              splashRadius: 20,
                                                              icon: Icon(Icons.add_circle),
                                                              onPressed: () {
                                                                int maxNumber = 0;
                                                                if (formSelectionIndex == 2) {
                                                                  maxNumber = int.parse(aircraft[index]['operational'].toString());
                                                                } else if (formSelectionIndex == 0) {
                                                                  maxNumber = int.parse(aircraft[index]['operational'].toString());
                                                                } else if (formSelectionIndex == 1) {
                                                                  int total = int.parse(aircraft[index]['total'].toString());
                                                                  int op = int.parse(aircraft[index]['operational'].toString());
                                                                  maxNumber = total - op;
                                                                } else {
                                                                  maxNumber = 100;
                                                                }
                                                                setState(() {
                                                                  if (selectedNumber < maxNumber) {
                                                                    selectedNumber++;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        formSelectionIndex == 3
                                                            ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                Text("Aircraft type:"),
                                                                DropdownButton<String>(
                                                                    value: aircraftDropdownValue,
                                                                    onChanged: (String newValue) {
                                                                      setState(() {
                                                                        aircraftDropdownValue = newValue;
                                                                      });
                                                                    },
                                                                    items: Provider.of<AircraftStatusCN>(context, listen: false)
                                                                        .aircraftList
                                                                        .map<DropdownMenuItem<String>>((String value) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: value,
                                                                        child: Container(
                                                                            width: 150, child: Text(value, overflow: TextOverflow.ellipsis)),
                                                                      );
                                                                    }).toList()),
                                                              ])
                                                            : Container(),
                                                        formSelectionIndex == 2
                                                            ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                Text("Destination:"),
                                                                DropdownButton<String>(
                                                                    value: dropdownValue,
                                                                    onChanged: (String newValue) {
                                                                      setState(() {
                                                                        dropdownValue = newValue;
                                                                      });
                                                                    },
                                                                    items: Provider.of<AircraftStatusCN>(context, listen: false)
                                                                        .airfieldList
                                                                        .map<DropdownMenuItem<String>>((String value) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: value,
                                                                        child: Container(
                                                                            width: 150, child: Text(value, overflow: TextOverflow.ellipsis)),
                                                                      );
                                                                    }).toList()),
                                                              ])
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            setState(() {
                                              formProcessing = true;
                                            });
                                            await Provider.of<AircraftStatusCN>(context, listen: false).pushAirfieldInventory(
                                              formSelectionIndex,
                                              selectedNumber,
                                              formSelectionIndex == 3 ? aircraftDropdownValue : aircraft[index]['type'],
                                              Provider.of<AircraftStatusCN>(context, listen: false).airfieldBEMap[airfield],
                                              Provider.of<AircraftStatusCN>(context, listen: false).airfieldBEMap[dropdownValue],
                                              Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                              Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                            );
                                            formProcessing = false;
                                            Navigator.pop(context);
                                          },
                                          child: Tooltip(
                                            message: "Submitting this would " +
                                                (formSelectionIndex == 2 && airfield == dropdownValue
                                                    ? "have no effect."
                                                    : selections[formSelectionIndex].toLowerCase() +
                                                        " " +
                                                        selectedNumber.toString() +
                                                        "x " +
                                                        aircraft[index]['type'] +
                                                        (selectedNumber > 1 ? "s" : "") +
                                                        ((formSelectionIndex == 3) ? "to" : " from ") +
                                                        airfield +
                                                        (formSelectionIndex == 2 ? " to " + dropdownValue : "")),
                                            child: Text("Submit"),
                                            waitDuration: Duration(milliseconds: 500),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                                );
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
