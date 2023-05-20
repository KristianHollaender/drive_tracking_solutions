import {Injectable} from '@angular/core';
import firebase from 'firebase/compat/app';
import 'firebase/compat/firestore';
import 'firebase/compat/auth';
import 'firebase/compat/storage';
import axios from "axios";
import * as config from '../../firebaseConfig.js'
import {User} from "./models/User";
import {FirebaseDatabaseNames} from "./models/helper/FirebaseDatabaseNames";
import {Tour} from "./models/Tour";
import {Observable} from "rxjs";

export const customAxios = axios.create({
  baseURL: 'https://us-central1-drivetrackingsolution.cloudfunctions.net/api'
});

@Injectable({
  providedIn: 'root'
})
export class FireService {
  firebaseApplication;
  firestore: firebase.firestore.Firestore;
  auth: firebase.auth.Auth;
  storage: firebase.storage.Storage;

  users: User[] = [];
  tours: any[] = [];

  constructor() {
    this.firebaseApplication = firebase.initializeApp(config.firebaseConfig);
    this.firestore = firebase.firestore();
    this.auth = firebase.auth();
    this.storage = firebase.storage();
    this.auth.onAuthStateChanged((user) => {
      this.intercept();
    });

    //#region Emulators
    //this.firestore.useEmulator('localhost', 8080);
    //this.auth.useEmulator('http://localhost:9099');
    //this.storage.useEmulator('localhost', 9199);
    //#endregion

  }

// Tried to add authorization, but it's not working in flutter
  intercept() {
    axios.interceptors
      .request
      .use(async (request) => {
        request.headers.Authorization = await this.auth.currentUser?.getIdToken() + ""
        return request;
      });
  };

  async signIn(email: string, password: string) {
    await this.auth.signInWithEmailAndPassword(email, password);
    console.log(await this.auth.currentUser?.getIdToken() + '');
  }

  /**
   async getUsers() {
    const httpResult = await customAxios.get('/User');
    this.users = httpResult.data['users'];
    return this.users;
  }
   */

  // Try to only
  async getUsers() {
    /**
     await this.firestore.collection(FirebaseDatabaseNames.user).onSnapshot(snapshot => {
      snapshot.docChanges().forEach(change => {
        if (change.type == 'added') {
          this.users.push({
            uid: change.doc.id,
            email: change.doc.data()['email'],
            firstname: change.doc.data()['firstname'],
            lastname: change.doc.data()['lastname'],
            role: change.doc.data()['role'],
          });
        }
        if (change.type == "modified") {
          const index = this.users.findIndex(user => user.uid == change.doc.id);
          this.users[index] = {
            uid: change.doc.id,
            email: change.doc.data()['email'],
            firstname: change.doc.data()['firstname'],
            lastname: change.doc.data()['lastname'],
            role: change.doc.data()['role'],
          };
        }
        if (change.type == "removed") {
          this.users == this.users.filter(u => u.uid != change.doc.id);
        }
      });
    });
     */

    await this.firestore.collection(FirebaseDatabaseNames.user).get().then(
      (snapshot) => {
        snapshot.forEach((doc) => {
          this.users.push({
            uid: doc.id,
            email: doc.data()['email'],
            firstname: doc.data()['firstname'],
            lastname: doc.data()['lastname'],
            role: doc.data()['role'],
          });
        })
      });


    return this.users;
  }

  getTours() {
    this.firestore.collection(FirebaseDatabaseNames.tour).orderBy(FirebaseDatabaseNames.tourStartTime, "asc").onSnapshot(snapshot => {
      snapshot.docChanges().forEach(change => {
        if (change.type == 'added') {
          this.tours.push({
            id: change.doc.id,
            data: change.doc.data(),
          });
        }
        if (change.type == "modified") {
          const index = this.tours.findIndex(document => document.id == change.doc.id);
          this.tours[index] = {
            id: change.doc.id, data: change.doc.data()
          };
        }
        if (change.type == "removed") {
          this.tours == this.tours.filter(d => d.id != change.doc.id);
        }
      });
    });
    return this.tours;
  };

  async forgotPassword(email: string) {
    await this.auth.sendPasswordResetEmail(email);
  }

  async signOut() {
    await this.auth.signOut().then(() => {
      this.users = [];
      this.tours = [];
    });
  }
}
