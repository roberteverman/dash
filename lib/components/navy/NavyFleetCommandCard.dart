import 'package:dash/components/navy/NavyVesselStatusCard.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/navy/NavyVesselCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class NavyFleetCommandCard extends StatelessWidget {
  const NavyFleetCommandCard({this.navyFleet, this.description});
  final String navyFleet;
  final String description;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<NavyFleetInventory> navyFleetInventoryList = Provider.of<NavyVesselCN>(context, listen: true).navyFleetInventoryList;
    NavyFleetInventory navyFleetInventory = navyFleetInventoryList.where((element) => element.fleet == navyFleet).toList()[0];

    List<Widget> navyVesselStatusCards = List.generate(
      navyFleetInventory.navyVesselCategoryList.length,
      (index) => NavyVesselStatusCard(
        navyVesselCategory: navyFleetInventory.navyVesselCategoryList[index],
        fleet: navyFleet,
        description: description,
      ),
    );

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
              crossAxisCount: 2,
              itemCount: navyVesselStatusCards.length,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              itemBuilder: (_, index) => navyVesselStatusCards[index],
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              addAutomaticKeepAlives: false,
            ),
          ],
        ),
      ),
    );
  }
}
