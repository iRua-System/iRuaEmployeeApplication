import 'dart:convert';

import 'package:cwa_irua_employee/constants/constants.dart';
import 'package:http/http.dart' as http;

class TakeAttendanceProvider {
  Future<bool> takeAttendance(String nfc) async {
    String url = API_URL + "/Employees/TakeAttendance";
    String transactionBody = json.encode({'username': nfc});
    try {
      var response = await http.post(
        Uri.parse(url),
        body: transactionBody,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return false;
  }

  Future<bool> logout(String nfc) async {
    String url = API_URL + "/Employees/Leave?serialNFC=$nfc";
    try {
      var response =
          await http.delete(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("error");
      throw Exception("Netword");
    }
    return false;
  }
}
