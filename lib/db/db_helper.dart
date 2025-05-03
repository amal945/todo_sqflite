import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_project/user_model.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    return await openDatabase("todo.db", version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    return await db.execute(
      "CREATE TABLE todo ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "userName TEXT,"
      "email TEXT,"
      "password TEXT"
      ")",
    );
  }

  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert("todo", user.toMap());
  }

  Future<User?> login(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> user = await db.query(
      "todo",
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (user.isNotEmpty) {
      return User.fromMap(user.first);
    }

    return null;
  }

  Future<bool> checkUserExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> user = await db.query(
      "todo",
      where: 'email = ?',
      whereArgs: [email],
    );

    if (user.isNotEmpty) {
      return true;
    }
    return false;
  }





}
