class Customer {
  final int id;
  final String name;
  final String mobileNumber;
  final String address;
  final String gstNumber;

  Customer({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.address,
    required this.gstNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      address: json['address'],
      gstNumber: json['gstNumber'],
    );
  }
}