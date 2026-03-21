import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:test/components/todo.dart';

typedef EventEntry = DropdownMenuEntry<EventLabel>;

enum EventLabel {
  appoinntment(name: 'Appointment', color: Colors.blue),
  homework(name: 'Homework', color: Colors.amber),
  meeting(name: 'Meeting', color: Colors.red),
  miscEvent(name: 'Misalleneous Event', color: Colors.deepPurple),
  payment(name: 'Payments', color: Colors.pink),
  schedule(name: 'Schedule', color: Colors.yellow),
  taskList(name: 'Task List', color: Colors.green);

  const EventLabel({required this.name, required this.color});

  final String name;
  final Color color;
  static final List<EventEntry> entries = UnmodifiableListView(
    values.map<EventEntry>(
      (EventLabel event) => EventEntry(value: event, label: event.name),
    ),
  );
}

class UsePriorityDDM extends StatefulWidget {
  const UsePriorityDDM({super.key});

  @override
  State<UsePriorityDDM> createState() => _PriorityMenu();
}

class _PriorityMenu extends State<UsePriorityDDM> {
  final TextEditingController pController = TextEditingController();
  Priority? selectedPriority;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(label: Text('Proirity')),
        items: Priority.values.map((p) {
          return DropdownMenuItem(value: p, child: Text(p.name));
        }).toList(),
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}

class UseEventDDm extends StatefulWidget {
  const UseEventDDm({super.key, required this.typeofEvent});
  final String typeofEvent;
  @override
  State<UseEventDDm> createState() => _EventMenu(getEvent: typeofEvent);
}

class _EventMenu extends State<UseEventDDm> {
  _EventMenu({required this.getEvent});
  String getEvent;
  final TextEditingController eventController = TextEditingController();
  EventLabel? selectedEvent;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      initialValue: getEvent,
      decoration: const InputDecoration(label: Text('Type Of Event')),
      items: EventLabel.values.map((e) {
        return DropdownMenuItem(value: e, child: Text(e.name));
      }).toList(),
      onChanged: (value) {
        setState(() {
          getEvent = value.toString();
        });
      },
    );
  }
}
