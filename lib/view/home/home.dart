import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:test_project/model/todo_model.dart';
import 'package:test_project/services/auth_services.dart';
import 'package:test_project/services/todo_services.dart';
import 'package:test_project/utils/custom_logout_dialoguebox.dart';
import 'package:test_project/utils/utls.dart';
import 'package:test_project/view/todo/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getAllTodos();
    super.initState();
  }

  List<Todo> todos = [];

  Future<void> getAllTodos() async {
    todos = await TodoService.getAllTodos();
    setState(() {});
  }

  Future<void> deleteTodo({required int todoId}) async {
    showDialog(
      context: context,
      builder: (context) {
        return customLogoutConfirmDialogueBox(
          context,
          onConfirm: () async {
            bool response = await TodoService.deleteTodo(
              context: context,
              todoId: todoId,
            );
            if (response) {
              customSnackBar(
                context,
                "Todo deleted successfully",
                Colors.green,
              );
              await getAllTodos();
            } else {
              customSnackBar(context, "Failed to delete", Colors.red);
            }
          },
          title: "Confirmation",
          subtitle: "Are you sure you want to delete",
        );
      },
    );
  }

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
                    title: 'Confirmation',
                    subtitle: 'Are you sure you want to logout?',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoScreen()),
          );
          await getAllTodos();
          setState(() {});
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          if (todos.isEmpty) {
            return Center(
              child: Text(
                "No Active Todos",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final todo = todos[index];
          final dateTime = DateTime.parse(todo.createdAt);
          final viewDate = DateFormat('d MMMM y').format(dateTime);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slidable(
              key: ValueKey(todo.id),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(12),
                    spacing: 2,
                    onPressed: (context) {
                      deleteTodo(todoId: todo.id!);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: "Delete",
                  ),
                ],
              ),
              child: InkWell(
                onTap: () async {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoScreen(todo: todo),
                    ),
                  );
                  await getAllTodos();
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) async {
                        final response = await TodoService.toggleCompletion(
                          context: context,
                          data: todo,
                        );
                        getAllTodos();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      activeColor: Colors.white,
                      checkColor: Colors.green,
                    ),
                    title: Text("${todo.title}"),
                    subtitle: Text("${todo.description}"),
                    trailing: Text("${viewDate}"),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
