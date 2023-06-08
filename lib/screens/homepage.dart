// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_app/providers/todo_provider.dart';
import 'package:simple_todo_app/screens/add_todo.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  @override
  void initState() {
    TodoProvider todoprovider = Provider.of(context, listen: false);
    todoprovider.fetchTodos();
    super.initState();
  }

  void showTodoDetailsDialog(
      BuildContext context, String? title, String? description, bool status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Todo-title :" + " " + title!),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(description!),
              SizedBox(height: 8),
              Text(
                'Status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(status ? 'Completed' : 'Incomplete'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                editTodoDetailsDialog(context);
              },
              child: Text('edit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void editTodoDetailsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Todo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  // controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  //controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    TodoProvider todoprovider = Provider.of(context);
    return Scaffold(
        drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return InputDialog();
                },
              );
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Row(
            children: [
              Text(
                "MyTodo List",
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Expanded(
                child: Container(
                  // Adjust the width as desired
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the border radius as desired
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      //hintText: 'Search',
                      // hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 18.0), // Adjust the padding as desired
                    ),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0), // Adjust the font size as desired
                    cursorColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
                itemCount: todoprovider.TodoList.length,
                itemBuilder: ((context, index) => InkWell(
                      onTap: () {
                        showTodoDetailsDialog(
                            context,
                            todoprovider.TodoList[index].title,
                            todoprovider.TodoList[index].description,
                            false);
                      },
                      child: ListTile(
                          leading: Checkbox(
                            value: todoprovider.TodoList[index].completed,
                            onChanged: (bool? value) {
                              setState(() {
                                todoprovider.TodoList[index].completed = value!;
                              });
                            },
                          ),
                          title: Text("Title :" +
                              " " +
                              "${todoprovider.TodoList[index].title}"),
                          subtitle: Text("description :" +
                              " " +
                              "${todoprovider.TodoList[index].description}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {

                              todoprovider.deleteTodo("${todoprovider.TodoList[index].id}");
                            },
                          )),
                    )))));
  }
}
