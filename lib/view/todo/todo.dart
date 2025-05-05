import 'package:flutter/material.dart';
import 'package:test_project/model/todo_model.dart';
import 'package:test_project/services/todo_services.dart';
import 'package:test_project/utils/utls.dart';

class TodoScreen extends StatefulWidget {
  final Todo? todo;

  const TodoScreen({super.key, this.todo});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    setValue();
    super.initState();
  }

  bool isEditMode = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void setValue() {
    if (widget.todo != null) {
      final data = widget.todo;
      titleController.text = data!.title;
      descriptionController.text = data.description;
      isEditMode = true;
      setState(() {});
    }
  }

  Future<void> addOrUpdateTodo() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      customSnackBar(context, "Please fill all fields", Colors.red);
      return;
    }

    if (!isEditMode) {
      await TodoService.addTodo(
        title: title,
        description: description,
        context: context,
      );
      Navigator.pop(context);
    } else {
      bool response = await TodoService.updateTodo(
        context: context,
        data: widget.todo!,
        title: title,
        description: description,
      );
      Navigator.pop(context);
      if (response) {
        customSnackBar(context, "Todo updated successfully!", Colors.green);
      } else {
        customSnackBar(context, "Failed to update!", Colors.red);
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("TODO"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Task Title",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Task Description",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  addOrUpdateTodo();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEditMode ? "Update" : "Save",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
