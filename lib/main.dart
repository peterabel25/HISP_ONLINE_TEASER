// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/todo_provider.dart';
import 'screens/homepage.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>TodoProvider())
      ],
      child: MaterialApp(
        home:MyHomepage() ,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
      ),
    ),
  );
}
