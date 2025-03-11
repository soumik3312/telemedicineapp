import 'package:telemedicine_application/models/doctor.dart';

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime dateTime;
  final String reason;
  final bool isVideoCall;

  Appointment({
    required this.id,
    required this.doctor,
    required this.dateTime,
    required this.reason,
    required this.isVideoCall,
  });
}
