import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  List<Appointment> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments
        .where((appointment) => appointment.dateTime.isAfter(now))
        .toList();
  }

  List<Appointment> get pastAppointments {
    final now = DateTime.now();
    return _appointments
        .where((appointment) => appointment.dateTime.isBefore(now))
        .toList();
  }

  Future<void> fetchAppointments() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data
      final now = DateTime.now();
      
      _appointments = [
        Appointment(
          id: '1',
          doctor: Doctor(
            id: '1',
            name: 'Dr. Sarah Johnson',
            specialization: 'General Physician',
            experience: 8,
            rating: 4.8,
            imageUrl: 'assets/doctor1.png',
            isAvailable: true,
          ),
          dateTime: now.add(const Duration(days: 2, hours: 3)),
          reason: 'Regular checkup and blood pressure monitoring',
          isVideoCall: true,
        ),
        Appointment(
          id: '2',
          doctor: Doctor(
            id: '2',
            name: 'Dr. Michael Chen',
            specialization: 'Cardiologist',
            experience: 12,
            rating: 4.9,
            imageUrl: 'assets/doctor2.png',
            isAvailable: true,
          ),
          dateTime: now.subtract(const Duration(days: 5)),
          reason: 'Heart palpitations and chest pain',
          isVideoCall: false,
        ),
      ];
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bookAppointment({
    required Doctor doctor,
    required DateTime dateTime,
    required String reason,
    required bool isVideoCall,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      final newAppointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        doctor: doctor,
        dateTime: dateTime,
        reason: reason,
        isVideoCall: isVideoCall,
      );
      
      _appointments.add(newAppointment);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _appointments.removeWhere((appointment) => appointment.id == appointmentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}