import 'dart:async';
import 'dart:convert';

import 'package:cwa_irua_employee/bloc/takeOrder_bloc.dart';
import 'package:cwa_irua_employee/widget/dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PushNoti {
  late DatabaseReference _notiRequest;
  late StreamSubscription approveStreamSubscription;
  late DatabaseReference _approveRequest;
  TakeOrderBloc takeBloc = TakeOrderBloc();
  PushNoti() {
    _notiRequest = FirebaseDatabase.instance.ref().child("takeOrder");
    _approveRequest = FirebaseDatabase.instance.ref();
  }

  void updateNoti(String oldEmp, newEmp, transInfo) {
    print("noti ne");

    _notiRequest.update({
      "newEmp": newEmp,
      "oldEmp": oldEmp,
      "transInfo": transInfo,
      "approve": "request"
    });
  }

  void listenToUpdateNoti(context, nfc, transId, deviceToken) {
    _approveRequest.child('takeOrder');
    approveStreamSubscription = _approveRequest.onChildChanged.listen((event) {
      DataSnapshot data = event.snapshot;
      Map<dynamic, dynamic>? value = data.value as Map<dynamic, dynamic>?;
      String approve = value!['approve'].toString();
      print(approve);
      if (approve == "Đồng ý") {
        takeBloc.takeOrderBloc(context, nfc, transId, "", true, deviceToken);
      } else if (approve == "Không đồng ý") {
        Navigator.of(context).pop();
        OpenDialog.displayDialog(
            "Error", context, "Chủ cửa hàng không đồng ý!!!");
      }
    });
  }

  Future<bool> sendNotiToUser(String body, deviceToken) async {
    String url = "https://fcm.googleapis.com/fcm/send";
    String key =
        "AAAALsDeKYg:APA91bGI6dxJLQbI2-kfLS0jc_vpKHUzokMFHiVZvWimr1u6d8trNcaG_roSmB14Fys_n3vQAIky9lh1sl3oNCQOO-Lj4eavxlL5BwQADjIevEAIVtJN3wwanIPp1fnTSYb_-nINnGqC";
    String transactionBody = json.encode({
      'notification': {
        "title": "Thông báo",
        "body": body,
      },
      'priority': 'high',
      'data': {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
      'to': deviceToken
    });
    print(transactionBody);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "key=" + key
          },
          body: transactionBody);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    // }
  }
}
