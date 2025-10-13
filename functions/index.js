const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { setGlobalOptions } = require("firebase-functions/v2");
const logger = require("firebase-functions/logger");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

setGlobalOptions({
  maxInstances: 10,
  region: "asia-south1",
});

// ======================================
// Helper: Save Notification to Firestore
// ======================================
async function saveNotificationToFirestore(userIds, notificationData, createdBy, updatedBy = null) {
  const db = getFirestore();
  const timestamp = new Date();

  // Loop through each user to store notification separately
  for (const userId of userIds) {
    const docRef = db.collection("users").doc(userId).collection("notifications").doc();

    await docRef.set({
      title: notificationData.notification.title,
      body: notificationData.notification.body,
      data: notificationData.data || {},
      isRead: false,
      createdAt: timestamp,
      timestamp: timestamp,
      createdBy,    // user who created the task
      updatedBy,    // user who last updated
    });
  }

  logger.log("Saved user-specific notifications in Firestore for:", userIds);
}

// (Optional) Send push notifications too
async function sendNotificationToUsers(userIds, message) {
  const db = getFirestore();
  const tokens = [];

  for (const userId of userIds) {
    const userDoc = await db.collection("users").doc(userId).get();
    if (userDoc.exists) {
      const fcmToken = userDoc.data().fcmToken;
      if (fcmToken) tokens.push(fcmToken);
    }
  }

  if (tokens.length === 0) {
    logger.log("No FCM tokens found for:", userIds);
    return;
  }

  const messages = tokens.map((token) => ({ ...message, token }));
  await Promise.all(messages.map((m) => getMessaging().send(m)));

  logger.log("FCM notifications sent to:", userIds);
}

// ========================
// 1️⃣ When New Task Created
// ========================
exports.sendTaskNotification = onDocumentCreated(
  { document: "tasks/{taskId}", region: "asia-south1" },
  async (event) => {
    try {
      const snapshot = event.data;
      if (!snapshot) return;

      const taskData = snapshot.data();
      const taskId = event.params.taskId;

      const creatorId = taskData.userId;
      const assignedTo = taskData.assignedTo;
      const reviewerId = taskData.reviewerId;

      const userIds = [assignedTo, reviewerId].filter(
        (id) => id && id !== creatorId
      );

      if (userIds.length === 0) return;

      const message = {
        notification: {
          title: "🆕 New Task Created",
          body: `${taskData.title || "Untitled Task"} has been assigned to you.`,
        },
        data: {
          taskId,
          type: "new_task",
        },
      };

      // Save in Firestore
      await saveNotificationToFirestore(userIds, message);

      // Optional: send FCM too
      await sendNotificationToUsers(userIds, message);
    } catch (error) {
      logger.error("Error in sendTaskNotification:", error);
    }
  }
);

// ====================
// 2️⃣ When Task Updated
// ====================
exports.sendTaskUpdateNotification = onDocumentUpdated(
  { document: "tasks/{taskId}", region: "asia-south1" },
  async (event) => {
    try {
      const beforeData = event.data.before.data();
      const afterData = event.data.after.data();
      const taskId = event.params.taskId;

      if (beforeData.status === afterData.status || afterData.status === "In Progress") return;

      const updaterId = afterData.lastUpdatedBy;
      const creatorId = afterData.userId;
      const assignedTo = afterData.assignedTo;
      const reviewerId = afterData.reviewerId;

      const userIds = Array.from(
        new Set([creatorId, assignedTo, reviewerId].filter(id => id && id !== updaterId))
      );

      if (userIds.length === 0) return;

      const message = {
        notification: {
          title: "✏️ Task Updated",
          body: `${afterData.title}: ${beforeData.status} → ${afterData.status}`,
        },
        data: {
          taskId,
          type: "task_update",
        },
      };
      await saveNotificationToFirestore(userIds, message);
      await sendNotificationToUsers(userIds, message);

      logger.log("Task update notifications sent for task:", taskId, "to users:", userIds);
    } catch (error) {
      logger.error("Error in sendTaskUpdateNotification:", error);
    }
  }
);


// ===================================
// 3️⃣ When Task Moves to "In Progress"
// ===================================
exports.sendTaskInProgressNotification = onDocumentUpdated(
  { document: "tasks/{taskId}", region: "asia-south1" },
  async (event) => {
    try {
      const beforeData = event.data.before.data();
      const afterData = event.data.after.data();
      const taskId = event.params.taskId;

      if (beforeData.status === "In Progress" || afterData.status !== "In Progress") return;

      const startedBy = afterData.lastUpdatedBy;
      const creatorId = afterData.userId;
      const assignedTo = afterData.assignedTo;
      const reviewerId = afterData.reviewerId;

    const userIds = Array.from(
      new Set([creatorId, assignedTo, reviewerId].filter((id) => id && id !== startedBy))
    );

      if (userIds.length === 0) return;

      const db = getFirestore();
      const assigneeDoc = await db.collection("users").doc(assignedTo).get();
      const assigneeName = assigneeDoc.exists ? assigneeDoc.data().fullName : "Someone";

      const message = {
        notification: {
          title: "🚀 Task In Progress",
          body: `${assigneeName} started working on ${afterData.title}`,
        },
        data: {
          taskId,
          type: "task_started",
        },
      };

      await saveNotificationToFirestore(userIds, message);
      await sendNotificationToUsers(userIds, message);
    } catch (error) {
      logger.error("Error in sendTaskInProgressNotification:", error);
    }
  }
);

// ===========================================
// 4️⃣ Daily Task Reminder (Scheduled at 10 AM)
// ===========================================
exports.sendDailyTaskReminder = onSchedule(
  { schedule: "0 10 * * *", timeZone: "Asia/Kolkata", region: "asia-south1" },
  async () => {
    try {
      logger.log("Running daily task reminder at 10 AM");

      const db = getFirestore();
      const tasksSnapshot = await db.collection("tasks").where("status", "==", "pending").get();

      if (tasksSnapshot.empty) {
        logger.log("No pending tasks found.");
        return;
      }

      const userTasks = {};
      tasksSnapshot.forEach((doc) => {
        const task = doc.data();
        const userId = task.assignedTo || task.userId;
        if (!userId) return;
        if (!userTasks[userId]) userTasks[userId] = [];
        userTasks[userId].push(task);
      });

      for (const userId of Object.keys(userTasks)) {
        const taskCount = userTasks[userId].length;
        const message = {
          notification: {
            title: "⏰ Daily Reminder",
            body: `You have ${taskCount} pending task${taskCount > 1 ? "s" : ""} to complete.`,
          },
          data: {
            type: "daily_reminder",
            taskCount: taskCount.toString(),
          },
        };

        await saveNotificationToFirestore([userId], message);
        await sendNotificationToUsers([userId], message);
      }

      logger.log("Daily reminders processed successfully.");
    } catch (error) {
      logger.error("Error sending daily reminders:", error);
    }
  }
);
