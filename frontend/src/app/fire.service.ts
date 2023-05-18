import {Injectable} from '@angular/core';
import firebase from 'firebase/compat/app';
import 'firebase/compat/firestore';
import 'firebase/compat/auth';
import 'firebase/compat/storage';

import * as config from '../../firebaseConfig.js'
import {Router} from "@angular/router";

@Injectable({
  providedIn: 'root'
})
export class FireService {
  firebaseApplication;
  firestore: firebase.firestore.Firestore;
  auth: firebase.auth.Auth;
  storage: firebase.storage.Storage;
  baseURL = 'http://127.0.0.1:5001/drivetrackingsolution/us-central1/api';


  constructor(private router: Router) {
    this.firebaseApplication = firebase.initializeApp(config.firebaseConfig);
    this.firestore = firebase.firestore();
    this.auth = firebase.auth();
    this.storage = firebase.storage();

    //#region Emulators
    //this.firestore.useEmulator('localhost', 8080);
    //this.auth.useEmulator('http://localhost:9099');
    //this.storage.useEmulator('localhost', 9199);
    //#endregion

  }

  signIn(email: string, password: string) {
    this.auth.signInWithEmailAndPassword(email, password)
      .then(() => {
        this.router.navigate(['users']);
      })
      .catch((error) => {
        console.log(error);
      });
  }

  getUsers() {

  }

  signout() {
    this.auth.signOut();
  }

  forgotPassword(email: string) {
    this.auth.sendPasswordResetEmail(email);
  }

  signOut() {
    this.auth.signOut()
      .then(() => {
        this.router.navigate(['']);
      })
      .catch((error) => {
        console.log(error);
      });
  }
}
