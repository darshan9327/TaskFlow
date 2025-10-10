const { setGlobalOptions } = require("firebase-functions/v2/options");
const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();
setGlobalOptions({ timeoutSeconds: 30, memory: "256MiB" });

// Helper function
async function sendNotificationToUsers(userIds, title, body, data = {}) {
  try {
    const db = getFirestore();
    const tokens = [];

    for (const userId of userIds) {
      const doc = await db.collection("users").doc(userId).get();
      if (doc.exists && doc.data().fcmToken) tokens.push(doc.data().fcmToken);
    }

    if (tokens.length === 0) {
      console.log("⚠️ No FCM tokens found for:", userIds);
      return;
    }

    const message = {
      tokens,
      notification: { title, body },
      data: { ...data, click_action: "FLUTTER_NOTIFICATION_CLICK" },
    };

    const res = await getMessaging().sendEachForMulticast(message);
    console.log(`✅ Sent ${res.successCount}, failed ${res.failureCount}`);
  } catch (e) {
    console.error("❌ Notification Error:", e);
  }
}

// 🆕 Task Created
exports.notifyOnTaskCreate = onDocumentCreated("tasks/{taskId}", async (event) => {
  const task = event.data.data();
  const { title, createdByName, assignedTo, reviewerId } = task;

  await sendNotificationToUsers(
    [assignedTo, reviewerId].filter(Boolean),
    "🆕 New Task Assigned",
    `${createdByName || "Someone"} created a new task: ${title}`,
    { taskId: event.params.taskId, type: "create" }
  );
});

// ✏️ Task Updated
exports.notifyOnTaskUpdate = onDocumentUpdated("tasks/{taskId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();

  if (
     before.title === after.title &&
     before.status === after.status &&
     before.assignedTo === after.assignedTo &&
     before.reviewerId === after.reviewerId
   ) return;

  const { title, updatedByName, assignedTo, reviewerId } = after;

  await sendNotificationToUsers(
    [assignedTo, reviewerId].filter(Boolean),
    "✏️ Task Updated",
    `${updatedByName || "Someone"} updated: ${title}`,
    { taskId: event.params.taskId, type: "update" }
  );
});

// 🗑️ Task Deleted
exports.notifyOnTaskDelete = onDocumentDeleted("tasks/{taskId}", async (event) => {
  const task = event.data.data();
  const { title, assignedTo, reviewerId } = task;

  await sendNotificationToUsers(
    [assignedTo, reviewerId].filter(Boolean),
    "🗑️ Task Deleted",
    `Task "${title}" was deleted.`,
    { taskId: event.params.taskId, type: "delete" }
  );
});
