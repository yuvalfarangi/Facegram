const { initializeFirebase } = require('../firebase/firebase_init');  // Adjust the path as needed
const firebase = require('firebase/app');
require('firebase/database');  // Import the database module

class Notification {
    constructor(event, title, body, user) {
        this.event = event; // Event type (e.g., "like", "follow")
        this.title = title; // Notification title
        this.body = body; // Notification body
        this.user = user; // Target user ID
    }

    async post() {
        initializeFirebase();
        const database = firebase.database();
        const userRef = database.ref('users/' + this.user);
        const notificationData = {
            event: this.event,
            title: this.title,
            body: this.body,
            user: this.user,
            timestamp: Date.now()
        };

        try {
            await userRef.push(notificationData);
            console.log('Notification posted successfully');
        } catch (error) {
            console.error('Error posting notification:', error);
        }
    }
}

module.exports = Notification;