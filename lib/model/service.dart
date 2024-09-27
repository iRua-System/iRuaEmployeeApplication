class Service {
  late int serviceVehicleId;
  late String name;
  late double price;

  Service(service) {
    serviceVehicleId = service['serviceVehicleId'];
    name = service['name'];
    price = service['price'];
  }
}
