import 'dart:convert';

import 'package:cwa_irua_employee/constants/constants.dart';

import 'package:http/http.dart' as http;

class TakeOrderProvider {
  Future<String> takeOrder(
      String transactionId, String nfc, String code) async {
    String url = API_URL + "/Transaction/Working/" + transactionId;
    String body = json.encode({'serialNumNfc': nfc, 'code': code});
    try {
      var response = await http.put(
        Uri.parse(url),
        body: body,
        headers: {"Content-Type": "application/json"},
      );
      print(url);
      print(body);
      print(response.body);
      if (response.statusCode != 500) {
        final data = json.decode(response.body);
        if (response.statusCode == 200) {
          return "Success";
        } else if (data['message'] == "Invalid Employee") {
          return "Emp";
        } else if (data['message'] == "Invalid Code") {
          return "Code";
        } else if (data['message'] == "Busy Employee") {
          return "Busy";
        }
      }
    } catch (e) {
      print(e);
      throw Exception("Network");
    }
    return "Fail";
  }
}
