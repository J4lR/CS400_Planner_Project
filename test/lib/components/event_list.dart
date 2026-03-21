import 'package:flutter/material.dart';
import 'package:test/components/todo.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.todos});

  final List<Todo> todos;
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todos.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.todos[index].priority.color.withOpacity(0.5),
            ),
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.todos[index].title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.todos[index].description),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: widget.todos[index].priority.color,
                  ),
                  child: Text(widget.todos[index].priority.name),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
