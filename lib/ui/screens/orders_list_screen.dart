import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/order_provider.dart';
import '../../models/order.dart';
import 'add_order_screen.dart';
import 'dashboard_screen.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).loadOrders();
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Received':
        return const Color(0xFFF59E0B);
      case 'Washing':
        return const Color(0xFF00B4D8);
      case 'Ready':
        return const Color(0xFF10B981);
      case 'Delivered':
        return const Color(0xFF6B7280);
      default:
        return Colors.black;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Received':
        return Icons.inbox_rounded;
      case 'Washing':
        return Icons.local_laundry_service_rounded;
      case 'Ready':
        return Icons.check_circle_rounded;
      case 'Delivered':
        return Icons.delivery_dining_rounded;
      default:
        return Icons.circle;
    }
  }

  void _showStatusUpdate(BuildContext context, LaundryOrder order) {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    final nextStatus = provider.getNextStatus(order.status);
    if (nextStatus == order.status) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Update Status',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
            'Move order #${order.id} from "${order.status}" to "$nextStatus"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.updateStatus(order.id!, nextStatus);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context);
    final orders = provider.orders;
    final filters = ['All', 'Received', 'Washing', 'Ready', 'Delivered'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧺 Laundry Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_rounded),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const DashboardScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF023E8A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name or order ID...',
                hintStyle:
                    const TextStyle(color: Colors.white60, fontSize: 14),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: provider.setSearch,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final f = filters[index];
                final selected = provider.selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => provider.setFilter(f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF023E8A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF023E8A)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color:
                              selected ? Colors.white : const Color(0xFF6B7280),
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_laundry_service_rounded,
                            size: 64,
                            color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No orders found',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final color = _statusColor(order.status);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showStatusUpdate(context, order),
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Text('Delete Order'),
                                content: const Text(
                                    'Are you sure you want to delete this order?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      provider.deleteOrder(order.id!);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color:
                                          color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_statusIcon(order.status),
                                        color: color, size: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(order.customerName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15)),
                                            Text(
                                              'KWD ${order.totalPrice.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Color(0xFF023E8A)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID: #${order.id} • ${order.serviceType}',
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${order.numberOfItems} items • ${order.phoneNumber}',
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 12),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: color
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                order.status,
                                                style: TextStyle(
                                                    color: color,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddOrderScreen())),
        backgroundColor: const Color(0xFF00B4D8),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Order',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}