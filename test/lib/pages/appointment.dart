import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';

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
          appBar: MyAppbar(pageTitle: 'Planner'),
          drawer: AppDrawer(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(children: [

              ],
            ),
          ),
        ),
      ),
    );
  }
}
