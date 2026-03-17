import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';

class OpenTaskList extends StatefulWidget {
  const OpenTaskList({super.key});

  @override
  State<OpenTaskList> createState() => _TaskListPage();
}

class _TaskListPage extends State<OpenTaskList> {
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
