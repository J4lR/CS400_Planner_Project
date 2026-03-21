import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

typedef PriorityEntry = DropdownMenuEntry<Priority>;

enum Priority {
  low(name: 'Low', color: Colors.green),
  medium(name: 'Medium', color: Colors.yellow),
  high(name: 'High', color: Colors.deepOrange),
  urgent(name: 'Urgent', color: Color.fromARGB(183, 136, 19, 11));

  const Priority({required this.name, required this.color});
  final String name;
  final Color color;
  static final List<PriorityEntry> p = UnmodifiableListView(
    values.map<PriorityEntry>(
      (Priority event) => PriorityEntry(value: event, label: event.name),
    ),
  );
}

class Todo {
  const Todo({
    required this.title,
    required this.description,
    required this.priority,
    this.dateOfEvent,
    this.timeOfEvent,
  });

  final String title;
  final String description;
  final Priority priority;
  final DateTime? dateOfEvent;
  final DateTime? timeOfEvent;
}
