import 'package:dash/components/air/SAMStatusCard.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/SAMStatusCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SAMTypeCard extends StatelessWidget {
  const SAMTypeCard({this.samType});
  final String samType;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // List<AirfieldStatus> airfieldStatusList = Provider.of<SAMStatusCN>(context, listen: true).airfieldStatus;
    List<SAMStatus> samStatusList = Provider.of<SAMStatusCN>(context, listen: true).samStatus;
    samStatusList.sort((a, b) => a.name.compareTo(b.name));

    // List<Widget> airfieldStatusCards = List.generate(
    //   airfieldStatusList.where((element) => element.airdiv == airDivision).toList().length,
    //   (index) => SAMStatusCard(
    //     airfieldStatus: airfieldStatusList.where((element) => element.airdiv == airDivision).toList()[index],
    //   ),
    // );

    List<Widget> samStatusCards = List.generate(
      samStatusList.where((element) => element.type == samType).toList().length,
      (index) => SAMStatusCard(
        samStatus: samStatusList.where((element) => element.type == samType).toList()[index],
      ),
    );

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: theme.primaryColorDark),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              samType,
              style: TextStyle(fontSize: 15),
            ),
            StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                crossAxisCount: MediaQuery.of(context).size.width >= 1540 ? 3 : 2,
                itemCount: samStatusCards.length,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemBuilder: (_, index) => samStatusCards[index],
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1)),
          ],
        ),
      ),
    );
  }
}
