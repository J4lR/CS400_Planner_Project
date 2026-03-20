import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';
import 'package:test/components/my_searchbar.dart';

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
          appBar: MyAppbar(pageTitle: 'Appointments'),
          drawer: AppDrawer(),
          body: Row(children: [searchbox()]),
        ),
      ),
    );
  }
}
