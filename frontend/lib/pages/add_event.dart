import 'package:flutter/material.dart';
import 'package:planner/api_service.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'task';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String _repeatType = 'none';
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedPriority = 'medium';

  final List<Map<String, dynamic>> _priorities = [
    {'value': 'low', 'label': 'Low', 'color': Color(0xFF22C55E)},
    {'value': 'medium', 'label': 'Medium', 'color': Color(0xFFF59E0B)},
    {'value': 'high', 'label': 'High', 'color': Color(0xFFEF4444)},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'value': 'task', 'label': 'Task', 'icon': Icons.task_alt, 'color': Color(0xFF3B82F6)},
    {'value': 'homework', 'label': 'Homework', 'icon': Icons.school_outlined, 'color': Color(0xFF8B5CF6)},
    {'value': 'payment', 'label': 'Payment', 'icon': Icons.payments_outlined, 'color': Color(0xFF22C55E)},
    {'value': 'meeting', 'label': 'Meeting', 'icon': Icons.groups_outlined, 'color': Color(0xFF3B82F6)},
    {'value': 'appointment', 'label': 'Appointment', 'icon': Icons.event_outlined, 'color': Color(0xFFF59E0B)},
    {'value': 'misc', 'label': 'Other', 'icon': Icons.more_horiz, 'color': Color(0xFF6B7280)},
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter a title');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await createTask({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      'due_date': _selectedDate.toIso8601String().split('T')[0],
      'completed': false,
      'repeats': _repeatType != 'none',
      'repeat_type': _repeatType == 'none' ? null : _repeatType,
      'priority': _selectedPriority,
      'due_time': _selectedTime != null ? _formatTime(_selectedTime!) : null,
    });

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      setState(() => _errorMessage = 'Failed to save. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Event'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                ),
                child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFEF4444))),
              ),

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: Icon(Icons.notes_outlined),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Category
            Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat['value'];
                final color = cat['color'] as Color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['value']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.15) : (isDark ? const Color(0xFF161B22) : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? color : (isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)), width: isSelected ? 2 : 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat['icon'] as IconData, size: 16, color: isSelected ? color : (isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280))),
                        const SizedBox(width: 4),
                        Text(cat['label'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? color : (isDark ? Colors.white : const Color(0xFF1F2937)))),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Priority
            Text('Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
            const SizedBox(height: 12),
            Row(
              children: _priorities.map((p) {
                final isSelected = _selectedPriority == p['value'];
                final color = p['color'] as Color;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPriority = p['value']),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withOpacity(0.15) : (isDark ? const Color(0xFF161B22) : Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? color : (isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)), width: isSelected ? 2 : 1),
                      ),
                      child: Text(
                        p['label'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? color : (isDark ? Colors.white : const Color(0xFF1F2937)),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Date picker
            Text('Due Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161B22) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF3B82F6)),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDark ? Colors.white : const Color(0xFF1F2937)),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Time picker (optional)
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161B22) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedTime != null
                        ? const Color(0xFF3B82F6)
                        : isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: _selectedTime != null ? const Color(0xFF3B82F6) : const Color(0xFF8B949E)),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime != null ? _formatTime(_selectedTime!) : 'Add Time (optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _selectedTime != null
                            ? (isDark ? Colors.white : const Color(0xFF1F2937))
                            : const Color(0xFF8B949E),
                      ),
                    ),
                    const Spacer(),
                    if (_selectedTime != null)
                      GestureDetector(
                        onTap: () => setState(() => _selectedTime = null),
                        child: const Icon(Icons.close, size: 18, color: Color(0xFF8B949E)),
                      )
                    else
                      Icon(Icons.chevron_right, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Repeats
            Text('Repeats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
            const SizedBox(height: 12),
            Row(
              children: [
                _repeatChip('None', 'none', isDark),
                const SizedBox(width: 8),
                _repeatChip('Monthly', 'monthly', isDark),
                const SizedBox(width: 8),
                _repeatChip('Yearly', 'yearly', isDark),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _repeatChip(String label, String value, bool isDark) {
    final isSelected = _repeatType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _repeatType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.15) : (isDark ? const Color(0xFF161B22) : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFF3B82F6) : (isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF3B82F6) : (isDark ? Colors.white : const Color(0xFF1F2937)),
            ),
          ),
        ),
      ),
    );
  }
}