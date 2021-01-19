class AirfieldStatus {
  AirfieldStatus({this.name, this.status, this.be, this.airdiv, this.rw, this.tw, this.ugf, this.pol, this.ms, this.rf});
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
    );
  }
}
