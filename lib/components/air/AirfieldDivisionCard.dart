import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/AirfieldStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'AirfieldStatusCard.dart';

class AirfieldDivisionCard extends StatelessWidget {
  const AirfieldDivisionCard({this.airDivision});
  final int airDivision;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String airDivisionString;

    List<AirfieldStatus> airfieldStatusList = Provider.of<AirFieldStatusCN>(context, listen: true).airfieldStatus;

    List<Widget> airfieldStatusCards = List.generate(
      airfieldStatusList.where((element) => element.airdiv == airDivision).toList().length,
          (index) => AirfieldStatusCard(
        airfieldStatus: airfieldStatusList.where((element) => element.airdiv == airDivision).toList()[index],
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
                crossAxisCount: MediaQuery.of(context).size.width >= 1540 ? 3 : 2,
                itemCount: airfieldStatusCards.length,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemBuilder: (_, index) => airfieldStatusCards[index],
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1)),
          ],
        ),
      ),
    );
  }
}