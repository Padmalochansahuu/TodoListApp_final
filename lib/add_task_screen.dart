import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list_app/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _reminderTime = TimeOfDay.now();
  TaskPriority _selectedPriority = TaskPriority.low; // Default priority

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty) {
      // Show an error message if title is blank
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Title cannot be blank.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    Task newTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _selectedPriority,
      creationDate: DateTime.now(), // Provide the current date and time
      dueDate: _dueDate,
      reminderTime: DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _reminderTime.hour,
        _reminderTime.minute,
      ),
    );
    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Due Date:'),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(
                    '${_dueDate.year}-${_dueDate.month}-${_dueDate.day}',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Reminder Time:'),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => _selectReminderTime(context),
                  child: Text(
                    '${_reminderTime.hour}:${_reminderTime.minute}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<TaskPriority>(
              value: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
