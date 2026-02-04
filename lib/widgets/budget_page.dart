import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final Color planItCyan = const Color(0xFF3DDBE1);

  final List<Map<String, dynamic>> _todoTasks = [
    {"title": "Choose cake flavor", "isDone": false},
    {"title": "Send digital RSVPs", "isDone": true},
    {"title": "Book Photographer", "isDone": false},
  ];

  double _totalBudget = 20000.0;
  double _spent = 5400.0;

  void _addNewTask() {
    TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("New Task"),
            content: TextField(
              controller: taskController,
              decoration: const InputDecoration(hintText: "Enter task name..."),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: planItCyan),
                onPressed: () {
                  if (taskController.text.isNotEmpty) {
                    setState(() {
                      _todoTasks.add({
                        "title": taskController.text,
                        "isDone": false,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          "Wedding Planner",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [planItCyan, planItCyan.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: planItCyan.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "REMAINING BALANCE",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "£${(_totalBudget - _spent).toStringAsFixed(0)}", // UPDATED SYMBOL
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Icon(
                      LucideIcons.sparkles,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _spent / _totalBudget,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Spent: £${_spent.toStringAsFixed(0)}", // UPDATED SYMBOL
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "Total: £${_totalBudget.toStringAsFixed(0)}", // UPDATED SYMBOL
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Text(
              "Planning Checklist",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _todoTasks.length,
              itemBuilder: (context, index) {
                final task = _todoTasks[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: CheckboxListTile(
                    value: task['isDone'],
                    onChanged: (v) => setState(() => task['isDone'] = v),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        color: task['isDone'] ? Colors.grey : Colors.black87,
                        decoration:
                            task['isDone'] ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    activeColor: planItCyan,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTask,
        backgroundColor: planItCyan,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "New Task",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
