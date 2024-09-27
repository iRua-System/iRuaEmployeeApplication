import 'dart:convert';

import 'package:cwa_irua_employee/constants/constants.dart';
import 'package:http/http.dart' as http;

class CheckNfcProvider {
  Future<String?> checkNfc(String transId, nfc) async {
    String url = API_URL +
        "/Employees/MatchNFC?TransactionId=" +
        transId +
        "&NewNFC=" +
        nfc;
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return "OK";
      } else {
        if (response.statusCode == 400) {
          final data = json.decode(response.body);
          var message = data['message'];
          if (message == "Request OTP") {
            return "OTP";
          } else if (message == "Invalid Employee") {
            return "Invalid";
          } else if (message == "Busy Employee") {
            return "Busy";
          } else if (message == "Wrong Input") {
            return "Wrong Input";
          } else if (message == "Wrong Ordered") {
            return "Wrong Ordered";
          }
        }
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return null;
  }
}
