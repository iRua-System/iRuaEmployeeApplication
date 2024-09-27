import 'dart:async';

import 'package:cwa_irua_employee/model/employee.dart';
import 'package:cwa_irua_employee/provider/checkNfc_provider.dart';
import 'package:cwa_irua_employee/widget/dialog.dart';
import 'package:flutter/material.dart';

class CheckNfcBloc {
  StreamController checkNfcStream = new StreamController.broadcast();
  Stream get checkNfc => checkNfcStream.stream.asBroadcastStream();

  Future<String?> checkNfcBloc(
      context, String transId, nfc, List<Employee> listEmp) async {
    print("Bloc Check");
    var check = CheckNfcProvider();
    var result = await check.checkNfc(transId, nfc).catchError((error) {
      OpenDialog.displayDialog("Error", context, "Check your connection");
    });
    print(result);
    if (result == "OK") {
      return "OK";
    } else {
      if (result == "OTP") {
        var hexNfc = num.tryParse(nfc)!.toInt().toRadixString(16);
        bool check = listEmp
                .where((element) => element.serialNumNfc
                    .toLowerCase()
                    .contains(hexNfc.toString().toLowerCase()))
                .toList()
                .length >
            0;
        if (check) {
          for (var emp in listEmp) {
            if (emp.serialNumNfc.contains(hexNfc.toString().toLowerCase()) &&
                emp.listTransaction.isEmpty) {
              return "OTP";
            }
          }
          Navigator.of(context).pop();
          OpenDialog.displayDialog("Error", context, "Employee is busy!");
          return null;
        } else if (!check) {
          Navigator.of(context).pop();
          OpenDialog.displayDialog("Error", context,
              "Employee hasn't taken attendance so that can't take order!");
          return null;
        }
      } else if (result == "Busy") {
        Navigator.of(context).pop();
        OpenDialog.displayDialog(
            "Error", context, "Employee is currently busy!!!");
        return null;
      } else if (result == "Wrong Input") {
        Navigator.of(context).pop();
        OpenDialog.popupDialog("Error", context, "Card ID is not existed!");
        return null;
      } else if (result == "Wrong Ordered") {
        print('alooo');
        Navigator.of(context).pop();
        OpenDialog.displayDialog(
            "Error", context, "Please take order in sequence!");
        return null;
      }
    }
    return "Invalid";
  }

  void dispose() {
    checkNfcStream.close();
  }
}
