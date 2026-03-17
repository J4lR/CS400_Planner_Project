import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';

class OpenHomework extends StatefulWidget {
  const OpenHomework({super.key});

  @override
  State<OpenHomework> createState() => _HomeworkPage();
}

class _HomeworkPage extends State<OpenHomework> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: MyAppbar(pageTitle: 'Planner'),
          drawer: AppDrawer(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(children: [

              ],
            ),
          ),
        ),
      ),
    );
  }
}
