import 'dart:convert';

import 'package:dash/helpers/models.dart';
import 'package:dash/helpers/test_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SAMStatusCN extends ChangeNotifier {
  List<AirfieldStatus> airfieldStatus = [];
  List<SAMStatus> samStatus = [];
  List<String> samTypeList = [];
  List<String> samNameList = [];

  List<String> airfieldList = [];
  List<int> airDivisionList = [];
  bool loading = true;
  int refreshRate = 20; //default timer
  String datetime = "Loading...";
  String lang = "en";

  Future<void> updateSAMStatus() async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    refreshRate = configJSON['refresh_rate']; //Here instead of theme to leave option for tab customization

    airfieldStatus = [];
    airfieldList = [];
    airDivisionList = [];

    samStatus = [];
    samTypeList = [];
    samNameList = [];

    if (configJSON['use_test_data'] == true) {
      // USING TEST DATA
      print("No test data available");
    } else {
      //USING SERVER DATA
      String url2 = configJSON['sam_get'] + "?lang=" + lang;
      var response2 = await http.get(Uri.parse(url2));
      if (response2.statusCode == 200) {
        var retrievedData = json.decode(response2.body)['data'].toList();
        datetime = json.decode(response2.body)['datetime'];
        for (int i = 0; i < retrievedData.length; i++) {
          //populate SAMStatus list with response data
          SAMStatus newEntry = SAMStatus.fromJson(retrievedData[i]);
          samStatus.add(newEntry);
          //create unique list of all the types and names
          if (!samTypeList.contains(newEntry.type)) {
            samTypeList.add(newEntry.type);
          }
          if (!samNameList.contains(newEntry.name)) {
            samNameList.add(newEntry.name);
          }
        }
        //airfieldStatus.sort((a, b) => a.name.compareTo(b.name));
        samNameList.sort((a, b) => a.compareTo(b));
        samTypeList.sort((a, b) => a.compareTo(b));
      }
    }
    notifyListeners();
  }

  Future<void> pushSAMStatus(String item, String field, String status, String apiKey, String user) async {
    String configString = await rootBundle.loadString('config/config.json');
    Map configJSON = json.decode(configString);
    if (configJSON['use_test_data'] == false) {
      String url = configJSON['sam_post'] + "?lang=" + lang;
      var response = await http.post(Uri(path: url),
          body: jsonEncode(<String, dynamic>{
            'item': item, //todo make be number instead of afld name
            'field': field,
            'status': status,
            'key': apiKey,
            'user': user,
          }));
      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Error!",
          webBgColor: "#dc2a2a",
          timeInSecForIosWeb: 3,
          webPosition: "right",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Success!",
          webBgColor: "#28A228",
          timeInSecForIosWeb: 3,
          webPosition: "right",
        );
        updateSAMStatus();
      }
    }
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
