import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/db/db_helper.dart';
import 'package:test_project/utils/utls.dart';
import 'package:test_project/view/home/home.dart';

import '../model/user_model.dart';
import '../view/login/login.dart';

class AuthService {
  bool validateEmail(BuildContext context, String email) {
    if (email.isEmpty) {
      customSnackBar(context, "Email is required", Colors.red);
      return false;
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      customSnackBar(context, "Invalid email format", Colors.red);
      false;
    }
    return true;
  }

  bool validatePassword(BuildContext context, String password) {
    if (password.isEmpty) {
      customSnackBar(context, "Password is required", Colors.red);
      return false;
    }
    if (password.length < 6) {
      customSnackBar(
        context,
        "Password must be at least 6 characters",
        Colors.red,
      );
      return false;
    }
    return true;
  }

  bool validateUsername(BuildContext context, String username) {
    if (username.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username must be at least 3 characters")),
      );
      return false;
    }

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Username is required")));
      return false;
    }

    return true;
  }

  bool validatePasswordRegister(
    BuildContext context,
    String password,
    String confirmPassword,
  ) {
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password is required")));
      return false;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Confirm Password is required")));
      return false;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return false;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return false;
    }
    return true;
  }

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (validateEmail(context, email) && validatePassword(context, password)) {
      DatabaseHelper databaseHelper = DatabaseHelper.instance;

      final response = await databaseHelper.login(email, password);

      if (response != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt("id", response.id!);

        customSnackBar(context, "Welcome ${response.userName}", Colors.green);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (route) => false,
        );
      } else {
        customSnackBar(context, "Invalid email or password", Colors.red);
      }
    }
  }

  Future<void> register(
    BuildContext context,
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (validateUsername(context, username) &&
        validateEmail(context, email) &&
        validatePasswordRegister(context, password, confirmPassword)) {
      DatabaseHelper databaseHelper = DatabaseHelper.instance;

      User user = User(userName: username, email: email, password: password);

      await databaseHelper.checkUserExists(email).then((value) {
        if (value) {
          customSnackBar(context, "User already exists", Colors.red);
        } else {
          databaseHelper.registerUser(user).then((value) {
            customSnackBar(
              context,
              "User registered successfully",
              Colors.green,
            );
            Navigator.pop(context);
          });
        }
      });
    }
  }

  static Future<void> logout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("id");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
