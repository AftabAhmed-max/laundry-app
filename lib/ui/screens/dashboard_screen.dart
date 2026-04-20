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

    final statusColors = {
      'Received': const Color(0xFFF59E0B),
      'Washing': const Color(0xFF00B4D8),
      'Ready': const Color(0xFF10B981),
      'Delivered': const Color(0xFF6B7280),
    };

    final statusIcons = {
      'Received': Icons.inbox_rounded,
      'Washing': Icons.local_laundry_service_rounded,
      'Ready': Icons.check_circle_rounded,
      'Delivered': Icons.delivery_dining_rounded,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF023E8A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _topCard(
                          'Total Orders',
                          provider.totalOrders.toString(),
                          Icons.receipt_long_rounded,
                          const Color(0xFF00B4D8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _topCard(
                          'Total Revenue',
                          'KWD ${provider.totalRevenue.toStringAsFixed(2)}',
                          Icons.payments_rounded,
                          const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Orders by Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...statusCounts.entries.map((e) {
                    final color = statusColors[e.key]!;
                    final icon = statusIcons[e.key]!;
                    final total = provider.totalOrders;
                    final percent = total == 0 ? 0.0 : e.value / total;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(icon, color: color, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  e.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                e.value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percent,
                              backgroundColor: color.withValues(alpha: 0.1),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(color),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              )),
        ],
      ),
    );
  }
}