import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/order_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context);

    final statusCounts = {
      'Received': 0,
      'Washing': 0,
      'Ready': 0,
      'Delivered': 0,
    };
    for (var order in provider.orders) {
      statusCounts[order.status] = (statusCounts[order.status] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _statCard(context, 'Total Orders',
                    provider.totalOrders.toString(), Colors.blue),
                const SizedBox(width: 12),
                _statCard(
                    context,
                    'Total Revenue',
                    'KWD ${provider.totalRevenue.toStringAsFixed(2)}',
                    Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Orders by Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...statusCounts.entries.map((e) => _statusRow(e.key, e.value)),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
      BuildContext context, String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 13)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(String status, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(status, style: const TextStyle(fontSize: 15)),
          Text(count.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}