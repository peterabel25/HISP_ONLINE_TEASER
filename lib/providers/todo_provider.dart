// ignore_for_file: unnecessary_new, non_constant_identifier_names, prefer_interpolation_to_compose_strings, dead_code, unnecessary_brace_in_string_interps, avoid_print

import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';

import '../model/todo_model.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:intl/intl.dart';

class TodoProvider extends ChangeNotifier {
  final String username = "admin";
  final String password = "district";
  final String myName = "peterAbel";

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  List<Todo> TodoList = [];

//GET ALL TODOS
  Future<void> fetchTodos() async {
    try {
      final url = Uri.parse(
        'https://dev.hisptz.com/dhis2/api/dataStore/${myName}?fields=.',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("admin:district"))}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List<dynamic>) {
          TodoList = data.map((item) => Todo.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          // Assuming the data is stored under a specific key, adjust the key accordingly
          final entries = data['entries'] as List<dynamic>?;
          if (entries != null) {
            TodoList = entries.map((item) => Todo.fromJson(item)).toList();
            print(TodoList[0].id);
          } else {
            throw Exception('Invalid response format: missing "entries" key');
          }
        } else {
          throw Exception(
              'Invalid response format: expected List<dynamic> or Map<String, dynamic>');
        }
      } else {
        throw Exception('Failed to fetch todos: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch todos: $error');
    }
    notifyListeners();
  }

//ADD A NEW TODO
  Future<void> postTodo(
    String id,
    String title,
    String description,
  ) async {
    try {
      final url = Uri.parse(
        'https://dev.hisptz.com/dhis2/api/dataStore/${myName}/${id}',
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("admin:district"))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': getRandomString(10),
          'title': title,
          'description': description,
          'completed': false,
          'created': formattedDate
        }),
      );
      print(response.body);
      if (response.statusCode == 201) {
        // Todo successfully posted
      } else {
        throw Exception('Failed to post todo');
      }
    } catch (error) {
      throw Exception('Failed to post todo: $error');
    }
    fetchTodos();
    notifyListeners();
  }

//GET SPECIFIC TODO
  Future<Todo> getTodoById(String id) async {
    try {
      final url = Uri.parse(
        'https://dev.hisptz.com/dhis2/api/dataStore/${myName}/$id',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("admin:district"))}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>?;

        if (data != null && data.containsKey('value')) {
          final todoData = data['value'] as Map<String, dynamic>;
          return Todo.fromJson(todoData);
          print(todoData);
        } else {
          throw Exception('Todo not found');
        }
      } else {
        throw Exception('Failed to fetch todo: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch todo: $error');
    }
  }

//DELETE A TODO

  Future<void> deleteTodo(String id) async {
    try {
      final url = Uri.parse(
        'https://dev.hisptz.com/dhis2/api/dataStore/${myName}/${id}',
      );

      final response = await http.delete(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("admin:district"))}',
        },
      );

      if (response.statusCode == 200) {
        print("To do deleted successfully");
      }
    } catch (error) {
      throw Exception('Failed to delete todo: $error');
    }
    fetchTodos();
    notifyListeners();
  }
}
