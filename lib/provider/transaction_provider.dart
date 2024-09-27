import 'dart:convert';

import 'package:cwa_irua_employee/constants/constants.dart';
import 'package:cwa_irua_employee/model/employee.dart';
import 'package:cwa_irua_employee/model/transaction.dart';
import 'package:http/http.dart' as http;

class TransactionProvider {
  Future<List<Employee>?> getListEmployeeWithTransaction() async {
    String url = API_URL + "/Employees/WorkingSchedule";
    List<Employee> listEmp = [];
    var response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          listEmp.add(Employee.fromJson(data[i]));
        }
        return listEmp;
      } else {
        return null;
      }
    } else {}
    return null;
  }

  Future<Transaction?> getTransactionById(String id) async {
    String url = API_URL + "/Transaction/GetTransByPhone?Username=$id";
    var response = await http.get(Uri.parse(url));
    late Transaction transaction;
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (int i = 0; i < 1; i++) {
        transaction = Transaction(data[0]);
      }
      return transaction;
    } else {
      return null;
    }
  }
}
