import 'package:flutter/material.dart';
import 'package:planner/api_service.dart';
import 'package:planner/pages/add_event.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<dynamic> _tasks = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    List<dynamic> tasks;

    if (_selectedFilter == 'all' && _selectedCategory == 'all') {
      tasks = await getTasks();
    } else if (_selectedFilter != 'all') {
      tasks = await getTasks(filter: _selectedFilter);
    } else {
      tasks = await getTasks(category: _selectedCategory);
    }

    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _deleteTask(int id) async {
    await deleteTask(id);
    _loadTasks();
  }

  Future<void> _toggleComplete(dynamic task) async {
    await updateTask(task['id'], {'completed': !task['completed']});
    _loadTasks();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'homework': return const Color(0xFF8B5CF6);
      case 'payment': return const Color(0xFF22C55E);
      case 'meeting': return const Color(0xFF3B82F6);
      case 'appointment': return const Color(0xFFF59E0B);
      case 'misc': return const Color(0xFF6B7280);
      default: return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEventPage()),
            ).then((_) => _loadTasks()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _filterChip('All', 'all', isFilter: true, isDark: isDark),
                _filterChip('Today', 'today', isFilter: true, isDark: isDark),
                _filterChip('Upcoming', 'upcoming', isFilter: true, isDark: isDark),
                _filterChip('Completed', 'completed', isFilter: true, isDark: isDark),
                const SizedBox(width: 8),
                Container(width: 1, height: 24, color: isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
                const SizedBox(width: 8),
                _filterChip('Tasks', 'task', isFilter: false, isDark: isDark),
                _filterChip('Homework', 'homework', isFilter: false, isDark: isDark),
                _filterChip('Payments', 'payment', isFilter: false, isDark: isDark),
                _filterChip('Meetings', 'meeting', isFilter: false, isDark: isDark),
                _filterChip('Appointments', 'appointment', isFilter: false, isDark: isDark),
                _filterChip('Other', 'misc', isFilter: false, isDark: isDark),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 64, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280)),
                            const SizedBox(height: 16),
                            Text('No tasks found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
                            const SizedBox(height: 8),
                            Text('Tap + to add a new event', style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280))),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            final category = task['category'] ?? 'task';
                            final color = _getCategoryColor(category);
                            final isOverdue = !task['completed'] &&
                                DateTime.parse(task['due_date']).isBefore(DateTime.now());

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF161B22) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isOverdue
                                      ? const Color(0xFFEF4444).withOpacity(0.5)
                                      : isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: GestureDetector(
                                  onTap: () => _toggleComplete(task),
                                  child: Icon(
                                    task['completed'] == true ? Icons.check_circle : Icons.circle_outlined,
                                    color: task['completed'] == true ? const Color(0xFF22C55E) : const Color(0xFF8B949E),
                                    size: 28,
                                  ),
                                ),
                                title: Text(
                                  task['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                                    decoration: task['completed'] == true ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (task['description'] != null && task['description'].isNotEmpty)
                                      Text(task['description'], style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280))),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 12, color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF8B949E)),
                                        const SizedBox(width: 4),
                                        Text(
                                          task['due_date'] ?? '',
                                          style: TextStyle(fontSize: 12, color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF8B949E)),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                          child: Text(category, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                                        ),
                                        if (isOverdue) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                            child: const Text('Overdue', style: TextStyle(fontSize: 10, color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
                                          ),
                                        ],
                                        if (task['repeats'] == true) ...[
                                          const SizedBox(width: 8),
                                          const Icon(Icons.repeat, size: 12, color: Color(0xFF8B949E)),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                                  onPressed: () => _deleteTask(task['id']),
                                ),
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

  Widget _filterChip(String label, String value, {required bool isFilter, required bool isDark}) {
    final isSelected = isFilter ? _selectedFilter == value : _selectedCategory == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isFilter) {
            _selectedFilter = value;
            _selectedCategory = 'all';
          } else {
            _selectedCategory = value;
            _selectedFilter = 'all';
          }
        });
        _loadTasks();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : (isDark ? const Color(0xFF161B22) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : (isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB))),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF1F2937)),
          ),
        ),
      ),
    );
  }
}