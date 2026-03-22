import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/components/date_model.dart';
import 'package:test/pages/home.dart';
import 'package:test/pages/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DateModel(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
