// web/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Your Firebase configuration
firebase.initializeApp({
  apiKey: "AIzaSyDKZ9vHZ9Z9Z9Z9Z9Z9Z9Z9Z9Z9Z9Z",  // Replace with your actual config
  authDomain: "task-flow-b8217.firebaseapp.com",
  projectId: "task-flow-b8217",
  storageBucket: "task-flow-b8217.firebasestorage.app",
  messagingSenderId: "206356076885",
  appId: "1:206356076885:web:225e9b679f7b057289b7dc"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('Received background message:', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});