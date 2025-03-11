import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../models/cart_item.dart';

class PharmacyProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  List<CartItem> _cartItems = [];

  List<Medicine> get medicines => _medicines;
  List<CartItem> get cartItems => _cartItems;

  double get cartTotal {
    return _cartItems.fold(
      0,
      (total, item) => total + (item.medicine.price * item.quantity),
    );
  }

  Future<void> fetchMedicines() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data
      _medicines = [
        Medicine(
          id: '1',
          name: 'Paracetamol 500mg',
          description: 'Paracetamol is a pain reliever and fever reducer. It is used to treat many conditions such as headache, muscle aches, arthritis, backache, toothaches, colds, and fevers.',
          dosage: 'Take 1-2 tablets every 4-6 hours as needed. Do not exceed 8 tablets in 24 hours.',
          price: 50.0,
          inStock: true,
          imageUrl: 'assets/med1.png',
        ),
        Medicine(
          id: '2',
          name: 'Amoxicillin 250mg',
          description: 'Amoxicillin is a penicillin antibiotic that fights bacteria. It is used to treat many different types of infection caused by bacteria, such as tonsillitis, bronchitis, pneumonia, and infections of the ear, nose, throat, skin, or urinary tract.',
          dosage: 'Take 1 capsule 3 times a day, with or without food. Complete the full course as prescribed by your doctor.',
          price: 120.0,
          inStock: true,
          imageUrl: 'assets/med2.png',
        ),
        Medicine(
          id: '3',
          name: 'Cetirizine 10mg',
          description: 'Cetirizine is an antihistamine that reduces the effects of natural chemical histamine in the body. Histamine can produce symptoms of sneezing, itching, watery eyes, and runny nose. It is used to treat cold or allergy symptoms such as sneezing, itching, watery eyes, or runny nose.',
          dosage: 'Take 1 tablet once daily. May be taken with or without food.',
          price: 80.0,
          inStock: true,
          imageUrl: 'assets/med3.png',
        ),
        Medicine(
          id: '4',
          name: 'Omeprazole 20mg',
          description: 'Omeprazole is a proton pump inhibitor that decreases the amount of acid produced in the stomach. It is used to treat symptoms of gastroesophageal reflux disease (GERD) and other conditions caused by excess stomach acid.',
          dosage: 'Take 1 capsule daily before a meal, preferably in the morning.',
          price: 150.0,
          inStock: true,
          imageUrl: 'assets/med4.png',
        ),
        Medicine(
          id: '5',
          name: 'Vitamin D3 1000IU',
          description: 'Vitamin D3 is a vitamin that helps your body absorb calcium. It is used to treat or prevent vitamin D deficiency.',
          dosage: 'Take 1 tablet daily with a meal.',
          price: 200.0,
          inStock: true,
          imageUrl: 'assets/med5.png',
        ),
        Medicine(
          id: '6',
          name: 'Ibuprofen 400mg',
          description: 'Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID). It works by reducing hormones that cause inflammation and pain in the body.',
          dosage: 'Take 1 tablet every 6-8 hours as needed. Do not exceed 3 tablets in 24 hours.',
          price: 60.0,
          inStock: true,
          imageUrl: 'assets/med6.png',
        ),
      ];
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void addToCart(Medicine medicine, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex] = CartItem(
        medicine: medicine,
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(
        medicine: medicine,
        quantity: quantity,
      ));
    }

    notifyListeners();
  }

  void updateCartItemQuantity(Medicine medicine, int quantity) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex] = CartItem(
        medicine: medicine,
        quantity: quantity,
      );
      notifyListeners();
    }
  }

  void removeFromCart(Medicine medicine) {
    _cartItems.removeWhere((item) => item.medicine.id == medicine.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }
}
