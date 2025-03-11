import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    // In a real app, check shared preferences or secure storage
    // For demo purposes, we'll assume not logged in initially
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, any credentials will work
      _user = User(
        id: '1',
        name: 'John Doe',
        phone: phone,
        email: 'john.doe@example.com',
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String phone, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Registration successful, but user needs to login
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      _user = User(
        id: _user!.id,
        name: name,
        phone: phone,
        email: email.isNotEmpty ? email : null,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
