import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';

class OpenMiscEvent extends StatefulWidget {
  const OpenMiscEvent({super.key});

  @override
  State<OpenMiscEvent> createState() => _MiscEventPage();
}

class _MiscEventPage extends State<OpenMiscEvent> {
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
