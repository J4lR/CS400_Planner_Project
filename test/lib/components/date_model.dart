import 'package:flutter/material.dart';

class DateModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void updatedSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key});

  @override
  State<DatePickerScreen> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePickerScreen> {
  DateTime? _selectedDate;

  Future<void> _selecteDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _selectedDate == null
              ? 'No Date Selected'
              : '${_selectedDate!.toLocal()}'.split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          onPressed: _selecteDate,
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    );
  }
}
