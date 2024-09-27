import 'package:cwa_irua_employee/model/transaction.dart';

class Employee {
  late String id;
  late String name;
  late String serialNumNfc;
  List<Transaction> listTransaction = [];
  bool isBusy = false;

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['empId'];
    name = json['empName'];
    serialNumNfc = json['serialNumNfc'];
    List<Transaction> temp = [];
    for (var trans in json['transactionInfo']) {
      Transaction transaction = Transaction(trans);
      if (transaction.status == "Working") {
        isBusy = true;
      }
      temp.add(transaction);
    }
    listTransaction = temp;
  }
}
