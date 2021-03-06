class AirfieldStatus {
  AirfieldStatus({this.name, this.status, this.be, this.airdiv, this.components, this.lat, this.lon});
  String name;
  String status;
  String be;
  int airdiv;
  List<dynamic> components;
  double lat;
  double lon;

  factory AirfieldStatus.fromJson(Map<String, dynamic> json) {
    return AirfieldStatus(
        name: json['airfield'],
        status: json['status'],
        be: json['be'],
        airdiv: json['airdiv'],
        components: json['component'],
        lat: json['lat'],
        lon: json['lon']);
  }
}

class NavcomStatus {
  NavcomStatus({this.navcom, this.status, this.be, this.lat, this.lon});
  String navcom;
  String status;
  String be;
  double lat;
  double lon;

  factory NavcomStatus.fromJson(Map<String, dynamic> json) {
    return NavcomStatus(navcom: json['navcom'], status: json['status'], be: json['be'], lat: json['lat'], lon: json['lon']);
  }
}

class AirfieldInventory {
  AirfieldInventory({this.name, this.status, this.airdiv, this.aircraft, this.lat, this.lon, this.be});
  String name;
  String status;
  int airdiv;
  List<dynamic> aircraft;
  double lat;
  double lon;
  String be;

  factory AirfieldInventory.fromJson(Map<String, dynamic> json) {
    return AirfieldInventory(
      name: json['airfield'],
      status: json['status'],
      aircraft: json['aircraft'],
      airdiv: json['airdiv'],
      lat: json['lat'],
      lon: json['lon'],
      be: json['be'],
    );
  }
}

class SAMStatus {
  SAMStatus({this.type, this.name, this.lat, this.lon, this.status, this.be, this.components});
  String type;
  String name;
  double lat;
  double lon;
  String status;
  String be;
  List<dynamic> components;

  factory SAMStatus.fromJson(Map<String, dynamic> json) {
    return SAMStatus(
        type: json['type'],
        name: json['name'],
        lat: json['lat'],
        lon: json['lon'],
        status: json['status'],
        be: json['be'],
        components: json['component']);
  }
}

class GroundUnitStatus {
  GroundUnitStatus({this.name, this.strength, this.lat, this.lon, this.parent, this.symbol});
  String name;
  int strength;
  double lat;
  double lon;
  String parent;
  String symbol;

  factory GroundUnitStatus.fromJson(Map<String, dynamic> json) {
    return GroundUnitStatus(
      name: json['unit_title'],
      strength: json['unit_strength'],
      lat: json['lat'],
      lon: json['lon'],
      parent: json['parent_title'],
      symbol: json['symbol_url'],
    );
  }
}

class NavyFleetInventory {
  String fleet;
  List<NavyVesselCategory> navyVesselCategoryList;
}

class NavyVesselCategory {
  String category;
  List<NavyVesselClassStatus> vesselClassStatusList;
}

class NavyVesselClassStatus {
  NavyVesselClassStatus({this.vesselClass, this.total, this.operational});
  String vesselClass;
  int total;
  int operational;

  factory NavyVesselClassStatus.fromJSON(Map<String, dynamic> json) {
    return NavyVesselClassStatus(
      vesselClass: json['item'],
      total: json['total'],
      operational: json['operational'],
    );
  }
}

class TBMInventory {
  String tbmType;
  List<TBMClassStatus> tbmClassStatusList;
}

class TBMClassStatus {
  TBMClassStatus({this.tbmClass, this.mslInit, this.mslTotal, this.telInit, this.telTotal});
  String tbmClass;
  int mslInit;
  int mslTotal;
  int telInit;
  int telTotal;
}
