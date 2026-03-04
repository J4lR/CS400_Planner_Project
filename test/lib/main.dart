import 'package:flutter/material.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:test/pages/calendar.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainPage();
}

class _MainPage extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              tooltip: "Navigation Menu",
              onPressed: () {
                Scaffold.of(context).openDrawer();
                Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(child: Text("DrawerTitle")),
                      ListTile(
                        title: const Text("Page 1"),
                        onTap: () {
                          //Should go to calendar page
                        },
                      ),
                      ListTile(
                        title: const Text("Page 2"),
                        onTap: () {
                          // Should go to Appointment page
                        },
                      ),
                      ListTile(
                        title: const Text("Page 3"),
                        onTap: () {
                          //Should go to Task List
                        },
                      ),
                      ListTile(
                        title: const Text("Page 4"),
                        onTap: () {
                          //Should go to Homework page
                        },
                      ),
                      ListTile(
                        title: const Text("Page 5"),
                        onTap: () {
                          //Should go to Meetings page
                        },
                      ),
                      ListTile(
                        title: const Text("Page 6"),
                        onTap: () {
                          // Should go to Schedule page
                        },
                      ),
                      ListTile(
                        title: const Text("Page 7"),
                        onTap: () {
                          //Should go to Payment page
                        },
                      ),
                      ListTile(
                        title: const Text("Page 8"),
                        onTap: () {
                          //Should go to Misc. Events page
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            title: Text("Planner"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_alert),
                tooltip: "Reminders",
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("No Reminders")));
                },
              ),
              IconButton(
                onPressed: null,
                icon: Icon(Icons.add),
                tooltip: "Add Task",
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: "Calendar",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableCalenderTest()),
                ),
              ),
            ],
            backgroundColor: const Color.fromARGB(255, 55, 102, 231),
          ),
          body: Column(
            children: [
              //Should be in a stateful widget since the task will be constantly updating
              Container(
                color: Color.fromARGB(253, 6, 30, 151),
                width: 300.0,
                alignment: Alignment.center,
                child: Title(color: Colors.white, child: Text('Task List')),
              ),
              Container(
                //using GestureDetectors to create unique buttons with containers
                color: Colors.blue,
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
