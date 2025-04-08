import 'package:flutter/material.dart';

void main() => runApp(const CW4App());

class CW4App extends StatelessWidget {
  const CW4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CW4 Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PlanManagerScreen(),
    );
  }
}

class Plan {
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  Plan({required this.name, required this.description, required this.date, this.isCompleted = false});
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key});

  @override
  State<PlanManagerScreen> createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  final List<Plan> _plans = [];

  void _addPlan(String name, String description, DateTime date) {
    setState(() {
      _plans.add(Plan(name: name, description: description, date: date));
    });
  }

  void _updatePlan(int index, String newName, String newDescription, DateTime newDate) {
    setState(() {
      _plans[index].name = newName;
      _plans[index].description = newDescription;
      _plans[index].date = newDate;
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      _plans[index].isCompleted = !_plans[index].isCompleted;
    });
  }

  void _deletePlan(int index) {
    setState(() {
      _plans.removeAt(index);
    });
  }

  void _showCreatePlanDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create New Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Plan Name')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  selectedDate = picked;
                }
              },
              child: const Text('Select Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addPlan(nameController.text, descriptionController.text, selectedDate);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan Manager')),
      body: ListView.builder(
        itemCount: _plans.length,
        itemBuilder: (context, index) {
          final plan = _plans[index];
          return GestureDetector(
            onDoubleTap: () => _deletePlan(index),
            onLongPress: () => _showEditPlanDialog(index),
            child: Dismissible(
              key: Key(plan.name + index.toString()),
              onDismissed: (_) => _toggleComplete(index),
              child: Card(
                color: plan.isCompleted ? Colors.green[100] : Colors.orange[100],
                child: ListTile(
                  title: Text(plan.name, style: TextStyle(decoration: plan.isCompleted ? TextDecoration.lineThrough : null)),
                  subtitle: Text("${plan.description} — ${plan.date.toLocal().toString().split(' ')[0]}"),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlanDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditPlanDialog(int index) {
    final plan = _plans[index];
    final nameController = TextEditingController(text: plan.name);
    final descriptionController = TextEditingController(text: plan.description);
    DateTime selectedDate = plan.date;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Plan Name')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  selectedDate = picked;
                }
              },
              child: const Text('Select Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePlan(index, nameController.text, descriptionController.text, selectedDate);
            },
            child: const Text('Update'),
          )
        ],
      ),
    );
  }
}
