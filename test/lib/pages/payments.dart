import 'package:flutter/material.dart';
import 'package:test/components/my_appbar.dart';

class OpenPayments extends StatefulWidget {
  const OpenPayments({super.key});

  @override
  State<OpenPayments> createState() => _PaymentsPage();
}

class _PaymentsPage extends State<OpenPayments> {
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
