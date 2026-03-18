import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';

class OpenMeetings extends StatefulWidget {
  const OpenMeetings({super.key});

  @override
  State<OpenMeetings> createState() => _MeetingsPage();
}

class _MeetingsPage extends State<OpenMeetings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: MyAppbar(pageTitle: 'Meetings'),
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
