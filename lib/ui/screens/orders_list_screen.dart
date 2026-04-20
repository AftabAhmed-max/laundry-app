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
        return Colors.orange;
      case 'Washing':
        return Colors.blue;
      case 'Ready':
        return Colors.green;
      case 'Delivered':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  void _showStatusUpdate(BuildContext context, LaundryOrder order) {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    final nextStatus = provider.getNextStatus(order.status);
    if (nextStatus == order.status) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Status'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const DashboardScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or order ID...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: provider.setSearch,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['All', 'Received', 'Washing', 'Ready', 'Delivered']
                  .map((s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(s),
                          selected: provider.orders == provider.orders,
                          onSelected: (_) => provider.setFilter(s),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text('No orders found.'))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(order.customerName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${order.id} • ${order.phoneNumber}'),
                              Text(
                                  '${order.serviceType} • ${order.numberOfItems} items'),
                              Text(
                                  'KWD ${order.totalPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(order.status)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: _statusColor(order.status)),
                                ),
                                child: Text(
                                  order.status,
                                  style: TextStyle(
                                      color: _statusColor(order.status),
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _showStatusUpdate(context, order),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Delete Order'),
                                content: const Text(
                                    'Are you sure you want to delete this order?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel')),
                                  ElevatedButton(
                                    onPressed: () {
                                      provider.deleteOrder(order.id!);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddOrderScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}