import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/model/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task, String userId) async {
    final docRef = _firestore.collection('tasks').doc();
    final newTask = task.copyWith(id: docRef.id);
    await docRef.set(newTask.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    if (task.id.isEmpty) return;
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  Stream<List<TaskModel>> getTasksForUser(String userId) {
    return _firestore
        .collection('tasks')
        .where('assignedTo', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TaskModel.fromMap(doc.id, doc.data())).toList());
  }

  Stream<List<TaskModel>> getTasksForAnyRole(String currentUserId) {
    return FirebaseFirestore.instance.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return TaskModel.fromMap(doc.id, doc.data());
          })
          .where((task) => task.userId == currentUserId || task.assignedTo == currentUserId || task.reviewerId == currentUserId)
          .toList();
    });
  }
}
