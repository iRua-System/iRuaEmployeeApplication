class Customer {
  late String cusId;
  late String fullname;
  late String phoneNum;
  late String deviceToken;

  Customer(cus) {
    cusId = cus['cusId'];
    fullname = cus['fullname'];
    phoneNum = cus['phoneNum'];
    deviceToken = '';
  }
}
