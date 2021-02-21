class AirfieldStatus {
  AirfieldStatus({this.name, this.status, this.be, this.airdiv, this.rw, this.tw, this.ugf, this.pol, this.ms, this.rf, this.lat, this.lon});
  String name;
  String status;
  String be;
  int airdiv;
  String rw;
  String tw;
  String ugf;
  String pol;
  String ms;
  String rf;
  double lat;
  double lon;

  factory AirfieldStatus.fromJson(Map<String, dynamic> json) {
    return AirfieldStatus(
        name: json['airfield'],
        status: json['status'],
        be: json['be'],
        airdiv: json['airdiv'],
        rw: json['rw'],
        tw: json['tw'],
        ugf: json['ugf'],
        pol: json['pol'],
        ms: json['ms'],
        rf: json['rf'],
        lat: json['lat'],
        lon: json['lon']);
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
  SAMStatus({this.type, this.name, this.lat, this.lon, this.status, this.be, this.rcb, this.lcb, this.c2b, this.rdr});
  String type;
  String name;
  double lat;
  double lon;
  String status;
  String be;
  String rcb;
  String lcb;
  String c2b;
  String rdr;

  factory SAMStatus.fromJson(Map<String, dynamic> json) {
    return SAMStatus(
        type: json['type'],
        name: json['name'],
        lat: json['lat'],
        lon: json['lon'],
        status: json['status'],
        be: json['be'],
        rcb: json['rcb'],
        lcb: json['lcb'],
        c2b: json['c2b'],
        rdr: json['rdr']);
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
      vesselClass: json['class'],
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
