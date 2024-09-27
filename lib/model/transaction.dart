import 'package:cwa_irua_employee/model/customer.dart';
import 'package:cwa_irua_employee/model/service.dart';

class Transaction {
  late String id;
  late String status;
  late double price;
  late String vehiclePlate;
  late String vehicleName;
  late String vehicleBrand;
  late List<Service> listService = [];
  late Customer customer;

  Transaction(trans) {
    id = trans['id'];
    status = trans['status'];
    price = trans['price'];
    vehiclePlate = trans['vehiclePlate'];
    vehicleName = trans['vehicleName'];
    vehicleBrand = trans['vehicleBrand'];
    List<Service> temp = [];
    for (var service in trans['services']) {
      Service serv = Service(service);
      temp.add(serv);
    }
    listService = temp;
    customer = Customer(trans['cusInfo']);
  }

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    price = json['price'];
    vehiclePlate = json['vehiclePlate'];
    vehicleName = json['vehicleName'];
    vehicleBrand = json['vehicleBrand'];
    List<Service> temp = [];
    for (var service in json['services']) {
      Service serv = Service(service);
      temp.add(serv);
    }
    listService = temp;
    customer = Customer(json['cusInfo']);
  }
}
