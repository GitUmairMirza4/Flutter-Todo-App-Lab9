
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import 'add_todo_screen.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    final completed = provider.completedCount;
    final total = provider.todos.length;
    final pending = total - completed;

    final filteredTodos = provider.todos.where((todo) {
      if (selectedFilter == 'Completed') {
        return todo.completed;
      }

      if (selectedFilter == 'Pending') {
        return !todo.completed;
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FB),
        elevation: 0,
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TodoProvider>().fetchTodos();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh tasks',
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF536DFE),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTodoScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            const Text('Unable to load tasks'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<TodoProvider>().fetchTodos();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () {
          return context.read<TodoProvider>().fetchTodos();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16, 8, 16, 100,
          ),
          children: [

            // Welcome section
            const Text(
              'Stay productive!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Manage your daily activities in one place.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 22),

            // Statistics cards
            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    'Total',
                    total,
                    Icons.checklist_rounded,
                    const Color(0xFF536DFE),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildStatCard(
                    'Completed',
                    completed,
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildStatCard(
                    'Pending',
                    pending,
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Progress section
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  total == 0
                      ? '0%'
                      : '${(completed / total * 100).round()}%',
                  style: const TextStyle(
                    color: Color(0xFF536DFE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : completed / total,
                minHeight: 9,
                backgroundColor: Colors.grey.shade300,
                color: const Color(0xFF536DFE),
              ),
            ),

            const SizedBox(height: 27),

            // Task heading
            const Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            // Filters
            Wrap(
              spacing: 8,
              children: ['All', 'Completed', 'Pending']
                  .map((filter) {
                final selected = selectedFilter == filter;

                return ChoiceChip(
                  label: Text(filter),
                  selected: selected,
                  selectedColor: const Color(0xFF536DFE),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Task list
            if (filteredTodos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text('No tasks found'),
                ),
              )
            else
              ...filteredTodos.map((todo) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),

                    leading: Icon(
                      todo.completed
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: todo.completed
                          ? Colors.green
                          : Colors.grey,
                      size: 27,
                    ),

                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.completed
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),

                    subtitle: Text(
                      'Task #${todo.id}',
                      style: const TextStyle(fontSize: 12),
                    ),

                    trailing: Icon(
                      todo.completed
                          ? Icons.done_all
                          : Icons.schedule,
                      color: todo.completed
                          ? Colors.green
                          : Colors.orange,
                      size: 20,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget buildStatCard(
      String title,
      int value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 12),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
