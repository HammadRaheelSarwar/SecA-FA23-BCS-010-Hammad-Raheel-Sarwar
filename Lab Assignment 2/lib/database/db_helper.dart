import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:game/models/game_result.dart';

class DatabaseHelper {
  static const String _databaseName = 'game_history.db';
  static const String _tableName = 'game_results';
  static const String _usersTable = 'users';
  static const int _databaseVersion = 2;

  static const String columnId = 'id';
  static const String columnGuess = 'guess';
  static const String columnCorrectNumber = 'correct_number';
  static const String columnStatus = 'status';
  static const String columnTimestamp = 'timestamp';
  // User columns
  static const String userColumnId = 'id';
  static const String userColumnName = 'name';
  static const String userColumnEmail = 'email';
  static const String userColumnPassword = 'password_hash';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final String databasePath = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnGuess INTEGER NOT NULL,
        $columnCorrectNumber INTEGER NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnTimestamp TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $_usersTable(
        $userColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $userColumnName TEXT NOT NULL,
        $userColumnEmail TEXT NOT NULL UNIQUE,
        $userColumnPassword TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add users table when upgrading from version 1 -> 2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_usersTable(
          $userColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $userColumnName TEXT NOT NULL,
          $userColumnEmail TEXT NOT NULL UNIQUE,
          $userColumnPassword TEXT NOT NULL
        )
      ''');
    }
  }

  Future<int> insertGameResult(GameResult gameResult) async {
    final Database db = await database;
    return await db.insert(
      _tableName,
      gameResult.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---- User related methods ----
  Future<int> insertUser(Map<String, dynamic> userMap) async {
    final Database db = await database;
    return await db.insert(
      _usersTable,
      userMap,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      _usersTable,
      where: '$userColumnEmail = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first.cast<String, dynamic>();
  }

  Future<List<GameResult>> getAllGameResults() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      _tableName,
      orderBy: '$columnTimestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return GameResult.fromMap(maps[i]);
    });
  }

  Future<void> deleteAllGameResults() async {
    final Database db = await database;
    await db.delete(_tableName);
  }

  Future<void> deleteGameResult(int id) async {
    final Database db = await database;
    await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> getGameResultCount() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(_tableName);
    return maps.length;
  }
}
