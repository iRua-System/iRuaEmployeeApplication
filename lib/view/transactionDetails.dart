import 'package:cwa_irua_employee/bloc/checkNfc_bloc.dart';
import 'package:cwa_irua_employee/bloc/takeOrder_bloc.dart';
import 'package:cwa_irua_employee/bloc/transaction_bloc.dart';
import 'package:cwa_irua_employee/constants/constants.dart';
import 'package:cwa_irua_employee/helper/noti.dart';
import 'package:cwa_irua_employee/model/employee.dart';
import 'package:cwa_irua_employee/model/service.dart';
import 'package:cwa_irua_employee/model/transaction.dart';
import 'package:cwa_irua_employee/view/nfc.dart';
import 'package:cwa_irua_employee/widget/backButton.dart';
import 'package:cwa_irua_employee/widget/dialog.dart';
import 'package:cwa_irua_employee/widget/service_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String? deviceToken;
  final String? nfc;
  final String? transactionId;
  final Employee? oldEmp;
  final bool? status;
  final String? transactionInfo;
  final List<Employee>? listEmp;
  TransactionDetailsScreen(
      {Key? key,
      this.deviceToken,
      this.transactionId,
      this.nfc,
      this.status,
      this.listEmp,
      this.oldEmp,
      this.transactionInfo})
      : super(key: key);
  @override
  _TransactionDetailsScreen createState() => _TransactionDetailsScreen();
}

