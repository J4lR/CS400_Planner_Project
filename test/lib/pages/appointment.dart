import 'package:flutter/material.dart';
import 'package:test/components/event_list.dart';
import 'package:test/components/my_appbar.dart';
import 'package:test/components/my_searchbar.dart';
import 'package:test/components/todo.dart';

class OpenAppointment extends StatefulWidget {
  const OpenAppointment({super.key});

  @override
  State<OpenAppointment> createState() => _AppointmentPage();
}

class _AppointmentPage extends State<OpenAppointment> {
  final List<Todo> todos = [
    const Todo(
      title: 'Doctor Check In',
      description: 'Go see main doctor at so and so street meet at ',
      priority: Priority.high,
    ),
    const Todo(
      title: 'Interview',
      description: 'Interview with boss for promotion',
      priority: Priority.urgent,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: MyAppbar(pageTitle: 'Appointments'),
          drawer: AppDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                MySearchbar(),
                Expanded(child: EventList(todos: todos)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
