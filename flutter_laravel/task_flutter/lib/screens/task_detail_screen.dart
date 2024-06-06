// タスクの詳細画面
import 'package:flutter/material.dart';
import 'package:task_flutter/models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Completed: '),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: null, // 詳細画面では編集不可
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

