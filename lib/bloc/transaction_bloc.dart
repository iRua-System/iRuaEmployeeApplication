import 'dart:async';

import 'package:cwa_irua_employee/model/employee.dart';
import 'package:cwa_irua_employee/model/transaction.dart';
import 'package:cwa_irua_employee/provider/transaction_provider.dart';

class TransactionBloc {
  StreamController employeeController = new StreamController();
  StreamController transactionController = new StreamController();
  Stream get listEmp => employeeController.stream;
  Stream get transaction => transactionController.stream;

  Future<void> getAll() async {
    List<Employee>? listEmployee =
        await TransactionProvider().getListEmployeeWithTransaction();
    if (listEmployee != null) {
      print(listEmployee);
      employeeController.sink.add(List<Employee>.from(listEmployee));
    }
  }

  Future<Transaction?> getTransaction(String id) async {
    Transaction? transaction =
        await TransactionProvider().getTransactionById(id);
    if (transaction != null) {
      transactionController.sink.add(transaction);
    }
    return transaction;
  }

  dispose() {
    employeeController.close();
    transactionController.close();
  }
}
