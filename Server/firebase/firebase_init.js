const firebase = require('firebase/app');
require('firebase/database'); // Import the database module

// Initialize Firebase function
const initializeFirebase = () => {
    const firebaseConfig = {
        apiKey: "AIzaSyCAVHBe3RAsVWEk29Id3gSlUgc_rWWbyA4",
        authDomain: "facegram-a94d9.firebaseapp.com",
        databaseURL: "https://facegram-a94d9-default-rtdb.firebaseio.com",
        projectId: "facegram-a94d9",
        storageBucket: "facegram-a94d9.firebasestorage.app",
        messagingSenderId: "871457614108",
        appId: "1:871457614108:web:87b4ee4f669fcfa02632d9"
    };

    if (!firebase.apps.length) {
        firebase.initializeApp(firebaseConfig); // Initialize Firebase if it hasn't been initialized yet
    } else {
        firebase.app(); // Use the existing Firebase app instance
    }

    console.log('Firebase Initialized');
};

module.exports = { initializeFirebase };