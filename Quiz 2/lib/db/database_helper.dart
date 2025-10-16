// Import the required packages
import 'package:sqflite/sqflite.dart';  // For SQLite database operations
import 'package:path/path.dart';        // For building correct file paths across platforms
import '../models/student.dart';        // Import the Student model class

// DatabaseHelper class - responsible for all database operations
class DatabaseHelper {
  // Create a single instance (Singleton pattern) to prevent multiple DB connections
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Private variable to store database reference
  static Database? _database;

  // Private named constructor
  DatabaseHelper._init();

  // Getter that returns the database object (creates it if not already initialized)
  Future<Database> get database async {
    // If database already exists, return it
    if (_database != null) return _database!;

    // Otherwise, initialize a new database
    _database = await _initDB('students.db');
    return _database!;
  }

  // Method to initialize (open/create) the database
  Future<Database> _initDB(String filePath) async {
    // Get the default database directory path (specific to Android/iOS)
    final dbPath = await getDatabasesPath();

    // Join the directory path with the database file name to create a full path
    final path = join(dbPath, filePath);

    // Open the database, and call _createDB if it doesn’t exist
    return await openDatabase(
      path,          // Database path
      version: 1,    // Version number (useful for upgrades)
      onCreate: _createDB,  // Callback when DB is first created
    );
  }

  // Function that runs only once when the database is first created
  Future _createDB(Database db, int version) async {
    // Create a table named 'students' with columns id, name, email, and age
    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,  // Auto-incremented unique ID
        name TEXT,                             // Student name
        email TEXT,                            // Student email
        age INTEGER                            // Student age
      )
    ''');
  }

  // Insert a new student record into the database
  Future<int> insertStudent(Student student) async {
    // Get the database instance
    final db = await instance.database;

    // Insert student data (converted to map) into 'students' table
    return await db.insert('students', student.toMap());
  }

  // Retrieve all students from the database
  Future<List<Student>> getStudents() async {
    final db = await instance.database;

    // Query all rows from 'students' table
    final result = await db.query('students');

    // Convert each row (Map) into a Student object and return as a list
    return result.map((e) => Student.fromMap(e)).toList();
  }

  // Retrieve a single student by ID
  Future<Student?> getStudent(int id) async {
    final db = await instance.database;

    // Query 'students' table for the row where id matches
    final result = await db.query(
      'students',
      where: 'id = ?',        // SQL condition
      whereArgs: [id],        // Replace ? with actual ID
    );

    // If student found, convert first result to Student object
    if (result.isNotEmpty) {
      return Student.fromMap(result.first);
    }
    // If no student found, return null
    return null;
  }

  // Update an existing student record
  Future<int> updateStudent(Student student) async {
    final db = await instance.database;

    // Update 'students' table with new data where id matches
    return await db.update(
      'students',
      student.toMap(),          // Updated values
      where: 'id = ?',          // Condition
      whereArgs: [student.id],  // Which record to update
    );
  }

  // Delete a student by ID
  Future<int> deleteStudent(int id) async {
    final db = await instance.database;

    // Delete row from 'students' table where id matches
    return await db.delete(
      'students',
      where: 'id = ?',       // Condition
      whereArgs: [id],       // Student ID to delete
    );
  }

  // Close the database connection (optional, but good practice)
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
/*
💡 Summary of What This Code Does

Manages a local SQLite database named students.db.

Creates a students table with columns: id, name, email, and age.

Provides CRUD operations:

✅ insertStudent() — Add new student

📋 getStudents() — Get all students

🔍 getStudent(id) — Get single student by ID

✏️ updateStudent() — Update student info

🗑️ deleteStudent() — Remove student
 */