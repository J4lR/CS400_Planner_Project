import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:planner/api_service.dart';
import 'package:planner/utils.dart';
import 'package:planner/pages/add_event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<dynamic> _allTasks = [];
  List<dynamic> _selectedDayTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTasks();
  }

  Future<void> _loadAllTasks() async {
    setState(() => _isLoading = true);
    final tasks = await getTasks();
    setState(() {
      _allTasks = tasks;
      _isLoading = false;
      if (_selectedDay != null) {
        _filterTasksForDay(_selectedDay!);
      }
    });
  }

  void _filterTasksForDay(DateTime day) {
    final dateStr =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    setState(() {
      _selectedDayTasks =
          _allTasks.where((t) => t['due_date'] == dateStr).toList();
    });
  }

  bool _hasTasksOnDay(DateTime day) {
    final dateStr =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return _allTasks.any((t) => t['due_date'] == dateStr);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'homework':
        return const Color(0xFF8B5CF6);
      case 'payment':
        return const Color(0xFF22C55E);
      case 'meeting':
        return const Color(0xFF3B82F6);
      case 'appointment':
        return const Color(0xFFF59E0B);
      case 'misc':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEventPage()),
            ).then((_) => _loadAllTasks()),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _filterTasksForDay(selectedDay);
                  },
                  onFormatChanged: (format) =>
                      setState(() => _calendarFormat = format),
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (_hasTasksOnDay(day)) {
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    weekendTextStyle: TextStyle(
                      color: isDark
                          ? const Color(0xFF8B949E)
                          : const Color(0xFF6B7280),
                    ),
                    outsideTextStyle: TextStyle(
                      color: isDark
                          ? const Color(0xFF30363D)
                          : const Color(0xFFD1D5DB),
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(
                          color: isDark
                              ? const Color(0xFF30363D)
                              : const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 13,
                    ),
                    titleTextStyle: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Selected day tasks
                // Selected day tasks
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadAllTasks,
                    child: _selectedDay == null
                        ? ListView(
                            children: [
                              SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                    'Tap a day to see events',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _selectedDayTasks.isEmpty
                            ? ListView(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.event_available, size: 48, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280)),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Nothing on this day',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937)),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Tap + to add an event',
                                            style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _selectedDayTasks.length,
                                itemBuilder: (context, index) {
                                  final task = _selectedDayTasks[index];
                                  final category = task['category'] ?? 'task';
                                  final color = _getCategoryColor(category);
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF161B22) : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 4,
                                          height: 40,
                                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task['title'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                                                  decoration: task['completed'] == true ? TextDecoration.lineThrough : null,
                                                ),
                                              ),
                                              if (task['description'] != null && task['description'].isNotEmpty)
                                                Text(task['description'], style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280))),
                                              if (task['due_time'] != null)
                                                Text(task['due_time'], style: const TextStyle(fontSize: 12, color: Color(0xFF3B82F6))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                          child: Text(category, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
    );
  }
}