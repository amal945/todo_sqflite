import 'package:flutter/material.dart';

customSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: color,
    ),
  );
}
