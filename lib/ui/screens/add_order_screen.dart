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

  final List<String> _services = [
    'Wash & Fold',
    'Wash & Iron',
    'Dry Clean',
    'Iron Only',
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
      appBar: AppBar(title: const Text('New Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (v.length < 7) return 'Invalid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _serviceType,
                decoration: const InputDecoration(labelText: 'Service Type'),
                items: _services
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _serviceType = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _itemsController,
                decoration: const InputDecoration(labelText: 'Number of Items'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateTotal(),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null || int.parse(v) <= 0)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price per Item'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateTotal(),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null || double.parse(v) <= 0)
                    return 'Enter a valid price';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price',
                        style: TextStyle(fontSize: 16)),
                    Text('KWD ${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Add Order', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}