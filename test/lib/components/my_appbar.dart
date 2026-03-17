import 'package:flutter/material.dart';
import 'package:test/main.dart';
import 'package:test/pages/calendar.dart';
import 'package:test/pages/appointment.dart';
import 'package:test/pages/tasklist.dart';
import 'package:test/pages/homework.dart';
import 'package:test/pages/meetings.dart';
import 'package:test/pages/payments.dart';
import 'package:test/pages/schedule.dart';
import 'package:test/pages/miscevent.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({super.key, required this.pageTitle});
  final String pageTitle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      title: Text(pageTitle),
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
        IconButton(onPressed: null, icon: Icon(Icons.add), tooltip: "Add Task"),
      ],
      backgroundColor: const Color.fromARGB(255, 55, 102, 231),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(16.0);
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text("Pages")),
          ListTile(
            title: const Text("Home"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MainApp()),
            ),
            // Opens Home Page
          ),
          ListTile(
            title: const Text("Calendar"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TableCalenderTest()),
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
    );
  }
}
