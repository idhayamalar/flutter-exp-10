import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbName = 'student_registration.db';

    if (kIsWeb) {
      return openDatabase(
        dbName,
        version: 1,
        onCreate: _createTable,
      );
    }

    final path = await getDatabasesPath();
    return openDatabase(
      '$path/$dbName',
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        regno TEXT,
        email TEXT,
        department TEXT,
        year TEXT,
        phone TEXT
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (index) {
      return Student.fromMap(maps[index]);
    });
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
