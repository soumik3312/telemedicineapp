import 'package:telemedicine_application/models/medicine.dart';

class CartItem {
  final Medicine medicine;
  final int quantity;

  CartItem({
    required this.medicine,
    required this.quantity,
  });
}
