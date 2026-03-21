import 'package:flutter/material.dart';
import 'package:planner/theme.dart';
import 'package:planner/pages/login.dart';

void main() {
  runApp(const TasklyApp());
}

class TasklyApp extends StatefulWidget {
  const TasklyApp({super.key});

  static _TasklyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_TasklyAppState>();

  @override
  State<TasklyApp> createState() => _TasklyAppState();
}

class _TasklyAppState extends State<TasklyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      theme: TasklyTheme.lightTheme,
      darkTheme: TasklyTheme.darkTheme,
      themeMode: _themeMode,
      home: const LoginPage(),
    );
  }
}