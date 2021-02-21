import 'package:auto_size_text/auto_size_text.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/tbm/TBMStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class TBMStatusCard extends StatelessWidget {
  const TBMStatusCard({this.tbmClassStatus, this.tbmType});
  final TBMClassStatus tbmClassStatus;
  final String tbmType;

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
                  tbmClassStatus.tbmClass,
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
                          'Item',
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
                  2,
                  (index) => DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Text(
                            index == 0 ? "Missiles" : "TELs",
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
                          percent: index == 0 ? tbmClassStatus.mslTotal / tbmClassStatus.mslInit : tbmClassStatus.telTotal / tbmClassStatus.telInit,
                          animateFromLastPercent: true,
                          backgroundColor: Colors.white24,
                          progressColor: Colors.white,
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            index == 0
                                ? tbmClassStatus.mslTotal.toString() + ' / ' + tbmClassStatus.mslInit.toString()
                                : tbmClassStatus.telTotal.toString() + ' / ' + tbmClassStatus.telInit.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    onSelectChanged: !Provider.of<ThemeChanger>(context, listen: true).spaceAdmin
                        ? null
                        : (selected) async {
                            int selectedNumber = 1;
                            List<String> selections = ['Destroy', 'Revive'];
                            formProcessing = false;

                            return await showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) => new StatefulBuilder(builder: (_, setState) {
                                return AlertDialog(
                                  title: Center(
                                    child: Container(
                                      width: 300,
                                      child: Text(
                                        index == 0 ? tbmClassStatus.tbmClass + " Missiles" : tbmClassStatus.tbmClass + " TELs",
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
                                                  children: List<Widget>.generate(2, (int index) {
                                                    return ChoiceChip(
                                                      selectedColor: Colors.white,
                                                      label: Text(
                                                        selections[index],
                                                        style: TextStyle(
                                                          color: formSelectionIndex == index ? Theme.of(context).backgroundColor : Colors.white,
                                                        ),
                                                      ),
                                                      selected: formSelectionIndex == index,
                                                      onSelected: (bool selected) {
                                                        setState(() {
                                                          formSelectionIndex = selected ? index : null;
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
                                                              if (index == 0) {
                                                                maxNumber = tbmClassStatus.mslTotal;
                                                              } else {
                                                                maxNumber = tbmClassStatus.telTotal;
                                                              }
                                                            } else if (formSelectionIndex == 1) {
                                                              //can't revive more than is destroyed
                                                              if (index == 0) {
                                                                maxNumber = tbmClassStatus.mslInit - tbmClassStatus.mslTotal;
                                                              } else {
                                                                maxNumber = tbmClassStatus.telInit - tbmClassStatus.telTotal;
                                                              }
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
                                        await Provider.of<TBMStatusCN>(context, listen: false).pushTBMInventory(
                                          formSelectionIndex,
                                          selectedNumber,
                                          index == 0 ? "missile" : "tel",
                                          tbmType,
                                          tbmClassStatus.tbmClass,
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
                                            tbmClassStatus.tbmClass +
                                            " " +
                                            (index == 0 ? "missiles." : "TELs."),
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
