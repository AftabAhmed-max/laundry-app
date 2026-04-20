import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/order_provider.dart';
import '../../models/order.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _itemsController = TextEditingController();
  final _priceController = TextEditingController();
  String _serviceType = 'Wash & Fold';
  double _totalPrice = 0;

  final List<Map<String, dynamic>> _services = [
    {'name': 'Wash & Fold', 'icon': Icons.local_laundry_service_rounded},
    {'name': 'Wash & Iron', 'icon': Icons.iron_rounded},
    {'name': 'Dry Clean', 'icon': Icons.dry_cleaning_rounded},
    {'name': 'Iron Only', 'icon': Icons.iron_rounded},
  ];

  void _calculateTotal() {
    final items = int.tryParse(_itemsController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    setState(() => _totalPrice = items * price);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final order = LaundryOrder(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        serviceType: _serviceType,
        numberOfItems: int.parse(_itemsController.text),
        pricePerItem: double.parse(_priceController.text),
        totalPrice: _totalPrice,
      );
      Provider.of<OrderProvider>(context, listen: false).addOrder(order);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('New Order'),
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: const Text(
                'Fill in the details below\nto create a new order',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _label('Customer Name'),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter full name',
                        prefixIcon: Icon(Icons.person_rounded,
                            color: Color(0xFF00B4D8)),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _label('Phone Number'),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Enter phone number',
                        prefixIcon: Icon(Icons.phone_rounded,
                            color: Color(0xFF00B4D8)),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (v.length < 7) return 'Invalid phone number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _label('Service Type'),
                    DropdownButtonFormField<String>(
                      value: _serviceType,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.dry_cleaning_rounded,
                            color: Color(0xFF00B4D8)),
                      ),
                      items: _services
                          .map((s) => DropdownMenuItem(
                                value: s['name'] as String,
                                child: Text(s['name'] as String),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _serviceType = v!),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('No. of Items'),
                              TextFormField(
                                controller: _itemsController,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  prefixIcon: Icon(Icons.format_list_numbered_rounded,
                                      color: Color(0xFF00B4D8)),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (_) => _calculateTotal(),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  if (int.tryParse(v) == null ||
                                      int.parse(v) <= 0)
                                    return 'Invalid';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Price per Item'),
                              TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  hintText: '0.00',
                                  prefixIcon: Icon(Icons.attach_money_rounded,
                                      color: Color(0xFF00B4D8)),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (_) => _calculateTotal(),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  if (double.tryParse(v) == null ||
                                      double.parse(v) <= 0)
                                    return 'Invalid';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF023E8A), Color(0xFF00B4D8)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Price',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                              SizedBox(height: 4),
                              Text('Auto calculated',
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 11)),
                            ],
                          ),
                          Text(
                            'KWD ${_totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B4D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Create Order',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}