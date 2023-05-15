import { Injectable } from '@angular/core';
import * as config from '../../firebaseConfig.js';
import firebase from 'firebase/compat/app';
import 'firebase/compat/firestore';
import 'firebase/compat/auth';
import 'firebase/compat/storage';

@Injectable({
  providedIn: 'root'
})
export class FireService {
  firebaseApplication;
  firestore: firebase.firestore.Firestore;
  auth: firebase.auth.Auth;
  storage: firebase.storage.Storage;
  baseURL = 'http://127.0.0.1:5001/drivetrackingsolution/us-central1/api';


  constructor() {
    //Initialize firebase app
    this.firebaseApplication = firebase.initializeApp(config.firebaseConfig);

    //Initialize firestore
    this.firestore = firebase.firestore();

    //Initialize firebase auth
    this.auth = firebase.auth();

    //Initialize firebase storage
    this.storage = firebase.storage();

    //#region Emulators
    this.firestore.useEmulator('localhost', 8080);
    this.auth.useEmulator('http://localhost:9099');
    this.storage.useEmulator('localhost', 9199);
    //#endregion
  }
}
