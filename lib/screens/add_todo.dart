// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class InputDialog extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TodoProvider todoprovider = Provider.of(context);

    return AlertDialog(
      title: Text('Add Todo'),
      content: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (value) {
                if (value == "") return "Title is required";
              },
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              validator: (value) {
                if (value == "") return "description is required";
              },
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formkey.currentState!.validate()) {
              todoprovider.postTodo(todoprovider.getRandomString(10),
                  titleController.text, descriptionController.text);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
