import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseApp = initializeApp({
    apiKey: "AIzaSyBAglKcfXZvEKXLd9-DGsgNOd1qdrTOMaQ",
    authDomain: "conexao-cidadania-4bec5.firebaseapp.com",
    projectId: "conexao-cidadania-4bec5",
    storageBucket: "conexao-cidadania-4bec5.firebasestorage.app",
    messagingSenderId: "786008933276",
    appId: "1:786008933276:web:0a31ac7c696b2c6e33fe59",
    measurementId: "G-81B0FSG2DN"
});

const auth = getAuth(firebaseApp);
const db = getFirestore(firebaseApp);