import 'package:flutter/material.dart';
import 'package:todo_list_app/task.dart';

class SearchScreen extends StatefulWidget {
  final List<Task> tasks;

  const SearchScreen({super.key, required this.tasks});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<Task> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchTasks(String query) {
    _searchResults.clear();
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = widget.tasks
            .where((task) =>
                task.title.toLowerCase().contains(query.toLowerCase()) ||
                task.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tasks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchTasks,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index].title),
                  subtitle: Text(_searchResults[index].description),
                  // Add more UI components to display other task details
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
