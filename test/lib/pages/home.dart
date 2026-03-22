import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';
import 'package:test/pages/calendar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: MyAppbar(pageTitle: 'Planner'),
          drawer: AppDrawer(),
          body: Column(
            children: [
              //Should be in a stateful widget since the task will be constantly updating
              Container(
                width: 300.0,
                alignment: Alignment.center,
                child: Title(
                  color: const Color.fromARGB(255, 189, 18, 18),
                  child: Text('Task List'),
                ),
              ),
              Container(
                //using GestureDetectors to create unique buttons with containers
                width: 300.0,
                height: 50,
                alignment: Alignment.topRight,
                child: Center(child: Text("Task")),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableCalenderTest()),
                ),
                child: const Text('View All Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
