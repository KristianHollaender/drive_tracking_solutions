// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
export const firebaseConfig = {
  apiKey: "AIzaSyC3dRRaws8KMTaP3P1VBiYS_UtZvoVuTTA",
  authDomain: "drivetrackingsolution.firebaseapp.com",
  databaseURL: "https://drivetrackingsolution-default-rtdb.europe-west1.firebasedatabase.app",
  projectId: "drivetrackingsolution",
  storageBucket: "drivetrackingsolution.appspot.com",
  messagingSenderId: "64233866167",
  appId: "1:64233866167:web:c4773f962dd399a8851e32",
  measurementId: "G-GT34QX24RL"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
