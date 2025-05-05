import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_project/model/todo_model.dart';
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
    String path = join(await getDatabasesPath(), "todo.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE users ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "userName TEXT,"
      "email TEXT,"
      "password TEXT"
      ")",
    );

    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        description TEXT,
        isCompleted INTEGER DEFAULT 0,
        createdAt TEXT,
        updatedAt TEXT NULL,
        completedAt TEXT NULL,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
  }

  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert("users", user.toMap());
  }

  Future<User?> login(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> user = await db.query(
      "users",
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
      "users",
      where: 'email = ?',
      whereArgs: [email],
    );

    if (user.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<int> createTodo(Todo data) async {
    final db = await database;
    return await db.insert("todos", data.toMap());
  }

  Future<List<Todo>?> fetchAllTodos({required int userId}) async {
    final db = await database;
    final List<Map<String, dynamic>> todos = await db.query(
      "todos",
      where: 'userId = ?',
      whereArgs: [userId],
    );
    final data = todos.map((e) => Todo.fromMap(e)).toList();
    return data;
  }

  Future<bool> updateTodo(Todo data) async {
    final db = await database;
    final rowsAffected = await db.update(
      "todos",
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );

    return rowsAffected > 0;
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete("todos", where: 'id = ?', whereArgs: [id]);
  }
}
