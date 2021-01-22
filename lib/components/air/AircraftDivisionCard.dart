import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/AircraftStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'AircraftStatusCard.dart';

class AircraftDivisionCard extends StatelessWidget {
  const AircraftDivisionCard({this.airDivision});
  final int airDivision;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String airDivisionString;
    int crossAxisCount;

    List<AirfieldInventory> aircraftStatusList = Provider.of<AircraftStatusCN>(context, listen: true).airfieldInventory;

    List<Widget> aircraftStatusCards = List.generate(
      aircraftStatusList.where((element) => element.airdiv == airDivision).toList().length,
      (index) => AircraftStatusCard(
        aircraftStatus: aircraftStatusList.where((element) => element.airdiv == airDivision).toList()[index],
      ),
    );

    switch (airDivision % 10) {
      case 1:
        airDivisionString = airDivision.toString() + "st Air Division";
        break;
      case 2:
        airDivisionString = airDivision.toString() + "nd Air Division";
        break;
      case 3:
        airDivisionString = airDivision.toString() + "rd Air Division";
        break;
      default:
        airDivisionString = airDivision.toString() + "th Air Division";
        break;
    }

    if (MediaQuery.of(context).size.width < 825) {
      crossAxisCount = 2;
    } else if (MediaQuery.of(context).size.width < 1050) {
      crossAxisCount = 3;
    } else if (MediaQuery.of(context).size.width < 1400) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorDark),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              airDivisionString,
              style: TextStyle(fontSize: 15),
            ),
            StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                crossAxisCount: crossAxisCount,
                itemCount: aircraftStatusCards.length,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemBuilder: (_, index) => aircraftStatusCards[index],
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1)),
          ],
        ),
      ),
    );
  }
}
