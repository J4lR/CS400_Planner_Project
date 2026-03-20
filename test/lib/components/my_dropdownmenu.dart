import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

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

typedef PriorityEntry = DropdownMenuEntry<PriorityLabel>;

enum PriorityLabel {
  low(name: 'Low', color: Colors.green),
  medium(name: 'Medium', color: Colors.yellow),
  high(name: 'High', color: Colors.deepOrange),
  urgent(name: 'Urgent', color: Color.fromARGB(183, 136, 19, 11));

  const PriorityLabel({required this.name, required this.color});
  final String name;
  final Color color;
  static final List<PriorityEntry> p = UnmodifiableListView(
    values.map<PriorityEntry>(
      (PriorityLabel event) => PriorityEntry(value: event, label: event.name),
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
  PriorityLabel? selectedPriority;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20.0),
      child: DropdownMenu(
        label: Text("Priority"),
        dropdownMenuEntries: PriorityLabel.p,
      ),
    );
  }
}

class UseEventDDm extends StatefulWidget {
  const UseEventDDm({super.key});

  @override
  State<UseEventDDm> createState() => _EventMenu();
}

class _EventMenu extends State<UseEventDDm> {
  final TextEditingController eventController = TextEditingController();
  EventLabel? selectedEvent;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      label: Text("Event Type"),
      dropdownMenuEntries: EventLabel.entries,
    );
  }
}
