import 'package:cwa_irua_employee/bloc/checkNfc_bloc.dart';
import 'package:cwa_irua_employee/bloc/takeAttendance_bloc.dart';
import 'package:cwa_irua_employee/bloc/takeOrder_bloc.dart';
import 'package:cwa_irua_employee/constants/constants.dart';
import 'package:cwa_irua_employee/helper/noti.dart';
import 'package:cwa_irua_employee/model/employee.dart';
import 'package:cwa_irua_employee/widget/backButton.dart';
import 'package:cwa_irua_employee/widget/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class NfcScreen extends StatefulWidget {
  final String? deviceToken;
  final String? transId;
  final String? phoneNumber;
  final String? status;
  final String? content;
  final List<Employee>? listEmp;
  final Employee? emp;
  const NfcScreen(
      {Key? key,
      this.deviceToken,
      this.content,
      this.listEmp,
      this.emp,
      this.status,
      this.phoneNumber,
      this.transId})
      : super(key: key);
  @override
  _NfcScreen createState() => _NfcScreen();
}

class _NfcScreen extends State<NfcScreen> {
  TextEditingController nfcController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    nfcController.addListener(() {
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });

    super.initState();
  }

  TakeAttendanceBloc attendanceBloc = TakeAttendanceBloc();
  TakeOrderBloc takeBloc = TakeOrderBloc();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (!focusScopeNode.hasPrimaryFocus) {
          focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff43ddfb).withOpacity(0.8),
                      Color(0xff20b9f5),
                    ]),
              ),
            ),
            Positioned(
              left: 30,
              top: 50,
              child: MyBackButton(color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              width: width / 2,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 50),
                    width: width / 2,
                    child: Text(
                      'Swipe NFC',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: height - 550,
                    width: width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: width / 4,
                            height: height / 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 20,
                                )
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Counter(
                                  color: Colors.black,
                                  number: 'Swipe NFC',
                                  image: "assets/images/nfc-card.png",
                                  width: width / 4,
                                  height: width / 4,
                                ),
                              ],
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: height,
                  width: width / 2.5,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 65.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 200),
                                        Container(
                                          width: width / 3,
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "NFC Card",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Container(
                                          width: width / 3,
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "Please swipe your card or input your serial number",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                              height: 50,
                                              width: width / 3,
                                              child: TextFormField(
                                                controller: nfcController,
                                                decoration: InputDecoration(
                                                  labelText: 'Card ID',
                                                  labelStyle:
                                                      TextStyle(fontSize: 20),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff20b9f5),
                                                        width: 2.0),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                StreamBuilder(
                                    stream: attendanceBloc.isLoggingStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data == 'Logging') {
                                          return Container(
                                            height: 60,
                                            child: Container(
                                              width: width / 4,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(PRIMARY_BLUE),
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              if (widget.content ==
                                                  "Take attendance") {
                                                onSignInClicked(context);
                                              } else if (widget.content ==
                                                  "Leave") {
                                                onSignOutClicked(context);
                                              } else {
                                                onTakeOrderClicked(context);
                                              }
                                            },
                                            child: Container(
                                              height: 60,
                                              child: Container(
                                                width: width / 3,
                                                child: Text(
                                                  'CONFIRM',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.bottomLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff43ddfb),
                                                        Color(0xff20b9f5),
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            if (widget.content ==
                                                "Take attendance") {
                                              onSignInClicked(context);
                                            } else if (widget.content ==
                                                "Leave") {
                                              onSignOutClicked(context);
                                            } else {
                                              onTakeOrderClicked(context);
                                            }
                                          },
                                          child: Container(
                                            height: 60,
                                            child: Container(
                                              width: width / 3,
                                              child: Text(
                                                'CONFIRM',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20),
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Color(0xff43ddfb),
                                                      Color(0xff20b9f5),
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ])),
    );
  }

  void onSignInClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    String nfc = nfcController.text;
    this.showDialogConfirmActive();
    attendanceBloc.takeAttendanceNfc(context, nfc, "1");
  }

  void onSignOutClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    String nfc = nfcController.text;
    this.showDialogConfirmActive();
    attendanceBloc.logout(context, nfc, "1");
  }

  void onTakeOrderClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    String transId = widget.transId!;
    String oldName = widget.emp!.name;
    String newNFC = nfcController.text;
    String status = widget.status!;
    String phoneNum = widget.phoneNumber!;
    String deviceToken = widget.deviceToken!;
    this.showDialogConfirmActive();
    CheckNfcBloc checkBloc = CheckNfcBloc();
    checkBloc
        .checkNfcBloc(context, transId, newNFC, widget.listEmp!)
        .then((value) {
      if (value == "OK") {
        if (status == "false") {
          if (transId == widget.emp!.listTransaction[0].id) {
            takeBloc.takeOrderBloc(
                context, newNFC, transId, null, false, deviceToken);
          } else {
            Navigator.of(context).pop();
            OpenDialog.displayDialog(
                "Error", context, "Please take order by sequence!!");
          }
        } else {
          Navigator.of(context).pop();
          OpenDialog.displayDialog(
              "Error", context, "Employee is currently busy !!");
        }
      } else if (value == "OTP") {
        String nfc = num.tryParse(newNFC)!.toInt().toRadixString(16);
        Navigator.of(context).pop();
        PushNoti noti = PushNoti();
        String newEmp = widget.listEmp!
            .where((element) =>
                element.serialNumNfc.toLowerCase().contains(nfc.toLowerCase()))
            .toList()[0]
            .name;
        noti.updateNoti(oldName, newEmp, phoneNum);
        this.showOTP();
        noti.listenToUpdateNoti(context, nfc, transId, deviceToken);
      } else if (value == "Invalid") {
        Navigator.of(context).pop();
        OpenDialog.displayDialog("Error", context, "Card ID is not existed");
      }
    });
  }

  void showOTP() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 250,
              width: 350,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                            child: CircularProgressIndicator(),
                            width: 50,
                            height: 50),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 80,
                        child: Text(
                          "Vui lòng chờ chủ cửa hàng xác nhận !!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void showDialogConfirmActive() {
    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: Text('Checking'),
            content: Container(
              height: 80,
              child: Center(
                child: Column(children: [
                  SizedBox(height: 10),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please wait for a few moment",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                  )
                ]),
              ),
            ),
          );
        });
  }
}

class Counter extends StatelessWidget {
  final String? number;
  final Color? color;
  final String? image;
  final double? width;
  final double? height;
  const Counter(
      {Key? key, this.color, this.number, this.image, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              height: width! / 2,
              width: width! / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image!),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              number!,
              style: TextStyle(fontSize: 35, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
