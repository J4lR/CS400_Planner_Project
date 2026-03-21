import 'package:flutter/material.dart';
import 'package:planner/api_service.dart';
import 'package:planner/pages/add_event.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  List<dynamic> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await getTasks(category: 'misc');
    setState(() { _tasks = tasks; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEventPage())).then((_) => _loadTasks()),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more_horiz, size: 64, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280)),
                      const SizedBox(height: 16),
                      Text('Nothing here yet!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
                      const SizedBox(height: 8),
                      Text('Tap + to add an event', style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280))),
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
                      final isOverdue = !task['completed'] && DateTime.parse(task['due_date']).isBefore(DateTime.now());
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF161B22) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isOverdue ? const Color(0xFFEF4444).withOpacity(0.5) : isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: GestureDetector(
                            onTap: () async { await updateTask(task['id'], {'completed': !task['completed']}); _loadTasks(); },
                            child: Icon(task['completed'] == true ? Icons.check_circle : Icons.circle_outlined, color: task['completed'] == true ? const Color(0xFF22C55E) : const Color(0xFF8B949E), size: 28),
                          ),
                          title: Text(task['title'] ?? '', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937), decoration: task['completed'] == true ? TextDecoration.lineThrough : null)),
                          subtitle: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 12, color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF8B949E)),
                              const SizedBox(width: 4),
                              Text(task['due_date'] ?? '', style: TextStyle(fontSize: 12, color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF8B949E))),
                            ],
                          ),
                          trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)), onPressed: () async { await deleteTask(task['id']); _loadTasks(); }),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}