import 'package:flutter/material.dart';
//import 'package:table_calendar/table_calendar.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:test/pages/calendar.dart';
import 'package:test/pages/appointment.dart';
import 'package:test/pages/tasklist.dart';
import 'package:test/pages/homework.dart';
import 'package:test/pages/meetings.dart';
import 'package:test/pages/payments.dart';
import 'package:test/pages/schedule.dart';
import 'package:test/pages/miscevent.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const appTitle = 'Planner';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MainPage(title: appTitle),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: "Navigation Menu",
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Text(widget.title),
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
            ],
            backgroundColor: const Color.fromARGB(255, 55, 102, 231),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(child: Text("Pages")),
                ListTile(
                  title: const Text("Calendar"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TableCalenderTest(),
                    ),
                  ),
                  // Opens Calendar Page
                ),
                ListTile(
                  title: const Text("Appointments"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenAppointment()),
                  ),
                  // Opens Appointment page
                ),
                ListTile(
                  title: const Text("Task List"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenTaskList()),
                  ),
                  //Opens Task List Page
                ),
                ListTile(
                  title: const Text("Homework"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenHomework()),
                  ),
                  //Opens Homework page
                ),
                ListTile(
                  title: const Text("Meetings"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenMeetings()),
                  ),
                  //Opens Meetings page
                ),
                ListTile(
                  title: const Text("Schedule"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenSchedule()),
                  ),
                  // Opens Schedule page
                ),
                ListTile(
                  title: const Text("Payments"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenPayments()),
                  ),
                  //Opens Payment page
                ),
                ListTile(
                  title: const Text("Misc. Events"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenMiscEvent()),
                  ),
                  //Opens Misc. Events page
                ),
              ],
            ),
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
