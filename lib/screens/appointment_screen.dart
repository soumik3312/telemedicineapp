// appointment_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  get http => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: TableCalendar(
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        firstDay: DateTime(1990),
        lastDay: DateTime(2050),
        selectedDayPredicate: (day) => _selectedDay == day,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Implement logic to book appointment here
          // For example, send a request to your server
          final response = await http.post(
            Uri.parse('https://your-server.com/book-appointment'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'date': _selectedDay.toString(),
              'patientId': '123', // Replace with actual patient ID
            }),
          );

          if (response.statusCode == 200) {
            print('Appointment booked successfully');
          } else {
            print('Failed to book appointment');
          }
        },
        tooltip: 'Book',
        child: Icon(Icons.book),
      ),
    );
  }
}
