import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/appbar.dart';
import '../../../data/model/task_model.dart';
import '../task_detail_screen/task_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _notificationsRef = FirebaseFirestore.instance.collection('notifications');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // ✅ Mark all as read (for current user only)
  Future<void> _markAllAsRead() async {
    try {
      final querySnapshot = await _notificationsRef
          .where('userIds', arrayContains: currentUserId)
          .get();

      if (querySnapshot.docs.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
      print("✅ All notifications marked as read for current user");
    } catch (e) {
      print("❌ Error marking notifications as read: $e");
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "🔔 Notifications",
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: "Mark all as read",
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: StreamBuilder<QuerySnapshot>(
          stream: _notificationsRef
              .where('userIds', arrayContains: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No notifications yet 🎉",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              );
            }

            final notifications = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final doc = notifications[index];
                final notif = doc.data() as Map<String, dynamic>;
                final notifId = doc.id;
                final timestamp = notif['timestamp'];
                final isRead = notif['isRead'] == true;

                return Dismissible(
                  key: Key(notifId),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.mark_email_read, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      final doc = await _notificationsRef.doc(notifId).get();
                      final currentIsRead = doc['isRead'] as bool? ?? false;

                      await _notificationsRef.doc(notifId).update({'isRead': !currentIsRead});

                      return false;
                    } else if (direction == DismissDirection.endToStart) {
                      await _notificationsRef.doc(notifId).delete();
                      return true;
                    }
                    return false;
                  },
                  child: Card(
                    color: isRead ? Colors.white : Colors.blue.shade50,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.shade100,
                        child: const Icon(Icons.notifications, color: Colors.white),
                      ),
                      title: Text(
                        notif['title'] ?? "No Title",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isRead ? Colors.black87 : Colors.blueAccent,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notif['body'] ?? "",
                              style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(_formatTimestamp(timestamp),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      onTap: () async {
                        await _notificationsRef
                            .doc(notifId)
                            .update({'isRead': true});

                        final taskId = notif['data']?['taskId'];
                        if (taskId != null && taskId.isNotEmpty) {
                          final taskDoc = await FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(taskId)
                              .get();

                          if (taskDoc.exists) {
                            final taskMap = taskDoc.data()!;
                            final taskModel =
                            TaskModel.fromMap(taskDoc.id, taskMap);

                            // ✅ Determine role for current user
                            String role = '';
                            if (taskModel.assignedTo == currentUserId) {
                              role = 'assigned';
                            } else if (taskModel.reviewerId == currentUserId) {
                              role = 'reviewer';
                            } else if (taskModel.userId == currentUserId) {
                              role = 'creator';
                            }

                            Get.to(() => TaskDetailScreen(
                              taskId: taskId,
                              task: taskModel,
                              role: role,
                              currentUserId: currentUserId,
                            ));
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} "
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (timestamp is DateTime) {
      return "${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year} "
          "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
    }
    return "";
  }
}
