import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class NavyVesselStatusCard extends StatelessWidget {
  const NavyVesselStatusCard({this.navyVesselCategory, this.fleet});
  final NavyVesselCategory navyVesselCategory;
  final String fleet;

  @override
  Widget build(BuildContext context) {
    bool formProcessing = false;
    int formSelectionIndex = 0;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Center(
                child: Text(
                  //todo add function to create new inventory
                  navyVesselCategory.category,
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              DataTable(
                sortColumnIndex: 0,
                sortAscending: true,
                columnSpacing: 10,
                showBottomBorder: true,
                showCheckboxColumn: false,
                columns: [
                  DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          'Class',
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        '',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          'Total',
                        ),
                      ),
                    ),
                  ),
                ],
                rows: List.generate(
                  navyVesselCategory.vesselClassStatusList.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            navyVesselCategory.vesselClassStatusList[index].vesselClass,
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        LinearPercentIndicator(
                          // width: 50,
                          lineHeight: 10.0,
                          percent:
                              navyVesselCategory.vesselClassStatusList[index].operational / navyVesselCategory.vesselClassStatusList[index].total,
                          animateFromLastPercent: true,
                          backgroundColor: Colors.white24,
                          progressColor: Colors.white,
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            navyVesselCategory.vesselClassStatusList[index].operational.toString() +
                                ' / ' +
                                navyVesselCategory.vesselClassStatusList[index].total.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    onSelectChanged: !Provider.of<ThemeChanger>(context, listen: true).navyAdmin
                        ? null
                        : (selected) async {
                            int selectedNumber = 1;
                            List<String> selections = ['Destroy', 'Revive'];
                            formProcessing = false;

                            List<bool> chipVisibility = [true, true];
                            formSelectionIndex = 0;
                            int totalVessels = navyVesselCategory.vesselClassStatusList[index].total;
                            int opVessels = navyVesselCategory.vesselClassStatusList[index].operational;

                            if (opVessels == 0) {
                              chipVisibility[0] = false;
                              formSelectionIndex = 1;
                            }
                            if (totalVessels - opVessels == 0) {
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
                                        fleet +
                                            "\n" +
                                            navyVesselCategory.vesselClassStatusList[index].vesselClass +
                                            " " +
                                            navyVesselCategory.category,
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  content: FittedBox(
                                    child: Container(
                                      width: 300,
                                      // child: Text("Hello"),
                                      child: formProcessing
                                          ? LoadingBouncingLine.circle()
                                          : Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: List<Widget>.generate(2, (int chipIndex) {
                                                    return ChoiceChip(
                                                      selectedColor: Colors.white,
                                                      label: Text(
                                                        selections[chipIndex],
                                                        style: TextStyle(
                                                          color: formSelectionIndex == chipIndex ? Theme.of(context).backgroundColor : Colors.white,
                                                        ),
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
                                                            if (formSelectionIndex == 0) {
                                                              //can't destroy more than is operational
                                                              maxNumber =
                                                                  int.parse(navyVesselCategory.vesselClassStatusList[index].operational.toString());
                                                            } else if (formSelectionIndex == 1) {
                                                              //can't revive more than is destroyed
                                                              maxNumber = navyVesselCategory.vesselClassStatusList[index].total -
                                                                  navyVesselCategory.vesselClassStatusList[index].operational;
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
                                        await Provider.of<NavyVesselCN>(context, listen: false).pushNavyInventory(
                                          formSelectionIndex,
                                          selectedNumber,
                                          navyVesselCategory.vesselClassStatusList[index].vesselClass,
                                          fleet,
                                          navyVesselCategory.category,
                                          Provider.of<ThemeChanger>(context, listen: false).apiKey,
                                          Provider.of<ThemeChanger>(context, listen: false).currentUser,
                                        );
                                        formProcessing = false;
                                        Navigator.pop(context);
                                      },
                                      child: Tooltip(
                                        message: "Submitting this would " +
                                            selections[formSelectionIndex].toLowerCase() +
                                            " " +
                                            selectedNumber.toString() +
                                            " " +
                                            fleet +
                                            " " +
                                            navyVesselCategory.vesselClassStatusList[index].vesselClass +
                                            " " +
                                            navyVesselCategory.category.toLowerCase(),
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
        ),
      ),
    );
  }
}
