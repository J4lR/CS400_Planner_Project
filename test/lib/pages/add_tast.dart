import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/components/date_model.dart';
import 'package:test/utils.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key, this.getPage});
  final String? getPage;
  @override
  Widget build(BuildContext context) {
    return _AddTaskPage(eventType: getPage);
  }
}

class _AddTaskPage extends StatefulWidget {
  const _AddTaskPage({super.key, required this.eventType});
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _editingController = TextEditingController();
  final String eventType;

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDay = context.watch<DateModel>().selectedDate;
    return Provider<DateModel>(
      create: (_) => DateModel(),
      builder: (context, child) {
        return AlertDialog(
          scrollable: true,
          title: Text('Add Task'),
          content: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(controller: _editingController),
          ),

          actions: [
            DropdownMenu(
              label: const Text('Select Event Type'),
              dropdownMenuEntries: <DropdownMenuEntry<Event>>[
                DropdownMenuEntry(value: value, label: 'Appointment'),
                DropdownMenuEntry(value: value, label: 'Homework'),
                DropdownMenuEntry(value: value, label: 'Meetings'),
                DropdownMenuEntry(value: value, label: 'Miscellaneous Event'),
                DropdownMenuEntry(value: value, label: 'Payments'),
                DropdownMenuEntry(value: value, label: 'Schedule'),
                DropdownMenuEntry(value: value, label: 'Appointment'),
              ],
              onSelected: (value) {
                if (event != null) {}
              },
            ),
            ElevatedButton(
              onPressed: () {
                events.addAll({
                  selectedDay: [Event(_editingController.text)],
                });
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ], // store the Event Name into map
        );
      },
    );
  }
}
