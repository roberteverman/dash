import 'package:circular_menu/circular_menu.dart';
import 'package:dash/helpers/models.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class GroundMap2 extends StatefulWidget {
  @override
  _GroundMap2State createState() => _GroundMap2State();
}

class _GroundMap2State extends State<GroundMap2> {
  MapShapeLayerController mapShapeLayerController;
  List<Marker> markers;
  int selectedIndex;
  bool keySelected = false;
  double keyX = 15;
  double keyY = 15;
  bool showComponents = false;

  @override
  void initState() {
    super.initState();
    mapShapeLayerController = new MapShapeLayerController();
  }

  @override
  void dispose() {
    mapShapeLayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<GroundUnitStatus> groundChildrenStatusList = Provider.of<GroundChartCN>(context, listen: true).childrenStatus;
    // GroundUnitStatus groundParentStatus = Provider.of<GroundChartCN>(context, listen: true).parentStatus;

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Theme.of(context).primaryColorDark),
      clipBehavior: Clip.hardEdge,
      child: SfMaps(
        layers: [
          Provider.of<GroundChartCN>(context, listen: true).mapShapeLayer,
          // MapTileLayer(
          //   urlTemplate: Provider.of<AirChartCN>(context, listen: true).mapServerURL,
          // )
          // MapShapeLayer(
          //   zoomPanBehavior: MapZoomPanBehavior(
          //     toolbarSettings: MapToolbarSettings(
          //       position: MapToolbarPosition.bottomRight,
          //       direction: Axis.vertical,
          //     ),
          //   ),
          //   // showDataLabels: true,
          //   source: MapShapeSource.network(
          //     Provider.of<GroundChartCN>(context, listen: false).mapShapeSource,
          //     shapeDataField: Provider.of<GroundChartCN>(context, listen: false).shapeDataField,
          //     // shapeDataField: "ADM1_EN",
          //   ),
          //   initialMarkersCount: groundChildrenStatusList.length + 1,
          //   markerTooltipBuilder: (BuildContext context, int i) {
          //     if (i == groundChildrenStatusList.length) {
          //       return Text(
          //         groundParentStatus.name + "\nStrength: " + groundParentStatus.strength.toString() + "%",
          //         style: TextStyle(
          //           color: Colors.black,
          //         ),
          //       );
          //     } else {
          //       return Text(
          //         groundChildrenStatusList[i].name + "\nStrength: " + groundChildrenStatusList[i].strength.toString() + "%",
          //         style: TextStyle(
          //           color: Colors.black,
          //         ),
          //       );
          //     }
          //   },
          //   markerBuilder: (BuildContext context, int i) {
          //     if (i == groundChildrenStatusList.length) {
          //       return MapMarker(
          //         latitude: groundParentStatus.lat,
          //         longitude: groundParentStatus.lon,
          //         child: Image.asset("images/SymbolServer.png"), //todo set up so that image from network works
          //       );
          //     } else {
          //       return MapMarker(
          //         latitude: groundChildrenStatusList[i].lat,
          //         longitude: groundChildrenStatusList[i].lon,
          //         child: Image.asset("images/SymbolServer.png"), //todo set up so that image from network works
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
