import 'dart:async';
import 'dart:io';

import 'package:cwa_irua_employee/bloc/takeAttendance_bloc.dart';
import 'package:cwa_irua_employee/bloc/transaction_bloc.dart';
import 'package:cwa_irua_employee/constants/constants.dart';
import 'package:cwa_irua_employee/firebase_options.dart';
import 'package:cwa_irua_employee/model/employee.dart';
import 'package:cwa_irua_employee/model/transaction.dart' as cwaTransaction;
import 'package:cwa_irua_employee/view/nfc.dart';
import 'package:cwa_irua_employee/view/transactionDetails.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dcdg/dcdg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TableRow> emptyRows = [];
  List<Employee> listEmployee = [];

  String statusEmp = '';
  final transactionViewModel = TransactionBloc();
  var data;
  late StreamSubscription reloadStreamSubscription;
  late DatabaseReference _reloadRequest;

  TextEditingController nfcController = TextEditingController();
  String submittedString = "";
  TakeAttendanceBloc attendanceBloc = TakeAttendanceBloc();
  @override
  void initState() {
    transactionViewModel.getAll();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _reloadRequest = FirebaseDatabase.instance.ref();
    super.initState();
    Timer.periodic(const Duration(seconds: 30),
        (Timer t) => transactionViewModel.getAll());
    update();
  }

  void update() async {
    _reloadRequest.child('int');
    reloadStreamSubscription = _reloadRequest.onChildChanged.listen(
      (event) {
        transactionViewModel.getAll();
        print('reload');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: StreamBuilder(
            stream: transactionViewModel.listEmp,
            builder: (context, snapshot) {
              listEmployee =
                  (snapshot.hasData ? snapshot.data as List<Employee> : []);
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image:
                              AssetImage("assets/images/background-image.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff43ddfb).withOpacity(0.5),
                            Color(0xff20b9f5).withOpacity(0.8),
                          ],
                          stops: [
                            0.0,
                            1.0
                          ]),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(flex: 2, child: title()),
                      Expanded(flex: 1, child: note()),
                      Expanded(
                        flex: 7,
                        child: Container(
                            alignment: Alignment.center,
                            child: listEmployee.length == 0
                                ? waitingForEmployee()
                                : showDataTable(listEmployee)),
                      ),
                      StreamBuilder(
                          stream: attendanceBloc.isLoggingStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == "Logging") {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 7,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                return Container(
                                    height: 10, width: 10, color: Colors.red);
                              }
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget waitingForEmployee() {
    return Container(
      height: 300,
      color: PRIMARY_WHITE.withOpacity(0.5),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 200,
              child: Image.asset("assets/images/employee-icon-not-found.png")),
          Text(
            "Waiting for employee to take attendance",
            style: TextStyle(
                fontFamily: "EncodeSans-Medium",
                fontSize: 36,
                color: HEADER_CARD,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget note() {
    return Container(
      margin: EdgeInsets.only(right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(color: PRIMARY_WHITE, height: 20, width: 30),
          SizedBox(
            width: 10,
          ),
          Text(
            "Waiting",
            style: TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 15,
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.black,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Container(color: PRIMARY_GREEN, height: 20, width: 30),
          SizedBox(
            width: 10,
          ),
          Text(
            "Progressing",
            style: TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Text(
              "SCHEDULE",
              style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lemonada-Regular",
                  color: PRIMARY_WHITE),
            ),
          ),
          Row(children: [
            GestureDetector(
              onTap: () {
                nfcDialog("NFC Card", context, "Please swipe your NFC",
                    "Take attendance");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: HEADER_CARD),
                  color: PRIMARY_WHITE,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(
                      "Take attendance",
                      style: TextStyle(
                          fontFamily: "EncodeSans-Medium",
                          fontSize: 25,
                          color: HEADER_CARD,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.assignment_turned_in_outlined,
                        color: HEADER_CARD),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                nfcDialog(
                    "NFC Card", context, "Please swipe your NFC", "Leave");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: PRIMARY_WHITE),
                  color: HEADER_CARD,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(
                      "Leave",
                      style: TextStyle(
                          fontFamily: "EncodeSans-Medium",
                          fontSize: 25,
                          color: PRIMARY_WHITE,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.logout, color: PRIMARY_WHITE),
                  ],
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {});
  }

  Widget showDataTable(List<Employee> listData) {
    if (listData == null) {
      return timeTable(emptyRows);
    } else {
      if (listData.length <= 0) {
        return timeTable(emptyRows);
      }
      if (listEmployee == null || listEmployee.isEmpty) {
        for (var emp in listData) {
          listEmployee.add(emp);
        }
      }
      List<TableRow> rows = [];
      listEmployee.forEach((employee) {
        try {
          var dataRow = tableRow(employee);
          rows.add(dataRow!);
        } catch (ex) {
          var dataRow = new TableRow(children: [
            employeeCell(null),
            transactionCell(null, employee, listData),
            transactionCell(null, employee, listData),
            transactionCell(null, employee, listData)
          ]);
          rows.add(dataRow);
        }
      });
      return timeTable(rows);
    }
  }

  TableRow? tableRow(Employee emp) {
    if (emp.listTransaction.length == 0) {
      return TableRow(children: [
        employeeCell(emp.name.toUpperCase()),
        transactionCell(null, emp, listEmployee),
        transactionCell(null, emp, listEmployee),
        transactionCell(null, emp, listEmployee),
      ]);
    } else if (emp.listTransaction.length == 1) {
      return TableRow(children: [
        employeeCell(emp.name.toUpperCase()),
        transactionCell(emp.listTransaction[0], emp, listEmployee),
        transactionCell(null, emp, listEmployee),
        transactionCell(null, emp, listEmployee),
      ]);
    } else if (emp.listTransaction.length == 2) {
      return TableRow(children: [
        employeeCell(emp.name.toUpperCase()),
        transactionCell(emp.listTransaction[0], emp, listEmployee),
        transactionCell(emp.listTransaction[1], emp, listEmployee),
        transactionCell(null, emp, listEmployee),
      ]);
    } else if (emp.listTransaction.length >= 3) {
      return TableRow(children: [
        employeeCell(emp.name.toUpperCase()),
        transactionCell(emp.listTransaction[0], emp, listEmployee),
        transactionCell(emp.listTransaction[1], emp, listEmployee),
        transactionCell(emp.listTransaction[2], emp, listEmployee),
      ]);
    }
  }

  onSignInSignOutClicked(BuildContext context, String content) {
    FocusScope.of(context).unfocus();
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => NfcScreen(
                  content: content,
                )))
        .then((value) => transactionViewModel.getAll());
  }

  bool nfcDialog(title, context, error, content) {
    nfcController.text = "";
    TextFormField textField = new TextFormField(
        controller: nfcController,
        autofocus: true,
        cursorColor: Colors.transparent,
        cursorWidth: 0,
        onChanged: (value) {
          print(value.length);
          if (value.length == 10) {
            if (content == "Take attendance") {
              this.showDialogConfirmActive();
              attendanceBloc
                  .takeAttendanceNfc(context, value, "2")
                  .then((value) {
                if (value) {
                  transactionViewModel.getAll();
                } else {
                  return false;
                }
              });
            } else if (content == "Leave") {
              this.showDialogConfirmActive();
              attendanceBloc.logout(context, value, "2").then((value) {
                if (value) {
                  transactionViewModel.getAll();
                } else {
                  return false;
                }
              });
            }
          }
        },
        style: TextStyle(color: Colors.white),
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
      //overlayColor: Colors.blue[400],
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
                  "FORGOT",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  if (content == "Take attendance") {
                    onSignInSignOutClicked(context, content);
                  } else if (content == "Leave") {
                    onSignInSignOutClicked(context, content);
                  }
                },
                color: Color(0xff20b9f5),
                radius: BorderRadius.circular(10.0),
              ),
            ],
            content: container)
        .show();
    return true;
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

  Widget transactionCell(
      cwaTransaction.Transaction? trans, Employee emp, List<Employee> listEmp) {
    if (trans != null) {
      print(trans.vehiclePlate + " " + trans.status);
    }
    return TableCell(
      child: InkWell(
        onTap: () {
          if (trans != null && emp != null) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => TransactionDetailsScreen(
                          nfc: emp.serialNumNfc,
                          transactionId: trans.id,
                          status: emp.isBusy,
                          listEmp: listEmp,
                          oldEmp: emp,
                          transactionInfo: trans.customer.phoneNum,
                        )))
                .then((value) {
              Future.delayed(Duration(seconds: 5), () {
                print('gọi nà');
                transactionViewModel.getAll();
              });
            });
          }
        },
        child: Container(
          height: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: trans != null && trans.status == "Working"
                  ? PRIMARY_GREEN
                  : PRIMARY_WHITE,
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            trans != null
                ? "ID: " +
                    trans.id.split("-")[0].toUpperCase() +
                    "\n" +
                    "PLATE: " +
                    trans.vehiclePlate.toUpperCase()
                : "",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "EncodeSans-Medium",
                fontWeight: FontWeight.w700,
                color: trans != null && trans.status == "Working"
                    ? PRIMARY_WHITE
                    : PRIMARY_BLUE),
          ),
        ),
      ),
    );
  }

  Widget employeeCell(String? content) {
    return TableCell(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: HEADER_CARD, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.all(5.0),
        child: Text(
          content != null ? content : "",
          style: TextStyle(
              fontSize: 20,
              fontFamily: "EncodeSans-Medium",
              fontWeight: FontWeight.w700,
              color: PRIMARY_WHITE),
        ),
      ),
    );
  }

  Widget headerCell(String? content) {
    return TableCell(
      child: Container(
        height: 70,
        decoration: content != null
            ? BoxDecoration(
                color: HEADER_CARD, borderRadius: BorderRadius.circular(20))
            : null,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.all(5.0),
        child: Text(
          content != null ? content : "",
          style: TextStyle(
              fontSize: 25, color: PRIMARY_WHITE, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget timeTable(List<TableRow> list) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: PRIMARY_WHITE.withOpacity(0.5)),
      child: Column(children: [
        Table(
          children: [
            TableRow(children: [
              headerCell(null),
              headerCell("1"),
              headerCell("2"),
              headerCell("3"),
            ])
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              child: Table(
                children: list,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
