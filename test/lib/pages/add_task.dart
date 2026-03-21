import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/components/date_model.dart';
import 'package:test/components/my_dropdownmenu.dart';
import 'package:test/utils.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key, required this.getPage});
  final String getPage;
  @override
  State<AddTask> createState() => _AddTaskPage(eventType: getPage);
}

class _AddTaskPage extends State<AddTask> {
  _AddTaskPage({required this.eventType});
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
          contentPadding: EdgeInsetsGeometry.all(15),
          scrollable: true,
          title: Text('Add Task'),
          content: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(controller: _editingController),
            //Needs to include an on changed
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  UseEventDDm(typeofEvent: eventType),
                  UsePriorityDDM(),
                  DatePickerScreen(),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
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
                    ],
                  ),
                ],
              ),
            ),
          ], // store the Event Name into map
        );
      },
    );
  }
}
