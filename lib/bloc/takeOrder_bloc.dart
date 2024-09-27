import 'dart:async';

import 'package:cwa_irua_employee/helper/noti.dart';
import 'package:cwa_irua_employee/provider/takeOrder_provider.dart';
import 'package:cwa_irua_employee/widget/dialog.dart';
import 'package:flutter/material.dart';

class TakeOrderBloc {
  StreamController takeOrder = new StreamController();
  StreamController isChecking = new StreamController();
  Stream get isCheckingStream => isChecking.stream;
  Stream get takeOrderStream => takeOrder.stream;

  Future<bool> takeOrderBloc(context, String nfc, String transactionId,
      String? code, bool check, String deviceToken) async {
    isChecking.sink.add("Logging");
    print("Bloc Check");
    var takeOrderProvider = TakeOrderProvider();
    var result = await takeOrderProvider
        .takeOrder(transactionId, nfc, code ?? '')
        .catchError((error) {
      OpenDialog.popupDialog("Error", context, "Please check your connection");
      isChecking.sink.add("Done");
    });
    if (check) {
      Navigator.of(context).pop();
    }
    if (result == "Success") {
      isChecking.sink.add("Done");
      PushNoti().sendNotiToUser(
          "Đơn hàng của bạn đang được nhân viên thực hiện!", deviceToken);
      OpenDialog.displayDialog("Success", context, "Take order success!");
      return true;
    } else if (result == "Emp") {
      isChecking.sink.add("Done");
      OpenDialog.popupDialog("Error", context, "Card ID is not existed!");
    } else if (result == "Code") {
      isChecking.sink.add("Done");
      OpenDialog.popupDialog("Error", context, "Failure!");
    } else if (result == "Busy") {
      isChecking.sink.add("Done");
      OpenDialog.popupDialog("Error", context, "Employee is currently busy!");
    } else {
      isChecking.sink.add("Done");
      OpenDialog.popupDialog("Error", context, "Take order fail!");
    }
    return false;
  }

  void dispose() {
    takeOrder.close();
    isChecking.close();
  }
}
