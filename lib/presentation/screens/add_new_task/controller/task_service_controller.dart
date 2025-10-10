import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/model/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task, String userId) async {
    final docRef = _firestore.collection('tasks').doc();
    final newTask = task.copyWith(id: docRef.id);
    final taskMap = newTask.toMap();
    taskMap['id'] = docRef.id;
    await docRef.set(taskMap);
  }


  Future<void> updateTask(TaskModel task, String currentUserId, String currentUserName) async {
    if (task.id.isEmpty) return;

    await _firestore.collection('tasks').doc(task.id).update({
      ...task.toMap(isNew: false),
      'updatedById': currentUserId,
      'updatedByName': currentUserName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
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

  Stream<List<TaskModel>> getTasksForAnyRole(String userId) {
    final tasksCollection = FirebaseFirestore.instance.collection('tasks');

    final queryCreated = tasksCollection.where('userId', isEqualTo: userId);
    final queryAssigned = tasksCollection.where('assignedTo', isEqualTo: userId);
    final queryReviewer = tasksCollection.where('reviewerId', isEqualTo: userId);

    final createdStream = queryCreated.snapshots();
    final assignedStream = queryAssigned.snapshots();
    final reviewerStream = queryReviewer.snapshots();

    return CombineLatestStream.combine3(
      createdStream,
      assignedStream,
      reviewerStream,
          (QuerySnapshot created, QuerySnapshot assigned, QuerySnapshot reviewer) {
        final allDocs = <String, QueryDocumentSnapshot>{};

        for (var doc in created.docs) {
          allDocs[doc.id] = doc;
        }
        for (var doc in assigned.docs) {
          allDocs[doc.id] = doc;
        }
        for (var doc in reviewer.docs) {
          allDocs[doc.id] = doc;
        }

        return allDocs.values
            .map((doc) => TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
