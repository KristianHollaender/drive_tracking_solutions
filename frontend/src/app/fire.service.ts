import {Injectable} from '@angular/core';
import firebase from 'firebase/compat/app';
import 'firebase/compat/firestore';
import 'firebase/compat/auth';
import 'firebase/compat/storage';
import axios from "axios";
import * as config from '../../firebaseConfig.js'
import {User} from "./models/User";
import {Tour} from "./models/Tour";

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
  tours: Tour[] = [];
  checkpoint: any[] = [];
  tour: any;
  user: User = {email: "", firstname: "", lastname: "", role: "", uid: ""};
  profilePicture: any = 'https://st3.depositphotos.com/6672868/13701/v/600/depositphotos_137014128-stock-illustration-user-profile-icon.jpg';


  constructor() {
    this.firebaseApplication = firebase.initializeApp(config.firebaseConfig);
    this.firestore = firebase.firestore();
    this.auth = firebase.auth();
    this.storage = firebase.storage();
    this.intercept();
    this.auth.onAuthStateChanged(async () => {
      await this.getImageOfSignInUser();
    });
  }

  intercept() {
    customAxios.interceptors
      .request
      .use(async (request) => {
        let t = localStorage.getItem('token');
        request.headers.Authorization = (await this.auth.currentUser?.getIdToken() ?? t);
        return request;
      });
  };

  async signIn(email: string, password: string) {
    await this.auth.signInWithEmailAndPassword(email, password).then(async (user) => {
      console.log('Token: ', await user.user?.getIdToken());
      await this.getUserById(user.user?.uid + '');
    });
  }

  async getUsers() {
    const httpResult = await customAxios.get('/Users');
    this.users = httpResult.data['users'];
    return this.users;
  }

  async getTours() {
    const httpResult = await customAxios.get('/Tours');
    this.tours = httpResult.data['tours'];
    return this.tours;
  };

  async getTourById(id: string) {
    const httpResult = await customAxios.get('/Tour/' + id);
    const tour = httpResult.data['tour'];
    console.log(tour['pause']);
    return tour['pause'];
  };

  async getCheckpointData(id: string) {
    const httpResult = await customAxios.get('/Tour/' + id + '/checkpointData');
    for(let checkpoint of httpResult.data){
      const data = checkpoint['truckStop'];
      this.checkpoint.push({lat: data['_latitude'], lng: data['_longitude']});
    }
    return this.checkpoint;
  }

  async forgotPassword(email: string) {
    await this.auth.sendPasswordResetEmail(email);
  }

  async signOut() {
    await this.auth.signOut().then(() => {
      this.users = [];
      this.tours = [];
    });
  }

  async createUser(dto: { firstname: any; password: any; email: any; lastname: any }) {
    await customAxios.post('/User', dto);
  }

  async editUser(id: string, dto: { firstname: any; email: any; lastname: any },) {
    await customAxios.put('/User/' + id, dto);
  }

  async deleteUser(id: string) {
    await customAxios.delete('/User/' + id);
  }

  async getUserById(id: string) {
    const httpResult = await customAxios.get('/User/' + id);
    this.user = httpResult.data['user'];
    return this.user;
  }

  async getImageOfSignInUser() {
    this.profilePicture = await this.storage
      .ref('profile_images')
      .child(this.auth.currentUser?.uid + '')
      .getDownloadURL();
  }
}
