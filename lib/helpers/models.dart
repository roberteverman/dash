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
