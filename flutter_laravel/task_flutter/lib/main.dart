import 'package:flutter/material.dart';
import 'models/task.dart';
import 'services/api_service.dart';
import 'screens/task_detail_screen.dart';
import 'screens/register_screen.dart';

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
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  void _login() async {
    try {
      await apiService.login(_emailController.text, _passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: $e')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToRegister,
              child: Text('Register'),
            ),
          ],
        ),
      ),
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
  String query = '';

  @override
  void initState() {
    super.initState();
    futureTasks = apiService.getTasks();
  }

  void _searchTasks(String query) {
    setState(() {
      this.query = query;
      futureTasks = apiService.getTasks().then((tasks) {
        return tasks.where((task) {
          return task.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'タスクを検索する',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _searchTasks,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Task task = snapshot.data![index];
                return Card(
                  child: ListTile(
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(task: task),
                        ),
                      );
                    },
                    onLongPress: () {
                      apiService.deleteTask(task.id);
                      setState(() {
                        futureTasks = apiService.getTasks();
                      });
                    },
                  ),
                );
              },
            );
          }
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
                apiService.createTask(newTask).then((task) {
                  setState(() {
                    futureTasks = apiService.getTasks();
                  });
                  Navigator.of(context).pop();
                });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(Task task) {
    final _titleController = TextEditingController(text: task.title);
    final _descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
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
                task.title = _titleController.text;
                task.description = _descriptionController.text;
                apiService.updateTask(task).then((_) {
                  setState(() {
                    futureTasks = apiService.getTasks();
                  });
                  Navigator.of(context).pop();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}