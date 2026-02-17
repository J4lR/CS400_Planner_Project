import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MainApp());
}
class TableCalenderTest extends StatefulWidget{
  const TableCalenderTest({Key? Key}) : super(key: Key);
  
  @override
}
class _CalenderTest extends State<TableCalenderTest>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectdDay;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing Calendar"),
      ),
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
          
        ),
    );
  }
}
class MainApp extends StatelessWidget{
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: const IconButton(
              onPressed: null, 
              icon: Icon(Icons.menu),
              tooltip: "Navigation Menu",
              ),
            title: Text("Planner"),
            actions: <Widget>[
              IconButton( 
                icon: const Icon(Icons.add_alert),
                tooltip: "Reminders",
                onPressed: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No Reminders"))
                  );
                },
              ),
              IconButton(
                onPressed: null, 
                icon: Icon(Icons.add),
                tooltip: "Add Task",
                ),
            ],
            backgroundColor: const Color.fromARGB(255, 55, 102, 231),
          ),
          body: Column(children: [//Should be in a stateful widget since the task will be constantly updating
            Container(
              color: Color.fromARGB(253, 6, 30, 151),
              width: 300.0,
              alignment: Alignment.center,
              child: Title(color: Colors.white , child: Text('Task List'),)
            ),
            Container(//using GestureDetectors to create unique buttons with containers
              color: Colors.blue,
              width: 300.0,
              height: 50,
              alignment: Alignment.topRight,
              child: Center(
                child: Text("Task"),
              ),
            )
          ],)
        ),
      ),
    ); 
  }
}
