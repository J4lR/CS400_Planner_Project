import 'package:flutter/material.dart';
import 'package:test/main.dart';

class OpenAppointment extends StatefulWidget {
  const OpenAppointment({super.key});

  @override
  State<OpenAppointment> createState() => _AppointmentPage();
}

class _AppointmentPage extends State<OpenAppointment> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainApp()),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: "Back to Home",
                );
              },
            ),
            title: Text("Appointment"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_alert),
                tooltip: "Reminders",
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("No Reminders")));
                },
              ),
              IconButton(
                onPressed: null,
                icon: Icon(Icons.add),
                tooltip: "Add Appointment",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
