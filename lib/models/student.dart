class Student {
  final int? id;
  final String name;
  final String regNo;
  final String email;
  final String department;
  final String year;
  final String phone;

  const Student({
    this.id,
    required this.name,
    required this.regNo,
    required this.email,
    required this.department,
    required this.year,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'regno': regNo,
      'email': email,
      'department': department,
      'year': year,
      'phone': phone,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      name: map['name'] as String,
      regNo: map['regno'] as String,
      email: map['email'] as String,
      department: map['department'] as String,
      year: map['year'] as String,
      phone: map['phone'] as String,
    );
  }
}
