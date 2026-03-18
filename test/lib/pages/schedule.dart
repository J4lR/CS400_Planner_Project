import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';

class OpenSchedule extends StatefulWidget {
  const OpenSchedule({super.key});

  @override
  State<OpenSchedule> createState() => _SchedulePage();
}

class _SchedulePage extends State<OpenSchedule> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: MyAppbar(pageTitle: 'Schedule'),
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
