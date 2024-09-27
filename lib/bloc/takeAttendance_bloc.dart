import 'dart:async';

import 'package:cwa_irua_employee/provider/takeAttendance_provider.dart';
import 'package:cwa_irua_employee/widget/dialog.dart';
import 'package:flutter/material.dart';

class TakeAttendanceBloc {
  StreamController takeAttendance = new StreamController();
  StreamController isLogging = new StreamController();
  StreamController logoutController = new StreamController();
  Stream get isLoggingStream => isLogging.stream;
  Stream get takeAttendanceStream => takeAttendance.stream;
  Stream get logoutStream => logoutController.stream;

  Future<bool> takeAttendanceNfc(context, String nfc, content) async {
    isLogging.sink.add("Logging");
    print("Bloc Check");
    var takeAttendanceProvider = TakeAttendanceProvider();
    var result =
        await takeAttendanceProvider.takeAttendance(nfc).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Please check your connection");
      isLogging.sink.add("Done");
    });
    if (content == "2") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    if (content == "1") {
      Navigator.of(context).pop();
    }
    print(result);
    if (result) {
      isLogging.sink.add("Done");
      OpenDialog.displayDialog("Success", context, "Take attendance success!");
      return true;
    } else {
      isLogging.sink.add("Done");
      OpenDialog.displayDialog("Error", context, "Take attendance fail");
      return false;
    }
  }

  Future<bool> logout(context, String nfc, content) async {
    isLogging.sink.add("Logging");
    var takeAttendanceProvider = TakeAttendanceProvider();
    var result = await takeAttendanceProvider.logout(nfc).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Please check your connection");
      isLogging.sink.add("Done");
    });
    if (content == "2") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    if (content == "1") {
      Navigator.of(context).pop();
    }

    if (result) {
      isLogging.sink.add("Complete");
      OpenDialog.displayDialog(
          "Success", context, "Thank you for working so hard today!");
      return true;
    } else {
      isLogging.sink.add("Done");
      OpenDialog.displayDialog("Error", context, "Please try again!");
      return false;
    }
  }

  void dispose() {
    isLogging.close();
    takeAttendance.close();
    logoutController.close();
  }
}
