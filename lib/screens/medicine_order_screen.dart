// medicine_order_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';

class MedicineOrderScreen extends StatefulWidget {
  @override
  _MedicineOrderScreenState createState() => _MedicineOrderScreenState();
}

class _MedicineOrderScreenState extends State<MedicineOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _quantityController = TextEditingController();
  
  get http => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _medicineNameController,
                decoration: InputDecoration(labelText: 'Medicine Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter medicine name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Implement logic to order medicine here
                    // For example, send a request to your server
                    final response = await http.post(
                      Uri.parse('https://your-server.com/order-medicine'),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode({
                        'medicineName': _medicineNameController.text,
                        'quantity': _quantityController.text,
                        'patientId': '123', // Replace with actual patient ID
                      }),
                    );

                    if (response.statusCode == 200) {
                      print('Medicine ordered successfully');
                    } else {
                      print('Failed to order medicine');
                    }
                  }
                },
                child: Text('Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
