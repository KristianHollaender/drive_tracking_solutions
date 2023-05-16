import firebase from "firebase/compat";
import Timestamp = firebase.firestore.Timestamp;
import GeoPoint = firebase.firestore.GeoPoint;

export interface Tour{
  uid: string,
  tourId: string,
  startTime: Timestamp,
  endTime: Timestamp,
  totalTime: string,
  totalPauseTime: string,
  startPoint: GeoPoint,
  endPoint: GeoPoint,
  note: string,
}
