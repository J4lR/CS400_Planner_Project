//By aleksanderwozniak
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test/components/date_model.dart';
import 'package:test/utils.dart';
import 'package:test/components/my_appbar.dart';

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
  void initState() {
    super.initState();
    _selectdDay = _focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final selectedDate = context.watch<DateModel>().selectedDate;
    return Provider<DateModel>(
      create: (_) => DateModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: MyAppbar(pageTitle: 'Calendar'),
          drawer: AppDrawer(),
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
                Provider.of<DateModel>(
                  context,
                  listen: false,
                ).updatedSelectedDate(selectedDay);
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
      },
    );
  }
}
