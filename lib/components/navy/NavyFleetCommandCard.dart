import 'package:dash/components/navy/NavyVesselStatusCard.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class NavyFleetCommandCard extends StatelessWidget {
  const NavyFleetCommandCard({this.navyFleet});
  final String navyFleet;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int crossAxisCount;

    List<NavyFleetInventory> navyFleetInventoryList = Provider.of<NavyVesselCN>(context, listen: true).navyFleetInventoryList;
    NavyFleetInventory navyFleetInventory = navyFleetInventoryList.where((element) => element.fleet == navyFleet).toList()[0];

    // for (var item in navyFleetInventory.navyVesselCategoryList) {
    //   print(item.category);
    // }

    List<Widget> navyVesselStatusCards = List.generate(
      navyFleetInventory.navyVesselCategoryList.length,
      (index) => NavyVesselStatusCard(
        navyVesselCategory: navyFleetInventory.navyVesselCategoryList[index],
        fleet: navyFleet,
      ),
    );

    // switch (airDivision % 10) {
    //   case 1:
    //     airDivisionString = airDivision.toString() + "st Air Division";
    //     break;
    //   case 2:
    //     airDivisionString = airDivision.toString() + "nd Air Division";
    //     break;
    //   case 3:
    //     airDivisionString = airDivision.toString() + "rd Air Division";
    //     break;
    //   default:
    //     airDivisionString = airDivision.toString() + "th Air Division";
    //     break;
    // }

    if (MediaQuery.of(context).size.width < 825) {
      crossAxisCount = 2;
    } else if (MediaQuery.of(context).size.width < 1050) {
      crossAxisCount = 2;
    } else if (MediaQuery.of(context).size.width < 1400) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorDark),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              navyFleet,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                crossAxisCount: crossAxisCount,
                itemCount: navyVesselStatusCards.length,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemBuilder: (_, index) => navyVesselStatusCards[index],
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1)),
          ],
        ),
      ),
    );
  }
}
