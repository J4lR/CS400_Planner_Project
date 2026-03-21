import 'package:flutter/material.dart';
import 'package:planner/api_service.dart';
import 'package:planner/main.dart';
import 'package:planner/pages/login.dart';
import 'package:planner/pages/calendar.dart';
import 'package:planner/pages/tasks.dart';
import 'package:planner/pages/add_event.dart';
import 'package:planner/pages/homework.dart';
import 'package:planner/pages/appointment.dart';
import 'package:planner/pages/meetings.dart';
import 'package:planner/pages/payments.dart';
import 'package:planner/pages/schedule.dart';
import 'package:planner/pages/other.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<dynamic> _todayTasks = [];
  List<dynamic> _tomorrowTasks = [];
  List<dynamic> _weekTasks = [];
  List<dynamic> _completedTasks = [];
  bool _isLoading = true;
  late List<Widget> _pages;

  @override
void initState() {
  super.initState();
  _pages = [
    Container(),
    const CalendarPage(),
    TasksPage(onTaskUpdated: _loadTodayTasks),
  ];
  _loadTodayTasks();
}

  Future<void> _loadTodayTasks() async {
    setState(() => _isLoading = true);

    final today = await getTasks(filter: 'today');
    final upcoming = await getTasks(filter: 'upcoming');
    final completed = await getTasks(filter: 'completed');

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowStr =
        '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';

    final nextWeek = DateTime.now().add(const Duration(days: 7));

    setState(() {
      _todayTasks = today;
      _tomorrowTasks =
          upcoming.where((t) => t['due_date'] == tomorrowStr).toList();
      _weekTasks = upcoming.where((t) {
        final date = DateTime.parse(t['due_date']);
        return date.isAfter(tomorrow) && date.isBefore(nextWeek);
      }).toList();
      _completedTasks = completed;
      _isLoading = false;
    });
  }

  void _logout() {
    authToken = null;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _pages[0] = _buildDashboard(isDark);
final pages = _pages;

    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hi, ',
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark
                            ? const Color(0xFF8B949E)
                            : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: widget.username,
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => TasklyApp.of(context)?.toggleTheme(),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(isDark),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            _loadTodayTasks();
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Calendar'),
          NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle),
              label: 'Tasks'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEventPage()),
        ).then((_) => _loadTodayTasks()),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDashboard(bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadTodayTasks,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Overview",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getFormattedDate(),
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                Expanded(
                    child: _buildStatCard(
                        'Total Today',
                        _todayTasks.length.toString(),
                        Icons.list_alt,
                        const Color(0xFF3B82F6),
                        isDark)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildStatCard(
                        'Completed',
                        _completedTasks.length.toString(),
                        Icons.check_circle,
                        const Color(0xFF22C55E),
                        isDark)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildStatCard(
                        'Pending',
                        _todayTasks
                            .where((t) => t['completed'] == false)
                            .length
                            .toString(),
                        Icons.pending,
                        const Color(0xFFF59E0B),
                        isDark)),
              ],
            ),
            const SizedBox(height: 24),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildSection('Due Today', _todayTasks, isDark),
                      const SizedBox(height: 24),
                      _buildSection('Due Tomorrow', _tomorrowTasks, isDark),
                      const SizedBox(height: 24),
                      _buildSection('Due This Week', _weekTasks, isDark),
                      const SizedBox(height: 24),
                      _buildSection(
                          'Recently Completed', _completedTasks, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> tasks, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            Text(
              '${tasks.length} items',
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        tasks.isEmpty
            ? _buildEmptyState(isDark)
            : Column(
                children:
                    tasks.map((task) => _buildTaskCard(task, isDark)).toList(),
              ),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1F2937))),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF8B949E)
                      : const Color(0xFF6B7280)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTaskCard(dynamic task, bool isDark) {
    final category = task['category'] ?? 'task';
    final color = _getCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2)),
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
                    decoration: task['completed'] == true
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                if (task['description'] != null &&
                    task['description'].isNotEmpty)
                  Text(
                    task['description'],
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF8B949E)
                            : const Color(0xFF6B7280)),
                  ),
                const SizedBox(height: 4),
                Text(
                  task['due_date'] ?? '',
                  style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF8B949E)
                          : const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(category,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              await updateTask(
                  task['id'], {'completed': !task['completed']});
              _loadTodayTasks();
            },
            child: Icon(
              task['completed'] == true
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: task['completed'] == true
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF8B949E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              size: 24,
              color: isDark
                  ? const Color(0xFF8B949E)
                  : const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Text(
            'Nothing here',
            style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(bool isDark) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              color: isDark
                  ? const Color(0xFF161B22)
                  : const Color(0xFFF6F8FA),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 40, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text('Taskly',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1F2937))),
                  Text('Hi, ${widget.username}',
                      style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF8B949E)
                              : const Color(0xFF6B7280))),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(Icons.task_alt, 'Tasks',
                      () => _navigateTo(const TasksPage())),
                  _drawerItem(Icons.school_outlined, 'Homework',
                      () => _navigateTo(const HomeworkPage())),
                  _drawerItem(Icons.event_outlined, 'Appointments',
                      () => _navigateTo(const AppointmentPage())),
                  _drawerItem(Icons.groups_outlined, 'Meetings',
                      () => _navigateTo(const MeetingsPage())),
                  _drawerItem(Icons.payments_outlined, 'Payments',
                      () => _navigateTo(const PaymentsPage())),
                  _drawerItem(Icons.schedule_outlined, 'Schedule',
                      () => _navigateTo(const SchedulePage())),
                  _drawerItem(Icons.more_horiz, 'Other',
                      () => _navigateTo(const OtherPage())),
                  const Divider(),
                  _drawerItem(Icons.logout, 'Logout', _logout,
                      color: const Color(0xFFEF4444)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon,
          color: color ??
              (isDark ? Colors.white : const Color(0xFF1F2937))),
      title: Text(label,
          style: TextStyle(
              color: color ??
                  (isDark ? Colors.white : const Color(0xFF1F2937)),
              fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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

  String _getFormattedDate() {
    final now = DateTime.now();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}