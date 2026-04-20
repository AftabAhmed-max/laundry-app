class LaundryOrder {
  final int? id;
  final String customerName;
  final String phoneNumber;
  final String serviceType;
  final int numberOfItems;
  final double pricePerItem;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  LaundryOrder({
    this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.serviceType,
    required this.numberOfItems,
    required this.pricePerItem,
    required this.totalPrice,
    this.status = 'Received',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'serviceType': serviceType,
      'numberOfItems': numberOfItems,
      'pricePerItem': pricePerItem,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LaundryOrder.fromMap(Map<String, dynamic> map) {
    return LaundryOrder(
      id: map['id'],
      customerName: map['customerName'],
      phoneNumber: map['phoneNumber'],
      serviceType: map['serviceType'],
      numberOfItems: map['numberOfItems'],
      pricePerItem: map['pricePerItem'],
      totalPrice: map['totalPrice'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}