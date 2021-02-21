import 'package:dash/components/tbm/TBMStatusCard.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/tbm/TBMStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class TBMTypeCard extends StatelessWidget {
  const TBMTypeCard({this.tbmType});
  final String tbmType;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int crossAxisCount;

    List<TBMInventory> tbmInventoryList = Provider.of<TBMStatusCN>(context, listen: true).tbmInventoryList;
    TBMInventory tbmInventory = tbmInventoryList.where((element) => element.tbmType == tbmType).toList()[0];
    tbmInventory.tbmClassStatusList.sort((a, b) => a.tbmClass.compareTo(b.tbmClass));

    List<Widget> tbmStatusCards = List.generate(
      tbmInventory.tbmClassStatusList.length,
      (index) => TBMStatusCard(
        tbmClassStatus: tbmInventory.tbmClassStatusList[index],
        tbmType: tbmType,
      ),
    );

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
              tbmType,
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
                itemCount: tbmStatusCards.length,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemBuilder: (_, index) => tbmStatusCards[index],
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1)),
          ],
        ),
      ),
    );
  }
}