class _TransactionDetailsScreen extends State<TransactionDetailsScreen> {
  late Transaction transaction;
  final transactionViewModel = TransactionBloc();
  TextEditingController codeController = TextEditingController();
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    transactionViewModel.getTransaction(widget.transactionId!.split("-")[0]);
    String str = widget.transactionId! + "+" + widget.nfc!;
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController nfcController = TextEditingController();
  TakeOrderBloc takeBloc = TakeOrderBloc();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (!focusScopeNode.hasPrimaryFocus) {
          focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: PRIMARY_BLUE,
          body: StreamBuilder(
              stream: transactionViewModel.transaction,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data as Transaction;
                  return Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
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
                    LeftWidget(
                      width: width,
                      height: height,
                      services: data.listService,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: height,
                          width: width / 2,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 50, left: 50),
                                width: width / 2,
                                child: Text(
                                  'Thông tin khách hàng',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Container(
                                  width: width / 2,
                                  child: Text(
                                    'Full Name',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.only(left: 50),
                                  height: 60,
                                  width: width * 0.43,
                                  child: TextFormField(
                                    enabled: false,
                                    style: TextStyle(fontSize: 20),
                                    controller: nameController
                                      ..text = data.customer.fullname,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff20b9f5),
                                            width: 2.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: width * 0.43,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Row(
                                    children: [
                                      phoneField(width, "Phone Number",
                                          data.customer.phoneNum),
                                      Spacer(),
                                      textField(width, "Vehicle Plate",
                                          data.vehiclePlate, plateController),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                width: width * 0.43,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Row(
                                    children: [
                                      textField(width, "Type", data.vehicleName,
                                          vehicleTypeController),
                                      Spacer(),
                                      textField(
                                          width,
                                          "Brand",
                                          data.vehicleBrand,
                                          vehicleBrandController),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              workingButton(data),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 7,
                      backgroundColor: PRIMARY_WHITE,
                    ),
                  );
                }
              })),
    );
  }

  Column textField(double width, String title, String data,
      TextEditingController controller) {
    if (data == "Other") {
      data = "Other";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: width / 7,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
            height: 60,
            width: width / 6,
            child: TextFormField(
              enabled: false,
              controller: controller..text = data,
              style: TextStyle(fontSize: 17),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff20b9f5), width: 2.0),
                ),
              ),
            )),
      ],
    );
  }

  Column phoneField(double width, String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: width / 6,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          height: 60,
          width: width / 6,
          child: TextFormField(
            enabled: false,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 17),
            controller: phoneController..text = data,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff20b9f5), width: 2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding fullnameWidget(double width) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Container(
        width: width / 2,
        child: Text(
          'Họ và Tên',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget workingButton(Transaction trans) {
    if (trans.status == "Checkin") {
      return Container(
        padding: const EdgeInsets.only(bottom: 50.0),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            nfcDialog("NFC Card", context, "Please swipe your card", trans,
                widget.listEmp!, widget.deviceToken);
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width / 7,
            child: Container(
              width: MediaQuery.of(context).size.width / 10,
              child: Text(
                'TAKE ORDER',
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
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void onVehicleReceiveClicked(
      BuildContext context, Transaction trans, List<Employee> listEmp) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NfcScreen(
            deviceToken: widget.deviceToken,
            content: "Take Order",
            listEmp: listEmp,
            emp: widget.oldEmp,
            transId: trans.id,
            status: widget.status.toString(),
            phoneNumber: trans.customer.phoneNum)));
  }

  Future<bool> nfcDialog(title, context, error, Transaction trans,
      List<Employee> listEmp, deviceToken) async {
    nfcController.text = "";
    TextFormField textField = new TextFormField(
        controller: nfcController,
        autofocus: true,
        cursorColor: Colors.transparent,
        cursorWidth: 0,
        onChanged: (value) {
          print(value.length);
          if (value.length == 10) {
            this.showDialogConfirmActive();
            CheckNfcBloc checkBloc = CheckNfcBloc();
            checkBloc
                .checkNfcBloc(context, trans.id, value, listEmp)
                .then((result) {
              if (result == "OK") {
                if (widget.status == false) {
                  if (widget.transactionId ==
                      widget.oldEmp!.listTransaction[0].id) {
                    Navigator.of(context).pop();
                    takeBloc.takeOrderBloc(
                        context, value, trans.id, null, false, deviceToken);
                  } else {
                    Navigator.of(context).pop();
                    OpenDialog.displayDialog(
                        "Error", context, "Please take order in sequence !");
                  }
                } else {
                  Navigator.of(context).pop();
                  OpenDialog.displayDialog(
                      "Error", context, "Employee is currently busy!");
                }
              } else if (result == "OTP") {
                Navigator.of(context).pop();
                PushNoti noti = PushNoti();
                String nfc =
                    num.tryParse(nfcController.text)!.toInt().toRadixString(16);
                String newEmp = widget.listEmp!
                    .where((element) => element.serialNumNfc
                        .toLowerCase()
                        .contains(nfc.toLowerCase()))
                    .toList()[0]
                    .name;
                noti.updateNoti(
                    widget.oldEmp!.name, newEmp, trans.customer.phoneNum);
                this.showOTP();
                noti.listenToUpdateNoti(context, nfc, trans.id, deviceToken);
              } else if (result == "Invalid") {
                Navigator.of(context).pop();
                OpenDialog.displayDialog(
                    "Error", context, "Card ID is not existed");
              }
            });
          }
        },
        style: TextStyle(color: Colors.transparent),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0)),
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
        ));
    Container container = Container(
      height: 1,
      child: FocusScope(
        child: Focus(
            onFocusChange: (focus) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            child: textField),
      ),
    );
    var alertStyle = AlertStyle(
      overlayColor: Colors.black.withOpacity(0.1),
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 100),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Color(0xff20b9f5),
      ),
    );
    Alert(
            context: context,
            style: alertStyle,
            type: AlertType.info,
            title: title,
            desc: error,
            buttons: [
              DialogButton(
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
                color: Color(0xff20b9f5),
                radius: BorderRadius.circular(10.0),
              ),
              DialogButton(
                child: Text(
                  "FORGET",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  onVehicleReceiveClicked(context, trans, listEmp);
                },
                color: Color(0xff20b9f5),
                radius: BorderRadius.circular(10.0),
              ),
            ],
            content: container)
        .show();
    return true;
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

class LeftWidget extends StatefulWidget {
  const LeftWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.services,
  }) : super(key: key);

  final double width;
  final double height;
  final List<Service> services;

  @override
  _LeftWidgetState createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<LeftWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      width: widget.width / 2,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, left: 50),
            width: widget.width / 2,
            child: Text(
              'Selected Services',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          SingleChildScrollView(
            child: Column(
              children: [
                for (var data in widget.services)
                  ServiceColumn(
                    title: data.name,
                    price: data.price.toString(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
