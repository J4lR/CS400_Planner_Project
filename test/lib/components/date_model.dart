import 'package:flutter/material.dart';

class DateModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void updatedSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}
