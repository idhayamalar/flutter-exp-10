import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/student.dart';
import 'student_details_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedYear;

  final List<String> _departments = [
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Mechanical',
    'Civil',
    'Commerce',
    'Arts',
  ];

  final List<String> _years = ['1', '2', '3', '4'];

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      name: _nameController.text.trim(),
      regNo: _regNoController.text.trim(),
      email: _emailController.text.trim(),
      department: _selectedDepartment ?? '',
      year: _selectedYear ?? '',
      phone: _phoneController.text.trim(),
    );

    try {
      await DatabaseHelper.instance.insertStudent(student);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student registered successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentDetailsScreen()),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving student: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter student name.';
    }
    return null;
  }

  String? _validateRegNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Register number is required.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validateDepartment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a department.';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select year of study.';
    }
    final yearValue = int.tryParse(value);
    if (yearValue == null || yearValue < 1 || yearValue > 4) {
      return 'Year must be between 1 and 4.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    final numericValue = value.replaceAll(RegExp(r'\D'), '');
    if (numericValue.length != 10) {
      return 'Phone number must contain 10 digits.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final formWidth = constraints.maxWidth > 700 ? 600.0 : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: formWidth,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 24 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            Center(
                              child: Image.asset(
                                'assets/student.png',
                                width: 160,
                                height: 160,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Register a Student',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Student Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: _validateName,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _regNoController,
                              decoration: const InputDecoration(
                                labelText: 'Register Number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.confirmation_number),
                              ),
                              validator: _validateRegNo,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedDepartment,
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.school),
                              ),
                              items: _departments
                                  .map(
                                    (department) => DropdownMenuItem(
                                      value: department,
                                      child: Text(department),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              },
                              validator: _validateDepartment,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedYear,
                              decoration: const InputDecoration(
                                labelText: 'Year of Study',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_month),
                              ),
                              items: _years
                                  .map(
                                    (year) => DropdownMenuItem(
                                      value: year,
                                      child: Text('Year $year'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedYear = value;
                                });
                              },
                              validator: _validateYear,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              validator: _validatePhone,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _registerStudent,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text(
                                'Register Student',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regNoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
