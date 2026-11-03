import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/student.dart';
import 'registration_screen.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = DatabaseHelper.instance.getStudents();
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _studentsFuture = DatabaseHelper.instance.getStudents();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No student records are available.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistrationScreen(),
                  ),
                );
              },
              child: const Text('Back to Registration'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStudents,
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading students: ${snapshot.error}'),
            );
          }

          final students = snapshot.data ?? [];

          if (students.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 500 + index * 180),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 18 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        student.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Year ${student.year}',
                                        style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                _infoRow('Register No', student.regNo),
                                _infoRow('Email', student.email),
                                _infoRow('Department', student.department),
                                _infoRow('Phone', student.phone),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegistrationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Back to Registration'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
