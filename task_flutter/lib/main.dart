import 'package:flutter/material.dart';
import 'models/task.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> futureTasks;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureTasks = apiService.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Task task = snapshot.data![index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        task.isCompleted = value!;
                        apiService.updateTask(task);
                      });
                    },
                  ),
                  onLongPress: () {
                    apiService.deleteTask(task.id);
                    setState(() {
                      futureTasks = apiService.getTasks();
                    });
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newTask = Task(
                  id: 0, // IDはサーバー側で自動生成されるため0でOK
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isCompleted: false,
                );
                ApiService apiService = ApiService();
                apiService.createTask(newTask).then((task) {
                  if (mounted) {
                    apiService.getTasks().then((tasks) {
                      setState(() {
                        futureTasks = Future.value(tasks);
                      });
                      Navigator.of(context).pop();
                    });
                  }
                }).catchError((error) {
                  // エラーハンドリングをここに追加
                });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}