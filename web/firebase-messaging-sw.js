importScripts("https://www.gstatic.com/firebasejs/7.5.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.5.0/firebase-messaging.js");
firebase.initializeApp({
    apiKey: "...",
    authDomain: "[YOUR_PROJECT].firebaseapp.com",
    databaseURL: "https://[YOUR_PROJECT].firebaseio.com",
    projectId: "[YOUR_PROJECT]",
    storageBucket: "[YOUR_PROJECT].appspot.com",
    messagingSenderId: "...",
    appId: "1:...:web:...",
    measurementId: "G-...",
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function(payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function(event) {
    console.log('notification received: ', event)
});