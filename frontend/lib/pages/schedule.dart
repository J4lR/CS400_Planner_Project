import 'package:flutter/material.dart';
import 'package:planner/api_service.dart';
import 'package:planner/pages/add_event.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<dynamic> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await getTasks(filter: 'upcoming');
    setState(() { _tasks = tasks; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
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
                      Icon(Icons.schedule_outlined, size: 64, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280)),
                      const SizedBox(height: 16),
                      Text('Nothing upcoming!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
                      const SizedBox(height: 8),
                      Text('Tap + to schedule something', style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280))),
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
                      final color = _getCategoryColor(task['category'] ?? 'task');
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF161B22) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                          title: Text(task['title'] ?? '', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1F2937))),
                          subtitle: Text(task['due_date'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF8B949E))),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text(task['category'] ?? '', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'homework': return const Color(0xFF8B5CF6);
      case 'payment': return const Color(0xFF22C55E);
      case 'meeting': return const Color(0xFF3B82F6);
      case 'appointment': return const Color(0xFFF59E0B);
      default: return const Color(0xFF3B82F6);
    }
  }
}