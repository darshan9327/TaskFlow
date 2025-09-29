import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task_model.dart';

class TaskService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    if (task.userId.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(task.userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }


  Stream<List<TaskModel>> getTasks({required userId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.id, doc.data()))
        .toList());
  }
}
