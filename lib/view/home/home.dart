import 'package:flutter/material.dart';
import 'package:test_project/services/services.dart';
import 'package:test_project/utils/custom_logout_dialoguebox.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Todo",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return customLogoutConfirmDialogueBox(
                    context,
                    onConfirm: () {
                      AuthService.logout(context);
                    },
                  );
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text("Home Screen")),
    );
  }
}
