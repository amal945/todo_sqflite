import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/db/db_helper.dart';
import 'package:test_project/model/todo_model.dart';
import 'package:test_project/utils/utls.dart';

class TodoService {
  static Future<void> addTodo({
    required String title,
    required String description,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("id");
      if (userId == null) {
        customSnackBar(context, "User not logged in", Colors.red);
        return;
      }
      String createdAt = DateTime.now().toIso8601String();
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      final todo = Todo(
        userId: userId,
        title: title,
        description: description,
        createdAt: createdAt,
        updatedAt: null,
      );

      final response = await databaseHelper.createTodo(todo);

      if (response != 0) {
        customSnackBar(context, "Todo added successfully", Colors.green);
      } else {
        customSnackBar(context, "Failed to add todo", Colors.red);
      }
    } catch (e) {
      customSnackBar(context, "$e", Colors.red);
    }
  }

  static Future<List<Todo>> getAllTodos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("id");

      DatabaseHelper databaseHelper = DatabaseHelper.instance;

      final response = await databaseHelper.fetchAllTodos(userId: userId!);

      if (response != null && response.isNotEmpty) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> toggleCompletion({
    required BuildContext context,
    required Todo data,
  }) async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      final updatedTodo = Todo(
        id: data.id,
        userId: data.userId,
        title: data.title,
        description: data.description,
        createdAt: data.createdAt,
        updatedAt: null,
        isCompleted: !data.isCompleted,
      );

      return databaseHelper.updateTodo(updatedTodo);
    } catch (e) {
      customSnackBar(context, "$e", Colors.red);
      return false;
    }
  }

  static Future<bool> updateTodo({
    required BuildContext context,
    required Todo data,
    required String title,
    required String description,
  }) async {
    try {
      String updatedAt = DateTime.now().toIso8601String();
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      final updatedTodo = Todo(
        id: data.id,
        userId: data.userId,
        title: title,
        description: description,
        createdAt: data.createdAt,
        updatedAt: updatedAt,
        isCompleted: data.isCompleted,
      );

      return databaseHelper.updateTodo(updatedTodo);
    } catch (e) {
      customSnackBar(context, "$e", Colors.red);
      return false;
    }
  }

  static Future<bool> deleteTodo({
    required BuildContext context,
    required int todoId,
  }) async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper.instance;

      final response = await databaseHelper.deleteTodo(todoId);

      return response > 0;
    } catch (e) {
      customSnackBar(context, "$e", Colors.red);
      return false;
    }
  }
}
