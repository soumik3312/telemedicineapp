import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../models/doctor.dart';
import 'appointment_success_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedSpecialization = 'General Physician';
  Doctor? _selectedDoctor;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = '10:00 AM';
  String _appointmentType = 'video';
  String _reason = '';
  bool _isLoading = false;
  bool _isDoctorsLoading = false;
  List<Doctor> _availableDoctors = [];

  final List<String> _specializations = [
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Orthopedic',
    'Neurologist',
    'Gynecologist',
    'Ophthalmologist',
    'ENT Specialist',
  ];

  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _isDoctorsLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _availableDoctors = [
        Doctor(
          id: '1',
          name: 'Dr. Sarah Johnson',
          specialization: 'General Physician',
          experience: 8,
          rating: 4.8,
          imageUrl: 'assets/doctor1.png',
          isAvailable: true,
        ),
        Doctor(
          id: '2',
          name: 'Dr. Michael Chen',
          specialization: 'Cardiologist',
          experience: 12,
          rating: 4.9,
          imageUrl: 'assets/doctor2.png',
          isAvailable: true,
        ),
        Doctor(
          id: '3',
          name: 'Dr. Priya Sharma',
          specialization: 'Pediatrician',
          experience: 6,
          rating: 4.7,
          imageUrl: 'assets/doctor3.png',
          isAvailable: true,
        ),
        Doctor(
          id: '4',
          name: 'Dr. James Wilson',
          specialization: 'General Physician',
          experience: 10,
          rating: 4.6,
          imageUrl: 'assets/doctor4.png',
          isAvailable: true,
        ),
      ];

      // Filter doctors by selected specialization
      _filterDoctorsBySpecialization();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading doctors: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDoctorsLoading = false;
        });
      }
    }
  }

  void _filterDoctorsBySpecialization() {
    final filteredDoctors = _availableDoctors
        .where((doctor) => doctor.specialization == _selectedSpecialization)
        .toList();
    
    setState(() {
      _selectedDoctor = filteredDoctors.isNotEmpty ? filteredDoctors.first : null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a doctor'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse time slot
      final timeParts = _selectedTimeSlot.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = 0;
      final isPM = _selectedTimeSlot.contains('PM');
      
      // Create appointment date time
      final appointmentDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        isPM && hour != 12 ? hour + 12 : hour,
        minute,
      );

      // Book appointment
      await Provider.of<AppointmentProvider>(context, listen: false).bookAppointment(
        doctor: _selectedDoctor!,
        dateTime: appointmentDateTime,
        reason: _reason,
        isVideoCall: _appointmentType == 'video',
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppointmentSuccessScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error booking appointment: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Specialization',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSpecialization,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _specializations.map((specialization) {
                  return DropdownMenuItem<String>(
                    value: specialization,
                    child: Text(specialization),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecialization = value!;
                    _filterDoctorsBySpecialization();
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Doctor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _isDoctorsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildDoctorSelection(),
              const SizedBox(height: 24),
              const Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Time Slot',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _timeSlots.map((timeSlot) {
                  return DropdownMenuItem<String>(
                    value: timeSlot,
                    child: Text(timeSlot),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTimeSlot = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Appointment Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Video Call'),
                      value: 'video',
                      groupValue: _appointmentType,
                      onChanged: (value) {
                        setState(() {
                          _appointmentType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('In-person'),
                      value: 'in-person',
                      groupValue: _appointmentType,
                      onChanged: (value) {
                        setState(() {
                          _appointmentType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Reason for Visit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Briefly describe your symptoms or reason for visit',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reason for visit';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reason = value!;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'BOOK APPOINTMENT',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorSelection() {
    final filteredDoctors = _availableDoctors
        .where((doctor) => doctor.specialization == _selectedSpecialization)
        .toList();

    if (filteredDoctors.isEmpty) {
      return const Center(
        child: Text(
          'No doctors available for this specialization',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Column(
      children: filteredDoctors.map((doctor) {
        final isSelected = _selectedDoctor?.id == doctor.id;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedDoctor = doctor;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(doctor.imageUrl),
                    onBackgroundImageError: (_, __) {},
                    child: doctor.imageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${doctor.experience} years experience',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor.rating.toString(),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Radio<String>(
                    value: doctor.id,
                    groupValue: _selectedDoctor?.id,
                    onChanged: (value) {
                      setState(() {
                        _selectedDoctor = doctor;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AppointmentSuccessScreen {
  const AppointmentSuccessScreen();
}
