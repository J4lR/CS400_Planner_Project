//By aleksanderwozniak
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test/utils.dart';

class TableCalenderTest extends StatefulWidget {
  const TableCalenderTest({super.key});

  @override
  State<TableCalenderTest> createState() => _CalenderTest();
}

class _CalenderTest extends State<TableCalenderTest> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectdDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testing Calendar")),
      body: TableCalendar(
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectdDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectdDay, selectedDay)) {
            setState(() {
              _selectdDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
