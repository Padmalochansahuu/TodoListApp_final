
enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final String title;
  final String description;
  final DateTime creationDate; // Add this line
  final DateTime? dueDate;
  final DateTime? reminderTime;
  final TaskPriority priority;

  Task({
    required this.title,
    required this.description,
    required this.creationDate, // Add this line
    this.dueDate,
    this.reminderTime,
    this.priority = TaskPriority.low,
  });
}
