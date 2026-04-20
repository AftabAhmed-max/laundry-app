import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../data/database_helper.dart';

class OrderProvider with ChangeNotifier {
  List<LaundryOrder> _orders = [];
  String _searchQuery = '';
  String _filterStatus = 'All';
  String get selectedFilter => _filterStatus;

  List<LaundryOrder> get orders {
    return _orders.where((order) {
      final matchesSearch = order.customerName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          order.id.toString().contains(_searchQuery);
      final matchesFilter =
          _filterStatus == 'All' || order.status == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get totalOrders => _orders.length;
  double get totalRevenue =>
      _orders.fold(0, (sum, order) => sum + order.totalPrice);

  Future<void> loadOrders() async {
    _orders = await DatabaseHelper.instance.getAllOrders();
    notifyListeners();
  }

  Future<void> addOrder(LaundryOrder order) async {
    await DatabaseHelper.instance.insertOrder(order);
    await loadOrders();
  }

  Future<void> updateStatus(int id, String status) async {
    await DatabaseHelper.instance.updateOrderStatus(id, status);
    await loadOrders();
  }

  Future<void> deleteOrder(int id) async {
    await DatabaseHelper.instance.deleteOrder(id);
    await loadOrders();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  String getNextStatus(String current) {
    const flow = ['Received', 'Washing', 'Ready', 'Delivered'];
    final index = flow.indexOf(current);
    if (index < flow.length - 1) return flow[index + 1];
    return current;
  }
}